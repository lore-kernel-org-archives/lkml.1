Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbXEaOQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbXEaOQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbXEaOQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:16:20 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:59503 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbXEaOQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:16:20 -0400
Date: Thu, 31 May 2007 07:16:00 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/22] 2.6.22-rc3 perfmon2 : modified x86_64 files
Message-ID: <20070531141600.GH22798@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <200705291348.l4TDmYaf019853@frankl.hpl.hp.com> <p73ejkxc9un.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ejkxc9un.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Thu, May 31, 2007 at 05:05:04PM +0200, Andi Kleen wrote:
> Stephane Eranian <eranian@frankl.hpl.hp.com> writes:
> 
> > @@ -557,6 +561,10 @@ static inline void __switch_to_xtra(stru
> >  		 */
> >  		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
> >  	}
> > +
> > +	if (test_tsk_thread_flag(next_p, TIF_PERFMON_CTXSW)
> > +	    || test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))
> > +		pfm_ctxsw(prev_p, next_p);
> >  }
> 
> I thought we had agreed earlier to put this into single "all uncommon
> bits" check first?
> 

This is it. the check for uncommon bits is below (_TIF_WORK_CTXSW). Then
we need to check each uncommon bits (done above). Did you have something else
in mind?

> >  
> >  /*
> > @@ -661,7 +669,7 @@ __switch_to(struct task_struct *prev_p, 
> >  	 * Now maybe reload the debug registers and handle I/O bitmaps
> >  	 */
> >  	if (unlikely((task_thread_info(next_p)->flags & _TIF_WORK_CTXSW))
> > -	    || test_tsk_thread_flag(prev_p, TIF_IO_BITMAP))
> > +  	    || (task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW))
> 
> >  		__switch_to_xtra(prev_p, next_p, tss);
> >  
> >  	/* If the task has used fpu the last 5 timeslices, just do a full
> > diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/kernel/setup64.c linux-2.6.22/arch/x86_64/kernel/setup64.c
> > --- linux-2.6.22.base/arch/x86_64/kernel/setup64.c	2007-05-29 03:17:16.000000000 -0700
> > +++ linux-2.6.22/arch/x86_64/kernel/setup64.c	2007-05-29 03:24:14.000000000 -0700
> > @@ -11,6 +11,7 @@
> >  #include <linux/bootmem.h>
> >  #include <linux/bitops.h>
> >  #include <linux/module.h>
> > +#include <linux/perfmon.h>
> >  #include <asm/bootsetup.h>
> >  #include <asm/pda.h>
> >  #include <asm/pgtable.h>
> > @@ -283,4 +284,6 @@ void __cpuinit cpu_init (void)
> >  	fpu_init(); 
> >  
> >  	raw_local_save_flags(kernel_eflags);
> > +
> > + 	pfm_init_percpu();
> 
> Just use a cpu notifier instead. No need to add everybody's per cpu init code here.

The code must run on the CPU that is being initialized.

> > diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/kernel/smpboot.c linux-2.6.22/arch/x86_64/kernel/smpboot.c
> > --- linux-2.6.22.base/arch/x86_64/kernel/smpboot.c	2007-05-29 03:17:16.000000000 -0700
> > +++ linux-2.6.22/arch/x86_64/kernel/smpboot.c	2007-05-29 03:24:14.000000000 -0700
> > @@ -49,6 +49,7 @@
> >  #include <linux/mc146818rtc.h>
> >  #include <linux/smp.h>
> >  #include <linux/kdebug.h>
> > +#include <linux/perfmon.h>
> >  
> >  #include <asm/mtrr.h>
> >  #include <asm/pgalloc.h>
> > @@ -1043,6 +1044,7 @@ int __cpu_disable(void)
> >  	spin_unlock(&vector_lock);
> >  	remove_cpu_from_maps();
> >  	fixup_irqs(cpu_online_map);
> > +	pfm_cpu_disable();
> 
> Also cpu notifier.
> 
Same thing here. I need to run on the CPU that is being disabled.

> 
> No compat syscalls? 
> 
compat syscalls for what? I need to ensure backward compatiblity on IA-64 only.

-- 

-Stephane
