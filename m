Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZI2QdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZI2QdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 12:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZI2QdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 12:33:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbZI2QdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 12:33:16 -0400
Date: Tue, 29 Sep 2009 18:28:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Scott James Remnant <scott@ubuntu.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Matt Helsley <matthltc@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] connector: Fix sid connector (was: Badness at
	kernel/softirq.c:143...)
Message-ID: <20090929162855.GA15319@redhat.com>
References: <200909251123.03482.borntraeger@de.ibm.com> <20090929142538.GA10180@redhat.com> <20090929144554.GA10937@redhat.com> <200909291712.33099.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909291712.33099.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29, Christian Borntraeger wrote:
>
>
> The network code must not be called with disabled interrupts but
> sys_setsid holds the tasklist_lock with spinlock_irq while calling
> the connector. We can safely move proc_sid_connector from
> __set_special_pids to sys_setsid.
>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>
> ---
>  kernel/exit.c |    4 +---
>  kernel/sys.c  |    2 ++
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> Index: linux-2.6/kernel/exit.c
> ===================================================================
> --- linux-2.6.orig/kernel/exit.c
> +++ linux-2.6/kernel/exit.c
> @@ -359,10 +359,8 @@ void __set_special_pids(struct pid *pid)
>  {
>  	struct task_struct *curr = current->group_leader;
>
> -	if (task_session(curr) != pid) {
> +	if (task_session(curr) != pid)
>  		change_pid(curr, PIDTYPE_SID, pid);
> -		proc_sid_connector(curr);
> -	}
>
>  	if (task_pgrp(curr) != pid)
>  		change_pid(curr, PIDTYPE_PGID, pid);
> Index: linux-2.6/kernel/sys.c
> ===================================================================
> --- linux-2.6.orig/kernel/sys.c
> +++ linux-2.6/kernel/sys.c
> @@ -1110,6 +1110,8 @@ SYSCALL_DEFINE0(setsid)
>  	err = session;
>  out:
>  	write_unlock_irq(&tasklist_lock);
> +	if (err > 0)
> +		proc_sid_connector(sid);
>  	return err;
>  }

Acked-by: Oleg Nesterov <oleg@redhat.com>

I'd suggest you to resend this patch to Andrew. Unless you know
another way to push it into Linus's tree ;)

Perhaps it makes sense to update the changelog, it should mention
the issues with daemonize().

Oleg.

