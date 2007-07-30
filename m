Return-Path: <linux-kernel-owner+w=401wt.eu-S968589AbXG3Ul2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968589AbXG3Ul2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967013AbXG3UlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:41:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:15934 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764539AbXG3UlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:41:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,200,1183359600"; 
   d="scan'208";a="256577327"
Date: Mon, 30 Jul 2007 13:35:19 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       npiggin@suse.de, ak@suse.de, jens.axboe@oracle.com,
       James.Bottomley@SteelEye.com, andrea@suse.de, akpm@linux-foundation.org,
       andrew.vasquez@qlogic.com
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20070730203519.GD10033@linux-os.sc.intel.com>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <Pine.LNX.4.64.0707301114060.743@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707301114060.743@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 11:20:04AM -0700, Christoph Lameter wrote:
> On Fri, 27 Jul 2007, Siddha, Suresh B wrote:
> 
> > We have been looking into the linux kernel direct IO scalability issues with
> > database workloads. Comments and suggestions on our below experiments are
> > welcome.
> 
> This was on an SMP system? These issues are much more pronounced on a NUMA 
> system. There the locality of the device may be a prime issue.

We are looking into both SMP(multi-core) and NUMA systems.

> Yes. The issue is even worse if the submission comes from a remote node. 
> F.e. If we have a system with a scsi controller on node 2. Now I/O 
> submission on node 1 and completion on node 2. In that case the 
> cacheline has to be transferred across the NUMA interlink.
> 
> However, you cannot avoid running the completion on the node where the 
> device sits. The device has all sorts of control structures and if you 
> would handle the completion on node 1 then it would have to transfer lots
> of cachelines that contain device state to node 1.

If the device is capable of multi queues, then some of the control structures,
irqbalance can be done based on how those multi queues are distributed.

> I think it is better to leave things as is. Or have the I/O submission be 
> relocated to the node of the device.

In the absence of specialized controllers, it is best to keep the control
structures close to the device node and move the I/O submission to this node.

> > Second experiment which we did was migrating the IO submission to the
> > IO completion cpu. Instead of submitting the IO on the same cpu where the
> > request arrived, in this experiment  the IO submission gets migrated to the
> > cpu that is processing IO completions(interrupt). This will minimize the
> > access to remote cachelines (that happens in timers, slab, scsi layers). The
> > IO submission request is forwarded to the kblockd thread on the cpu receiving
> > the interrupts. As part of this, we also made kblockd thread on each cpu as the
> > highest priority thread, so that IO gets submitted as soon as possible on the
> > interrupt cpu with out any delay. On x86_64 SMP platform with 16 cores, this
> > resulted in 2% performance improvement and 3.3% improvement on two node ia64
> > platform.
> 
> I think that is the right approach. This will also help in cases where I/O 
> devices can only be accessed from a certain node (NUMA device address 
> restrictions on some systems may not allow remote cacheline access!)

Ok, there we have no other choice ;-)

> > Observation #2: This introduces some migration overhead during IO submission.
> > With the current prototype, every incoming IO request results in an IPI and
> > context switch(to kblockd thread) on the interrupt processing cpu.
> > This issue needs to be addressed and main challenge to address is
> > the efficient mechanism of doing this IO migration(how much batching to do and
> > when to send the migrate request?), so that we don't delay the IO much and at
> > the same point, don't cause much overhead during migration.
> 
> Right.

So any suggestions for making this clean and acceptable to everyone?

thanks,
suresh
