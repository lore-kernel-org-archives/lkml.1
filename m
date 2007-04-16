Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbXDPHFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbXDPHFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 03:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbXDPHFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 03:05:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42087 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753640AbXDPHFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 03:05:54 -0400
Date: Mon, 16 Apr 2007 09:05:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [RFC][PATCH][EXPERIMENTAL] CPU hotplug with frozen tasks
Message-ID: <20070416070531.GC1783@elf.ucw.cz>
References: <200704061732.32712.rjw@sisk.pl> <200704160027.58425.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704160027.58425.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> As I said before, we have a problem with using the CPU hotplug for suspending
> because of the notifiers that are called from within cpu_up()/cpu_down() and
> (sometimes) assume that the system is fully functional.
> 
> One obvious solution of this problem would be to make the notifiers behave
> differently if tasks are frozen, but for this purpose we'd need to tell them
> that this is the case.  In principle, we could do it in many different ways
> (eg. by using a global variable, with the help of suspend notifiers etc.), but
> IMO one of the cleanest methods woud be to use some special values for the
> notifications occuring while tasks are frozen (eg. CPU_DEAD_FROZEN instead of
> CPU_DEAD etc.).  In that case the notifiers could react in some special ways
> to the "FROZEN" notfifications and that would allow us to simplify some code
> paths (eg. in the microcode driver).
> 
> The appended patch introduces such "FROZEN" notfifications, modifies the CPU
> hotplug core to use them and updates all of the users of CPU hotplug notifiers
> to recognize them.  For now, they are treated in the same way as the
> corresponding "normal" notifications, but I'm going to modify the microcode
> driver to really use them and I believe that some other subsystems can benefit
> from using them as well.
> 
> The patch is totally experimental and untested, although it's been successfully
> compiled on x86_64 and it's main purpose is to show what exactly I
> mean. :-)

Looks sane to me.

> Index: linux-2.6.21-rc6/kernel/cpu.c
> ===================================================================
> --- linux-2.6.21-rc6.orig/kernel/cpu.c	2007-04-16 00:24:56.000000000 +0200
> +++ linux-2.6.21-rc6/kernel/cpu.c	2007-04-16 00:25:14.000000000 +0200
> @@ -120,11 +120,12 @@ static int take_cpu_down(void *unused)
>  }
>  
>  /* Requires cpu_add_remove_lock to be held */
> -static int _cpu_down(unsigned int cpu)
> +static int _cpu_down(unsigned int cpu, int tasks_frozen)
>  {
>  	int err;
>  	struct task_struct *p;
>  	cpumask_t old_allowed, tmp;
> +	unsigned long mod = tasks_frozen ? 0x0008 : 0;
>  

Can we get constant instead of 0x0008 here?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
