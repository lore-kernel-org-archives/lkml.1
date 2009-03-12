Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbZCLJMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbZCLJMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 05:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZCLJMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 05:12:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:33987 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZCLJMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 05:12:20 -0400
Subject: Re: [tip:perfcounters/core] perfcounters: IRQ and NMI support on
 AMD CPUs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20090312014415.GD10105@erda.amd.com>
References: <1236273633.5187.286.camel@laptop>
	 <tip-b0f3f28e0f14eb335f67bfaae33ce8b8d74fd58b@git.kernel.org>
	 <20090312014415.GD10105@erda.amd.com>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 10:12:14 +0100
Message-Id: <1236849134.5090.26.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-12 at 02:44 +0100, Robert Richter wrote:
> On 05.03.09 17:27:29, Peter Zijlstra wrote:
> > Commit-ID:  b0f3f28e0f14eb335f67bfaae33ce8b8d74fd58b
> > Gitweb:     http://git.kernel.org/tip/b0f3f28e0f14eb335f67bfaae33ce8b8d74fd58b
> > Author:     "Peter Zijlstra" <a.p.zijlstra@chello.nl>
> > AuthorDate: Thu, 5 Mar 2009 18:08:27 +0100
> > Commit:     Ingo Molnar <mingo@elte.hu>
> > CommitDate: Thu, 5 Mar 2009 18:25:16 +0100
> > 
> > perfcounters: IRQ and NMI support on AMD CPUs
> > 
> > The below completes the K7+ performance counter support:
> > 
> >  - IRQ support
> >  - NMI support
> > 
> > KernelTop output works now as well.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > LKML-Reference: <1236273633.5187.286.camel@laptop>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 
> > ---
> >  arch/x86/kernel/cpu/perf_counter.c |  272 ++++++++++++++++++++++++++++++------
> >  1 files changed, 228 insertions(+), 44 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> > index 3b65f19..6ebe9ab 100644
> > --- a/arch/x86/kernel/cpu/perf_counter.c
> > +++ b/arch/x86/kernel/cpu/perf_counter.c
> 
> [...]
> 
> > @@ -205,18 +243,24 @@ static u64 pmc_intel_save_disable_all(void)
> >  
> >  static u64 pmc_amd_save_disable_all(void)
> >  {
> > -	int idx;
> > -	u64 val, ctrl = 0;
> > +	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
> > +	int enabled, idx;
> > +
> > +	enabled = cpuc->enabled;
> > +	cpuc->enabled = 0;
> > +	barrier();
> 
> Peter,
> 
> please add comments to all barrier()s you added to this file. Is it
> sufficient in hw_perf_save_disable() to stop NMI's only on the current
> core?

Yes, counters are fundamentally per cpu. But you're right, I'll go
through the code and add comments and fix up some barriers.

