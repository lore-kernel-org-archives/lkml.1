Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbXFER06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbXFER06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXFER0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:26:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:13393 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbXFER0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:26:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,386,1175497200"; 
   d="scan'208";a="93728780"
Date: Tue, 5 Jun 2007 10:23:10 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070605172310.GD17143@linux-os.sc.intel.com>
References: <20070601004427.GI30788@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601004427.GI30788@tree.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 05:44:27PM -0700, Darrick J. Wong wrote:
> Hi there,
> 
> I'm seeing a driver hang with 2.6.22-rc3 while being slightly stupid
> about offlining CPUs.  I suspect that this problem extends beyond a
> particular machine, as I've been able to replicate it with an IBM x3650
> and an IBM x3755.  This is what I'm doing:
> 
> 1) I tie an IRQ to a particular CPU via /proc/irq/XXX/smp_affinity (IRQ
> 4341 is the network card and we're picking on CPU1 in this example):
> echo 2 > /proc/irq/4341/smp_affinity

Darrick, I see a kernel bug in this area(which is already filled with bugs,
and I am looking into ways to fix them). Are you making sure that
between step-1 and step-2, that interrupts actually started arriving at cpu1?

i.e., do step-1 and wait till the irq's start hitting at cpu1. At this point
do step-2 and let us know if you still hit this bug?

> 
> 2) I then take CPU1 offline:
> echo 0 > /sys/devices/system/cpu/cpu1/online
> 
> 3) The kernel prints this:
> [ 1101.968040] Breaking affinity for irq 4341
> [ 1102.074019] CPU 1 is now offline
> [ 1102.081593] lockdep: not fixing up alternatives.
> [ 1112.886919] nfs: server 9.47.66.169 not responding, still trying
> 
> After step 2 the system never sees interrupts from the network card and
> remains hung like that until CPU1 is brought back up.  It looks as
> though the kernel is trying to reroute the IRQ (or so I'm assuming from
> the "Breaking affinity" message), but this doesn't ever happen, so the
> the kernel stops seeing interrupts from the device.
> 
> Granted, one should not be offlining the CPU that is currently
> designated to handle an IRQ, but I suspect that the kernel ought at a
> minimum to reject the offlining or route the IRQ to any online CPU
> instead of screwing things up.
> 
> There exists a similar scenario.  Set the IRQ affinity to a bunch of
> CPUs, watch /proc/interrupts to see which CPU is actually servicing the
> interrupts, then offline that CPU.  The kernel does not reroute the IRQ
> to any of the other CPUs and the device also hangs.

Is this a theory or did you observe this problem happening?

thanks,
suresh

> 
> The furthest that I've dug is that it works on 2.6.17 and is broken in
> 2.6.22-rc3 and 2.6.21.  Will git-bisect further, but I wanted to know if
> anyone else has seen this sort of problem.  afaik, this seems to happen
> with both IOAPIC and MSI interrupts, possibly more.
