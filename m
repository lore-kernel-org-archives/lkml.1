Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0CBQ0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 11:26:44 -0500
Received: from smtp-out.google.com ([216.239.44.51]:43257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab0CBQ0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 11:26:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=RmYw2Y45LB7wVlblJG83z/Ymv+wfJ9mEDn7dV2HMm8JI4EY6lvBdEBklTxrljlVb/
	9lTUuJ0ovdNue1uVW5tZw==
MIME-Version: 1.0
In-Reply-To: <tip-b622d644c7d61a5cb95b74e7b143c263bed21f0a@git.kernel.org>
References: <tip-b622d644c7d61a5cb95b74e7b143c263bed21f0a@git.kernel.org>
Date: Tue, 2 Mar 2010 17:26:39 +0100
Message-ID: <bd4cb8901003020826w6540ffebje2cee53b52f1ff27@mail.gmail.com>
Subject: Re: [tip:perf/core] perf_events, x86: Fixup fixed counter constraints
From: Stephane Eranian <eranian@google.com>
To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 3:31 PM, tip-bot for Peter Zijlstra
<a.p.zijlstra@chello.nl> wrote:
>
> Commit-ID:  b622d644c7d61a5cb95b74e7b143c263bed21f0a
> Gitweb:     http://git.kernel.org/tip/b622d644c7d61a5cb95b74e7b143c263bed21f0a
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Mon, 1 Feb 2010 15:36:30 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 2 Mar 2010 15:06:47 +0100
>
> perf_events, x86: Fixup fixed counter constraints
>
> Patch 1da53e0230 ("perf_events, x86: Improve x86 event scheduling")
> lost us one of the fixed purpose counters and then ed8777fc13
> ("perf_events, x86: Fix event constraint masks") broke it even
> further.
>
> Widen the fixed event mask to event+umask and specify the full config
> for each of the 3 fixed purpose counters. Then let the init code fill
> out the placement for the GP regs based on the cpuid info.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

>  static struct event_constraint intel_core2_event_constraints[] =
>  {
> -       FIXED_EVENT_CONSTRAINT(0xc0, (0x3|(1ULL<<32))), /* INSTRUCTIONS_RETIRED */
> -       FIXED_EVENT_CONSTRAINT(0x3c, (0x3|(1ULL<<33))), /* UNHALTED_CORE_CYCLES */
> +       FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
> +       FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
> +       /*
> +        * Core2 has Fixed Counter 2 listed as CPU_CLK_UNHALTED.REF and event
> +        * 0x013c as CPU_CLK_UNHALTED.BUS and specifies there is a fixed
> +        * ratio between these counters.
> +        */
> +       /* FIXED_EVENT_CONSTRAINT(0x013c, 2),  CPU_CLK_UNHALTED.REF */
>        INTEL_EVENT_CONSTRAINT(0x10, 0x1), /* FP_COMP_OPS_EXE */
>        INTEL_EVENT_CONSTRAINT(0x11, 0x2), /* FP_ASSIST */
>        INTEL_EVENT_CONSTRAINT(0x12, 0x2), /* MUL */
> @@ -37,14 +43,16 @@ static struct event_constraint intel_core2_event_constraints[] =
>        INTEL_EVENT_CONSTRAINT(0x18, 0x1), /* IDLE_DURING_DIV */
>        INTEL_EVENT_CONSTRAINT(0x19, 0x2), /* DELAYED_BYPASS */
>        INTEL_EVENT_CONSTRAINT(0xa1, 0x1), /* RS_UOPS_DISPATCH_CYCLES */
> +       INTEL_EVENT_CONSTRAINT(0xc9, 0x1), /* ITLB_MISS_RETIRED (T30-9) */

Where does the constraint on ITLB_MISS_RETIRED come from?
