Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZBTXp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZBTXp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbZBTXpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:45:16 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:25601 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbZBTXpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:45:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=YD5c8e+RppQ/ZwLGAw1p8JvPqehhYydFPz6UkEzl0GfqN9HuHv1DbtOEmVCKytrwKI
         hm+s6dz+gB9Hzm6RKBy4p+akjLGlXqagfuhWBFyJM8O9oZFhQoXSznrqwal0/a/g45/7
         w7jGNpXeiRSsc+1wnqxJykIrclEN/EUFUAXyo=
Date: Sat, 21 Feb 2009 01:38:45 +0200
From: Pekka Paalanen <pq@iki.fi>
To: hpa@zytor.com, mingo@redhat.com, torvalds@linux-foundation.org, pq@iki.fi,
       tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm: fault.c, simplify kmmio_fault()
Message-ID: <20090221013845.718d507a@daedalus.pq.iki.fi>
In-Reply-To: <tip-b814d41f0987c7648d7ed07471258101c95c026b@kernel.org>
References: <tip-b814d41f0987c7648d7ed07471258101c95c026b@kernel.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 22:40:09 GMT
Ingo Molnar <mingo@elte.hu> wrote:

> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Fri, 20 Feb 2009 22:32:10 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 21 Feb 2009 00:09:42 +0100
> 
> x86, mm: fault.c, simplify kmmio_fault()
> 
> Impact: cleanup
> 
> Remove an #ifdef from kmmio_fault() - we can do this by
> providing default implementations for is_kmmio_active()
> and kmmio_handler(). The compiler optimizes it all away
> in the !CONFIG_MMIOTRACE case.
> 
> Also, while at it, clean up mmiotrace.h a bit:
> 
>  - standard header guards
>  - standard vertical spaces for structure definitions
> 
> No code changed (both with mmiotrace on and off in the config):
> 
>    text	   data	    bss	    dec	    hex	filename
>    2947	     12	     12	   2971	    b9b	fault.o.before
>    2947	     12	     12	   2971	    b9b	fault.o.after
> 
> Cc: Pekka Paalanen <pq@iki.fi>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 

Acked-by: Pekka Paalanen <pq@iki.fi>
except for one minor detail below.

> 
> ---
>  arch/x86/mm/fault.c       |    5 ++-
>  include/linux/mmiotrace.h |   78 +++++++++++++++++++++++++++------------------
>  2 files changed, 50 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 3e36614..fe99af4 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -55,13 +55,14 @@ enum x86_pf_error_code {
>  	PF_INSTR	=		1 << 4,
>  };
>  
> +/*
> + * (returns 0 if mmiotrace is disabled)

Returns 0 if the fault was not handled in mmiotrace.

> + */
>  static inline int kmmio_fault(struct pt_regs *regs, unsigned long addr)
>  {
> -#ifdef CONFIG_MMIOTRACE
>  	if (unlikely(is_kmmio_active()))
>  		if (kmmio_handler(regs, addr) == 1)
>  			return -1;
> -#endif
>  	return 0;
>  }
>  
> diff --git a/include/linux/mmiotrace.h b/include/linux/mmiotrace.h
> index 139d7c8..3d1b7bd 100644
> --- a/include/linux/mmiotrace.h
> +++ b/include/linux/mmiotrace.h
> @@ -1,5 +1,5 @@
> -#ifndef MMIOTRACE_H
> -#define MMIOTRACE_H
> +#ifndef _LINUX_MMIOTRACE_H
> +#define _LINUX_MMIOTRACE_H
>  
>  #include <linux/types.h>
>  #include <linux/list.h>
> @@ -13,28 +13,34 @@ typedef void (*kmmio_post_handler_t)(struct kmmio_probe *,
>  				unsigned long condition, struct pt_regs *);
>  
>  struct kmmio_probe {
> -	struct list_head list; /* kmmio internal list */
> -	unsigned long addr; /* start location of the probe point */
> -	unsigned long len; /* length of the probe region */
> -	kmmio_pre_handler_t pre_handler; /* Called before addr is executed. */
> -	kmmio_post_handler_t post_handler; /* Called after addr is executed */
> -	void *private;
> +	/* kmmio internal list: */
> +	struct list_head	list;
> +	/* start location of the probe point: */
> +	unsigned long		addr;
> +	/* length of the probe region: */
> +	unsigned long		len;
> +	/* Called before addr is executed: */
> +	kmmio_pre_handler_t	pre_handler;
> +	/* Called after addr is executed: */
> +	kmmio_post_handler_t	post_handler;
> +	void			*private;
>  };
>  
> +extern unsigned int kmmio_count;
> +
> +extern int register_kmmio_probe(struct kmmio_probe *p);
> +extern void unregister_kmmio_probe(struct kmmio_probe *p);
> +
> +#ifdef CONFIG_MMIOTRACE
>  /* kmmio is active by some kmmio_probes? */
>  static inline int is_kmmio_active(void)
>  {
> -	extern unsigned int kmmio_count;
>  	return kmmio_count;
>  }
>  
> -extern int register_kmmio_probe(struct kmmio_probe *p);
> -extern void unregister_kmmio_probe(struct kmmio_probe *p);
> -
>  /* Called from page fault handler. */
>  extern int kmmio_handler(struct pt_regs *regs, unsigned long addr);
>  
> -#ifdef CONFIG_MMIOTRACE
>  /* Called from ioremap.c */
>  extern void mmiotrace_ioremap(resource_size_t offset, unsigned long size,
>  							void __iomem *addr);
> @@ -43,7 +49,17 @@ extern void mmiotrace_iounmap(volatile void __iomem *addr);
>  /* For anyone to insert markers. Remember trailing newline. */
>  extern int mmiotrace_printk(const char *fmt, ...)
>  				__attribute__ ((format (printf, 1, 2)));
> -#else
> +#else /* !CONFIG_MMIOTRACE: */
> +static inline int is_kmmio_active(void)
> +{
> +	return 0;
> +}
> +
> +static inline int kmmio_handler(struct pt_regs *regs, unsigned long addr)
> +{
> +	return 0;
> +}
> +
>  static inline void mmiotrace_ioremap(resource_size_t offset,
>  					unsigned long size, void __iomem *addr)
>  {
> @@ -63,28 +79,28 @@ static inline int mmiotrace_printk(const char *fmt, ...)
>  #endif /* CONFIG_MMIOTRACE */
>  
>  enum mm_io_opcode {
> -	MMIO_READ = 0x1,     /* struct mmiotrace_rw */
> -	MMIO_WRITE = 0x2,    /* struct mmiotrace_rw */
> -	MMIO_PROBE = 0x3,    /* struct mmiotrace_map */
> -	MMIO_UNPROBE = 0x4,  /* struct mmiotrace_map */
> -	MMIO_UNKNOWN_OP = 0x5, /* struct mmiotrace_rw */
> +	MMIO_READ	= 0x1,	/* struct mmiotrace_rw */
> +	MMIO_WRITE	= 0x2,	/* struct mmiotrace_rw */
> +	MMIO_PROBE	= 0x3,	/* struct mmiotrace_map */
> +	MMIO_UNPROBE	= 0x4,	/* struct mmiotrace_map */
> +	MMIO_UNKNOWN_OP = 0x5,	/* struct mmiotrace_rw */
>  };
>  
>  struct mmiotrace_rw {
> -	resource_size_t phys;	/* PCI address of register */
> -	unsigned long value;
> -	unsigned long pc;	/* optional program counter */
> -	int map_id;
> -	unsigned char opcode;	/* one of MMIO_{READ,WRITE,UNKNOWN_OP} */
> -	unsigned char width;	/* size of register access in bytes */
> +	resource_size_t	phys;	/* PCI address of register */
> +	unsigned long	value;
> +	unsigned long	pc;	/* optional program counter */
> +	int		map_id;
> +	unsigned char	opcode;	/* one of MMIO_{READ,WRITE,UNKNOWN_OP} */
> +	unsigned char	width;	/* size of register access in bytes */
>  };
>  
>  struct mmiotrace_map {
> -	resource_size_t phys;	/* base address in PCI space */
> -	unsigned long virt;	/* base virtual address */
> -	unsigned long len;	/* mapping size */
> -	int map_id;
> -	unsigned char opcode;	/* MMIO_PROBE or MMIO_UNPROBE */
> +	resource_size_t	phys;	/* base address in PCI space */
> +	unsigned long	virt;	/* base virtual address */
> +	unsigned long	len;	/* mapping size */
> +	int		map_id;
> +	unsigned char	opcode;	/* MMIO_PROBE or MMIO_UNPROBE */
>  };
>  
>  /* in kernel/trace/trace_mmiotrace.c */
> @@ -94,4 +110,4 @@ extern void mmio_trace_rw(struct mmiotrace_rw *rw);
>  extern void mmio_trace_mapping(struct mmiotrace_map *map);
>  extern int mmio_trace_printk(const char *fmt, va_list args);
>  
> -#endif /* MMIOTRACE_H */
> +#endif /* _LINUX_MMIOTRACE_H */
> 


-- 
Pekka Paalanen
http://www.iki.fi/pq/
