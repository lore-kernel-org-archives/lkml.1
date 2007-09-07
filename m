Return-Path: <linux-kernel-owner+w=401wt.eu-S965125AbXIGInp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965125AbXIGInp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 04:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964986AbXIGIng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 04:43:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43856 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964985AbXIGIne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 04:43:34 -0400
Date: Fri, 7 Sep 2007 14:13:15 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, pageexec@freemail.hu
Subject: Re: [patch 05/10] Text Edit Lock - Alternative code for i386 and x86_64
Message-ID: <20070907084315.GA28915@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070906200124.595238505@polymtl.ca> <20070906200212.080849869@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070906200212.080849869@polymtl.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2007 at 04:01:29PM -0400, Mathieu Desnoyers wrote:

<snip>

> Index: linux-2.6-lttng/arch/i386/kernel/alternative.c
> ===================================================================
> --- linux-2.6-lttng.orig/arch/i386/kernel/alternative.c	2007-09-06 14:32:11.000000000 -0400
> +++ linux-2.6-lttng/arch/i386/kernel/alternative.c	2007-09-06 14:59:19.000000000 -0400
> @@ -16,6 +16,99 @@
>  #ifdef CONFIG_HOTPLUG_CPU
>  static int smp_alt_once;
> 
> +/*
> + * Warning:
> + * When you use this code to patch more than one byte of an instruction
> + * you need to make sure that other CPUs cannot execute this code in parallel.
> + * Also no thread must be currently preempted in the middle of these
> + * instructions.  And on the local CPU you need to be protected again NMI or MCE
> + * handlers seeing an inconsistent instruction while you patch.
> + * Warning: read_cr0 is modified by paravirt, this is why we have _early
> + * versions. They are not in the __init section because they can be used at
> + * module load time.
> + */
> +static inline void text_sync(void *addr, size_t len)
> +{
> +	void *faddr;
> +
> +	sync_core();
> +	/* Not strictly needed, but can speed CPU recovery up. */
> +	if (cpu_has_clflush)
> +		for (faddr = addr; faddr < addr + len;
> +				faddr += boot_cpu_data.x86_clflush_size)
> +			asm("clflush (%0) " :: "r" (faddr) : "memory");
> +}
> +
> +void * text_poke_early(void *addr, const void *opcode,
> +					size_t len)
> +{
> +	memcpy(addr, opcode, len);
> +	text_sync(addr, len);
> +	return addr;
> +}
> +
> +void * text_set_early(void *addr, int c, size_t len)
> +{
> +	memset(addr, c, len);
> +	text_sync(addr, len);
> +	return addr;
> +}
> +
> +/*
> + * Only atomic text poke/set should be allowed when not doing early patching.
> + * It means the size must be writable atomically and the address must be aligned
> + * in a way that permits an atomic write.
> + */
> +void * __kprobes text_poke(void *addr, const void *opcode, size_t len)
> +{
> +	unsigned long cr0;
> +	int unaligned;
> +
> +	if (len > sizeof(long)) {
> +		printk(KERN_ERR "text_poke of len %zu too big (max %lu)\n",
> +			len, sizeof(long));
> +		BUG_ON(1);
> +	}
> +	unaligned = (((long)addr + len - 1) & ~(sizeof(long) - 1))
> +		- ((long)addr & ~(sizeof(long) - 1));
> +	if (unlikely(unaligned)) {
> +		printk(KERN_ERR "text_poke of at addr %p of len %zu is "
> +				"unaligned (%d)\n",
> +			addr, len, unaligned);
> +		BUG_ON(1);
> +	}
> +	kernel_wp_save(cr0);
> +	memcpy(addr, opcode, len);
> +	kernel_wp_restore(cr0);
> +	text_sync(addr, len);
> +	return addr;
> +}
> +
> +void * __kprobes text_set(void *addr, int c, size_t len)
> +{
> +	unsigned long cr0;
> +	int unaligned;
> +
> +	if (len > sizeof(long)) {
> +		printk(KERN_ERR "text_set of len %zu too big (max %lu)\n",
> +			len, sizeof(long));
> +		BUG_ON(1);
> +	}
> +	unaligned = (((long)addr + len - 1) & ~(sizeof(long) - 1))
> +		- ((long)addr & ~(sizeof(long) - 1));
> +	if (unlikely(unaligned)) {
> +		printk(KERN_ERR "text_set of at addr %p of len %zu is "
> +				"unaligned (%d)\n",
> +			addr, len, unaligned);
> +		BUG_ON(1);
> +	}
> +	kernel_wp_save(cr0);
> +	memset(addr, c, len);
> +	kernel_wp_restore(cr0);
> +	text_sync(addr, len);
> +	return addr;
> +}
> +

The above chunk is within ifdef CONFIG_HOTPLUG_CPU. This breaks a CONFIG_SMP=n
build:

  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
arch/i386/kernel/built-in.o: In function `apply_alternatives':
/home/ananth/kprobes/marker/linux-2.6.23-rc4/arch/i386/kernel/alternative.c:293:
undefined reference to `text_poke_early'
arch/i386/kernel/built-in.o: In function `arch_disarm_kprobe':
/home/ananth/kprobes/marker/linux-2.6.23-rc4/arch/i386/kernel/kprobes.c:185:
undefined reference to `text_set'
arch/i386/kernel/built-in.o: In function `arch_arm_kprobe':
/home/ananth/kprobes/marker/linux-2.6.23-rc4/arch/i386/kernel/kprobes.c:180:
undefined reference to `text_set'
make: *** [.tmp_vmlinux1] Error 1

Ananth
