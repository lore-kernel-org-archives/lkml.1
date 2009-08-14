Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZHNRGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZHNRGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 13:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZHNRGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 13:06:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754160AbZHNRGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 13:06:15 -0400
Date: Fri, 14 Aug 2009 10:04:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
cc: mano@roarinelk.homelinux.net, rjw@sisk.pl, willy@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       akpm@linux-foundation.org, andrew.patterson@hp.com
Subject: Re: PCI resources allocation problem on Toshiba Satellite A40
In-Reply-To: <200908141850.44736.elendil@planet.nl>
Message-ID: <alpine.LFD.2.01.0908140957050.3162@localhost.localdomain>
References: <200908021619.48285.rjw@sisk.pl> <200908140341.02210.elendil@planet.nl> <alpine.LFD.2.01.0908131843200.3162@localhost.localdomain> <200908141850.44736.elendil@planet.nl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 Aug 2009, Frans Pop wrote:

> On Friday 14 August 2009, Linus Torvalds wrote:
> > Can you send
> >  - output of /proc/ioports both with the current kernel (or the 2.6.30
> >    kernel - they should be identical) and with one of the kernels in
> >    between that didn't warn
> >  - send the full bootup dmesg with CONFIG_PCI_DEBUG enabled
> >
> > and we can probably figure it out.
> 
> Attached.

Ok, this one actually looks obvious from just the ioports thing:

	--- ioports.a76117d     2009-08-14 18:44:42.000000000 +0200
	+++ ioports.current-git 2009-08-14 18:44:42.000000000 +0200
	...
	+18c0-18df : 0000:00:1d.0
	+  18c0-18df : uhci_hcd
	+18e0-18ff : 0000:00:1d.1
	+  18e0-18ff : uhci_hcd
	 bfa0-bfaf : 0000:00:1f.1
	   bfa0-bfaf : piix
	 c000-cfff : PCI Bus 0000:01
	   c000-c0ff : PCI CardBus 0000:02
	   c400-c4ff : PCI CardBus 0000:02
	   cf40-cf7f : 0000:01:08.0
	     cf40-cf7f : e100
	-  cf80-cf9f : 0000:00:1d.1
	-    cf80-cf9f : uhci_hcd
	-  cfe0-cfff : 0000:00:1d.0
	-    cfe0-cfff : uhci_hcd

That old cf80-cf9f/cfe0-cfff location is just totally invalid. Your UHCI 
device is (as it shows) PCI device 0000:00:1d, functions 0/1. In other 
words, they are on PCI bus 0.

But the c000-cfff area is a window that has been set up for PCI bus 1.

The ioports.a76117d version is simply wrong. The Linux PCI layer did the 
right thing, and moved the silly device away from that PCI bus 1 window.

Now, it so happens that I bet it does _work_ in there, but that's likely 
because that 0000:00:1d.x device is on the southbridge chip itself, and it 
probably simply gets decoded before it any access is even sent out on the 
PCI bus and hits the bridge for bus#1. But the fact is, your BIOS has 
simply set up the devices in a totally insane way, and I think the kernel 
did everything right.

So the fact that it "worked" for a few kernels was simply due to a kernel 
bug, where "pci_claim_resource()" incorrectly allowed the resource to be 
inserted into a resource window that wasn't actually its parent, and a 
crazy BIOS that did crazy things, together with a chipset where those 
crazy things just _happened_ to work because of how decoding was done.

			Linus

