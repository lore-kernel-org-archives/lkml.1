Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbYJ0P7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbYJ0P7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYJ0P7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:59:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40562 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbYJ0P7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:59:38 -0400
Date: Mon, 27 Oct 2008 16:59:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, lenb@kernel.org
Subject: Re: PATCH] ftrace: Add a C/P state tracer to help power
	optimization
Message-ID: <20081027155920.GS5704@elte.hu>
References: <20081006102640.481acd23@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006102640.481acd23@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Fri, 3 Oct 2008 10:18:21 -0700
> Subject: [PATCH] ftrace: Add a C/P state tracer to help power optimization
> 
> This patch adds a C/P-state ftrace plugin that will generate
> detailed statistics about the C/P-states that are being used,
> so that we can look at detailed decisions that the C/P-state
> code is making, rather than the too high level "average"
> that we have today.

nice! No fundamental objections - Len, do you concur? We could carry 
this in the ftrace tree, the impact on the rest of the kernel is 
minimal.

A few minor nits:

>  static void poll_idle(void)
>  {
> +	struct power_trace it;
> +	trace_power_start(&it, POWER_CSTATE, 0);

please put a newline after variable definitions.

> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -232,6 +232,32 @@ static inline void start_boot_trace(void) { }
>  static inline void stop_boot_trace(void) { }
>  #endif
>  
> +#define POWER_NONE 0
> +#define POWER_CSTATE 1
> +#define POWER_PSTATE 2
> +struct power_trace {

the defines should be an enum and please put a newline after the enum 
definition.

> +#ifdef CONFIG_POWER_TRACER
> +	ktime_t			stamp;
> +	ktime_t			end;
> +	int			type;
> +	int			state;
> +#endif
> +};

> index 396aea1..1f797bd 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -134,6 +134,17 @@ config BOOT_TRACER
>  	  be enabled if this tracer is selected since only one tracer
>  	  should touch the tracing buffer at a time.
>  
> +config POWER_TRACER
> +	bool "Trace power consumption behavior"
> +	depends on DEBUG_KERNEL
> +	depends on X86
> +	select TRACING

this should be HAVE_POWER_TRACER defined in arch/x86/Kconfig, instead 
of a 'depends on X86'.

> +	help
> +	  This tracer helps developers to analyize and optimize the kernels
> +	  power management decisions, specifically the C-state and P-state
> +	  behavior.

s/analyize/analyse
s/kernels/kernel's

> +static struct trace_array *power_trace;
> +static int trace_power_enabled;

__read_mostly ?

	Ingo
