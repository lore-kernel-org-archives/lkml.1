Return-Path: <linux-kernel-owner+w=401wt.eu-S1753217Ab0ATAof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab0ATAof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548Ab0ATAoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:44:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40146 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab0ATAod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:44:33 -0500
Date: Wed, 20 Jan 2010 01:44:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
Message-ID: <20100120004430.GA23484@basil.fritz.box>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B560ACD.4040206@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 11:41:01AM -0800, Corey Ashford wrote:
> One subject that hasn't been addressed since the introduction of 
> perf_events in the Linux kernel is that of support for "uncore" or "nest" 
> unit events.  Uncore is the term used by the Intel engineers for their 
> off-core units but are still on the same die as the cores, and "nest" means 
> exactly the same thing for IBM Power processor engineers.  I will use the 
> term uncore for brevity and because it's in common parlance, but the issues 
> and design possibilities below are relevant to both.  I will also broaden 
> the term by stating that uncore will also refer to PMUs that are completely 
> off of the processor chip altogether.

Yes, e.g. chipsets commonly have their own PMUs too.

> The main difference is that uncore events are mostly likely not going to be 
> tied to a particular Linux task, or even a CPU context.  Uncore units are 
> resources that are in some sense system-wide, though, they may not really 
> be accessible system-wide in some architectures.  In the case of 
> accelerators and I/O devices, it's likely they will run asynchronously from 
> the cores, and thus keeping track of events on a per-task basis doesn't 
> make a lot of sense.  The other existing mode in perf_events is a per-CPU 
> context, and it turns out that this mode does match up with uncore units 
> well, though the choice of which CPU to use to manage that uncore unit is 
> going to need to be arch-dependent and may involve other issues as well, 
> such as minimizing access latency between the uncore unit and the CPU which 
> is managing it.

What the user needs to know is which CPUs are affected by that uncore
event. For example the integrated memory controller counters that count local
accesses should be somehow associated with the local CPUs.

> 4. How do you encode uncore events?
> ----
> Uncore events will need to be encoded in the config field of the 
> perf_event_attr struct using the existing PERF_TYPE_RAW encoding.  64 bits 
> are available in the config field, and that may be sufficient to support 
> events on most systems. However, due to  the proliferation and added 
> complexity of PMUs we envision, we might want to add another 64-bit config 
> (perhaps call it config_extra or config2) field to encode any extra 
> attributes that might be needed.  The exact encoding used, just as for the 
> current encoding for core events, will be on a per-arch and possibly 
> per-system basis.

I don't think a raw hex number will scale anywhere. You'll need a human
readable event list / sub event masks with help texts.

Often uncore events have specific restrictions, and that needs
to be enforced somewhere too.

Doing that all in a clean way that is also usable
by programs likely needs a lot more thinking.


> bits   field
> ------ -----
> 3..0   PMU number 0-15  /* specifies which of several identical PMUs being 
> addressed */
> 7..4   core id 0-15
> 8..8   node id 0-1
> 11..9  chip id 0-7
> 16..12 blade id 0-31
> 23..17 rack id 0-128

Such a compressed addressing scheme doesn't seem very future proof.
e.g. core 4 bits for the core is already obsolete (see the "80 core chip" that
was recently announced)


> probably put something together for a particular system.
>
> Addressing Option 2)
>
> Have the kernel create nodes for each uncore PMU in /sys/devices/system or 
> other pseudo file system, such as the existing  /proc/device-tree on Power 
> systems. /sys/devices/system or /proc/device-tree could be explored by the
> user tool, and the user could then specify the path of the requested PMU 
> via a string which the kernel could interpret.  To be overly simplistic, 
> something like "/sys/devices/system/pmus/blade4/cpu0/vectorcopro1".  If we 
> settled on a common tree root to use, we could specify only the relative 
> path name, "blade4/cpu0/vectorcopro1".

That's a more workable scheme, but you still need to find a clean
way to describe topology (see above). The existing examples in sysfs
are unfortuately all clumpsy imho.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
