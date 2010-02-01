Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab0BAQE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:04:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49282 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab0BAQE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:04:57 -0500
Subject: Re: [PATCH]  perf_events: fix bug in hw_perf_enable()
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com,
       Arjan van de Ven <arjan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1265038508.24455.177.camel@laptop>
References: <4b66dc67.0b38560a.1635.ffffae18@mx.google.com>
	 <1265038508.24455.177.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 17:04:20 +0100
Message-ID: <1265040260.24455.200.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 16:35 +0100, Peter Zijlstra wrote:
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
> @@ -243,8 +243,18 @@ static struct event_constraint intel_cor
>  
>  static struct event_constraint intel_core2_event_constraints[] =
>  {
> -       FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
> -       FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
> +       FIXED_EVENT_CONSTRAINT(0x00c0, 1ULL << 32), /* INST_RETIRED.ANY */
> +       FIXED_EVENT_CONSTRAINT(0x003c, 1ULL << 33), /* CPU_CLK_UNHALTED.CORE */
> +       /*
> +        * FIXED_EVENT_CONSTRAINT(0x013c, 1ULL << 34),  CPU_CLK_UNHALTED.REF
> +        *
> +        * Core2 has Fixed Counter 2 listed as CPU_CLK_UNHALTED.REF and event
> +        * 0x013c as CPU_CLK_UNHALTED.BUS and specifies there is a fixed
> +        * ratio between these counters.
> +        *
> +        * TODO: find/measure the fixed ratio and apply it so that we can
> +        * enable this fixed purpose counter in a transparent way.
> +        */
>         INTEL_EVENT_CONSTRAINT(0x10, 0x1), /* FP_COMP_OPS_EXE */
>         INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
>         INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */ 

>From what I can measure on the available Core2 systems this ratio is
exactly 1, which would be consistent with the Nehalem and Westmere
tables calling this event .REF

Stephane, have you ever observed this ratio to be anything other than 1?

If not, I think we can simply stick this counter back in and not worry
about it.

