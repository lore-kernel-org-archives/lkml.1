Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbXLUGC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbXLUGC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 01:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbXLUGCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 01:02:18 -0500
Received: from [222.73.24.84] ([222.73.24.84]:60495 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbXLUGCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 01:02:18 -0500
From: "zhangxiliang" <zhangxiliang@cn.fujitsu.com>
To: "'zhangxiliang'" <zhangxiliang@cn.fujitsu.com>,
       "'Mathieu Desnoyers'" <mathieu.desnoyers@polymtl.ca>,
       <akpm@linux-foundation.org>, "'Ingo Molnar'" <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>
Cc: "'Andi Kleen'" <andi@firstfloor.org>
References: <20071221015438.433195466@polymtl.ca> <20071221015724.089631037@polymtl.ca> <001701c84390$f6825f70$cb8da70a@zhangxiliang>
Subject: RE: [patch 05/24] Text Edit Lock - Architecture Independent Code
Date: Fri, 21 Dec 2007 14:01:22 +0800
Message-ID: <001a01c84396$e9b27040$cb8da70a@zhangxiliang>
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
In-Reply-To: <001701c84390$f6825f70$cb8da70a@zhangxiliang>
Thread-Index: AchDdwoeSwdpfoifR862bqp0AEs7vgADFcFgAATBQoA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
> In "__register_kprobe" funtion, its implement
> "arch_prepare_kprobe" and
> "arch_arm_kprobe" is also depended on arch.  So the remove
> implement is not
> the same on the different architecture code.
>
> Maybe it doesn't need the mutex_lock in "arch_remove_kprobe"
> on some embeded
> system chips if linux can support the other embeded system
> chips in future.

Could we insert the "mutex_lock" and "mutex_unlock" into "free_insn_slot"
instead of architecture code?

modify as follows:

void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
{
	struct kprobe_insn_page *kip;
	struct hlist_node *pos;

+	mutex_lock(&kprobe_mutex);
	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
		if (kip->insns <= slot &&
		    slot < kip->insns + (INSNS_PER_PAGE * MAX_INSN_SIZE)) {
			int i = (slot - kip->insns) / MAX_INSN_SIZE;
			if (dirty) {
				kip->slot_used[i] = SLOT_DIRTY;
				kip->ngarbage++;
			} else {
				collect_one_slot(kip, i);
			}
			break;
		}
	}

	if (dirty && ++kprobe_garbage_slots > INSNS_PER_PAGE)
		collect_garbage_slots();
+	mutex_unlock(&kprobe_mutex);
}


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of zhangxiliang
> Sent: Friday, December 21, 2007 1:19 PM
> To: 'Mathieu Desnoyers'; akpm@linux-foundation.org; 'Ingo
> Molnar'; linux-kernel@vger.kernel.org
> Cc: 'Andi Kleen'
> Subject: RE: [patch 05/24] Text Edit Lock - Architecture
> Independent Code
>
> hello,
>        I have some questions for your patches.
>
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
> Why "mark_rodata_ro" doesn't consider smp instance? Maybe it
> will be appied in
> future.
>
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
> In "__register_kprobe" funtion, its implement
> "arch_prepare_kprobe" and
> "arch_arm_kprobe" is also depended on arch.  So the remove
> implement is not
> the same on the different architecture code.
>
> Maybe it doesn't need the mutex_lock in "arch_remove_kprobe"
> on some embeded
> system chips if linux can support the other embeded system
> chips in future.
>
>
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org
> > [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of
> > Mathieu Desnoyers
> > Sent: Friday, December 21, 2007 9:55 AM
> > To: akpm@linux-foundation.org; Ingo Molnar;
> > linux-kernel@vger.kernel.org
> > Cc: Mathieu Desnoyers; Andi Kleen
> > Subject: [patch 05/24] Text Edit Lock - Architecture
> Independent Code
> >
> > This is an architecture independant synchronization around
> kernel text
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
> > + * kernel_text_unlock   -   Release the kernel text
> modification lock
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
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>



