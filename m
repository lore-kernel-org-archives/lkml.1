Return-Path: <linux-kernel-owner+w=401wt.eu-S1765672AbXHPHks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765672AbXHPHks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761623AbXHPHk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:40:29 -0400
Received: from styx.suse.cz ([82.119.242.94]:34451 "EHLO elijah.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760835AbXHPHkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:40:07 -0400
Subject: Re: Fork Bombing Patch
From: Petr Tesarik <ptesarik@suse.cz>
To: Anand Jahagirdar <anandjigar@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: SuSE CR
Date: Thu, 16 Aug 2007 09:40:04 +0200
Message-Id: <1187250004.12446.3.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-16 at 11:54 +0530, Anand Jahagirdar wrote:
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

Please do not add comments inside functions. The printk() is self-descriptive, anyway.

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

