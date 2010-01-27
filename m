Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184Ab0A0K3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0A0K3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167Ab0A0K27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:28:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37132 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab0A0K26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:28:58 -0500
Date: Wed, 27 Jan 2010 11:28:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
Message-ID: <20100127102834.GA27357@elte.hu>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
 <1263994448.4283.1052.camel@laptop>
 <1264023204.4283.1124.camel@laptop>
 <4B57907E.5000207@linux.vnet.ibm.com>
 <20100121072118.GA10585@elte.hu>
 <4B58A750.2060607@linux.vnet.ibm.com>
 <4B58AAF7.60507@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B58AAF7.60507@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:

> On 1/21/2010 11:13 AM, Corey Ashford wrote:
> >
> >
> >On 1/20/2010 11:21 PM, Ingo Molnar wrote:
> >>
> >>* Corey Ashford<cjashfor@linux.vnet.ibm.com> wrote:
> >>
> >>>I really think we need some sort of data structure which is passed
> >>>from the
> >>>kernel to user space to represent the topology of the system, and give
> >>>useful information to be able to identify each PMU node. Whether this is
> >>>done with a sysfs-style tree, a table in a file, XML, etc... it doesn't
> >>>really matter much, but it needs to be something that can be parsed
> >>>relatively easily and *contains just enough information* for the user
> >>>to be
> >>>able to correctly choose PMUs, and for the kernel to be able to
> >>>relate that
> >>>back to actual PMU hardware.
> >>
> >>The right way would be to extend the current event description under
> >>/debug/tracing/events with hardware descriptors and (maybe) to
> >>formalise this
> >>into a separate /proc/events/ or into a separate filesystem.
> >>
> >>The advantage of this is that in the grand scheme of things we
> >>_really_ dont
> >>want to limit performance events to 'hardware' hierarchies, or to
> >>devices/sysfs, some existing /proc scheme, or any other arbitrary (and
> >>fundamentally limiting) object enumeration.
> >>
> >>We want a unified, logical enumeration of all events and objects that
> >>we care
> >>about from a performance monitoring and analysis point of view, shaped
> >>for the
> >>purpose of and parsed by perf user-space. And since the current event
> >>descriptors are already rather rich as they enumerate all sorts of
> >>things:
> >>
> >>- tracepoints
> >>- hw-breakpoints
> >>- dynamic probes
> >>
> >>etc., and are well used by tooling we should expand those with real
> >>hardware
> >>structure.
> >
> >This is an intriguing idea; I like the idea of generalizing all of this
> >info into one structure.
> >
> >So you think that this structure should contain event info as well? If
> >these structures are created by the kernel, I think that would
> >necessitate placing large event tables into the kernel, which is
> >something I think we'd prefer to avoid because of the amount of memory
> >it would take. Keep in mind that we need not only event names, but event
> >descriptions, encodings, attributes (e.g. unit masks), attribute
> >descriptions, etc. I suppose the kernel could read a file from the file
> >system, and then add this info to the tree, but that just seems bad. Are
> >there existing places in the kernel where it reads a user space file to
> >create a user space pseudo filesystem?
> >
> >I think keeping event naming in user space, and PMU naming in kernel
> >space might be a better idea: the kernel exposes the available PMUs to
> >user space via some structure, and a user space library tries to
> >recognize the exposed PMUs and provide event lists and other needed
> >info. The perf tool would use this library to be able to list available
> >events to users.
> >
> 
> Perhaps another way of handing this would be to have the kernel dynamically 
> load a specific "PMU kernel module" once it has detected that it has a 
> particular PMU in the hardware.  The module would consist only of a data 
> structure, and a simple API to access the event data.  This way, only only 
> the PMUs that actually exist in the hardware would need to be loaded into 
> memory, and perhaps then only temporarily (just long enough to create the 
> pseudo fs nodes).
> 
> Still, though, since it's a pseudo fs, all of that event data would be 
> taking up kernel memory.
> 
> Another model, perhaps, would be to actually write this data out to a real 
> file system upon every boot up, so that it wouldn't need to be held in 
> memory.  That seems rather ugly and time consuming, though.

I dont think memory consumption is a problem at all. The structure of the 
monitored hardware/software state is information we _want_ the kernel to 
provide, mainly because there's no unified repository for user-space to get 
this info from.

If someone doesnt want it on some ultra-embedded box then sure a .config 
switch can be provided to allow it to be turned off.

	Ingo
