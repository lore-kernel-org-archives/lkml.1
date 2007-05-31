Return-Path: <linux-kernel-owner+w=401wt.eu-S1761630AbXEaMvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761630AbXEaMvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759918AbXEaMvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:51:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbXEaMvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:51:05 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/9] Conditional Calls - Architecture Independent Code
References: <20070530140025.917261793@polymtl.ca>
	<20070530140227.070136408@polymtl.ca>
From: Andi Kleen <andi@firstfloor.org>
Date: 31 May 2007 15:47:44 +0200
In-Reply-To: <20070530140227.070136408@polymtl.ca>
Message-ID: <p73wsypcdfj.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> +struct __cond_call_struct {

Calling structs *_struct is severly deprecated and will cause some people
to make fun of your code.


> +	const char *name;
> +	void *enable;
> +	int flags;
> +} __attribute__((packed));

The packed doesn't seem to be needed. There will be padding at 
the end anyways because the next one needs to be aligned.

> +
> +
> +/* Cond call flags : selects the mechanism used to enable the conditional calls
> + * and prescribe what can be executed within their function. This is primarily
> + * used at reentrancy-unfriendly sites. */
> +#define CF_OPTIMIZED		(1 << 0) /* Use optimized cond_call */
> +#define CF_LOCKDEP		(1 << 1) /* Can call lockdep */
> +#define CF_PRINTK		(1 << 2) /* Probe can call vprintk */
> +#define CF_STATIC_ENABLE	(1 << 3) /* Enable cond_call statically */

Why is that all needed?  Condcall shouldn't really need to know anything
about all this. They're just a fancy conditional anyways -- and you don't
tell if() that it may need to printk.

Please consider eliminating.



> +#define _CF_NR			4


> +
> +#ifdef CONFIG_COND_CALL
> +
> +/* Generic cond_call flavor always available.
> + * Note : the empty asm volatile with read constraint is used here instead of a
> + * "used" attribute to fix a gcc 4.1.x bug. */

What gcc 4.1 bug? 

> +#define cond_call_generic(flags, name, func) \
> +	({ \
> +		static const char __cstrtab_name_##name[] \
> +		__attribute__((section("__cond_call_strings"))) = #name; \
> +		static char __cond_call_enable_##name = \
> +			(flags) & CF_STATIC_ENABLE; \
> +		static const struct __cond_call_struct __cond_call_##name \
> +			__attribute__((section("__cond_call"))) = \
> +			{ __cstrtab_name_##name, \
> +			&__cond_call_enable_##name, \
> +			(flags) & ~CF_OPTIMIZED } ; \
> +		asm volatile ( "" : : "i" (&__cond_call_##name)); \
> +		(unlikely(__cond_call_enable_##name)) ? \
> +			(func) : \
> +			(__typeof__(func))0; \
> +	})

-Andi
