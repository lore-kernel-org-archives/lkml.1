Return-Path: <linux-kernel-owner+w=401wt.eu-S1764394AbZE0Oqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764394AbZE0Oqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762876AbZE0Oqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:46:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40645 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761152AbZE0Oqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:46:44 -0400
Date: Wed, 27 May 2009 16:46:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: One question about perf_counter on IA
Message-ID: <20090527144635.GA7300@elte.hu>
References: <20090527071736.GA26774@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527071736.GA26774@ywang-moblin2.bj.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yong Wang <yong.y.wang@linux.intel.com> wrote:

> I noticed that the LVT error register is masked and then unmasked 
> during perf_counter initialization on IA in 
> arch/x86/kernel/cpu/perf_counter.c
> 
> void perf_counters_lapic_init(int nmi)
> {
> 	u32 apic_val;
> 
> 	if (!x86_pmu_initialized())
> 		return;
> 
> 	/*
> 	 * Enable the performance counter vector in the APIC LVT:
> 	 */
> 	apic_val = apic_read(APIC_LVTERR);
> 
> 	apic_write(APIC_LVTERR, apic_val | APIC_LVT_MASKED);
> 	if (nmi)
> 		apic_write(APIC_LVTPC, APIC_DM_NMI);
> 	else
> 		apic_write(APIC_LVTPC, LOCAL_PERF_VECTOR);
> 	apic_write(APIC_LVTERR, apic_val);
> }
> 
> Why is this needed? Is this documented somewhere in the spec? I 
> tried commenting out the masking and unmasking operations and I 
> did not any error interrupt generated.

i think a spurious error irq can be triggered due to APIC_DM_NMI 
having zero for the vector bit. If we switch between irq and nmi 
mode frequently then there could be racy situations.

Not that having an error irq would hurt much ...

Note, in the current code we essentially always use NMI mode, the 
cleanups just have not propagated through fully yet. Feel free to 
send a patch for this!

	Ingo
