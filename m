Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbXE3Udg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbXE3Udg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbXE3Ud2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:33:28 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbXE3Ud1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:33:27 -0400
Date: Wed, 30 May 2007 13:32:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 1/9] Conditional Calls - Architecture Independent Code
Message-Id: <20070530133242.9a0d2c71.akpm@linux-foundation.org>
In-Reply-To: <20070530140227.070136408@polymtl.ca>
References: <20070530140025.917261793@polymtl.ca>
	<20070530140227.070136408@polymtl.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 10:00:26 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Conditional calls are used to compile in code that is meant to be dynamically
> enabled at runtime. When code is disabled, it has a very small footprint.
> 
> It has a generic cond_call version and optimized per architecture cond_calls.
> The optimized cond_call uses a load immediate to remove a data cache hit.
> 
> It adds a new rodata section "__cond_call" to place the pointers to the enable
> value.
> 
> cond_call activation functions sits in module.c.
> 

The above doesn't really describe what these things are, nor what they are
used for, nor how they actually work.  It's all a bit of a mystery.

The i386 implementation appears to be using self-modifying code, which is
intriguing.

<finds the documentation patch>

OK, that helps somewhat.

> ---
>  include/asm-generic/vmlinux.lds.h |   16 +-
>  include/linux/condcall.h          |   91 +++++++++++++
>  include/linux/module.h            |    4 
>  kernel/module.c                   |  248 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 356 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6-lttng/include/linux/condcall.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/linux/condcall.h	2007-05-17 02:13:53.000000000 -0400
> @@ -0,0 +1,91 @@
> +#ifndef _LINUX_CONDCALL_H
> +#define _LINUX_CONDCALL_H
> +
> +/*
> + * Conditional function calls. Cheap when disabled, enabled at runtime.
> + *
> + * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> + *
> + * This file is released under the GPLv2.
> + * See the file COPYING for more details.
> + */
> +
> +#ifdef __KERNEL__
> +
> +struct __cond_call_struct {
> +	const char *name;
> +	void *enable;
> +	int flags;
> +} __attribute__((packed));

Please document data structures lavishly.

> +
> +/* Cond call flags : selects the mechanism used to enable the conditional calls
> + * and prescribe what can be executed within their function. This is primarily
> + * used at reentrancy-unfriendly sites. */

You consistently use the wrong commenting style.  We prefer

/* Cond call flags : selects the mechanism used to enable the conditional calls
 * and prescribe what can be executed within their function. This is primarily
 * used at reentrancy-unfriendly sites.
 */

or

/*
 * Cond call flags : selects the mechanism used to enable the conditional calls
 * and prescribe what can be executed within their function. This is primarily
 * used at reentrancy-unfriendly sites.
 */

> +#ifdef CONFIG_COND_CALL_ENABLE_OPTIMIZATION
> +#include <asm/condcall.h>		/* optimized cond_call flavor */
> +#else
> +#include <asm-generic/condcall.h>	/* fallback on generic cond_call */
> +#endif

The preferred way to do this is to give every architecture an
asm/condcall.h and from within that, include asm-generic/condcall.h.  Your
[patch 3/9] does most of that, but it didn't remove the above ifdef, and I
don't think it removed the should-be-unneeded
CONFIG_COND_CALL_ENABLE_OPTIMIZATION either?

> +#define COND_CALL_MAX_FORMAT_LEN	1024
> +
> +extern int cond_call_arm(const char *name);
> +extern int cond_call_disarm(const char *name);
> +
> +/* cond_call_query : Returns 1 if enabled, 0 if disabled or not present */
> +extern int cond_call_query(const char *name);
> +extern int cond_call_list(const char *name);
> +
> +#endif /* __KERNEL__ */
> +#endif
> Index: linux-2.6-lttng/include/asm-generic/vmlinux.lds.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-generic/vmlinux.lds.h	2007-05-17 02:12:25.000000000 -0400
> +++ linux-2.6-lttng/include/asm-generic/vmlinux.lds.h	2007-05-17 02:13:42.000000000 -0400
> @@ -116,11 +116,22 @@
>  		*(__kcrctab_gpl_future)					\
>  		VMLINUX_SYMBOL(__stop___kcrctab_gpl_future) = .;	\
>  	}								\
> -									\
> +	/* Conditional calls: pointers */				\
> +	__cond_call : AT(ADDR(__cond_call) - LOAD_OFFSET) {		\
> +		VMLINUX_SYMBOL(__start___cond_call) = .;		\
> +		*(__cond_call)						\
> +		VMLINUX_SYMBOL(__stop___cond_call) = .;			\
> +	}								\
>  	/* Kernel symbol table: strings */				\
>          __ksymtab_strings : AT(ADDR(__ksymtab_strings) - LOAD_OFFSET) {	\
>  		*(__ksymtab_strings)					\
> -	}								\
> + 	}								\
> +	/* Conditional calls: strings */				\
> +        __cond_call_strings : AT(ADDR(__cond_call_strings) - LOAD_OFFSET) { \

whitespace went bad here.


