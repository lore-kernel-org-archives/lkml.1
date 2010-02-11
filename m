Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab0BKWYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 17:24:54 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:41233
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756799Ab0BKWYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 17:24:52 -0500
X-SpamScore: -24
X-BigFish: VPS-24(z3b68jz1432R98dN936eM1442J62a3Lzz1202hzzz32i6bh1f2h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KXP7L7-01-9XH-02
X-M-MSG: 
Date: Thu, 11 Feb 2010 23:24:41 +0100
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [RFC] perf_events: how to add Intel LBR support
Message-ID: <20100211222441.GA6027@erda.amd.com>
References: <bd4cb8901002100331id369b65lc944886f35067fb5@mail.gmail.com>
 <20100210154638.GJ24679@erda.amd.com>
 <bd4cb8901002100801p50e2450x25e3004a0f45cff7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bd4cb8901002100801p50e2450x25e3004a0f45cff7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Feb 2010 22:24:42.0146 (UTC) FILETIME=[01AC3820:01CAAB69]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.02.10 17:01:45, Stephane Eranian wrote:
> I was referring to the fact that if I enable LBR via a PERF_SAMPLE_* bit, I
> will actually need more than one bit because there are configuration options.
> I was not talking about event_attr.config.

I am not sure how big a LBR sample would be, but couldn't you send the
whole sample to the userland as a raw sample? If this is too much
overhead and you need to configure the formate, you could set up this
using a small part of the config value.

> > The basic idea for IBS is to define special pmu events that have a
> > different behaviour than standard events (on x86 these are performance
> > counters). The 64 bit configuration value of such an event is simply
> > marked as a special event. The pmu detects the type of the model
> > specific event and passes its value to the hardware. Doing so you can
> > pass any kind of configuration data to a certain pmu.

> Isn't that what the event_attr.type field is used for? there is a RAW type.
> I use it all the time. As for passing to the PMU specific code, this is
> already what it does based on event_attr.type.

I mean, you could setup the pmu with a raw config value. The samples
you return are in raw format too. Doing so, you could put in all
information, also that about the sample format into you
configuration. Of course there must be a way for values more than 64
bits.

The problem with the current x86 implementation is that it expects a
raw config value in the performance counter format. To mark the config
as different, I would simply introduce a bit in event_attr that marks
it as special event.

> > The sample data you get in this case could be either packed into the
> > standard perf_event sampling format, or if this does not fit, the pmu
> > may return raw samples in a special format the userland knows about.
> >
> There is a PERF_SAMPLE_RAW (used by tracing?). It can return opaque
> data of variable length.
> 
> There is a slight difference between IBS and LBR. LBR in itself does not
> generate any interrupts. It has no associated period you arm. It is a free
> running cyclic buffer. To be useful, it needs to be associated with a regular
> counting event, e.g, BRANCH_INSTRUCTIONS_RETIRED. Thus, you
> would need to set PERF_SAMPLE_TAKEN_BRANCH on this event, and
> then you would expect the LBR data coming back as PERF_SAMPLE_RAW.
> 
> 
> If you use the other approach with a dedicated event type. For instance:
> 
> event.type = PERF_TYPE_HW_BRANCH;
> event.config  = PERF_HW_BRANCH:TAKEN:ANY
> 
> I used a symbolic name to make things clearer (but it is the same model as
> for the cache events).
> 
> Then you need to group this event with BRANCH_INSTRUCTIONS_RETIRED
> and set PERF_SAMPLE_GROUP to collect the values of the other member
> of the group. In that case, the other member is LBR but it has a value that
> is more than 64 bits. That does not work with the current code.

There are several questions: How to attach additional setup options to
an event? Grouping seems to be a solution for this. How to pass config
values with more than 64 bits to the pmu? An extension of the api is
probably needed, or grouping could work too. How to get samples back?
The raw sample format is the best to use here. For IBS the difference
is that the configuration has nothing to do with performance counters
and a raw config value needs differen handling.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

