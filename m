Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbZHGIVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbZHGIVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbZHGIVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:21:44 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:24164 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089AbZHGIVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:21:43 -0400
X-SourceIP: 213.93.53.227
Subject: RE: [patch] x86, perf_counter, bts: add bts to perf_counter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1BFEEE3@irsmsx504.ger.corp.intel.com>
References: <20090721155648.A17047@sedona.ch.intel.com>
	 <1249381489.7924.186.camel@twins> <20090804111412.GA20942@elte.hu>
	 <20090804113555.GA28198@elte.hu>
	 <928CFBE8E7CB0040959E56B4EA41A77EC1BFEEE3@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 10:21:22 +0200
Message-Id: <1249633282.32113.613.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 08:29 +0100, Metzger, Markus T wrote:

> I incorporated Peter's review comments, except that I would not enforce sample_period == 1
> when branch tracing is requested. There might be users who want to sample the IP every 100.000'th
> branch for profiling reasons.

But in case you don't set sample_period==1 then you won't be able to
match the BTS counter:

+       if (unlikely((event ==
+                     x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS)) &&
+                    (hwc->sample_period == 1)))
+               return X86_PMC_IDX_FIXED_BTS;

Also,

+               /*
+                * Try to use BTS for branch tracing. If that is not
+                * available, try to get a generic counter.
+                */
+               if (unlikely(!cpuc->ds))
+                       goto try_generic;

How will be use a generic counter for BTS, will it generate an NMI for
every encountered branch? That might very will hit the throttle as that
might be many.

Would it not be better to force sample_period==1 usage onto the BTS and
simply fail if its not available?



