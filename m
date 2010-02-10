Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab0BJPrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 10:47:11 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:56136
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754416Ab0BJPrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:47:09 -0500
X-SpamScore: -22
X-BigFish: VPS-22(z3b68jz1432R98dN936eM62a3Lzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KXMUHP-02-FGK-02
X-M-MSG: 
Date: Wed, 10 Feb 2010 16:46:38 +0100
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [RFC] perf_events: how to add Intel LBR support
Message-ID: <20100210154638.GJ24679@erda.amd.com>
References: <bd4cb8901002100331id369b65lc944886f35067fb5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bd4cb8901002100331id369b65lc944886f35067fb5@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Feb 2010 15:46:38.0884 (UTC) FILETIME=[3BB9E640:01CAAA68]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

On 10.02.10 12:31:16, Stephane Eranian wrote:
> I started looking into how to add LBR support to perf_events. We have LBR
> support in perfmon and it has proven very useful for some measurements.
> 
> The usage model is that you always couple LBR with sampling on an event.
> You want the LBR state dumped into the sample on overflow. When you resume,
> after an overflow, you clear LBR and you restart it.
> 
> One obvious implementation would be to add a new sample type such as
> PERF_SAMPLE_TAKEN_BRANCHES. That would generate a sample with
> a body containing an array of 4x2 up to 16x2 u64 addresses. Internally, the
> hw_perf_event_structure would have to store the LBR state so it could be
> saved and restored on context switch in per-thread mode.
> 
> There is one problem with this approach. On Nehalem, the LBR can be configured
> to capture only certain types of branches + priv levels. That is about
> 8 config bits
> + priv levels. Where do we pass those config options?

I have a solution for IBS in mind and try to implement it. I just have
the problem that the current development on perf is so fast and
changes are very intrusive that I am not able to publish a working
version due to merge conflicts. So I need a bit time to rework my
exisisting implementation and review your changes.

The basic idea for IBS is to define special pmu events that have a
different behaviour than standard events (on x86 these are performance
counters). The 64 bit configuration value of such an event is simply
marked as a special event. The pmu detects the type of the model
specific event and passes its value to the hardware. Doing so you can
pass any kind of configuration data to a certain pmu.

The sample data you get in this case could be either packed into the
standard perf_event sampling format, or if this does not fit, the pmu
may return raw samples in a special format the userland knows about.

The interface extension is adopting the perfmon2 model specific pmu
setup where you can pass config values to the pmu and return
performance data from it. The implementation is architecture
independent and compatible with the current interface. The only change
to the api is an additional bit to the perf_event_attr to mark the raw
config value as model specific.

> One solution would have to provide as many PERF_SAMPLE bits as the hardware
> OR provide some config field for it in perf_event_attr. All of this
> would have to
> remain very generic.
> 
> An alternative approach is to define a new type of (pseudo)-event, e.g.,
> PERF_TYPE_HW_BRANCH and provide variations very much like this is
> done for the generic cache events. That event would be associated with a
> new fixed-purpose counter (similar to BTS). It would go through scheduling
> via a specific constraint (similar to BTS). The hw_perf_event structure
> would provide the storage area for dumping LBR state.
> 
> To sample on LBR with the event approach, the LBR event would have to
> be in the same event group. The sampling event would then simply add
> sample_type = PERF_SAMPLE_GROUP.
> 
> The second approach looks more extensible, flexible than the first one. But
> it runs into a major problem with the current perf_event API/ABI and
> implementation. The current assumption is that all events never return more
> than 64-bit worth of data. In the case of LBR, we would need to return way
> more than this.

My implementation just need one 64 bit config value, but it could be
extended to use more than one config value too.

I will try to send working sample code soon, but I need a 'somehow
stable' perf tree for this. It would also help if you would publish
patch sets with many small patches instead of one big change. This
reduces merge or rebase effort.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

