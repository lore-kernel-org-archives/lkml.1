Return-Path: <linux-kernel-owner+w=401wt.eu-S1762231AbZAORav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762231AbZAORav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758841AbZAORal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:30:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754432AbZAORak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:30:40 -0500
Date: Thu, 15 Jan 2009 09:30:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, steiner@sgi.com, hugh@veritas.com
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
Message-Id: <20090115093007.4215b4b4.akpm@linux-foundation.org>
In-Reply-To: <496F38C7.5000403@kernel.org>
References: <496C717F.70204@kernel.org>
	<73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com>
	<496C9FB7.9050907@kernel.org>
	<496D8CEB.5060402@zytor.com>
	<20090114093834.GA19799@elte.hu>
	<496F0F50.6070200@kernel.org>
	<20090115113045.GG22850@elte.hu>
	<496F2032.5080502@kernel.org>
	<20090115122611.GJ22850@elte.hu>
	<496F346B.6020804@kernel.org>
	<20090115130740.GE21839@elte.hu>
	<496F38C7.5000403@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 22:23:19 +0900 Tejun Heo <tj@kernel.org> wrote:

> --- a/include/asm-generic/percpu.h
> +++ b/include/asm-generic/percpu.h
> @@ -80,4 +80,56 @@ extern void setup_per_cpu_areas(void);
>  #define DECLARE_PER_CPU(type, name) extern PER_CPU_ATTRIBUTES \
>  					__typeof__(type) per_cpu_var(name)
>  
> +/*
> + * Optional methods for optimized non-lvalue per-cpu variable access.
> + *
> + * @var can be a percpu variable or a field of it and its size should
> + * equal char, int or long.  percpu_read() evaluates to a lvalue and
> + * all others to void.
> + *
> + * These operations are guaranteed to be atomic w.r.t. preemption.
> + * The generic versions use plain get/put_cpu_var().  Archs are
> + * encouraged to implement single-instruction alternatives which don't
> + * require preemption protection.
> + */
> +#ifndef percpu_read
> +# define percpu_read(var)						\
> +  ({									\
> +	typeof(per_cpu_var(var)) __tmp_var__;				\
> +	__tmp_var__ = get_cpu_var(var);					\
> +	put_cpu_var(var);						\
> +	__tmp_var__;							\
> +  })
> +#endif

I wonder if the preempt_disable()/preempt_enable() in here actually
does anything useful on any architecture.

> +#define __percpu_generic_to_op(var, val, op)				\
> +do {									\
> +	get_cpu_var(var) op val;					\
> +	put_cpu_var(var);						\
> +} while (0)

We'll need it here.
