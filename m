Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661Ab0ATNen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab0ATNen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:34:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771Ab0ATNed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:34:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55461 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0ATNec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:34:32 -0500
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>
In-Reply-To: <4B560ACD.4040206@linux.vnet.ibm.com>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 14:34:08 +0100
Message-ID: <1263994448.4283.1052.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 11:41 -0800, Corey Ashford wrote:

> ----
> 3. Why does a CPU need to be assigned to manage a particular uncore unit's events?
> ----
> 
> * The control registers of the uncore unit's PMU need to be read and written, 
> and that may be possible only from a subset of processors in the system.
> * A processor is needed to rotate the event list on the uncore unit on every 
> tick for the purposes of event scheduling.
> * Because of access latency issues, we may want the CPU to be close in locality 
> to the PMU.
> 
> It seems like a good idea to let the kernel decide which CPU to use to monitor a 
> particular uncore event, based on the location of the uncore unit, and possibly 
> current system load balance.  The user will not want to have to figure out this 
> detailed information.

Well, to some extend the user will have to participate. For example
which uncore pmu will be selected depends on the cpu you're attaching
the event to according to the cpu to node map.

Furthermore the intel uncore thing has curious interrupt routing
capabilities which could be tied into this mapping.

> ----
> 4. How do you encode uncore events?
> ----
> Uncore events will need to be encoded in the config field of the perf_event_attr 
> struct using the existing PERF_TYPE_RAW encoding.  64 bits are available in the 
> config field, and that may be sufficient to support events on most systems. 
> However, due to  the proliferation and added complexity of PMUs we envision, we 
> might want to add another 64-bit config (perhaps call it config_extra or 
> config2) field to encode any extra attributes that might be needed.  The exact 
> encoding used, just as for the current encoding for core events, will be on a 
> per-arch and possibly per-system basis.

Lets cross that bridge when we get there.

> ----
> 5. How do you address a particular uncore PMU?
> ----
> 
> This one is going to be very system- and arch-dependent, but it seems fairly 
> clear that we need some sort of addressing scheme that can be 
> system/arch-defined by the kernel.
> 
>  From a hierarchical perspective, here's an example of possible uncore PMU 
> locations in a large system:
> 
> 1) Per-core - units that are shared between all hardware threads in a core
> 2) Per-node - units that are shared between all cores in a node
> 3) Per-chip - units that are shared between all nodes in a chip
> 4) Per-blade - units that are shared between all chips on a blade
> 5) Per-rack - units that are shared between all blades in a rack

So how about PERF_TYPE_{CORE,NODE,SOCKET} like things?

> ----
> 6. Event rotation issues with uncore PMUs
> ----
> 
> Currently, the perf_events code rotates the set of events assigned to a CPU or 
> task on every system tick, so that event scheduling collisions on a PMU are 
> mitigated.  This turns out to cause problems for uncore units for two reasons - 
> inefficiency and CPU load.

Well, if you give these things a cpumask and put them all onto the
context of first cpu of that mask things seem to collect nicely.

> b) Access to some PMU uncore units may be quite slow due to the interconnect 
> that is used.  This can place a burden on the CPU if it is done every system tick.
> 
> This can be addressed by keeping a counter, on a per-PMU context basis that 
> reduces the rate of event rotations.  Setting the rotation period to three, for 
> example, would cause event rotations in that context to happen on every third 
> tick, instead of every tick.  We think that the kernel could measure the amount 
> of time it is taking to do a rotate, and then dynamically decrease the rotation 
> rate if it's taking too long; "rotation rate throttling" in other words.

The better solution is to generalize the whole rr on tick scheme (which
has already been discussed).


