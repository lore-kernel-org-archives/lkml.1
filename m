Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab0CKVuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:50:22 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:52764 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab0CKVuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:50:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ea6lmx/CKS9xjkwaV2r4ydnEOp6npienwXRu856UMhaCapJuNQAdBRVbz8PO6+xPLk
         SOJIPJRQN9vbxnuP1m5ohS/qHOrsZ87EBSxjb1oOtCox/M+VgWBFbxG+TyFX7QrVkwwU
         ijJYBn6mBf6svYb7hYdM79zue8pK9Gti/gpZ4=
Date: Fri, 12 Mar 2010 00:50:16 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Stephane Eranian <eranian@google.com>,
       Robert Richter <robert.richter@amd.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86,perf: Implement minimal P4 PMU driver v14
Message-ID: <20100311215016.GG25162@lenovo>
References: <20100310183102.GC8070@lenovo> <1268274775.4996.16.camel@minggr.sh.intel.com> <20100311165439.GB5129@lenovo> <20100311181646.GA12235@elte.hu> <20100311183921.GA30249@elte.hu> <20100311211538.GC25162@lenovo> <1268342662.5037.143.camel@laptop> <20100311213128.GE25162@lenovo> <1268343480.5037.145.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268343480.5037.145.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 10:38:00PM +0100, Peter Zijlstra wrote:
> On Fri, 2010-03-12 at 00:31 +0300, Cyrill Gorcunov wrote:
> > On Thu, Mar 11, 2010 at 10:24:22PM +0100, Peter Zijlstra wrote:
> > > On Fri, 2010-03-12 at 00:15 +0300, Cyrill Gorcunov wrote:
> > > 
> > > > Perhaps something like the patch below (tested with kvm)? With this patch
> > > > we will actually waste ~4/8 bytes per PMU (intel,amd,p6) since this call
> > > > hits on p4 only, so I think perhaps better to use one x86 scheduler hook
> > > > instead of empty schedule_events() in PMU, hmm?
> > > > ---
> > > > 
> > > > x86,perf: Fix NULL deref on not assigned x86_pmu
> > > > 
> > > > In case of not assigned x86_pmu and software events
> > > > NULL dereference may being hit via x86_pmu::schedule_events
> > > > method.
> > > > 
> > > > Fix it by calling x86_pmu::schedule_events only if we
> > > > have one. Otherwise use general scheduler.
> > > > 
> > > > Also the former x86_schedule_events calls restored.
> > > 
> > > Hrm,.. not sure that makes sense, sure it might not crash anymore, but
> > > its not making much sense to compute anything if we don't have an
> > > initialized x86_pmu.
> > > 
> > > Doesn't adding something like:
> > > 
> > >   if (!x86_pmu_initialized())
> > >    return;
> > > 
> > > to hw_perf_group_sched_in() make more sense? We seem to do that for all
> > > these weak things except this one.
> > > 
> > 
> > As far as I see it'll not update tstamp_running then (in x86_event_sched_in).
> > Or I miss somethig?
> 
> Have it return 0 and it will fallback to defaults. Since there is no
> initialized x86_pmu there's no point in doing anything x86 specific.
>

I suppose you mean something like below.
 
	-- Cyrill
---
x86,perf: Fix NULL deref on not assigned x86_pmu

In case of not assigned x86_pmu and software events
NULL dereference may being hit via x86_pmu::schedule_events
method.

Fix it by checking if x86_pmu is initialized at all.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -1263,6 +1263,9 @@ int hw_perf_group_sched_in(struct perf_e
 	int assign[X86_PMC_IDX_MAX];
 	int n0, n1, ret;
 
+	if (!x86_pmu_initialized())
+		return 0;
+
 	/* n0 = total number of events */
 	n0 = collect_events(cpuc, leader, true);
 	if (n0 < 0)
