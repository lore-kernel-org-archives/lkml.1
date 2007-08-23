Return-Path: <linux-kernel-owner+w=401wt.eu-S1760894AbXHWLwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbXHWLwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 07:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757730AbXHWLwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 07:52:23 -0400
Received: from khc.piap.pl ([195.187.100.11]:42453 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757595AbXHWLwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 07:52:23 -0400
To: "Anand Jahagirdar" <anandjigar@gmail.com>
Cc: "Chris Snook" <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Patch
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
	<46C4BC46.7000305@redhat.com>
	<25ae38200708200724sbce2749m7eb27565d7c84e5e@mail.gmail.com>
	<46C9A867.6090509@redhat.com>
	<25ae38200708212317h7776768v33a82f646ac6b749@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 23 Aug 2007 13:52:20 +0200
In-Reply-To: <25ae38200708212317h7776768v33a82f646ac6b749@mail.gmail.com> (Anand Jahagirdar's message of "Wed, 22 Aug 2007 11:47:18 +0530")
Message-ID: <m3d4xeii2z.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Anand Jahagirdar" <anandjigar@gmail.com> writes:

>    I am forwarding one more improved patch which i have modified as
> per your suggestions. Insted of KERN_INFO i have used KERN_NOTICE and
> i have added one more if block to check hard limit. how good it is?

Not very, still lacks "#ifdef CONFIG_something" and the required
Kconfig change (or other runtime thing defaulting to "no printk").

And now, it seems, the "goto bad_fork_tree" (not only printk())
ignores the soft limit -> really bad.

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
> +		 if (atomic_read(&p->user->processes) >= p->signal->rlim[RLIMIT_NPROC].rlim_max)
> 	 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
> -				p->user != &root_user) 
> +				p->user != &root_user)  {
> +                        	if (printk_ratelimit())
> +                               	 printk(KERN_NOTICE "User with uid %u is Nearing the process limit\n",p->user->uid);
> +
>  			 	goto bad_fork_free;
> -			
> +			}			
>  			
>  	atomic_inc(&p->user->__count);
>  	atomic_inc(&p->user->processes);

-- 
Krzysztof Halasa
