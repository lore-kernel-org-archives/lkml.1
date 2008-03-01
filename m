Return-Path: <linux-kernel-owner+w=401wt.eu-S932678AbYCADFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbYCADFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 22:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYCADFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 22:05:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:52443 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbYCADFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 22:05:43 -0500
Subject: Re: [PATCH] add strncmp to PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1204301097.14759.6.camel@localhost.localdomain>
References: <1204301097.14759.6.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 01 Mar 2008 14:04:50 +1100
Message-Id: <1204340690.15052.457.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 11:04 -0500, Steven Rostedt wrote:
> strncmp is defined in assembly for bootup, but it is not defined in the
> normal running kernel. This patch takes the strncmp code from the bootup
> and copies it to the kernel proper.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---

Do we have any indication that it performs better than the C one ?

Ben.

>  arch/powerpc/kernel/ppc_ksyms.c |    1 +
>  arch/powerpc/lib/string.S       |   12 ++++++++++++
>  include/asm-powerpc/string.h    |    2 ++
>  3 files changed, 15 insertions(+)
> 
> Index: linux-sched-devel.git/arch/powerpc/kernel/ppc_ksyms.c
> ===================================================================
> --- linux-sched-devel.git.orig/arch/powerpc/kernel/ppc_ksyms.c	2008-02-27 14:01:38.000000000 -0800
> +++ linux-sched-devel.git/arch/powerpc/kernel/ppc_ksyms.c	2008-02-29 07:24:22.000000000 -0800
> @@ -78,6 +78,7 @@ EXPORT_SYMBOL(strncpy);
>  EXPORT_SYMBOL(strcat);
>  EXPORT_SYMBOL(strlen);
>  EXPORT_SYMBOL(strcmp);
> +EXPORT_SYMBOL(strncmp);
>  
>  EXPORT_SYMBOL(csum_partial);
>  EXPORT_SYMBOL(csum_partial_copy_generic);
> Index: linux-sched-devel.git/arch/powerpc/lib/string.S
> ===================================================================
> --- linux-sched-devel.git.orig/arch/powerpc/lib/string.S	2008-02-27 14:01:38.000000000 -0800
> +++ linux-sched-devel.git/arch/powerpc/lib/string.S	2008-02-29 07:24:22.000000000 -0800
> @@ -75,6 +75,18 @@ _GLOBAL(strcmp)
>  	beq	1b
>  	blr
>  
> +_GLOBAL(strncmp)
> +	mtctr	r5
> +	addi	r5,r3,-1
> +	addi	r4,r4,-1
> +1:	lbzu	r3,1(r5)
> +	cmpwi	1,r3,0
> +	lbzu	r0,1(r4)
> +	subf.	r3,r0,r3
> +	beqlr	1
> +	bdnzt	eq,1b
> +	blr
> +
>  _GLOBAL(strlen)
>  	addi	r4,r3,-1
>  1:	lbzu	r0,1(r4)
> Index: linux-sched-devel.git/include/asm-powerpc/string.h
> ===================================================================
> --- linux-sched-devel.git.orig/include/asm-powerpc/string.h	2008-02-27 14:01:58.000000000 -0800
> +++ linux-sched-devel.git/include/asm-powerpc/string.h	2008-02-29 07:24:22.000000000 -0800
> @@ -7,6 +7,7 @@
>  #define __HAVE_ARCH_STRNCPY
>  #define __HAVE_ARCH_STRLEN
>  #define __HAVE_ARCH_STRCMP
> +#define __HAVE_ARCH_STRNCMP
>  #define __HAVE_ARCH_STRCAT
>  #define __HAVE_ARCH_MEMSET
>  #define __HAVE_ARCH_MEMCPY
> @@ -18,6 +19,7 @@ extern char * strcpy(char *,const char *
>  extern char * strncpy(char *,const char *, __kernel_size_t);
>  extern __kernel_size_t strlen(const char *);
>  extern int strcmp(const char *,const char *);
> +extern int strncmp(const char *,const char *,__kernel_size_t);
>  extern char * strcat(char *, const char *);
>  extern void * memset(void *,int,__kernel_size_t);
>  extern void * memcpy(void *,const void *,__kernel_size_t);
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

