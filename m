Return-Path: <linux-kernel-owner+w=401wt.eu-S932209AbYCSUTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbYCSUTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757309AbYCSTjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:39:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:35952 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbYCSTi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:38:57 -0400
Message-ID: <7e0fb38c0803190504x3b725790n812c76e6e0b760f7@mail.gmail.com>
Date: Wed, 19 Mar 2008 08:04:33 -0400
From: "Eric Paris" <eparis@parisplace.org>
To: "Pavel Emelyanov" <xemul@openvz.org>
Subject: Re: [PATCH] Audit: netlink socket can be auto-bound to pid other than current->pid
Cc: linux-audit@redhat.com, "Thomas Graf" <tgraf@suug.ch>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       aviro@redhat.com, sgrubb@redhat.com, akpm@osdl.org
In-Reply-To: <47E0D8AF.1060907@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47DF8A30.5010602@openvz.org>
	 <7e0fb38c0803181629u4a6ff1d6ye83881ddf0e96d48@mail.gmail.com>
	 <47E0D8AF.1060907@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/08, Pavel Emelyanov <xemul@openvz.org> wrote:
> Eric Paris wrote:
>  > On 3/18/08, Pavel Emelyanov <xemul@openvz.org> wrote:
>  >
>  > Can we please just leave audit_pid as the one flag to tell us if
>  > auditd is supposedly up there in userspace?  Use audit_nlk_pid to send
>  > messages to the right place, but leave everything else to do with
>  > audit_pid alone.
>
>
> OK, point taken ;) Is that patch looks OK? If yes, I'll comment
>  it properly and re-send to Andrew.
>
>  The audit_nlk_pid reset to 0 is not required, since all the
>  decisions are taken based on audit_pid value only.

I looks good to me.  Feel free to add Acked-by: Eric Paris
<eparis@redhat.com> on your submission.

-Eric

>
>  Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
>
>
>  diff --git a/kernel/audit.c b/kernel/audit.c
>
> index ccc7d0e..12a0278 100644
>
> --- a/kernel/audit.c
>  +++ b/kernel/audit.c
>
> @@ -77,9 +77,13 @@ static int   audit_default;
>
>  /* If auditing cannot proceed, audit_failure selects what happens. */
>   static int     audit_failure = AUDIT_FAIL_PRINTK;
>
>  -/* If audit records are to be written to the netlink socket, audit_pid
>
> - * contains the (non-zero) pid. */
>  +/*
>  + * If audit records are to be written to the netlink socket, audit_pid
>  + * contains the pid of the auditd process and audit_nlk_pid contains
>  + * the pid to use to send netlink messages to that process.
>  + */
>   int            audit_pid;
>
> +static int     audit_nlk_pid;
>
>
>  /* If audit_rate_limit is non-zero, limit the rate of sending audit records
>
>   * to that number per second.  This prevents DoS attacks, but results in
>  @@ -349,7 +353,7 @@ static int kauditd_thread(void *dummy)
>
>                 wake_up(&audit_backlog_wait);
>                 if (skb) {
>                         if (audit_pid) {
>  -                               int err = netlink_unicast(audit_sock, skb, audit_pid, 0);
>
> +                               int err = netlink_unicast(audit_sock, skb, audit_nlk_pid, 0);
>
>                                 if (err < 0) {
>                                         BUG_ON(err != -ECONNREFUSED); /* Shoudn't happen */
>                                         printk(KERN_ERR "audit: *NO* daemon at audit_pid=%d\n", audit_pid);
>
> @@ -626,6 +630,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>
>                                                         sid, 1);
>
>                         audit_pid = new_pid;
>  +                       audit_nlk_pid = NETLINK_CB(skb).pid;
>                 }
>                 if (status_get->mask & AUDIT_STATUS_RATE_LIMIT)
>                         err = audit_set_rate_limit(status_get->rate_limit,
>
