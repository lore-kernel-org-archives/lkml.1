Return-Path: <linux-kernel-owner+w=401wt.eu-S1756286AbYCTM77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286AbYCTM77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 08:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbYCTM7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 08:59:52 -0400
Received: from sacred.ru ([62.205.161.221]:46308 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756AbYCTM7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 08:59:51 -0400
Message-ID: <47E25F7F.5040907@openvz.org>
Date: Thu, 20 Mar 2008 15:58:39 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Thomas Graf <tgraf@suug.ch>, Eric Paris <eparis@parisplace.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-audit@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steve Grubb <sgrubb@redhat.com>, Amy Griffis <amy.griffis@hp.com>
Subject: [PATCH] audit: netlink socket can be auto-bound to pid other than
 current->pid (v2)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 20 Mar 2008 15:58:34 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is based on the one from Thomas.

The kauditd_thread() calls the netlink_unicast() and passes 
the audit_pid to it. The audit_pid, in turn, is received from 
the user space and the tool (I've checked the audit v1.6.9) 
uses getpid() to pass one in the kernel. Besides, this tool 
doesn't bind the netlink socket to this id, but simply creates 
it allowing the kernel to auto-bind one.

That's the preamble.

The problem is that netlink_autobind() _does_not_ guarantees
that the socket will be auto-bound to the current pid. Instead
it uses the current pid as a hint to start looking for a free
id. So, in case of conflict, the audit messages can be sent
to a wrong socket. This can happen (it's unlikely, but can be)
in case some task opens more than one netlink sockets and then
the audit one starts - in this case the audit's pid can be busy
and its socket will be bound to another id.

The proposal is to introduce an audit_nlk_pid in audit subsys,
that will point to the netlink socket to send packets to. It
will most often be equal to audit_pid. The socket id can be 
got from the skb's netlink CB right in the audit_receive_msg.
The audit_nlk_pid reset to 0 is not required, since all the
decisions are taken based on audit_pid value only.

Later, if the audit tools will bind the socket themselves, the
kernel will have to provide a way to setup the audit_nlk_pid
as well.

A good side effect of this patch is that audit_pid can later 
be converted to struct pid, as it is not longer safe to use 
pid_t-s in the presence of pid namespaces. But audit code still 
uses the tgid from task_struct in the audit_signal_info and in
the audit_filter_syscall.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Eric Paris <eparis@redhat.com>

---

diff --git a/kernel/audit.c b/kernel/audit.c
index ccc7d0e..12a0278 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -77,9 +77,13 @@ static int	audit_default;
 /* If auditing cannot proceed, audit_failure selects what happens. */
 static int	audit_failure = AUDIT_FAIL_PRINTK;
 
-/* If audit records are to be written to the netlink socket, audit_pid
- * contains the (non-zero) pid. */
+/*
+ * If audit records are to be written to the netlink socket, audit_pid
+ * contains the pid of the auditd process and audit_nlk_pid contains
+ * the pid to use to send netlink messages to that process.
+ */
 int		audit_pid;
+static int	audit_nlk_pid;
 
 /* If audit_rate_limit is non-zero, limit the rate of sending audit records
  * to that number per second.  This prevents DoS attacks, but results in
@@ -349,7 +353,7 @@ static int kauditd_thread(void *dummy)
 		wake_up(&audit_backlog_wait);
 		if (skb) {
 			if (audit_pid) {
-				int err = netlink_unicast(audit_sock, skb, audit_pid, 0);
+				int err = netlink_unicast(audit_sock, skb, audit_nlk_pid, 0);
 				if (err < 0) {
 					BUG_ON(err != -ECONNREFUSED); /* Shoudn't happen */
 					printk(KERN_ERR "audit: *NO* daemon at audit_pid=%d\n", audit_pid);
@@ -626,6 +630,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 							sid, 1);
 
 			audit_pid = new_pid;
+			audit_nlk_pid = NETLINK_CB(skb).pid;
 		}
 		if (status_get->mask & AUDIT_STATUS_RATE_LIMIT)
 			err = audit_set_rate_limit(status_get->rate_limit,
