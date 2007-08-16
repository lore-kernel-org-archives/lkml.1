Return-Path: <linux-kernel-owner+w=401wt.eu-S1764889AbXHPVGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764889AbXHPVGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 17:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbXHPVGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 17:06:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185AbXHPVGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 17:06:23 -0400
Message-ID: <46C4BC46.7000305@redhat.com>
Date: Thu, 16 Aug 2007 17:06:14 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Anand Jahagirdar <anandjigar@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Patch
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
In-Reply-To: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anand Jahagirdar wrote:
> Hello All
>            I have searched for Maintainers List to get the correct
> Maintainer for my patch. But i am not getting exact maintainer to
> which i should forward my patch. Will any body please tell me,to which
> maintainer i should forward my patch for its inclusion?
> 
> Summery of the Patch:
> 
> This patch Warns the administrator about the fork bombing attack
> (whenever any user is crossing its process limit). I have used
> printk_ratelimit function in this patch. This function helps to
> prevent flooding of syslog and prints message as per the values set by
> root user in following files:-
> 
> 1) /proc/sys/kernel/printk_ratelimit:- This file contains value for,
> how many times message should be printed in syslog.
> 
> 2) /proc/sys/kernel/printk_ratelimit_burst: - This file contains value
> for, after how much time message should be repeated.
> 
> This patch is really helpful for administrator/root user from security
> point of view. They can take action against attacker by looking at
> syslog messages related with fork bombing attack.
> 
> Added comments will definitely help developers.
> 
> Signed-Off-by: Anand Jahagirdar <anandjigar@gmail.com>
> 
> 
> ------------------------------------------------------------------------
> 
> Index: root/Desktop/a1/linux-2.6.17.tar.bz2_FILES/linux-2.6.17/kernel/fork.c
> ===================================================================
> --- root.orig/Desktop/a1/linux-2.6.17.tar.bz2_FILES/linux-2.6.17/kernel/fork.c	2007-06-26 20:40:06.000000000 +0530
> +++ root/Desktop/a1/linux-2.6.17.tar.bz2_FILES/linux-2.6.17/kernel/fork.c	2007-06-26 20:41:41.000000000 +0530
> @@ -957,12 +957,19 @@
>  
>  	retval = -EAGAIN;
>  	
> -        
> +        /*
> +         * following code does not allow Non Root User to cross its process
> +         * limit and it alerts administrator about user Nearing the process limit.
> +         */
> + 
>        	if (atomic_read(&p->user->processes) >= p->signal->rlim[RLIMIT_NPROC].rlim_cur) 
>  		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
> -				p->user != &root_user) 
> +				p->user != &root_user)  {
> +                        if (printk_ratelimit())
> +                                printk(KERN_WARNING "User with uid %u is Nearing the process limit\n",p->user->uid);
> +
>  			 goto bad_fork_free;
> -			
> +		}			
>  			
>  	atomic_inc(&p->user->__count);
>  	atomic_inc(&p->user->processes);

1) The printk is misleading.  We're hitting this condition because the 
user has hit the limit, not merely approached it.

2) This should probably be KERN_INFO.  The kernel itself is not in any 
danger because of this condition.

3) You should only be printing a warning if the user's hard limit is 
exceeded, not the soft limit.  While these default to the same value, 
applications are free to deliberately lower their soft limit to 
self-manage their resource utilization.  It's even perfectly valid (if 
uncommon) to lower the limit and deliberately keep your process count 
right at that limit by forking opportunistically.  If an application is 
doing this, you don't need or want to spam the message logs.  So, check 
to see if p->signal->rlim[RLIMIT_NPROC].rlim_cur == 
p->signal->rlim[RLIMIT_NPROC].rlim_max before spewing this out into the log.

4) Even with the printk_ratelimit, lowering the priority to KERN_INFO, 
and only logging when the hard limit is reached, an unprivileged user 
can still spam the system logs.  Perhaps a sysctl is in order?

	-- Chris
