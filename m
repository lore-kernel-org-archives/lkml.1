Return-Path: <linux-kernel-owner+w=401wt.eu-S967459AbXG3SUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967459AbXG3SUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 14:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764799AbXG3SUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 14:20:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42584 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762716AbXG3SUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 14:20:05 -0400
Date: Mon, 30 Jul 2007 11:20:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       npiggin@suse.de, ak@suse.de, jens.axboe@oracle.com,
       James.Bottomley@SteelEye.com, andrea@suse.de, akpm@linux-foundation.org,
       andrew.vasquez@qlogic.com
Subject: Re: [rfc] direct IO submission and completion scalability issues
In-Reply-To: <20070728012128.GB10033@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0707301114060.743@schroedinger.engr.sgi.com>
References: <20070728012128.GB10033@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007, Siddha, Suresh B wrote:

> We have been looking into the linux kernel direct IO scalability issues with
> database workloads. Comments and suggestions on our below experiments are
> welcome.

This was on an SMP system? These issues are much more pronounced on a NUMA 
system. There the locality of the device may be a prime issue.

> In the linux kernel, direct IO requests are not batched at the block layer.
> i.e, as a new request comes in, the request get directly submitted to the
> IO controller on the same cpu that the request originates. And the IO completion
> likely happens on a different cpu which is processing interrupts. This results
> in cacheline bouncing of some of the hot kernel cachelines (like timers, scsi
> cmds, slab, sched, etc) and is becoming an important scalability issue
> as the number of cpus and distance between them increase with multi-core
> and numa.

Yes. The issue is even worse if the submission comes from a remote node. 
F.e. If we have a system with a scsi controller on node 2. Now I/O 
submission on node 1 and completion on node 2. In that case the 
cacheline has to be transferred across the NUMA interlink.

However, you cannot avoid running the completion on the node where the 
device sits. The device has all sorts of control structures and if you 
would handle the completion on node 1 then it would have to transfer lots
of cachelines that contain device state to node 1.

I think it is better to leave things as is. Or have the I/O submission be 
relocated to the node of the device.
 
> Second experiment which we did was migrating the IO submission to the
> IO completion cpu. Instead of submitting the IO on the same cpu where the
> request arrived, in this experiment  the IO submission gets migrated to the
> cpu that is processing IO completions(interrupt). This will minimize the
> access to remote cachelines (that happens in timers, slab, scsi layers). The
> IO submission request is forwarded to the kblockd thread on the cpu receiving
> the interrupts. As part of this, we also made kblockd thread on each cpu as the
> highest priority thread, so that IO gets submitted as soon as possible on the
> interrupt cpu with out any delay. On x86_64 SMP platform with 16 cores, this
> resulted in 2% performance improvement and 3.3% improvement on two node ia64
> platform.

I think that is the right approach. This will also help in cases where I/O 
devices can only be accessed from a certain node (NUMA device address 
restrictions on some systems may not allow remote cacheline access!)

> Observation #2: This introduces some migration overhead during IO submission.
> With the current prototype, every incoming IO request results in an IPI and
> context switch(to kblockd thread) on the interrupt processing cpu.
> This issue needs to be addressed and main challenge to address is
> the efficient mechanism of doing this IO migration(how much batching to do and
> when to send the migrate request?), so that we don't delay the IO much and at
> the same point, don't cause much overhead during migration.

Right.

