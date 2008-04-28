Return-Path: <linux-kernel-owner+w=401wt.eu-S937304AbYD1TDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937304AbYD1TDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937211AbYD1TC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:02:29 -0400
Received: from hu-out-0506.google.com ([72.14.214.232]:64595 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937199AbYD1TC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:02:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=RYYC960MAxQLN0gFTQbjQPYeclKqY3qkykVNQzyOVuFHzF1VJSiL75ruVZiC0u3MBI0ZibqDHww/y9rn4sWKbridPKI7emXiXeOt0d8RFPUWYr7sIF2skmpL/dWO5DoAb77EQX31Vj2F3HVcEjQDrtWgcu/V+9kEqUJVUYpNyDM=
Date: Mon, 28 Apr 2008 22:02:09 +0300
From: Pekka Paalanen <pq@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: Pekka Paalanen <pq@iki.fi>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 3/3] mmiotrace full patch, preview 3
Message-ID: <20080428220209.1df54d86@daedalus.pq.iki.fi>
In-Reply-To: <20080428215854.1047eb5d@daedalus.pq.iki.fi>
References: <20080428214504.5c359195@daedalus.pq.iki.fi>
	<20080428215854.1047eb5d@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, sorry, this is of course titled RFC 3/3.


On Mon, 28 Apr 2008 21:58:54 +0300
Pekka Paalanen <pq@iki.fi> wrote:

> On Mon, 28 Apr 2008 21:45:04 +0300
> Pekka Paalanen <pq@iki.fi> wrote:
> 
> > Hi all,
> > 
> > this is the third full mmiotrace patch set for review (a bit late, sorry).
> > These patches do not apply to any git tree that I know of, but after Ingo
> > pushes a new version of his sched-devel/latest tree, these patches should
> > be subtractable from there.
> ...
> > This first patch adds the bulk of the new code, only introducing new files.
> > The second patch establishes the interfaces to the ftrace framework, and
> > the third patch hooks everything up into the Kbuild system, page fault
> > handler, and ioremap functions.
> 
>  arch/x86/Kconfig.debug |   28 ++++++++++++++++++++++++++++
>  arch/x86/mm/Makefile   |    5 +++++
>  arch/x86/mm/fault.c    |   13 +++++++++++++
>  arch/x86/mm/ioremap.c  |    9 ++++++++-
>  arch/x86/mm/pageattr.c |    1 +
>  5 files changed, 55 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index 1f237d2..fb0794e 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -170,6 +170,34 @@ config IOMMU_LEAK
>  	  Add a simple leak tracer to the IOMMU code. This is useful when you
>  	  are debugging a buggy device driver that leaks IOMMU mappings.
>  
> +config MMIOTRACE_HOOKS
> +	bool
> +
> +config MMIOTRACE
> +	bool "Memory mapped IO tracing"
> +	depends on DEBUG_KERNEL && PCI
> +	select TRACING
> +	select MMIOTRACE_HOOKS
> +	default y
> +	help
> +	  Mmiotrace traces Memory Mapped I/O access and is meant for
> +	  debugging and reverse engineering. It is called from the ioremap
> +	  implementation and works via page faults. Tracing is disabled by
> +	  default and can be enabled at run-time.
> +
> +	  See Documentation/tracers/mmiotrace.txt.
> +	  If you are not helping to develop drivers, say N.
> +
> +config MMIOTRACE_TEST
> +	tristate "Test module for mmiotrace"
> +	depends on MMIOTRACE && m
> +	help
> +	  This is a dumb module for testing mmiotrace. It is very dangerous
> +	  as it will write garbage to IO memory starting at a given address.
> +	  However, it should be safe to use on e.g. unused portion of VRAM.
> +
> +	  Say N, unless you absolutely know what you are doing.
> +
>  #
>  # IO delay types:
>  #
> diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
> index b7b3e4c..07dab50 100644
> --- a/arch/x86/mm/Makefile
> +++ b/arch/x86/mm/Makefile
> @@ -8,6 +8,11 @@ obj-$(CONFIG_X86_PTDUMP)	+= dump_pagetables.o
>  
>  obj-$(CONFIG_HIGHMEM)		+= highmem_32.o
>  
> +obj-$(CONFIG_MMIOTRACE_HOOKS)	+= kmmio.o
> +obj-$(CONFIG_MMIOTRACE)		+= mmiotrace.o
> +mmiotrace-y			:= pf_in.o mmio-mod.o
> +obj-$(CONFIG_MMIOTRACE_TEST)	+= testmmiotrace.o
> +
>  ifeq ($(CONFIG_X86_32),y)
>  obj-$(CONFIG_NUMA)		+= discontig_32.o
>  else
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 4145597..0440dce 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -26,6 +26,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/kdebug.h>
>  #include <linux/magic.h>
> +#include <linux/mmiotrace.h>
>  
>  #include <asm/system.h>
>  #include <asm/desc.h>
> @@ -51,6 +52,16 @@
>  #define PF_RSVD		(1<<3)
>  #define PF_INSTR	(1<<4)
>  
> +static inline int kmmio_fault(struct pt_regs *regs, unsigned long addr)
> +{
> +#ifdef CONFIG_MMIOTRACE_HOOKS
> +	if (unlikely(is_kmmio_active()))
> +		if (kmmio_handler(regs, addr) == 1)
> +			return -1;
> +#endif
> +	return 0;
> +}
> +
>  static inline int notify_page_fault(struct pt_regs *regs)
>  {
>  #ifdef CONFIG_KPROBES
> @@ -623,6 +634,8 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
>  
>  	if (notify_page_fault(regs))
>  		return;
> +	if (unlikely(kmmio_fault(regs, address)))
> +		return;
>  
>  	/*
>  	 * We fault-in kernel-space virtual memory on-demand. The
> diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
> index d176b23..68b287d 100644
> --- a/arch/x86/mm/ioremap.c
> +++ b/arch/x86/mm/ioremap.c
> @@ -12,6 +12,7 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
> +#include <linux/mmiotrace.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/e820.h>
> @@ -126,6 +127,7 @@ static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
>  	unsigned long new_prot_val;
>  	pgprot_t prot;
>  	int retval;
> +	void __iomem *ret_addr;
>  
>  	/* Don't allow wraparound or zero size */
>  	last_addr = phys_addr + size - 1;
> @@ -229,7 +231,10 @@ static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
>  		return NULL;
>  	}
>  
> -	return (void __iomem *) (vaddr + offset);
> +	ret_addr = (void __iomem *) (vaddr + offset);
> +	mmiotrace_ioremap(phys_addr, size, ret_addr);
> +
> +	return ret_addr;
>  }
>  
>  /**
> @@ -306,6 +311,8 @@ void iounmap(volatile void __iomem *addr)
>  	    addr < phys_to_virt(ISA_END_ADDRESS))
>  		return;
>  
> +	mmiotrace_iounmap(addr);
> +
>  	addr = (volatile void __iomem *)
>  		(PAGE_MASK & (unsigned long __force)addr);
>  
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index bd5e05c..099374b 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -227,6 +227,7 @@ pte_t *lookup_address(unsigned long address, unsigned int *level)
>  
>  	return pte_offset_kernel(pmd, address);
>  }
> +EXPORT_SYMBOL_GPL(lookup_address);
>  
>  /*
>   * Set the new pmd in all the pgds we know about:
> 


-- 
Pekka Paalanen
http://www.iki.fi/pq/
