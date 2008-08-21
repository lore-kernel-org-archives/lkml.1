Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYHUNRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYHUNRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYHUNRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:17:24 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:4183 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbYHUNRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:17:23 -0400
X-BigFish: VPS-45(zz1432R98dR936eQ62a3L1805M936fQzz10d3izzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K5YCWM-02-FU3-01
Date: Thu, 21 Aug 2008 15:16:52 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: patch "x86: MOVE PCI IO ECS code to x86/pci" breaks CPU hotplug
Message-ID: <20080821131652.GC13011@erda.amd.com>
References: <48AD7F80.76E4.0078.0@novell.com> <20080821130259.GA22887@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080821130259.GA22887@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 21 Aug 2008 13:17:14.0006 (UTC) FILETIME=[3A009360:01C90390]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.08.08 15:02:59, Ingo Molnar wrote:
> 
> * Jan Beulich <jbeulich@novell.com> wrote:
> 
> > Converting __cpuinit functions called out of init_amd() (and similar 
> > others) to __init (and making them subject of xxx_initcall() handling 
> > isn't valid, as they would no longer be called for hot plugged CPUs.
> > 
> > Further, since it's likely that in virtualized environments the MSR 
> > write would at best be ignored, I'd also recommend using the 
> > fault-safe accessors here *and* check that the bit actually got set 
> > before setting PCI_HAS_IO_ECS (one would obviously have to BUG() when 
> > hot-plugged CPUs fail to set the bit when those available at boot 
> > successfully did so).
> 
> hm, which patch is this exactly, and in what tree? It's not upstream nor 
> in -tip.

Probably this in the mainline kernel is meant:

commit 3a27dd1ce5de08e21e0266ddf00e6f1f843bfe8b
Author: Robert Richter <robert.richter@amd.com>
Date:   Thu Jun 12 20:19:23 2008 +0200

    x86: Move PCI IO ECS code to x86/pci
    
    "Form follows function". Code is now where it belongs to.
    
    Signed-off-by: Robert Richter <robert.richter@amd.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

The problem is code like this:

+static int __init enable_pci_io_ecs(void)
+{
+       /* assume all cpus from fam10h have IO ECS */
+        if (boot_cpu_data.x86 < 0x10)
+               return 0;
+       on_each_cpu(enable_pci_io_ecs_per_cpu, NULL, 1, 1);
+       pci_probe |= PCI_HAS_IO_ECS;
+       return 0;
+}

It is only called during the setup and if the cpu is enabled. I intend
to rewrite the cpu setup code using cpu notifiers.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

