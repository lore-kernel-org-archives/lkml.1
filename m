Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbYBJXCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbYBJXCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYBJXCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:02:09 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:39712 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYBJXCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:02:07 -0500
Date: Sun, 10 Feb 2008 16:02:04 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Tony Camuso <tcamuso@redhat.com>,
       Grant Grundler <grundler@parisc-linux.org>, Loic Prylli <loic@myri.com>,
       Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>
Subject: raw_pci_read in quirk_intel_irqbalance
Message-ID: <20080210230204.GH5299@parisc-linux.org>
References: <20080129030340.GE20198@parisc-linux.org> <86802c440802022330o771cf98btcf750c790668b6e9@mail.gmail.com> <47AB299D.4000500@redhat.com> <20080209124138.GA28967@parisc-linux.org> <86802c440802092225u5a901ab2i66b952382a999fa@mail.gmail.com> <20080210072116.GA12375@kroah.com> <20080210145122.GC5299@parisc-linux.org> <86802c440802101216t3b04c0b4y89a05ac9a04a0ac5@mail.gmail.com> <alpine.LFD.1.00.0802101222560.2896@woody.linux-foundation.org> <20080210204556.GG5299@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210204556.GG5299@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 01:45:57PM -0700, Matthew Wilcox wrote:
> I just looked at fixing that -- the reason seems to be that we don't
> actually have the struct pci_dev at that point.  I can fix it, but I
> think it's actually buggy.  I want to look at some chipset docs to
> confirm that though.

I don't think I fully understand what's going on here.  So here's what
I've been able to glean; hopefully someone who understands this better
can help out.

I happen to have an E7525-based machine, so here's an lspci of bus 0:

00:00.0 Host bridge: Intel Corporation E7525 Memory Controller Hub (rev 0a)
00:02.0 PCI bridge: Intel Corporation E7525/E7520/E7320 PCI Express Port A (rev 0a)
00:03.0 PCI bridge: Intel Corporation E7525/E7520/E7320 PCI Express Port A1 (rev 0a)
00:04.0 PCI bridge: Intel Corporation E7525/E7520 PCI Express Port B (rev 0a)
00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev 02)
00:1f.5 Multimedia audio controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) AC'97 Audio Controller (rev 02)

The line in question reads:

        /* read xTPR register */
        raw_pci_read(0, 0, 0x40, 0x4c, 2, &word);

That's domain 0, bus 0, device 8, function 0, address 0x4c, length 2.

I've checked the public E7525 and E7520 MCH datasheets, and they don't
document the xTPR registers; nor do any of the devices in the datasheet
have registers documented at 0x4c.

You can see from my lspci above that I don't _have_ a device 8 on bus 0.
The aforementioned documentation says:

"A disabled or non-existent device's configuration register space is
hidden. A disabled or non-existent device will return all ones for reads
and will drop writes just as if the cycle terminated with a Master Abort
on PCI."

Now, my E7525 isn't affected by this quirk as it has a revision greater
than 0x9.  So maybe it's expected that device 8 is hidden on my machine;
that it's only present on revisions up to 0x9.  But maybe device 8 is
always hidden, and that's why the author used raw_pci_ops?

We can still do better than this, though.  We can do:

-	raw_pci_read(0, 0, 0x40, 0x4c, 2, &word);
+	pci_bus_read_config_word(dev->bus, PCI_DEVFN(8, 0), 0x4c, &word);

Using PCI_DEVFN tells people you really did mean device 8, and it's not
a braino for device 4 or 2 (how many bits for slot and function again?)

I'll see if I can dig up the internal documentation for the xTPR register
when I'm at work on Monday.  But I've never gone looking for internal
documentation before, so I have no idea how easy it will be to find ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
