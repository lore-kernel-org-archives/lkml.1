Return-Path: <linux-kernel-owner+w=401wt.eu-S965386AbXAZMEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965386AbXAZMEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 07:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965465AbXAZMEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 07:04:46 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:50685 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965386AbXAZMEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 07:04:45 -0500
Date: Fri, 26 Jan 2007 12:04:37 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@shafik.org,
       systemtap@sources.redhat.com, Douglas Niehaus <niehaus@eecs.ku.edu>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 05/10] local_t : mips extension
Message-ID: <20070126120437.GA18778@linux-mips.org>
References: <1169741777507-git-send-email-mathieu.desnoyers@polymtl.ca> <1169741780423-git-send-email-mathieu.desnoyers@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169741780423-git-send-email-mathieu.desnoyers@polymtl.ca>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 11:16:12AM -0500, Mathieu Desnoyers wrote:
> From:	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> To:	linux-kernel@vger.kernel.org
> Cc:	Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
> 	Ingo Molnar <mingo@redhat.com>,
> 	Greg Kroah-Hartman <gregkh@suse.de>,
> 	Christoph Hellwig <hch@infradead.org>, ltt-dev@shafik.org,
> 	systemtap@sources.redhat.com,
> 	Douglas Niehaus <niehaus@eecs.ku.edu>,
> 	"Martin J. Bligh" <mbligh@mbligh.org>,
> 	Thomas Gleixner <tglx@linutronix.de>,
> 	Paul Mackerras <paulus@samba.org>,
> 	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

How about copying the MIPS maintainer or linux-mips mailing list instead
of a zillion people who probably don't care?

> Subject: [PATCH 05/10] local_t : mips extension
> Date:	Thu, 25 Jan 2007 11:16:12 -0500
> 
> local_t : mips extension
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> --- a/include/asm-mips/local.h
> +++ b/include/asm-mips/local.h
> @@ -1,60 +1,524 @@
> -#ifndef _ASM_LOCAL_H
> -#define _ASM_LOCAL_H
> +#ifndef _ARCH_POWERPC_LOCAL_H
> +#define _ARCH_POWERPC_LOCAL_H

The subject claims this is a MIPS patch ;-)

>  #include <linux/percpu.h>
>  #include <asm/atomic.h>
>  
> -#ifdef CONFIG_32BIT
> +typedef struct
> +{
> +	local_long_t a;
> +} local_t;
>  
> -typedef atomic_t local_t;
> +#define LOCAL_INIT(i)	{ local_LONG_INIT(i) }
>  
> -#define LOCAL_INIT(i)	ATOMIC_INIT(i)
> -#define local_read(v)	atomic_read(v)
> -#define local_set(v,i)	atomic_set(v,i)
> +#define local_read(l)	local_long_read(&(l)->a)
> +#define local_set(l,i)	local_long_set(&(l)->a, (i))
>  
> -#define local_inc(v)	atomic_inc(v)
> -#define local_dec(v)	atomic_dec(v)
> -#define local_add(i, v)	atomic_add(i, v)
> -#define local_sub(i, v)	atomic_sub(i, v)
> +#define local_add(i,l)	local_long_add((i),(&(l)->a))
> +#define local_sub(i,l)	local_long_sub((i),(&(l)->a))
> +#define local_inc(l)	local_long_inc(&(l)->a)
> +#define local_dec(l)	local_long_dec(&(l)->a)
>  
> -#endif
>  
> -#ifdef CONFIG_64BIT
> +#ifndef CONFIG_64BITS

There is no CONFIG_64BITS

> -typedef atomic64_t local_t;
> +/*
> + * Same as above, but return the result value
> + */
> +static __inline__ int local_add_return(int i, local_t * l)
> +{
> +	unsigned long result;
> +
> +	if (cpu_has_llsc && R10000_LLSC_WAR) {

Missing #include  <asm/war.h>.

> +		unsigned long temp;
> +
> +		__asm__ __volatile__(
> +		"	.set	mips3					\n"
> +		"1:	ll	%1, %2		# local_add_return	\n"
> +		"	addu	%0, %1, %3				\n"
> +		"	sc	%0, %2					\n"
> +		"	beqzl	%0, 1b					\n"
> +		"	addu	%0, %1, %3				\n"
> +		"	.set	mips0					\n"
> +		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
> +		: "Ir" (i), "m" (&(l->a.counter))
> +		: "memory");
> +	} else if (cpu_has_llsc) {
> +		unsigned long temp;
> +
> +		__asm__ __volatile__(
> +		"	.set	mips3					\n"
> +		"1:	ll	%1, %2		# local_add_return	\n"
> +		"	addu	%0, %1, %3				\n"
> +		"	sc	%0, %2					\n"
> +		"	beqz	%0, 1b					\n"
> +		"	addu	%0, %1, %3				\n"
> +		"	.set	mips0					\n"
> +		: "=&r" (result), "=&r" (temp), "=m" (&(l->a.counter))
> +		: "Ir" (i), "m" (&(l->a.counter))
> +		: "memory");
> +	} else {
> +		unsigned long flags;
> +
> +		local_irq_save(flags);
> +		result = &(l->a.counter);
> +		local_irq_restore(flags);
> +	}

Asigning some pointer value to an integer variable with no cast?

> +		result += i;
> +		&(l->a.counter) = result;

Invalid lvalue in assignment.

What I generally dislike about this patch is that several fairly large
functions have been duplicated with only little change.

  Ralf
