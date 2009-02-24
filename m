Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbZBXQph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbZBXQph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 11:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbZBXQp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 11:45:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274AbZBXQp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 11:45:27 -0500
Date: Tue, 24 Feb 2009 08:45:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: George Rapp <george.rapp@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Anvin <hpa@zytor.com>, Dave Airlie <airlied@gmail.com>
Subject: Re: pci 0000:01:00.0: BAR 0: can't allocate resource
In-Reply-To: <f1f3dd8f0902240542m58aa6adfn3fc09cee162636a1@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0902240753550.3111@localhost.localdomain>
References: <f1f3dd8f0902221910n2722b024pe3ec8748fd3aed5b@mail.gmail.com>  <alpine.LFD.2.00.0902221941510.3111@localhost.localdomain> <f1f3dd8f0902240542m58aa6adfn3fc09cee162636a1@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Feb 2009, George Rapp wrote:
> 
> [root@newbackend ~]# cat /proc/iomem
> ...
> d8000000-e7ffffff : PCI Bus 0000:01
>   d8000000-d801ffff : 0000:01:00.0

Ok, that's the large prefetchable PCI bridge window we would _want_ to fit 
into. And it even has something from your video card in it. In fact, I 
think it's the expansion ROM (which is not actually enabled, but the 
resource has been allocated for it).

> e8000000-efffffff : 0000:00:00.0

This is the AGP window, I think.

> f0000000-f1ffffff : PCI Bus 0000:01
>   f1000000-f100ffff : 0000:01:00.0

And this is the non-prefetchable PCI bridge window, and has the 
non-prefetchable video card resource in it.

But the odd thing is that prefetchable bridge window:

	d8000000-e7ffffff : PCI Bus 0000:01
	  d8000000-d801ffff : 0000:01:00.0

because the thing you _want_ to fit into it is this:

	pci 0000:01:00.0: BAR 0: can't allocate mem resource [0xe0000000-0xe7ffffff]

and quite frankly, it should fit perfectly fine. I'm not seeing at all why 
it can't just allocate it. Why can't we not just put it in that exact 
range: 0xe0000000-0xe7ffffff.

But there are other odd things there too. Your dmesg contains one 
tantalizing clue about the setup the BIOS used that I hadn't noticed 
before:

	pci 0000:01:00.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
	pci 0000:01:00.0: reg 14 io port: [0x9000-0x90ff]
	pci 0000:01:00.0: reg 18 32bit mmio: [0xf1000000-0xf100ffff]
	pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
	pci 0000:01:00.0: supports D1 D2

an the odd clue is that [0xd0000000-0xdfffffff]. It's the same BAR, when 
probed for initial values. And the _size_ is different. At that initial 
probe, the PCI bridge windows are set up by the BIOS (and we actually try 
to keep them, so they stay the same after PCI probing) as

	pci 0000:00:01.0: bridge io port: [0x9000-0x9fff]
	pci 0000:00:01.0: bridge 32bit mmio: [0xf0000000-0xf1ffffff]
	pci 0000:00:01.0: bridge 32bit mmio pref: [0xd8000000-0xe7ffffff]

and the _initial_ problem at that point is that we cannot reconcile the 
original video device BAR mapping (0xd0000000-0xdfffffff) with the PCI 
bridge window (0xd8000000-0xe7ffffff) since they overlap in invalid ways.

So at that point, the size of that thing is actually bigger (256M) than we 
think it's later (128M), and because it doesn't fit anywhere, we say "the 
BIOS setup must be crap, we need to re-allocate that resource". And with 
that bigger size, it really _is_ impossible to allocate.

Then at the later point, when we try to re-allocate space for it, we fail, 
but then we print out the failure and seem to think it's just 128MB in 
size:

	BAR 0: can't allocate mem resource [0xe0000000-0xe7ffffff]

(The difference in starting point is unimportant - it comes from the 
resource code having tried different starting points and failed to find 
one that satisfies us).

I wonder why the heck the sizes don't match. It also looks like the BIOS 
had set the card originally at 0xd0000000, which isn't even inside the 
bridge window. That PCI bridge is:

	00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 03) (prog-if 00 [Normal decode])

which says "normal decode", but knowing intel bridges they probably say 
that, and then they are subtractive decode after all, so the damn thing 
probably _works_ even if it's outside the bridge window.

Your machine is a mess. Has graphics _ever_ worked for you under Linux on 
that thing (not counting VESA or other braindead modes that use the 
legacy VGA apertures)?

Very odd. The 256MB size would explain why we can't seem to allocate it. 
But why do we print out the size as being 128M? And why did the BIOS do 
that crazy initial setup?

George, what happens if you ask Linux to just re-allocate all BIOS PCI bus 
window information by passing in the kernel command line

	pci=assign-busses

(and perhaps also "pci=norom", but try with just the assign-busses thing 
first).

			Linus
