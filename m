Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbYCLNtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbYCLNtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYCLNtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:49:47 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:1559 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYCLNtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:49:45 -0400
Date: Wed, 12 Mar 2008 14:49:24 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, dhowells@redhat.com,
       hpa@zytor.com, ink@jurassic.park.msu.ru, kkojima@rr.iij4u.or.jp,
       lethal@linux-sh.org, mingo@elte.hu, mpm@selenic.com, rc@rc0.org.uk,
       rth@twiddle.net, starvik@axis.com, takata@linux-m32r.org,
       tglx@linutronix.de, ysato@users.sourceforge.jp,
       Byron Bradley <byron.bbradley@gmail.com>, linux-kernel@vger.kernel.org,
       michael@free-electrons.com
Subject: Re: + inflate-refactor-inflate-malloc-code.patch added to -mm tree
Message-ID: <20080312144924.769ad73e@crazy>
In-Reply-To: <20080218140704.4e0d6dba@crazy>
References: <200802152010.m1FKANcT021529@imap1.linux-foundation.org>
	<20080215203103.GA22118@flint.arm.linux.org.uk>
	<20080218140704.4e0d6dba@crazy>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Any comments about this patch ? Could it be included in -mm ?

Thanks,

Thomas

Le Mon, 18 Feb 2008 14:07:04 +0100,
Thomas Petazzoni <thomas.petazzoni@free-electrons.com> a écrit :

> Thanks for the review. I missed the arch_decomp_wdog() part. The
> updated patch below should fix it (the generic inflate code regularly
> calls arch_decomp_wdog() if ARCH_HAS_DECOMP_WDOG is defined). The
> arch_decomp_wdog() call is still used by the S3C platform (see
> include/asm-arm/plat-s3c/uncompress.h).
> 
> The updated patch also fixes the build problem reported by Byron
> Bradley on ARM. On ARM, I renamed free_mem_ptr_end to free_mem_end_ptr
> in order to match the other architectures. I also defined
> free_mem_end_ptr on architectures in which it wasn't defined (CRIS v10
> and CRIS v32).
> 
> I compiled/booted the modified kernel on x86 and ARM.
> 
> I hope that the patch is better now.
> 
> Thanks for your comments and review,
> 
> Thomas
> 
> ---
> 
> inflate: refactor inflate malloc code
> 
> Inflate requires some dynamic memory allocation very early in the boot
> process and this is provided with a set of four functions:
> malloc/free/gzip_mark/gzip_release.
> 
> The old inflate code used a mark/release strategy rather than
> implement free. This new version instead keeps a count on the number
> of outstanding allocations and when it hits zero, it resets the malloc
> arena.
> 
> This allows removing all the mark and release implementations and
> unifying all the malloc/free implementations.
> 
> The architecture-dependent code must define two addresses:
>  - free_mem_ptr, the address of the beginning of the area in which
>    allocations should be made
>  - free_mem_end_ptr, the address of the end of the area in which
>    allocations should be made. If set to 0, then no check is made on
>    the number of allocations, it just grows as much as needed
> 
> The architecture-dependent code can also provide an arch_decomp_wdog()
> function call. This function will be called several times during the
> decompression process, and allow to notify the watchdog that the
> system is still running. If an architecture provides such a call, then
> it must define ARCH_HAS_DECOMP_WDOG so that the generic inflate code
> calls arch_decomp_wdog().
> 
> Work initially done by Matt Mackall <mpm@selenic.com>, updated to a
> recent version of the kernel by me.
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> 
> ---
>  arch/alpha/boot/misc.c                    |   39 +------------------
>  arch/arm/boot/compressed/misc.c           |   59
> +++---------------------------
> arch/cris/arch-v10/boot/compressed/misc.c |   35 -----------------
> arch/cris/arch-v32/boot/compressed/misc.c |   35 -----------------
> arch/h8300/boot/compressed/misc.c         |   38 -------------------
> arch/m32r/boot/compressed/misc.c          |   37 ------------------
> arch/mn10300/boot/compressed/misc.c       |   37 ------------------
> arch/sh/boot/compressed/misc_32.c         |   38 -------------------
> arch/sh/boot/compressed/misc_64.c         |   40 --------------------
> arch/x86/boot/compressed/misc.c           |   37 ------------------
> init/do_mounts_rd.c                       |   25 +-----------
> init/initramfs.c                          |   22 +----------
> lib/inflate.c                             |   52
> ++++++++++++++++++++++---- 13 files changed, 60 insertions(+), 434
> deletions(-)
> 
> Index: linux/arch/alpha/boot/misc.c
> ===================================================================
> --- linux.orig/arch/alpha/boot/misc.c
> +++ linux/arch/alpha/boot/misc.c
> @@ -78,8 +78,6 @@
>  static int  fill_inbuf(void);
>  static void flush_window(void);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>  
>  static char *input_data;
>  static int  input_data_size;
> @@ -88,51 +86,18 @@
>  static ulg output_ptr;
>  static ulg bytes_out;
>  
> -static void *malloc(int size);
> -static void free(void *where);
>  static void error(char *m);
>  static void gzip_mark(void **);
>  static void gzip_release(void **);
>  
>  extern int end;
>  static ulg free_mem_ptr;
> -static ulg free_mem_ptr_end;
> +static ulg free_mem_end_ptr;
>  
>  #define HEAP_SIZE 0x3000
>  
>  #include "../../../lib/inflate.c"
>  
> -static void *malloc(int size)
> -{
> -	void *p;
> -
> -	if (size <0) error("Malloc error");
> -	if (free_mem_ptr <= 0) error("Memory error");
> -
> -	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
> -
> -	p = (void *)free_mem_ptr;
> -	free_mem_ptr += size;
> -
> -	if (free_mem_ptr >= free_mem_ptr_end)
> -		error("Out of memory");
> -	return p;
> -}
> -
> -static void free(void *where)
> -{ /* gzip_mark & gzip_release do the free */
> -}
> -
> -static void gzip_mark(void **ptr)
> -{
> -	*ptr = (void *) free_mem_ptr;
> -}
> -
> -static void gzip_release(void **ptr)
> -{
> -	free_mem_ptr = (long) *ptr;
> -}
> -
>  /*
> ===========================================================================
>   * Fill the input buffer. This is called only when the buffer is
> empty
>   * and at least one byte is really needed.
> @@ -193,7 +158,7 @@
>  
>  	/* FIXME FIXME FIXME */
>  	free_mem_ptr		= (ulg)output_start + ksize;
> -	free_mem_ptr_end	= (ulg)output_start + ksize +
> 0x200000;
> +	free_mem_end_ptr	= (ulg)output_start + ksize +
> 0x200000; /* FIXME FIXME FIXME */
>  
>  	/* put in temp area to reduce initial footprint */
> Index: linux/arch/arm/boot/compressed/misc.c
> ===================================================================
> --- linux.orig/arch/arm/boot/compressed/misc.c
> +++ linux/arch/arm/boot/compressed/misc.c
> @@ -217,8 +217,6 @@
>  static int  fill_inbuf(void);
>  static void flush_window(void);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>  
>  extern char input_data[];
>  extern char input_data_end[];
> @@ -227,64 +225,21 @@
>  static ulg output_ptr;
>  static ulg bytes_out;
>  
> -static void *malloc(int size);
> -static void free(void *where);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>  
>  static void putstr(const char *);
>  
>  extern int end;
>  static ulg free_mem_ptr;
> -static ulg free_mem_ptr_end;
> +static ulg free_mem_end_ptr;
>  
> -#define HEAP_SIZE 0x3000
> -
> -#include "../../../../lib/inflate.c"
> -
> -#ifndef STANDALONE_DEBUG
> -static void *malloc(int size)
> -{
> -	void *p;
> -
> -	if (size <0) error("Malloc error");
> -	if (free_mem_ptr <= 0) error("Memory error");
> -
> -	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
> -
> -	p = (void *)free_mem_ptr;
> -	free_mem_ptr += size;
> -
> -	if (free_mem_ptr >= free_mem_ptr_end)
> -		error("Out of memory");
> -	return p;
> -}
> -
> -static void free(void *where)
> -{ /* gzip_mark & gzip_release do the free */
> -}
> -
> -static void gzip_mark(void **ptr)
> -{
> -	arch_decomp_wdog();
> -	*ptr = (void *) free_mem_ptr;
> -}
> +#ifdef STANDALONE_DEBUG
> +#define NO_INFLATE_MALLOC
> +#endif
>  
> -static void gzip_release(void **ptr)
> -{
> -	arch_decomp_wdog();
> -	free_mem_ptr = (long) *ptr;
> -}
> -#else
> -static void gzip_mark(void **ptr)
> -{
> -}
> +#define ARCH_HAS_DECOMP_WDOG
>  
> -static void gzip_release(void **ptr)
> -{
> -}
> -#endif
> +#include "../../../../lib/inflate.c"
>  
>  /*
> ===========================================================================
>   * Fill the input buffer. This is called only when the buffer is
> empty @@ -348,7 +303,7 @@
>  {
>  	output_data		= (uch *)output_start;	/*
> Points to kernel start */ free_mem_ptr		=
> free_mem_ptr_p;
> -	free_mem_ptr_end	= free_mem_ptr_end_p;
> +	free_mem_end_ptr	= free_mem_ptr_end_p;
>  	__machine_arch_type	= arch_id;
>  
>  	arch_decomp_setup();
> Index: linux/arch/cris/arch-v10/boot/compressed/misc.c
> ===================================================================
> --- linux.orig/arch/cris/arch-v10/boot/compressed/misc.c
> +++ linux/arch/cris/arch-v10/boot/compressed/misc.c
> @@ -84,8 +84,6 @@
>  static int  fill_inbuf(void);
>  static void flush_window(void);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>  
>  extern char *input_data;  /* lives in head.S */
>  
> @@ -93,11 +91,7 @@
>  static uch *output_data;
>  static unsigned long output_ptr = 0;
>   
> -static void *malloc(int size);
> -static void free(void *where);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>   
>  static void puts(const char *);
>  
> @@ -105,37 +99,10 @@
>    
>  extern int end;
>  static long free_mem_ptr = (long)&end;
> +static long free_mem_end_ptr = 0;
>   
>  #include "../../../../../lib/inflate.c"
>  
> -static void *malloc(int size)
> -{
> -	void *p;
> -
> -	if (size <0) error("Malloc error");
> -
> -	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
> -
> -	p = (void *)free_mem_ptr;
> -	free_mem_ptr += size;
> -
> -	return p;
> -}
> -
> -static void free(void *where)
> -{	/* Don't care */
> -}
> -
> -static void gzip_mark(void **ptr)
> -{
> -	*ptr = (void *) free_mem_ptr;
> -}
> -
> -static void gzip_release(void **ptr)
> -{
> -	free_mem_ptr = (long) *ptr;
> -}
> -
>  /* decompressor info and error messages to serial console */
>  
>  static void
> Index: linux/arch/cris/arch-v32/boot/compressed/misc.c
> ===================================================================
> --- linux.orig/arch/cris/arch-v32/boot/compressed/misc.c
> +++ linux/arch/cris/arch-v32/boot/compressed/misc.c
> @@ -89,8 +89,6 @@
>  
>  static void flush_window(void);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>  
>  extern char *input_data;  /* lives in head.S */
>  
> @@ -98,11 +96,7 @@
>  static uch *output_data;
>  static unsigned long output_ptr = 0;
>  
> -static void *malloc(int size);
> -static void free(void *where);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>  
>  static void puts(const char *);
>  
> @@ -110,37 +104,10 @@
>  
>  extern int _end;
>  static long free_mem_ptr = (long)&_end;
> +static long free_mem_end_ptr = 0;
>  
>  #include "../../../../../lib/inflate.c"
>  
> -static void *malloc(int size)
> -{
> -	void *p;
> -
> -	if (size <0) error("Malloc error");
> -
> -	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
> -
> -	p = (void *)free_mem_ptr;
> -	free_mem_ptr += size;
> -
> -	return p;
> -}
> -
> -static void free(void *where)
> -{	/* Don't care */
> -}
> -
> -static void gzip_mark(void **ptr)
> -{
> -	*ptr = (void *) free_mem_ptr;
> -}
> -
> -static void gzip_release(void **ptr)
> -{
> -	free_mem_ptr = (long) *ptr;
> -}
> -
>  /* decompressor info and error messages to serial console */
>  
>  static inline void
> Index: linux/arch/h8300/boot/compressed/misc.c
> ===================================================================
> --- linux.orig/arch/h8300/boot/compressed/misc.c
> +++ linux/arch/h8300/boot/compressed/misc.c
> @@ -67,8 +67,6 @@
>  static int  fill_inbuf(void);
>  static void flush_window(void);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>  
>  extern char input_data[];
>  extern int input_len;
> @@ -77,11 +75,7 @@
>  static uch *output_data;
>  static unsigned long output_ptr = 0;
>  
> -static void *malloc(int size);
> -static void free(void *where);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>  
>  int puts(const char *);
>  
> @@ -98,38 +92,6 @@
>  #define TDR *((volatile unsigned char *)0xffff8b)
>  #define SSR *((volatile unsigned char *)0xffff8c)
>  
> -static void *malloc(int size)
> -{
> -	void *p;
> -
> -	if (size <0) error("Malloc error");
> -	if (free_mem_ptr == 0) error("Memory error");
> -
> -	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
> -
> -	p = (void *)free_mem_ptr;
> -	free_mem_ptr += size;
> -
> -	if (free_mem_ptr >= free_mem_end_ptr)
> -		error("Out of memory");
> -
> -	return p;
> -}
> -
> -static void free(void *where)
> -{	/* Don't care */
> -}
> -
> -static void gzip_mark(void **ptr)
> -{
> -	*ptr = (void *) free_mem_ptr;
> -}
> -
> -static void gzip_release(void **ptr)
> -{
> -	free_mem_ptr = (long) *ptr;
> -}
> -
>  int puts(const char *s)
>  {
>  	return 0;
> Index: linux/arch/m32r/boot/compressed/misc.c
> ===================================================================
> --- linux.orig/arch/m32r/boot/compressed/misc.c
> +++ linux/arch/m32r/boot/compressed/misc.c
> @@ -70,8 +70,6 @@
>  static int  fill_inbuf(void);
>  static void flush_window(void);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>  
>  static unsigned char *input_data;
>  static int input_len;
> @@ -82,9 +80,6 @@
>  
>  #include "m32r_sio.c"
>  
> -static void *malloc(int size);
> -static void free(void *where);
> -
>  static unsigned long free_mem_ptr;
>  static unsigned long free_mem_end_ptr;
>  
> @@ -92,38 +87,6 @@
>  
>  #include "../../../../lib/inflate.c"
>  
> -static void *malloc(int size)
> -{
> -	void *p;
> -
> -	if (size <0) error("Malloc error");
> -	if (free_mem_ptr == 0) error("Memory error");
> -
> -	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
> -
> -	p = (void *)free_mem_ptr;
> -	free_mem_ptr += size;
> -
> -	if (free_mem_ptr >= free_mem_end_ptr)
> -		error("Out of memory");
> -
> -	return p;
> -}
> -
> -static void free(void *where)
> -{	/* Don't care */
> -}
> -
> -static void gzip_mark(void **ptr)
> -{
> -	*ptr = (void *) free_mem_ptr;
> -}
> -
> -static void gzip_release(void **ptr)
> -{
> -	free_mem_ptr = (long) *ptr;
> -}
> -
>  void* memset(void* s, int c, size_t n)
>  {
>  	int i;
> Index: linux/arch/mn10300/boot/compressed/misc.c
> ===================================================================
> --- linux.orig/arch/mn10300/boot/compressed/misc.c
> +++ linux/arch/mn10300/boot/compressed/misc.c
> @@ -153,26 +153,9 @@
>  static unsigned long output_ptr;
>  
>  
> -static void *malloc(int size);
> -
> -static inline void free(void *where)
> -{	/* Don't care */
> -}
> -
>  static unsigned long free_mem_ptr = (unsigned long) &end;
>  static unsigned long free_mem_end_ptr = (unsigned long) &end +
> 0x90000; 
> -static inline void gzip_mark(void **ptr)
> -{
> -	kputs(".");
> -	*ptr = (void *) free_mem_ptr;
> -}
> -
> -static inline void gzip_release(void **ptr)
> -{
> -	free_mem_ptr = (unsigned long) *ptr;
> -}
> -
>  #define INPLACE_MOVE_ROUTINE	0x1000
>  #define LOW_BUFFER_START	0x2000
>  #define LOW_BUFFER_END		0x90000
> @@ -186,26 +169,6 @@
>  
>  #include "../../../../lib/inflate.c"
>  
> -static void *malloc(int size)
> -{
> -	void *p;
> -
> -	if (size < 0)
> -		error("Malloc error\n");
> -	if (!free_mem_ptr)
> -		error("Memory error\n");
> -
> -	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
> -
> -	p = (void *) free_mem_ptr;
> -	free_mem_ptr += size;
> -
> -	if (free_mem_ptr >= free_mem_end_ptr)
> -		error("\nOut of memory\n");
> -
> -	return p;
> -}
> -
>  static inline void scroll(void)
>  {
>  	int i;
> Index: linux/arch/sh/boot/compressed/misc_32.c
> ===================================================================
> --- linux.orig/arch/sh/boot/compressed/misc_32.c
> +++ linux/arch/sh/boot/compressed/misc_32.c
> @@ -74,8 +74,6 @@
>  static int  fill_inbuf(void);
>  static void flush_window(void);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>  
>  extern char input_data[];
>  extern int input_len;
> @@ -84,11 +82,7 @@
>  static uch *output_data;
>  static unsigned long output_ptr = 0;
>  
> -static void *malloc(int size);
> -static void free(void *where);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>  
>  int puts(const char *);
>  
> @@ -101,38 +95,6 @@
>  
>  #include "../../../../lib/inflate.c"
>  
> -static void *malloc(int size)
> -{
> -	void *p;
> -
> -	if (size <0) error("Malloc error");
> -	if (free_mem_ptr == 0) error("Memory error");
> -
> -	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
> -
> -	p = (void *)free_mem_ptr;
> -	free_mem_ptr += size;
> -
> -	if (free_mem_ptr >= free_mem_end_ptr)
> -		error("Out of memory");
> -
> -	return p;
> -}
> -
> -static void free(void *where)
> -{	/* Don't care */
> -}
> -
> -static void gzip_mark(void **ptr)
> -{
> -	*ptr = (void *) free_mem_ptr;
> -}
> -
> -static void gzip_release(void **ptr)
> -{
> -	free_mem_ptr = (long) *ptr;
> -}
> -
>  #ifdef CONFIG_SH_STANDARD_BIOS
>  size_t strlen(const char *s)
>  {
> Index: linux/arch/sh/boot/compressed/misc_64.c
> ===================================================================
> --- linux.orig/arch/sh/boot/compressed/misc_64.c
> +++ linux/arch/sh/boot/compressed/misc_64.c
> @@ -72,8 +72,6 @@
>  static int fill_inbuf(void);
>  static void flush_window(void);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>  
>  extern char input_data[];
>  extern int input_len;
> @@ -82,11 +80,7 @@
>  static uch *output_data;
>  static unsigned long output_ptr = 0;
>  
> -static void *malloc(int size);
> -static void free(void *where);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>  
>  static void puts(const char *);
>  
> @@ -99,40 +93,6 @@
>  
>  #include "../../../../lib/inflate.c"
>  
> -static void *malloc(int size)
> -{
> -	void *p;
> -
> -	if (size < 0)
> -		error("Malloc error\n");
> -	if (free_mem_ptr == 0)
> -		error("Memory error\n");
> -
> -	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
> -
> -	p = (void *) free_mem_ptr;
> -	free_mem_ptr += size;
> -
> -	if (free_mem_ptr >= free_mem_end_ptr)
> -		error("\nOut of memory\n");
> -
> -	return p;
> -}
> -
> -static void free(void *where)
> -{				/* Don't care */
> -}
> -
> -static void gzip_mark(void **ptr)
> -{
> -	*ptr = (void *) free_mem_ptr;
> -}
> -
> -static void gzip_release(void **ptr)
> -{
> -	free_mem_ptr = (long) *ptr;
> -}
> -
>  void puts(const char *s)
>  {
>  }
> Index: linux/arch/x86/boot/compressed/misc.c
> ===================================================================
> --- linux.orig/arch/x86/boot/compressed/misc.c
> +++ linux/arch/x86/boot/compressed/misc.c
> @@ -168,8 +168,6 @@
>  static int  fill_inbuf(void);
>  static void flush_window(void);
>  static void error(char *m);
> -static void gzip_mark(void **);
> -static void gzip_release(void **);
>    
>  /*
>   * This is set up by the setup-routine at boot-time
> @@ -187,9 +185,6 @@
>  
>  static long bytes_out = 0;
>  
> -static void *malloc(int size);
> -static void free(void *where);
> -
>  static void *memset(void *s, int c, unsigned n);
>  static void *memcpy(void *dest, const void *src, unsigned n);
>  
> @@ -220,38 +215,6 @@
>  
>  #include "../../../../lib/inflate.c"
>  
> -static void *malloc(int size)
> -{
> -	void *p;
> -
> -	if (size <0) error("Malloc error");
> -	if (free_mem_ptr <= 0) error("Memory error");
> -
> -	free_mem_ptr = (free_mem_ptr + 3) & ~3;	/* Align */
> -
> -	p = (void *)free_mem_ptr;
> -	free_mem_ptr += size;
> -
> -	if (free_mem_ptr >= free_mem_end_ptr)
> -		error("Out of memory");
> -
> -	return p;
> -}
> -
> -static void free(void *where)
> -{	/* Don't care */
> -}
> -
> -static void gzip_mark(void **ptr)
> -{
> -	*ptr = (void *) free_mem_ptr;
> -}
> -
> -static void gzip_release(void **ptr)
> -{
> -	free_mem_ptr = (memptr) *ptr;
> -}
> - 
>  static void scroll(void)
>  {
>  	int i;
> Index: linux/init/do_mounts_rd.c
> ===================================================================
> --- linux.orig/init/do_mounts_rd.c
> +++ linux/init/do_mounts_rd.c
> @@ -313,32 +313,11 @@
>  
>  static int  __init fill_inbuf(void);
>  static void __init flush_window(void);
> -static void __init *malloc(size_t size);
> -static void __init free(void *where);
>  static void __init error(char *m);
> -static void __init gzip_mark(void **);
> -static void __init gzip_release(void **);
>  
> -#include "../lib/inflate.c"
> -
> -static void __init *malloc(size_t size)
> -{
> -	return kmalloc(size, GFP_KERNEL);
> -}
> -
> -static void __init free(void *where)
> -{
> -	kfree(where);
> -}
> -
> -static void __init gzip_mark(void **ptr)
> -{
> -}
> -
> -static void __init gzip_release(void **ptr)
> -{
> -}
> +#define NO_INFLATE_MALLOC
>  
> +#include "../lib/inflate.c"
>  
>  /*
> ===========================================================================
>   * Fill the input buffer. This is called only when the buffer is
> empty Index: linux/init/initramfs.c
> ===================================================================
> --- linux.orig/init/initramfs.c
> +++ linux/init/initramfs.c
> @@ -14,16 +14,6 @@
>  		message = x;
>  }
>  
> -static void __init *malloc(size_t size)
> -{
> -	return kmalloc(size, GFP_KERNEL);
> -}
> -
> -static void __init free(void *where)
> -{
> -	kfree(where);
> -}
> -
>  /* link hash */
>  
>  #define N_ALIGN(len) ((((len) + 1) & ~3) + 2)
> @@ -407,18 +397,10 @@
>  
>  static void __init flush_window(void);
>  static void __init error(char *m);
> -static void __init gzip_mark(void **);
> -static void __init gzip_release(void **);
>  
> -#include "../lib/inflate.c"
> +#define NO_INFLATE_MALLOC
>  
> -static void __init gzip_mark(void **ptr)
> -{
> -}
> -
> -static void __init gzip_release(void **ptr)
> -{
> -}
> +#include "../lib/inflate.c"
>  
>  /*
> ===========================================================================
>   * Write the output window window[0..outcnt-1] and update crc and
> bytes_out. Index: linux/lib/inflate.c
> ===================================================================
> --- linux.orig/lib/inflate.c
> +++ linux/lib/inflate.c
> @@ -230,6 +230,45 @@
>  #define NEEDBITS(n) {while(k<(n)){b|=((ulg)NEXTBYTE())<<k;k+=8;}}
>  #define DUMPBITS(n) {b>>=(n);k-=(n);}
>  
> +#ifndef NO_INFLATE_MALLOC
> +/* A trivial malloc implementation, adapted from
> + *  malloc by Hannu Savolainen 1993 and Matthias Urlichs 1994
> + */
> +
> +static unsigned long malloc_ptr;
> +static int malloc_count;
> +
> +static void *malloc(int size)
> +{
> +       void *p;
> +
> +       if (size <0)
> +               error("Malloc error");
> +       if (!malloc_ptr)
> +               malloc_ptr = free_mem_ptr;
> +
> +       malloc_ptr = (malloc_ptr + 3) & ~3;     /* Align */
> +
> +       p = (void *)malloc_ptr;
> +       malloc_ptr += size;
> +
> +       if (free_mem_end_ptr && malloc_ptr >= free_mem_end_ptr)
> +               error("Out of memory");
> +
> +       malloc_count++;
> +       return p;
> +}
> +
> +static void free(void *where)
> +{
> +       malloc_count--;
> +       if (!malloc_count)
> +               malloc_ptr = free_mem_ptr;
> +}
> +#else
> +#define malloc(a) kmalloc(a, GFP_KERNEL)
> +#define free(a) kfree(a)
> +#endif
>  
>  /*
>     Huffman code decoding is performed using a multi-level table
> lookup. @@ -1042,7 +1081,6 @@
>    int e;                /* last block flag */
>    int r;                /* result code */
>    unsigned h;           /* maximum struct huft's malloc'ed */
> -  void *ptr;
>  
>    /* initialize window, bit buffer */
>    wp = 0;
> @@ -1054,12 +1092,12 @@
>    h = 0;
>    do {
>      hufts = 0;
> -    gzip_mark(&ptr);
> -    if ((r = inflate_block(&e)) != 0) {
> -      gzip_release(&ptr);	    
> -      return r;
> -    }
> -    gzip_release(&ptr);
> +#ifdef ARCH_HAS_DECOMP_WDOG
> +    arch_decomp_wdog();
> +#endif
> +    r = inflate_block(&e);
> +    if (r)
> +	    return r;
>      if (hufts > h)
>        h = hufts;
>    } while (!e);
> 
> 


-- 
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)
