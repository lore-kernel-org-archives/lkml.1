Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbYKYKMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbYKYKMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbYKYKMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:12:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60223 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbYKYKM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:12:29 -0500
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: Re: [patch 9/9] x86, bts, ftrace: a BTS ftrace plug-in prototype
From: Andi Kleen <andi@firstfloor.org>
References: <20081125092415.A31432@sedona.ch.intel.com>
Date: Tue, 25 Nov 2008 11:12:33 +0100
In-Reply-To: <20081125092415.A31432@sedona.ch.intel.com> (Markus Metzger's message of "Tue, 25 Nov 2008 09:24:15 +0100")
Message-ID: <87hc5wcdwu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Metzger <markus.t.metzger@intel.com> writes:

Basic idea looks very useful. Thanks.

> +static void bts_trace_cpuinit(struct cpuinfo_x86 *c)

That should be somewhere generic I think. Doesn't ptrace have it too?

-Andi


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
> +
> +static void bts_trace_reset(struct trace_array *tr)
> +{
> +	int cpu;
> +
> +	tr->time_start = ftrace_now(tr->cpu);
> +

-- 
ak@linux.intel.com
