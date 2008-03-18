Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbYCTB6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbYCTB6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 21:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYCTB6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 21:58:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:52142 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbYCTB6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 21:58:15 -0400
Message-ID: <7e0fb38c0803181629u4a6ff1d6ye83881ddf0e96d48@mail.gmail.com>
Date: Tue, 18 Mar 2008 19:29:45 -0400
From: "Eric Paris" <eparis@parisplace.org>
To: "Pavel Emelyanov" <xemul@openvz.org>
Subject: Re: [PATCH] Audit: netlink socket can be auto-bound to pid other than current->pid
Cc: linux-audit@redhat.com, "Thomas Graf" <tgraf@suug.ch>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       aviro@redhat.com, sgrubb@redhat.com, akpm@osdl.org
In-Reply-To: <47DF8A30.5010602@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47DF8A30.5010602@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/08, Pavel Emelyanov <xemul@openvz.org> wrote:

Can we please just leave audit_pid as the one flag to tell us if
auditd is supposedly up there in userspace?  Use audit_nlk_pid to send
messages to the right place, but leave everything else to do with
audit_pid alone.


>  diff --git a/kernel/audit.c b/kernel/audit.c
>  index 10c4930..40b3a34 100644
>  --- a/kernel/audit.c
>  +++ b/kernel/audit.c
>  @@ -78,8 +78,10 @@ static int   audit_default;
>   /* If auditing cannot proceed, audit_failure selects what happens. */
>   static int     audit_failure = AUDIT_FAIL_PRINTK;
>
>  -/* If audit records are to be written to the netlink socket, audit_pid
>  +/* If audit records are to be written to the netlink socket, audit_nlk_pid

/* If audit records are to be written to the netlink socket, audit_pid
contain the pid of the auditd process and audit_nlk_pid will contain
the pid to use to send netlink messages to that process. */

>   * contains the (non-zero) pid. */
>  +static int     audit_nlk_pid;
>  +
>   int            audit_pid;
>
>   /* If audit_rate_limit is non-zero, limit the rate of sending audit records
>  @@ -349,13 +351,13 @@ static int kauditd_thread(void *dummy)
>                 skb = skb_dequeue(&audit_skb_queue);
>                 wake_up(&audit_backlog_wait);
>                 if (skb) {
>  -                       if (audit_pid) {
>  -                               int err = netlink_unicast(audit_sock, skb, audit_pid, 0);
>  +                       if (audit_nlk_pid) {

unneeded change

>  +                               int err = netlink_unicast(audit_sock, skb, audit_nlk_pid, 0);

good.

>                                 if (err < 0) {
>                                         BUG_ON(err != -ECONNREFUSED); /* Shoudn't happen */
>  -                                       printk(KERN_ERR "audit: *NO* daemon at audit_pid=%d\n", audit_pid);
>  +                                       printk(KERN_ERR "audit: *NO* daemon at audit_nlk_pid=%d\n", audit_nlk_pid);

userspace is never going to care about audit_nlk_pid, its meaningless
at that level.  This message should continue to use audit_pid.

>                                         audit_log_lost("auditd dissapeared\n");
>  -                                       audit_pid = 0;

We still need to 0 audit_pid otherwise all of the tests which use it
are bogus (aka things like audit_panic and audit_filter_syscall you
mentioned)

>  +                                       audit_nlk_pid = 0;
>                                 }
>                         } else {
>                                 if (printk_ratelimit())
>  @@ -626,6 +628,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>                                                         sid, 1);
>
>                         audit_pid = new_pid;
>  +                       audit_nlk_pid = NETLINK_CB(skb).pid;
>                 }
>                 if (status_get->mask & AUDIT_STATUS_RATE_LIMIT)
>                         err = audit_set_rate_limit(status_get->rate_limit,
>  @@ -1354,7 +1357,7 @@ void audit_log_end(struct audit_buffer *ab)
>                 audit_log_lost("rate limit exceeded");
>         } else {
>                 struct nlmsghdr *nlh = nlmsg_hdr(ab->skb);
>  -               if (audit_pid) {
>  +               if (audit_nlk_pid) {

don't need this if we zero audit_pid.

>                         nlh->nlmsg_len = ab->skb->len - NLMSG_SPACE(0);
>                         skb_queue_tail(&audit_skb_queue, ab->skb);
>                         ab->skb = NULL;
>
