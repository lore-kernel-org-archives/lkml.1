Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbXJOXrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbXJOXrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 19:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbXJOXq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 19:46:57 -0400
Received: from smtp-out.google.com ([216.239.45.13]:28688 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbXJOXq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 19:46:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=fpI0lsNfkAOXT0v7g7YIM1iUCRjbgt1wsI+4+ddS5EFk5+4pYb9YOXKrLHa0O5k07
	M8tvTB1Vh3W1Xov8tgySg==
Date: Mon, 15 Oct 2007 16:45:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 2/11] maps3: introduce task_size_of for all arches
In-Reply-To: <3.290135367@selenic.com>
Message-ID: <alpine.DEB.0.9999.0710151643260.18722@chino.kir.corp.google.com>
References: <3.290135367@selenic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Matt Mackall wrote:

> Index: l/include/asm-mips/processor.h
> ===================================================================
> --- l.orig/include/asm-mips/processor.h	2007-10-09 17:37:58.000000000 -0500
> +++ l/include/asm-mips/processor.h	2007-10-10 11:46:30.000000000 -0500
> @@ -45,6 +45,8 @@ extern unsigned int vced_count, vcei_cou
>   * space during mmap's.
>   */
>  #define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 3))
> +#define TASK_SIZE_OF(tsk)						\
> +	(test_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
>  #endif
>  
>  #ifdef CONFIG_64BIT
> @@ -65,6 +67,8 @@ extern unsigned int vced_count, vcei_cou
>  #define TASK_UNMAPPED_BASE						\
>  	(test_thread_flag(TIF_32BIT_ADDR) ?				\
>  		PAGE_ALIGN(TASK_SIZE32 / 3) : PAGE_ALIGN(TASK_SIZE / 3))
> +#define TASK_SIZE_OF(tsk)						\
> +	(test_thread_flag(TIF_32BIT_ADDR) ? TASK_SIZE32 : TASK_SIZE)
>  #endif
>  
>  #define NUM_FPU_REGS	32

These need to use test_tsk_thread_flag(tsk, TIF_32BIT_ADDR).

> Index: l/include/asm-parisc/processor.h
> ===================================================================
> --- l.orig/include/asm-parisc/processor.h	2007-10-09 17:36:49.000000000 -0500
> +++ l/include/asm-parisc/processor.h	2007-10-10 11:46:30.000000000 -0500
> @@ -32,7 +32,8 @@
>  #endif
>  #define current_text_addr() ({ void *pc; current_ia(pc); pc; })
>  
> -#define TASK_SIZE               (current->thread.task_size)
> +#define TASK_SIZE_OF(tsk)       ((tsk)->thread.task_size)
> +#define TASK_SIZE	         (current->thread.task_size)
>  #define TASK_UNMAPPED_BASE      (current->thread.map_base)
>  
>  #define DEFAULT_TASK_SIZE32	(0xFFF00000UL)

TASK_SIZE_OF() should be defined in terms of TASK_SIZE, just like it is 
for ia64.

> Index: l/include/asm-powerpc/processor.h
> ===================================================================
> --- l.orig/include/asm-powerpc/processor.h	2007-10-09 17:37:58.000000000 -0500
> +++ l/include/asm-powerpc/processor.h	2007-10-10 11:46:30.000000000 -0500
> @@ -99,7 +99,9 @@ extern struct task_struct *last_task_use
>   */
>  #define TASK_SIZE_USER32 (0x0000000100000000UL - (1*PAGE_SIZE))
>  
> -#define TASK_SIZE (test_thread_flag(TIF_32BIT) ? \
> +#define TASK_SIZE	  (test_thread_flag(TIF_32BIT) ? \
> +		TASK_SIZE_USER32 : TASK_SIZE_USER64)
> +#define TASK_SIZE_OF(tsk) (test_tsk_thread_flag(tsk, TIF_32BIT) ? \
>  		TASK_SIZE_USER32 : TASK_SIZE_USER64)
>  

Same.

>  /* This decides where the kernel will search for a free chunk of vm
> Index: l/include/asm-s390/processor.h
> ===================================================================
> --- l.orig/include/asm-s390/processor.h	2007-10-09 17:37:58.000000000 -0500
> +++ l/include/asm-s390/processor.h	2007-10-10 11:46:30.000000000 -0500
> @@ -75,6 +75,8 @@ extern struct task_struct *last_task_use
>  
>  # define TASK_SIZE		(test_thread_flag(TIF_31BIT) ? \
>  					(0x80000000UL) : (0x40000000000UL))
> +# define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_31BIT) ? \
> +					(0x80000000UL) : (0x40000000000UL))
>  # define TASK_UNMAPPED_BASE	(TASK_SIZE / 2)
>  # define DEFAULT_TASK_SIZE	(0x40000000000UL)
>  

Same.
