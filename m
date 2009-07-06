Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbZGFBNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbZGFBNY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 21:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbZGFBNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 21:13:12 -0400
Received: from ozlabs.org ([203.10.76.45]:40505 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757130AbZGFBNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 21:13:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Subject: Re: [PATCH v3] RO/NX protection for loadable kernel modules
Date: Mon, 6 Jul 2009 10:43:09 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
References: <817ecb6f0907051623l46ad93e9uc24d8d61669c938e@mail.gmail.com>
In-Reply-To: <817ecb6f0907051623l46ad93e9uc24d8d61669c938e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907061043.11793.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009 08:53:56 am Siarhei Liakh wrote:
> This patch is a logical extension of the protection provided by
> CONFIG_DEBUG_RODATA to LKMs.

Hi Siarhei,

   Concept looks good, but needs a bit more de-macroing.

> +/* Modules' sections will be aligned on page boundaries
> + * to ensure complete separation of code and data */
> +#ifdef CONFIG_DEBUG_RODATA
> +#define ALIGN_MODULE_SECTION(SECTION, ALIGNMENT) \
> +	do { SECTION = ALIGN(SECTION, ALIGNMENT); } while (0)
> +#else
> +#define ALIGN_MODULE_SECTION(SECTION, ALIGNMENT) do { ; } while (0)
> +#endif
> +
> +/* Given a virtual address returns 1 if the address is page-aligned,
> + * 0 otherwise */
> +#define PAGE_ALIGNED(ADDR) (((unsigned long) ADDR & \
> +				((1UL << PAGE_SHIFT) - 1UL)) ? \
> +					(0) : (1))
> +
> +/* Given a virtual address returns a virtual page number
> + * that contains that address */
> +#define PAGE_NUMBER(ADDR) (((unsigned long) ADDR) >> PAGE_SHIFT)
> +
> +/* Given BASE and SIZE this macro calculates the number of pages the
> + * memory regions occupies */
> +#define NUMBER_OF_PAGES(BASE, SIZE) ((SIZE > 0) ?	\
> +		(PAGE_NUMBER(BASE + SIZE - 1) -		\
> +			 PAGE_NUMBER(BASE) + 1)		\
> +		: (0UL))
> +
> +/* This macro catches a section group with SEC_ID and records it's
> + * size into SEC_SIZE, aligning it (as well as SIZE) on page boundary
> + * if necessary */
> +#define CATCH_MODULE_SECTION(SEC_GROUP, SEC_ID, SEC_SIZE, SIZE)	\
> +	do {							\
> +		if (SEC_GROUP == SEC_ID) {			\
> +			/* align section size to a page */	\
> +			ALIGN_MODULE_SECTION(SIZE, PAGE_SIZE);	\
> +			/* set new module section size */	\
> +			SEC_SIZE = SIZE;			\
> +		}						\
> +	} while (0)

This is far clearer open-coded.  As a switch statement:

	switch (m) {
	case 0: /* executable */
		mod->core_text_size = debug_align(mod->core_text_size);
		mod->core_size = mod->core_text_size;
		break;
	case 1: /* RO data (executable code + RO data) */
		mod->core_ro_size = debug_align(mod->core_ro_size);
		mod->core_size = mod->core_ro_size;
		break;
	case 3: /* whole module (executable + RO data + RW data + small alloc) */
		mod->core_size = debug_align(mod->core_size);
		break;
	}

Later, we can create a nice struct to hold the section parts and merge the 
layout code between init and core loops.

> +/* Generic memory allocation for modules, since
> + * module_alloc() is platform-specific */
> +#define generic_module_alloc(size) module_alloc(size)
> +
> +/* Free memory returned from generic_module_alloc, since
> + * module_free() is platform-specific */
> +void generic_module_free(struct module *mod, void *module_region)

I don't like the gratuitous unused generic_module_alloc, nor the 
generic_module_free name.   Probably best to implement unset_section_ro_nx() 
and call it explicitly in the three places needed: two in free_module and one 
in sys_init_module.

> +/* LKM RO/NX protection: protect module's text/ro-data
> + * from modification and any data from execution.
> + * Siarhei Liakh, Xuxian Jiang  */
> +static void set_section_ro_nx(unsigned long base,
> +			unsigned long text_size,
> +			unsigned long ro_size,
> +			unsigned long total_size)

A void * first arg would make the callers not need to cast: does it make the 
implementation messier?  (Remember, gcc lets you do arithmetic on void * 
pointers).

Thanks!
Rusty.
