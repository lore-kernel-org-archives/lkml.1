Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab0BOULN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 15:11:13 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:31783
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755264Ab0BOULM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 15:11:12 -0500
X-SpamScore: -23
X-BigFish: VPS-23(z37d5nz1432R98dN14ffO936eM62a3Lzz1202hzzz32i6bh1f2h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KXWG2G-02-2IK-02
X-M-MSG: 
Date: Mon, 15 Feb 2010 21:11:02 +0100
From: Robert Richter <robert.richter@amd.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC perf,x86] P4 PMU early draft
Message-ID: <20100215201102.GN13205@erda.amd.com>
References: <20100208184504.GB5130@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100208184504.GB5130@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 15 Feb 2010 20:11:03.0082 (UTC) FILETIME=[FF9728A0:01CAAE7A]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.02.10 21:45:04, Cyrill Gorcunov wrote:
> Hi all,
> 
> first of all the patches are NOT for any kind of inclusion. It's not
> ready yet. More likely I'm asking for glance review, ideas, criticism.
> 
> The main problem in implementing P4 PMU is that it has much more
> restrictions for event to MSR mapping. So to fit into current
> perf_events model I made the following:
> 
> 1) Event representation. P4 uses a tuple of ESCR+CCCR+COUNTER
>    as an "event". Since every CCCR register mapped directly to
>    counter itself and ESCR and CCCR uses only 32bits of their
>    appropriate MSRs, I decided to use "packed" config in
>    in hw_perf_event::config. So that upper 31 bits are ESCR
>    and lower 32 bits are CCCR values. The bit 64 is for HT flag.
> 
>    So the base idea here is to pack into 64bit hw_perf_event::config
>    as much info as possible.
> 
>    Due to difference in bitfields I needed to implement
>    hw_perf_event::config helper which unbind hw_perf_event::config field
>    from processor specifics and allow to use it in P4 PMU.

If we introduce model specific configuration, we should put more model
specific code in here and then remove

  u64             (*raw_event)(u64);

in struct x86_pmu.

> 3) I've started unbinding x86_schedule_events into per x86_pmu::schedule_events
>    and there I hit hardness in binding HT bit. Have to think...

Instead of implemting x86_pmu.schedule_events() you should rather
abstract x86_pmu_enable(). This will be much more flexible to
implement other model spcific features.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

