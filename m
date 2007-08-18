Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbXHRJp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbXHRJp0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 05:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXHRJpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 05:45:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51247 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbXHRJpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 05:45:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46C6BF3B.2000502@s5r6.in-berlin.de>
Date: Sat, 18 Aug 2007 11:43:23 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Xu Yang <risingsunxy@googlemail.com>
CC: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: warning in set_irq_chip, ARM port (was Re: bug information)
References: <ab40e9c0708170911r539f4f63t3659084d52567522@mail.gmail.com>
In-Reply-To: <ab40e9c0708170911r539f4f63t3659084d52567522@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xu Yang wrote:
> When I was porting kernel 2.6.19 to my realview_eb_mpcore system, I
> got the following information.
...
> does anyone know what does these information tell ? and where might be
> the problem?
...
> <5>Linux version 2.6.19-arm2 (risingsunxy@localhost.localdomain) (gcc
> version 4.2.0 20070413 (prerelease) (CodeSourcery Sourcery G++ Lite
> 2007q1-21)) #13 SMP Wed Aug 15 19:10:52 CEST 2007
> CPU: ARMv6-compatible processor [410fb022] revision 2 (ARMv6TEJ), cr=00c5387f
> Machine: ARM-RealView EB
...
> BUG: warning at kernel/irq/chip.c:95/set_irq_chip()
> [<c001d338>] (dump_stack+0x0/0x14) from [<c005b6f8>] (set_irq_chip+0x30/0x94)
> [<c005b6c8>] (set_irq_chip+0x0/0x94) from [<c000de88>]
> (gic_dist_init+0x144/0x1a8)
...
> Trying to set irq flags for IRQ128
...

These log lines com from the WARN_ON macro at the indicated file, line,
and function.  This is the function definition:
http://lxr.free-electrons.com/source/kernel/irq/chip.c?v=2.6.19#083

So, set_irq_chip(irq, chip) was called with irq >= NR_IRQS.

According to your log, the kernel iterated over IRQs up to 255 but
NR_IRQS, the total number of IRQs, is obviously defined as 128.  The
call trace points to gic_dist_init as caller of set_irq_chip.
http://lxr.free-electrons.com/source/arch/arm/common/gic.c?v=2.6.19#108

Either the parameters used to calculate max_irq in gic_dist_init are
wrong, or NR_IRQS is wrong, or gic_dist_init's loop over the
set_irq_chip call is wrong.  I am not familiar with this architecture,
but this looks suspicious to me:

	/*
	 * The GIC only supports up to 1020 interrupt sources.
	 * Limit this to either the architected maximum, or the
	 * platform maximum.
	 */
	if (max_irq > max(1020, NR_IRQS))
		max_irq = max(1020, NR_IRQS);

Shouldn't this be:

	if (max_irq > min(1020, NR_IRQS))
		max_irq = min(1020, NR_IRQS);

On the other hand, gic_dist_init's loop over set_irq_chip has been
changed in Linux 2.6.21 to work with multiple interrupt controllers by
the following patch from Catalin Marinas:
"The current implementation only assumes one GIC to be present in the
system. However, there are platforms with more than one cascaded
interrupt controllers (RealView/EB MPCore for example)."
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b3a1bde4db9889feb116330bff21214811c940e4

I think it would be best if you try again with linux-2.6.22.y (latest is
2.6.22.3) or 2.6.23-rcX (latest is 2.6.23-rc3).  If the bug is still
there, report to the linux-arm-kernel@lists.arm.linux.org.uk.  (You
would need to subscribe at
http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel first.)


A few side notes on getting started with kernel hacking:

I found 'LXR' a very useful tool to examine the kernel sources.
A similar tool but for offline use is 'cscope', which I often use via
the nice GUI frontend 'kscope'.

The commit which changed set_irq_chip can be found using the history
links in gitweb
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=history;f=arch/arm/common/gic.c;h=0c89bd35e06fb495dbaddfe2796c6d88a28cea87;hb=HEAD
or quicker and more precisely on a locally installed git repo via 'git
blame' or with the GUI frontend qgit.  I actually used qgit in this case.
-- 
Stefan Richter
-=====-=-=== =--- =--=-
http://arcgraph.de/sr/
