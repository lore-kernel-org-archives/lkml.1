Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbXFAAna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbXFAAna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 20:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756339AbXFAAnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 20:43:22 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:55069 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756061AbXFAAnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 20:43:22 -0400
Date: Thu, 31 May 2007 17:44:27 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: Device hang when offlining a CPU due to IRQ misrouting
Message-ID: <20070601004427.GI30788@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I'm seeing a driver hang with 2.6.22-rc3 while being slightly stupid
about offlining CPUs.  I suspect that this problem extends beyond a
particular machine, as I've been able to replicate it with an IBM x3650
and an IBM x3755.  This is what I'm doing:

1) I tie an IRQ to a particular CPU via /proc/irq/XXX/smp_affinity (IRQ
4341 is the network card and we're picking on CPU1 in this example):
echo 2 > /proc/irq/4341/smp_affinity

2) I then take CPU1 offline:
echo 0 > /sys/devices/system/cpu/cpu1/online

3) The kernel prints this:
[ 1101.968040] Breaking affinity for irq 4341
[ 1102.074019] CPU 1 is now offline
[ 1102.081593] lockdep: not fixing up alternatives.
[ 1112.886919] nfs: server 9.47.66.169 not responding, still trying

After step 2 the system never sees interrupts from the network card and
remains hung like that until CPU1 is brought back up.  It looks as
though the kernel is trying to reroute the IRQ (or so I'm assuming from
the "Breaking affinity" message), but this doesn't ever happen, so the
the kernel stops seeing interrupts from the device.

Granted, one should not be offlining the CPU that is currently
designated to handle an IRQ, but I suspect that the kernel ought at a
minimum to reject the offlining or route the IRQ to any online CPU
instead of screwing things up.

There exists a similar scenario.  Set the IRQ affinity to a bunch of
CPUs, watch /proc/interrupts to see which CPU is actually servicing the
interrupts, then offline that CPU.  The kernel does not reroute the IRQ
to any of the other CPUs and the device also hangs.

The furthest that I've dug is that it works on 2.6.17 and is broken in
2.6.22-rc3 and 2.6.21.  Will git-bisect further, but I wanted to know if
anyone else has seen this sort of problem.  afaik, this seems to happen
with both IOAPIC and MSI interrupts, possibly more.

--D
