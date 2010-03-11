Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0CKVY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:24:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:51559 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab0CKVY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:24:27 -0500
Subject: Re: [RFC] x86,perf: Implement minimal P4 PMU driver v14
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Stephane Eranian <eranian@google.com>,
       Robert Richter <robert.richter@amd.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100311211538.GC25162@lenovo>
References: <20100310183102.GC8070@lenovo>
	 <1268274775.4996.16.camel@minggr.sh.intel.com>
	 <20100311165439.GB5129@lenovo> <20100311181646.GA12235@elte.hu>
	 <20100311183921.GA30249@elte.hu>  <20100311211538.GC25162@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 22:24:22 +0100
Message-ID: <1268342662.5037.143.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 00:15 +0300, Cyrill Gorcunov wrote:

> Perhaps something like the patch below (tested with kvm)? With this patch
> we will actually waste ~4/8 bytes per PMU (intel,amd,p6) since this call
> hits on p4 only, so I think perhaps better to use one x86 scheduler hook
> instead of empty schedule_events() in PMU, hmm?
> ---
> 
> x86,perf: Fix NULL deref on not assigned x86_pmu
> 
> In case of not assigned x86_pmu and software events
> NULL dereference may being hit via x86_pmu::schedule_events
> method.
> 
> Fix it by calling x86_pmu::schedule_events only if we
> have one. Otherwise use general scheduler.
> 
> Also the former x86_schedule_events calls restored.

Hrm,.. not sure that makes sense, sure it might not crash anymore, but
its not making much sense to compute anything if we don't have an
initialized x86_pmu.

Doesn't adding something like:

  if (!x86_pmu_initialized())
   return;

to hw_perf_group_sched_in() make more sense? We seem to do that for all
these weak things except this one.

