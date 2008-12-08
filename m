Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbYLHHTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbYLHHTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 02:19:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYLHHSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 02:18:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:25611 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYLHHSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 02:18:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=UOJm2wzzS17TGoQK6MqDaYlSlC0RvzO/a8h0oqG4NXl+rhRZ3GRO9Ergo/IoSXVLAa
         se+mrB5jcoYorXeMWZx9mrNsXl3FRIQTnJk+AX+1mofWNLLk7nmpaLANdv+ig3VCqpW2
         3PpRxZM0qFiXNwb8dCo4ltuBoEOffNV3tnfhM=
Message-ID: <7c86c4470812072318n33e27045k50490f180ecfd8c0@mail.gmail.com>
Date: Mon, 8 Dec 2008 08:18:51 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Veen" <arjan@infradead.org>,
       "Peter Anvin" <hpa@zytor.com>, "Steven Rostedt" <rostedt@goodmis.org>,
       "David Miller" <davem@davemloft.net>
In-Reply-To: <18747.23509.977047.540995@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081204225345.654705757@linutronix.de>
	 <18744.29747.728320.652642@cargo.ozlabs.ibm.com>
	 <20081205063131.GB12785@elte.hu>
	 <18744.56857.259756.129894@cargo.ozlabs.ibm.com>
	 <20081205080813.GA2030@elte.hu>
	 <18744.61429.548462.667020@cargo.ozlabs.ibm.com>
	 <20081205120734.GA26244@elte.hu>
	 <18745.49593.567217.277510@cargo.ozlabs.ibm.com>
	 <1228566879.16244.4.camel@lappy.programming.kicks-ass.net>
	 <18747.23509.977047.540995@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Dec 7, 2008 at 6:15 AM, Paul Mackerras <paulus@samba.org> wrote:
> Peter Zijlstra writes:
>
>> On Sat, 2008-12-06 at 11:05 +1100, Paul Mackerras wrote:
>> > Now, the tables in perfmon's user-land libpfm that describe the
>> > mapping from abstract events to event-selector values and the
>> > constraints on what events can be counted together come to nearly
>> > 29,000 lines of code just for the IBM 64-bit powerpc processors.
>> >
>> > Your API condemns us to adding all that bloat to the kernel, plus the
>> > code to use those tables.
>>
>> Since you need those tables and that code anyway, and in a solid
>> reliable way, what is the objection of carrying it in the kernel?
>
> Because it's about 320kB of unpageable kernel memory, and it doesn't
> need to be in the kernel.
>

That inevitably pulls in large amounts of data, the event table for each PMU
model and the description of the constraints between events. New processors
have hundreds of events. Moreover, there is the complexity of the assignment
algorithm to map the events to counters such that they actually measure what
you've asked for. I described some of those constraints in my previous message.
They are not trivial and are oftentimes multi-dimensional. Getting the
algorithms
right is difficult. Event tables are also oftentimes incomplete or
bogus when first
published by HW vendors.

It does not make sense to have this kind of data + code in the kernel. It would
make developing them much more difficult. Maintenance would also be more
difficult. And clearly you don't want to have to re-run the assignment routine
each time you context switch.

The kernel is not the only place for rock-solid code. You can have solid/stable
code in libraries as well.

> The fundamental problem with Ingo and Thomas's proposal is that the
> abstraction is at the wrong level.  It makes individual counters the
> central idea, when the central idea should be a set of counters that
> all start and stop counting at the same times.  People doing
> performance analysis want to be able to compare counts of different
> events and get ratios, and you can't do that meaningfully if the
> counts correspond to different stretches of code.
>
> Once you make the abstraction a set of counters, then you also make it
> possible to have a counter-set that is the whole PMU.  Then you don't
> have to have the kernel knowing all the possible settings for the PMU;
> it only needs to know the simple ones, and if you want to do something
> more sophisticated, you can have userspace specifying the bits to
> select the more sophisticated setting.
>
>> Furthermore, is there a good technical reason these cpus are so
>> complicated to use?
>
> That question is a bit ambiguous.  If you mean, why did the hardware
> designers make it so complex? then I don't really know, but it doesn't
> matter because the CPU hardware is what it is.  At best I might be
> able to influence future designs to be a bit simpler.
>

Let me explain the HW complexity a bit. It's all a matter of tradeoffs.
I have regular discussions with the PMU design architects about this.
If you talk to them, then you understand the environment they have to
live in and you understand why those constraints are there. The key point
to understand is that the PMU is never critical to the chip. The chip can work
well without. The real-estate on the chip is always very tight. PMU is a 2nd
class citizen, thus low in the priority list. For certain PMU features
the tradeoff
is: do you want the feature with constraints on programming or no feature at
all. The common HW limitation is wires. For instance, I was once told: would you
rather have a PMU cache event that can be programmed on any counters but
with an increased cache latency for all accesses or a faster cache and
a constraint
on the event? The response is obvious.

I think you now understand why there are constraints and also why they
will never
go away, quite the contrary. I'd rather have a PMU with constraints than no PMU.
Hardware designers make a lot of efforts to give us what we have today already
and we should be thankful.

> If you mean, could the software description of the hardware be
> simpler? then maybe - I'm just reading up on the details of the
> hardware, and it is pretty complex, with multiple layers of
> multiplexers and event buses.
>
