Return-Path: <linux-kernel-owner+w=401wt.eu-S1755501AbYKGFy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbYKGFy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 00:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYKGFyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 00:54:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbYKGFyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 00:54:15 -0500
Date: Thu, 6 Nov 2008 21:52:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Nicolas Pitre <nico@cam.org>,
       Ralf Baechle <ralf@linux-mips.org>, benh@kernel.crashing.org,
       paulus@samba.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: Re: [RFC patch 07/18] Trace clock core
Message-Id: <20081106215256.a9f01ec4.akpm@linux-foundation.org>
In-Reply-To: <20081107053349.699011457@polymtl.ca>
References: <20081107052336.652868737@polymtl.ca>
	<20081107053349.699011457@polymtl.ca>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2008 00:23:43 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> 32 to 64 bits clock extension. Extracts 64 bits tsc from a [1..32]
> bits counter, kept up to date by periodical timer interrupt. Lockless.
> 
> ...
>
> +#include <linux/sched.h> /* FIX for m68k local_irq_enable in on_each_cpu */

What's going on here?

> +struct synthetic_tsc_struct {
> +	union {
> +		u64 val;
> +		struct {
> +#ifdef __BIG_ENDIAN
> +			u32 msb;
> +			u32 lsb;
> +#else
> +			u32 lsb;
> +			u32 msb;
> +#endif

One would expect an identifier called "msb" to mean "most significant
bit" or possible "most significant byte".

Maybe ms32 and ls32?

> +		} sel;
> +	} tsc[2];
> +	unsigned int index;	/* Index of the current synth. tsc. */
> +};
> +
> +static DEFINE_PER_CPU(struct synthetic_tsc_struct, synthetic_tsc);
> +
> +/* Called from IPI : either in interrupt or process context */

IPI handlers should always be called with local interrupts disabled.

> +static void update_synthetic_tsc(void)
> +{
> +	struct synthetic_tsc_struct *cpu_synth;
> +	u32 tsc;
> +
> +	preempt_disable();

which would make this unnecessary.

> +	cpu_synth = &per_cpu(synthetic_tsc, smp_processor_id());
> +	tsc = trace_clock_read32();		/* Hardware clocksource read */
> +
> +	if (tsc < HW_LSB(cpu_synth->tsc[cpu_synth->index].sel.lsb)) {
> +		unsigned int new_index = 1 - cpu_synth->index; /* 0 <-> 1 */
> +		/*
> +		 * Overflow
> +		 * Non atomic update of the non current synthetic TSC, followed
> +		 * by an atomic index change. There is no write concurrency,
> +		 * so the index read/write does not need to be atomic.
> +		 */
> +		cpu_synth->tsc[new_index].val =
> +			(SW_MSB(cpu_synth->tsc[cpu_synth->index].val)
> +				| (u64)tsc) + (1ULL << HW_BITS);
> +		cpu_synth->index = new_index;	/* atomic change of index */
> +	} else {
> +		/*
> +		 * No overflow : We know that the only bits changed are
> +		 * contained in the 32 LSBs, which can be written to atomically.
> +		 */
> +		cpu_synth->tsc[cpu_synth->index].sel.lsb =
> +			SW_MSB(cpu_synth->tsc[cpu_synth->index].sel.lsb) | tsc;
> +	}
> +	preempt_enable();
> +}

Is there something we should be fixing in m68k?

