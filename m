Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZHYTB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZHYTB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbZHYTB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:01:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:53634 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616AbZHYTB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:01:56 -0400
Message-ID: <4A9434DA.1010603@kernel.org>
Date: Tue, 25 Aug 2009 12:00:42 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: bugzilla-daemon@bugzilla.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ricardo Jorge da Fonseca Marques Ferreira 
	<storm@sys49152.net>,
       cebbert@redhat.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 13940] iwlagn and sky2 stopped working, ACPI-related
References: <bug-13940-13546@http.bugzilla.kernel.org/> <200908251555.n7PFt7Wt015763@demeter.kernel.org> <4A9425E4.40108@kernel.org> <alpine.LFD.2.01.0908251127460.3218@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908251127460.3218@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 25 Aug 2009, Yinghai Lu wrote:
>> please try to attached patch, that will increae alignment from 32M to 64M.
> 
> Hmm. That may indeed fix the problem, because we have:
> 
>  - working-2.6.30.log:
> 
> 	Allocating PCI resources starting at b8000000 (gap: b6000000:4a000000)
> 
>  - not-working-2.6.31.log:
> 
> 	Allocating PCI resources starting at b6000000 (gap: b6000000:4a000000)
> 
> HOWEVER. We also have:
> 
>  - working-2.6.31_acpi=off.log:
> 
> 	Allocating PCI resources starting at b6000000 (gap: b6000000:4a000000)
> 
> ie it really does seem to be ACPI-related somehow: starting PCI 
> allocations at that b6000000 address works perfectly fine if ACPI is not 
> enabled.
> 
> In the not-working version, we end up getting:
> 
> [    1.408588] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:07
> [    1.408593] pci 0000:00:1c.4:   IO window: 0x2000-0x2fff
> [    1.408600] pci 0000:00:1c.4:   MEM window: 0xb6000000-0xb60fffff
> [    1.408606] pci 0000:00:1c.4:   PREFETCH window: disabled
> [    1.408623] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:08
> [    1.408626] pci 0000:00:1c.5:   IO window: disabled
> [    1.408633] pci 0000:00:1c.5:   MEM window: 0xb6100000-0xb61fffff
> [    1.408639] pci 0000:00:1c.5:   PREFETCH window: disabled
> 
> 
> while in the working version we have:
> 
>  - ACPI off - looks like a BIOS allocated memory window:
> 
> 	[    0.290854] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:07
> 	[    0.290854] pci 0000:00:1c.4:   IO window: 0x3000-0x3fff
> 	[    0.290854] pci 0000:00:1c.4:   MEM window: 0xf4500000-0xf45fffff
> 	[    0.290854] pci 0000:00:1c.4:   PREFETCH window: disabled
> 	[    0.290854] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:08
> 	[    0.290854] pci 0000:00:1c.5:   IO window: disabled
> 	[    0.290854] pci 0000:00:1c.5:   MEM window: 0xf4600000-0xf46fffff
> 	[    0.290854] pci 0000:00:1c.5:   PREFETCH window: disabled

interesting, when acpi=off, BIOS does allocate resource for them

[    0.261960] pci 0000:07:00.0: reg 10 64bit mmio: [0xf4500000-0xf4503fff]
[    0.261970] pci 0000:07:00.0: reg 18 io port: [0x3000-0x30ff]
[    0.262049] pci 0000:07:00.0: supports D1 D2
[    0.262051] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.262058] pci 0000:07:00.0: PME# disabled
[    0.272117] pci 0000:00:1c.4: bridge io port: [0x3000-0x3fff]
[    0.272122] pci 0000:00:1c.4: bridge 32bit mmio: [0xf4500000-0xf45fffff]
[    0.272212] pci 0000:08:00.0: reg 10 64bit mmio: [0xf4600000-0xf4601fff]
[    0.272321] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.272330] pci 0000:08:00.0: PME# disabled
[    0.280128] pci 0000:00:1c.5: bridge 32bit mmio: [0xf4600000-0xf46fffff]


> 
>  - ACPI on - we allocated the memory window, but at 0xb8000000+, rather 
>    than directly after end-of-RAM:
> 
> 	[    0.842970] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:07
> 	[    0.842975] pci 0000:00:1c.4:   IO window: 0x2000-0x2fff
> 	[    0.842983] pci 0000:00:1c.4:   MEM window: 0xb8000000-0xb80fffff
> 	[    0.842989] pci 0000:00:1c.4:   PREFETCH window: disabled
> 	[    0.843012] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:08
> 	[    0.843016] pci 0000:00:1c.5:   IO window: disabled
> 	[    0.843023] pci 0000:00:1c.5:   MEM window: 0xb8100000-0xb81fffff
> 	[    0.843029] pci 0000:00:1c.5:   PREFETCH window: disabled
> 
> ie for some reason ACPI caused that bus to be re-allocated, and 
> re-allocating it right after the memory window doesn't work.
> 
> Crazy.
> 
> I wonder what is hiding at that 0xb6000000 address. And while I think that 
> in this case rounding up to 64MB will fix it, I worry that our old model 
> (of never starting directly after RAM, even if it was aligned) may not 
> have been safer.
> 

acpi does clear sth.

YH
