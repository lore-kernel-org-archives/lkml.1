Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbYG1Vop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbYG1Vop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbYG1Vog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:44:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34520 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754216AbYG1Vof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:44:35 -0400
Date: Mon, 28 Jul 2008 16:44:33 -0500
From: Russ Anderson <rja@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, tglx@linutronix.de, Tony Luck <tony.luck@intel.com>,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org
Subject: Re: [PATCH 0/2] Migrate data off physical pages with corrected memory errors (Version 7)
Message-ID: <20080728214433.GA243074@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080718203514.GD29621@sgi.com> <87prpa88iw.fsf@basil.nowhere.org> <20080720173914.GA9409@sgi.com> <20080721194000.GE29543@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721194000.GE29543@basil.nowhere.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 09:40:00PM +0200, Andi Kleen wrote:
> On Sun, Jul 20, 2008 at 12:39:14PM -0500, Russ Anderson wrote:
> > The patch has a module for IA64, based on experience on IA64 hardware.
> > It is a first step, to get the basic functionality in the kernel.
> 
> The basic functionality doesn't seem flexible enough for me 
> for useful policies.

To make sure I understand, it is the decision making functionality
in the kernel loadable module you find not flexible enough, not
the migration code (in mm/migrate.c), correct?  I knew the decision
making part would be the most controversial.  That's why it's implemented
as a kernel loadable module.  I'm not opposed to more flexibility,
but I'm also trying to get some functionality in.

> > (~20,000 in one customer system).  So disabling the memory on a
> > DIMM with a flaky connector is a small percentage of overall memory.
> > On a large NUMA machine the flaky DIMM connector would only effect
> > memory on one node.
> 
> You would still lose significant parts of that node, won't you?

The amount of memory loss would depend on the number of DIMMs on
the node.  It is not unusual to have 4-6 DIMM pairs.

> Even on the large systems people might miss a node or two.

Not the entire node, just a percentage of memory on the node.

Customers vary, but in the case of a flaky connector causing 
correctable errors, most of the customers I've worked with would
not want to contunue hitting corrected errors, out of fear that it
could become uncorrectable errors, even if that means disabling
innocent memory, to reduce the risk of crashing.

> > A good enhancement would be to migrate all the data off a DRAM and/or
> > DIMM when a threshold is exceeded.  That would take knowledge of the
> > physical memory to memory map layout.  
> 
> Would be probably difficult to teach this the kernel in a nice generic
> way. In particular interleaving is difficult.

Sure, especially given the differences in the various archs.  If limited
to just x86 (or x86_64) would it be less difficult?  Just trying to find
a way of making forward progress.

> > > If you really wanted to do this you probably should hook it up
> > > to mcelog's (or the IA64 equivalent) DIMM database
> > 
> > Is there an IA64 equivalent?  I've looked at the x86_64 mcelog,
> > but have not found a IA64 version.
> 
> There's a sal logger process in user space I believe, but I have never looked 
> at it. It could do these things in theory.

Do you mean salinfo_decode?  salinfo_decode reads & logs error records.
I guess it could be modified to be more intelligent.  

> Also in the IA64 case the firmware can actually tell the kernel
> what to do because it gets involved here (and firmware often
> has usable heuristics for this case) 

I'm looking at that.  

> > > and DIMM specific knowledge. But it's unlikely it can be really
> > > done nicely in a way that is isolated from very specific 
> > > knowledge about the underlying memory configuration.
> > 
> > Agreed.  An interface to export the physical memory configuration
> > (from ACPI tables?) would be useful.
> 
> On x86 there's currently only DMI/SMBIOS for this, but it has some issues.

What would be the best way to export the physical memory configuration?
Enhance DMI/SMBIOS?  ACPI table?  Other?

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
