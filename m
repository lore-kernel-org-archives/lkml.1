Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbYKYQlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbYKYQlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbYKYQla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:41:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43017 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbYKYQl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:41:29 -0500
Date: Tue, 25 Nov 2008 17:40:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: Re: [patch 9/9] x86, bts, ftrace: a BTS ftrace plug-in prototype
Message-ID: <20081125164038.GE22504@elte.hu>
References: <20081125092415.A31432@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125092415.A31432@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> Index: ftrace/kernel/trace/trace_bts.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ ftrace/kernel/trace/trace_bts.c	2008-11-25 08:18:07.000000000 +0100

> +#define this_tracer per_cpu(tracer, smp_processor_id())
> +#define this_buffer per_cpu(buffer, smp_processor_id())

please change these to inline functions.

> +/*
> + * Information to interpret a BTS record.
> + * This will go into an in-kernel BTS interface.
> + */
> +static unsigned char sizeof_field;
> +static unsigned long debugctl_mask;

__read_mostly.

> +static void bts_trace_cpuinit(struct cpuinfo_x86 *c)
> +{
> +	switch (c->x86) {
> +	case 0x6:
> +		switch (c->x86_model) {
> +		case 0x0 ... 0xC:
> +			break;
> +		case 0xD:
> +		case 0xE: /* Pentium M */
> +			sizeof_field = sizeof(long);
> +			debugctl_mask = (1<<6)|(1<<7);
> +			break;
> +		default:
> +			sizeof_field = 8;
> +			debugctl_mask = (1<<6)|(1<<7);
> +			break;
> +		}
> +		break;
> +	case 0xF:
> +		switch (c->x86_model) {
> +		case 0x0:
> +		case 0x1:
> +		case 0x2: /* Netburst */
> +			sizeof_field = sizeof(long);
> +			debugctl_mask = (1<<2)|(1<<3);
> +			break;
> +		default:
> +			/* sorry, don't know about them */
> +			break;
> +		}
> +		break;
> +	default:
> +		/* sorry, don't know about them */
> +		break;
> +	}
> +}
> +
> +static inline void bts_enable(void)
> +{
> +	unsigned long debugctl;
> +
> +	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
> +	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl | debugctl_mask);
> +}
> +
> +static inline void bts_disable(void)
> +{
> +	unsigned long debugctl;
> +
> +	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
> +	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl & ~debugctl_mask);
> +}

these x86 architecture bits should move into arch/x86/kernel/ftrace.c. 
(or ds.c)

> +static void bts_trace_print_header(struct seq_file *m)
> +{
> +#ifdef __i386__
> +	seq_puts(m, "# CPU#    FROM           TO     FUNCTION\n");
> +	seq_puts(m, "#  |       |             |         |\n");
> +#else
> +	seq_puts(m,
> +		 "# CPU#        FROM                   TO         FUNCTION\n");
> +	seq_puts(m,
> +		 "#  |           |                     |             |\n");
> +#endif

lets just standardize on the 64-bit width, ok?

> +#ifdef CONFIG_KALLSYMS
> +		char function[KSYM_SYMBOL_LEN];
> +		sprint_symbol(function, it->from);
> +#else
> +		char *function = "<unknown>";
> +#endif

just do this:

		char function[KSYM_SYMBOL_LEN];
		sprint_symbol(function, it->from);

that should do the right thing in the !KALLSYMS case too.

> +struct tracer bts_tracer __read_mostly =
> +{
> +	.name		= "bts",

please rename it to: "hw-branch-tracer". "BTS" is an x86 concept and 
we want to keep the name generic.

	Ingo
