Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbYCRJY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbYCRJY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 05:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYCRJYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 05:24:48 -0400
Received: from sacred.ru ([62.205.161.221]:33358 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbYCRJYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 05:24:47 -0400
Message-ID: <47DF8A30.5010602@openvz.org>
Date: Tue, 18 Mar 2008 12:24:00 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>, linux-audit@redhat.com
CC: Thomas Graf <tgraf@suug.ch>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Audit: netlink socket can be auto-bound to pid other than
 current->pid
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 18 Mar 2008 12:23:56 +0300 (MSK)
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

---

diff --git a/kernel/audit.c b/kernel/audit.c
index 10c4930..40b3a34 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -78,8 +78,10 @@ static int	audit_default;
 /* If auditing cannot proceed, audit_failure selects what happens. */
 static int	audit_failure = AUDIT_FAIL_PRINTK;
 
-/* If audit records are to be written to the netlink socket, audit_pid
+/* If audit records are to be written to the netlink socket, audit_nlk_pid
  * contains the (non-zero) pid. */
+static int	audit_nlk_pid;
+
 int		audit_pid;
 
 /* If audit_rate_limit is non-zero, limit the rate of sending audit records
@@ -349,13 +351,13 @@ static int kauditd_thread(void *dummy)
 		skb = skb_dequeue(&audit_skb_queue);
 		wake_up(&audit_backlog_wait);
 		if (skb) {
-			if (audit_pid) {
-				int err = netlink_unicast(audit_sock, skb, audit_pid, 0);
+			if (audit_nlk_pid) {
+				int err = netlink_unicast(audit_sock, skb, audit_nlk_pid, 0);
 				if (err < 0) {
 					BUG_ON(err != -ECONNREFUSED); /* Shoudn't happen */
-					printk(KERN_ERR "audit: *NO* daemon at audit_pid=%d\n", audit_pid);
+					printk(KERN_ERR "audit: *NO* daemon at audit_nlk_pid=%d\n", audit_nlk_pid);
 					audit_log_lost("auditd dissapeared\n");
-					audit_pid = 0;
+					audit_nlk_pid = 0;
 				}
 			} else {
 				if (printk_ratelimit())
@@ -626,6 +628,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 							sid, 1);
 
 			audit_pid = new_pid;
+			audit_nlk_pid = NETLINK_CB(skb).pid;
 		}
 		if (status_get->mask & AUDIT_STATUS_RATE_LIMIT)
 			err = audit_set_rate_limit(status_get->rate_limit,
@@ -1354,7 +1357,7 @@ void audit_log_end(struct audit_buffer *ab)
 		audit_log_lost("rate limit exceeded");
 	} else {
 		struct nlmsghdr *nlh = nlmsg_hdr(ab->skb);
-		if (audit_pid) {
+		if (audit_nlk_pid) {
 			nlh->nlmsg_len = ab->skb->len - NLMSG_SPACE(0);
 			skb_queue_tail(&audit_skb_queue, ab->skb);
 			ab->skb = NULL;
