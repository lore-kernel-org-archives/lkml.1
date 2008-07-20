Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbYGTRj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbYGTRj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 13:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757827AbYGTRjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 13:39:18 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48970 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757622AbYGTRjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 13:39:17 -0400
Date: Sun, 20 Jul 2008 12:39:14 -0500
From: Russ Anderson <rja@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, tglx@linutronix.de, Tony Luck <tony.luck@intel.com>,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: Re: [PATCH 0/2] Migrate data off physical pages with corrected memory errors (Version 7)
Message-ID: <20080720173914.GA9409@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080718203514.GD29621@sgi.com> <87prpa88iw.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87prpa88iw.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 12:37:11PM +0200, Andi Kleen wrote:
> Russ Anderson <rja@sgi.com> writes:
> 
> > [PATCH 0/2] Migrate data off physical pages with corrected memory errors (Version 7)
> 
> FWIW I discussed this with some hardware people and the general
> opinion was that it was way too aggressive to disable a page on the
> first corrected error like this patchkit currently does.  

Part of the "fun" of memory error decision making is that memory hardware
can fail in different ways based on design, manufacturing process, running
conditions (ie temperature), etc.  So the right answer for one type
of memory hardware may be the wrong answer for another type.  That is
why the decision making part of the migration code is implemented
as a kernel loadable module.  That way distros/vendors can use 
a module appropriate for the specific hardware.

The patch has a module for IA64, based on experience on IA64 hardware.
It is a first step, to get the basic functionality in the kernel.
The module can be enhanced for different failure modes and hardware
types.

Note also the functionality to return pages that have been marked
bad.  This allows the pages to be freed if the module is too aggressive.

> The corrected bit error could be caused by a temporary condition
> e.g. in the DIMM link, and does not necessarily mean that part of the
> DIMM is really going bad. Permanently disabling would only be
> justified if you saw repeated corrected errors over a long time from
> the same DIMM.

That is true in some cases.  We have extensive experience with Altix
hardware where corrected errors quickly degrade to uncorrected errors.

> There are also some potential scenarios where being so aggressive
> could hurt, e.g. if you have a low rate of random corrected events
> spread randomly all over your memory (e.g. with a flakey DIMM
> connection) after a long enough uptime you could lose significant parts
> of your memory even though the DIMM is actually still ok.

That is a function of system size.  The fewer DIMMs in the system the
greater that could be a issue.  Altix systems tend to have many DIMMs
(~20,000 in one customer system).  So disabling the memory on a
DIMM with a flaky connector is a small percentage of overall memory.
On a large NUMA machine the flaky DIMM connector would only effect
memory on one node.

> Also the other issue that if the DIMM is going bad then it's likely
> larger areas than just the lines making up this page. So you
> would still risk uncorrected errors anyways because disabling
> the page would only cover a small subset of the affected area.

Sure.  A common failure mode is that a row/column on a DRAM goes
bad, which effects a range of addresses.  I have a DIMM on one 
of my test machines which behaves that way.  It was valuable for
testing the code because several meg worth of pages get migrated.
It is a good stress test for the migration code.

A good enhancement would be to migrate all the data off a DRAM and/or
DIMM when a threshold is exceeded.  That would take knowledge of the
physical memory to memory map layout.  

> If you really wanted to do this you probably should hook it up
> to mcelog's (or the IA64 equivalent) DIMM database

Is there an IA64 equivalent?  I've looked at the x86_64 mcelog,
but have not found a IA64 version.

>                                                     and then
> control it from user space with suitable large thresholds
> and DIMM specific knowledge. But it's unlikely it can be really
> done nicely in a way that is isolated from very specific 
> knowledge about the underlying memory configuration.

Agreed.  An interface to export the physical memory configuration
(from ACPI tables?) would be useful.

Thanks,
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
