Return-Path: <linux-kernel-owner+w=401wt.eu-S1762014AbXLUNqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762014AbXLUNqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 08:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbXLUNqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 08:46:10 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:56118 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbXLUNqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 08:46:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAOtSa0dMROHU/2dsb2JhbACBV6d6
Date: Fri, 21 Dec 2007 08:46:02 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: zhangxiliang <zhangxiliang@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, "'Ingo Molnar'" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "'Andi Kleen'" <andi@firstfloor.org>
Subject: Re: [patch 05/24] Text Edit Lock - Architecture Independent Code
Message-ID: <20071221134602.GA31783@Krystal>
References: <20071221015438.433195466@polymtl.ca> <20071221015724.089631037@polymtl.ca> <001701c84390$f6825f70$cb8da70a@zhangxiliang>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <001701c84390$f6825f70$cb8da70a@zhangxiliang>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:30:03 up 47 days, 18:35,  5 users,  load average: 7.06, 5.09,
	2.78
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* zhangxiliang (zhangxiliang@cn.fujitsu.com) wrote:
> hello,
>        I have some questions for your patches.
> 

Hi,

> > Paravirt and alternatives are always done when SMP is
> > inactive, so there is no
> > need to use locks.
> 
> > -#ifndef CONFIG_KPROBES
> > -#ifdef CONFIG_HOTPLUG_CPU
> > -	/* It must still be possible to apply SMP alternatives. */
> > -	if (num_possible_cpus() <= 1)
> > -#endif
> > -	{
> > -		change_page_attr(virt_to_page(start),
> > -		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
> > -		printk("Write protecting the kernel text:
> > %luk\n", size >> 10);
> > -	}
> > -#endif
> > +	change_page_attr(virt_to_page(start),
> > +		size >> PAGE_SHIFT, PAGE_KERNEL_RX);
> > +	printk(KERN_INFO "Write protecting the kernel text: %luk\n",
> > +		size >> 10);
> > +
> 
> Why "mark_rodata_ro" doesn't consider smp instance? Maybe it will be appied in 
> future.
> 

In its previous state, mark_rodata_ro was disabled in these situations :
- System supports CPU_HOTPLUG (alternatives will need to be applied when
  we pass from 1->2 and 2->1 cpu.
- System supports KPROBES, it need to put breakpoints in the code.

The main effect of the change I introduce is that I allow the kernel
code to be marked RO even in these situations. Alternatives and kprobes
uses the text_poke to modify kernel code, which temporarily disabled the
Write Protection bit on the local CPU so the memory write to RO pages
can be done.

So I guess the answer to your question is : previously, mark_rodata_ro
did not support CPU HOTPLUG nor KPROBES, and now it does, which is
much cleaner.


> 
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/kprobes.c	2007-12-12
> > 18:10:32.000000000 -0500
> > +++ linux-2.6-lttng/kernel/kprobes.c	2007-12-12
> > 18:10:34.000000000 -0500
> > @@ -644,7 +644,9 @@ valid_p:
> >  			list_del_rcu(&p->list);
> >  			kfree(old_p);
> >  		}
> > +		mutex_lock(&kprobe_mutex);
> >  		arch_remove_kprobe(p);
> > +		mutex_unlock(&kprobe_mutex);
> >  	} else {
> >  		mutex_lock(&kprobe_mutex);
> >  		if (p->break_handler)
> 
> I think "mutex_lock" and "mutex_unlock" shoud be in architecture code.
> In "__register_kprobe" funtion, its implement "arch_prepare_kprobe" and 
> "arch_arm_kprobe" is also depended on arch.  So the remove implement is not 
> the same on the different architecture code.
> 
> Maybe it doesn't need the mutex_lock in "arch_remove_kprobe" on some embeded 
> system chips if linux can support the other embeded system chips in future.
> 

Which patch is this coming from ?

My Text Edit Lock - kprobes architecture independent support
patch _removes_ the kprobe_mutex taken around arch_remove_kprobes
because it is useless, I don't see how this patch snippet applies to my
patchset at all.

If you suggest to change the way locking is currently done in
kprobes, please do this in a separate thread, as a RFC ?

Mathieu

> 
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org
> > [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of
> > Mathieu Desnoyers
> > Sent: Friday, December 21, 2007 9:55 AM
> > To: akpm@linux-foundation.org; Ingo Molnar;
> > linux-kernel@vger.kernel.org
> > Cc: Mathieu Desnoyers; Andi Kleen
> > Subject: [patch 05/24] Text Edit Lock - Architecture Independent Code
> >
> > This is an architecture independant synchronization around kernel text
> > modifications through use of a global mutex.
> >
> > A mutex has been chosen so that kprobes, the main user of
> > this, can sleep during
> > memory allocation between the memory read of the instructions
> > it must replace
> > and the memory write of the breakpoint.
> >
> > Other user of this interface: immediate values.
> >
> > Paravirt and alternatives are always done when SMP is
> > inactive, so there is no
> > need to use locks.
> >
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: Andi Kleen <andi@firstfloor.org>
> > ---
> >  include/linux/memory.h |    7 +++++++
> >  mm/memory.c            |   34 ++++++++++++++++++++++++++++++++++
> >  2 files changed, 41 insertions(+)
> >
> > Index: linux-2.6-lttng/include/linux/memory.h
> > ===================================================================
> > --- linux-2.6-lttng.orig/include/linux/memory.h> 
> > 2007-11-07 11:11:26.000000000 -0500
> > +++ linux-2.6-lttng/include/linux/memory.h	2007-11-07
> > 11:13:48.000000000 -0500
> > @@ -93,4 +93,11 @@ extern int memory_notify(unsigned long v
> >  #define hotplug_memory_notifier(fn, pri) do { } while (0)
> >  #endif
> >
> > +/*
> > + * Take and release the kernel text modification lock, used
> > for code patching.
> > + * Users of this lock can sleep.
> > + */
> > +extern void kernel_text_lock(void);
> > +extern void kernel_text_unlock(void);
> > +
> >  #endif /* _LINUX_MEMORY_H_ */
> > Index: linux-2.6-lttng/mm/memory.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/mm/memory.c	2007-11-07
> > 11:12:33.000000000 -0500
> > +++ linux-2.6-lttng/mm/memory.c	2007-11-07
> > 11:14:25.000000000 -0500
> > @@ -50,6 +50,8 @@
> >  #include <linux/delayacct.h>
> >  #include <linux/init.h>
> >  #include <linux/writeback.h>
> > +#include <linux/kprobes.h>
> > +#include <linux/mutex.h>
> >
> >  #include <asm/pgalloc.h>
> >  #include <asm/uaccess.h>
> > @@ -84,6 +86,12 @@ EXPORT_SYMBOL(high_memory);
> >
> >  int randomize_va_space __read_mostly = 1;
> >
> > +/*
> > + * mutex protecting text section modification (dynamic code
> > patching).
> > + * some users need to sleep (allocating memory...) while
> > they hold this lock.
> > + */
> > +static DEFINE_MUTEX(text_mutex);
> > +
> >  static int __init disable_randmaps(char *s)
> >  {
> >  	randomize_va_space = 0;
> > @@ -2748,3 +2756,29 @@ int access_process_vm(struct task_struct
> >
> >  	return buf - old_buf;
> >  }
> > +
> > +/**
> > + * kernel_text_lock     -   Take the kernel text modification lock
> > + *
> > + * Insures mutual write exclusion of kernel and modules text
> > live text
> > + * modification. Should be used for code patching.
> > + * Users of this lock can sleep.
> > + */
> > +void __kprobes kernel_text_lock(void)
> > +{
> > +	mutex_lock(&text_mutex);
> > +}
> > +EXPORT_SYMBOL_GPL(kernel_text_lock);
> > +
> > +/**
> > + * kernel_text_unlock   -   Release the kernel text modification lock
> > + *
> > + * Insures mutual write exclusion of kernel and modules text
> > live text
> > + * modification. Should be used for code patching.
> > + * Users of this lock can sleep.
> > + */
> > +void __kprobes kernel_text_unlock(void)
> > +{
> > +	mutex_unlock(&text_mutex);
> > +}
> > +EXPORT_SYMBOL_GPL(kernel_text_unlock);
> >
> > -- 
> > Mathieu Desnoyers
> > Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25
> > A8FE 3BAE 9A68
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> >
> 
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
