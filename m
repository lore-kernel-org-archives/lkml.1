Return-Path: <linux-kernel-owner+w=401wt.eu-S934107AbZJNOsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107AbZJNOsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934062AbZJNOsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:48:37 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:49691 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933956AbZJNOsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:48:37 -0400
Date: Wed, 14 Oct 2009 10:36:24 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mingo@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       rostedt@goodmis.org, hpa@zytor.com, cebbert@redhat.com,
       tony.luck@intel.com
Subject: Re: [PATCH 13/16] percpu: remove per_cpu__ prefix.
In-Reply-To: <1255500125-3210-14-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.1.10.0910141026370.26476@gentwo.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Tejun Heo wrote:

> @@ -39,7 +39,7 @@ extern void *per_cpu_init(void);
>   * On the positive side, using __ia64_per_cpu_var() instead of __get_cpu_var() is slightly
>   * more efficient.
>   */
> -#define __ia64_per_cpu_var(var)	per_cpu__##var
> +#define __ia64_per_cpu_var(var)	var

IA64 could completely drop the macro? Tony?

> diff --git a/arch/microblaze/include/asm/entry.h b/arch/microblaze/include/asm/entry.h
> index 61abbd2..ec89f2a 100644
> --- a/arch/microblaze/include/asm/entry.h
> +++ b/arch/microblaze/include/asm/entry.h
> @@ -21,7 +21,7 @@
>   * places
>   */
>
> -#define PER_CPU(var) per_cpu__##var
> +#define PER_CPU(var) var

Microblaze too.

> +#define PER_CPU(var, reg)	__percpu_mov_op $var, reg
> +#define PER_CPU_VAR(var)	var

Drop X86 PER_CPU_VAR

> -#define percpu_read(var)	percpu_from_op("mov", per_cpu__##var,	\
> -					       "m" (per_cpu__##var))
> -#define percpu_read_stable(var)	percpu_from_op("mov", per_cpu__##var,	\
> -					       "p" (&per_cpu__##var))
> -#define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
> -#define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
> -#define percpu_sub(var, val)	percpu_to_op("sub", per_cpu__##var, val)
> -#define percpu_and(var, val)	percpu_to_op("and", per_cpu__##var, val)
> -#define percpu_or(var, val)	percpu_to_op("or", per_cpu__##var, val)
> -#define percpu_xor(var, val)	percpu_to_op("xor", per_cpu__##var, val)
> +#define percpu_read(var)		percpu_from_op("mov", var, "m" (var))
> +#define percpu_read_stable(var)		percpu_from_op("mov", var, "p" (&(var)))
> +#define percpu_write(var, val)		percpu_to_op("mov", var, val)
> +#define percpu_add(var, val)		percpu_to_op("add", var, val)
> +#define percpu_sub(var, val)		percpu_to_op("sub", var, val)
> +#define percpu_and(var, val)		percpu_to_op("and", var, val)
> +#define percpu_or(var, val)		percpu_to_op("or", var, val)
> +#define percpu_xor(var, val)		percpu_to_op("xor", var, val)

The percpu_xx definitions are now equal to __this_cpu_xx(). They could be
dropped for the core.

> diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
> index 8087b90..ca6f049 100644
> --- a/include/asm-generic/percpu.h
> +++ b/include/asm-generic/percpu.h
> @@ -50,11 +50,11 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
>   * offset.
>   */
>  #define per_cpu(var, cpu) \
> -	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), per_cpu_offset(cpu)))
> +	(*SHIFT_PERCPU_PTR(&(var), per_cpu_offset(cpu)))

>  #define __get_cpu_var(var) \
> -	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), my_cpu_offset))
> +	(*SHIFT_PERCPU_PTR(&(var), my_cpu_offset))

== this_cpu_read(var) or this_cpu_write(var, value)


>  #define __raw_get_cpu_var(var) \
> -	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), __my_cpu_offset))
> +	(*SHIFT_PERCPU_PTR(&(var), __my_cpu_offset))

== __this_cpu_read() or this_cpu_write(var, value)

__raw? Combination of __ and raw? Can we clearly define what each means?

> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -182,7 +182,7 @@ static inline void *pcpu_lpage_remapped(void *kaddr)
>  #ifndef percpu_read
>  # define percpu_read(var)						\
>    ({									\
> -	typeof(per_cpu_var(var)) __tmp_var__;				\
> +	typeof(var) __tmp_var__;					\
>  	__tmp_var__ = get_cpu_var(var);					\
>  	put_cpu_var(var);						\
>  	__tmp_var__;							\

== this_cpu_read(var)


Great work. There is lots more possible cleanup work that could be done
after this patch has merged.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
