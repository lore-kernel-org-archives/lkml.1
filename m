Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbZDQNRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbZDQNRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759167AbZDQNRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:17:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44378 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758355AbZDQNRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:17:40 -0400
Date: Fri, 17 Apr 2009 15:16:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
Message-ID: <20090417131633.GA30578@elte.hu>
References: <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <20090416235452.GE21405@elte.hu> <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 17 Apr 2009, Ingo Molnar wrote:
> > 
> > Could we perhaps round up to 1MB in this case too?
> 
> (The below 1MB one).
> 
> I'd argue against it, at least in this incarnation. I can well 
> imagine somebody wanting to do resource management in the 640k-1M 
> window, so..

ok - indeed - if there's some super-small system with limited 
address lines and all physical addresses tightly packed with RAM?

> > Would it make sense to round up everything that is listed in the 
> > E820 map? Just in case the BIOS is not entirely honest about the 
> > true extent of that area.
> 
> Well, it would probably work, but on the other hand, when we see 
> "E820_RAM", that means that we really _can_ trust that that E820 
> entry is right, since we're going to use it as RAM (and Windows 
> would too), and if it wasn't RAM, really bad things would happen.
> 
> So E820_RAM is a _lot_ more trustworthy than the other cases. If 
> we're rounding up by reasonably large amounts like 32MB or even 
> more, I really think we should do so for the things we really know 
> are there, and that we really fundamentally know come in big 
> granularities.
> 
> The other entries in the e820 map can reasonably be 4kB or 
> something, because they are an IO-APIC or whatever. I can't say 
> that I'd feel happy putting a guard area around something like 
> that. But RAM? Sure, it can come in 384kB chunks (think RAM 
> remapping for the low 1MB area), but it doesn't tend to happen 
> when we're talking gigs any more.

One of my systems is a bit weird, with such a checkered RAM map:

BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)       0.639 MB RAM
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)     0.001 MB
                                                [ hole ]       0.250 MB
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)     0.125 MB
 BIOS-e820: 0000000000100000 - 000000003ed94000 (usable)    1004.5   MB RAM
 BIOS-e820: 000000003ed94000 - 000000003ee4e000 (ACPI NVS)     0.7   MB
 BIOS-e820: 000000003ee4e000 - 000000003fea2000 (usable)      16.3   MB RAM
 BIOS-e820: 000000003fea2000 - 000000003fee9000 (ACPI NVS)     0.3   MB
 BIOS-e820: 000000003fee9000 - 000000003feed000 (usable)       0.15  MB RAM
 BIOS-e820: 000000003feed000 - 000000003feff000 (ACPI data     0.07  MB
 BIOS-e820: 000000003feff000 - 000000003ff00000 (usable)       0.004 MB RAM
                                                [ hole ]       1.0   MB
                                                [ hole ]    3072.0   MB

On this map, using your scheme, we'd fill up that small 1MB hole up 
to 1GB [mockup]:

 BIOS-e820: 000000003ff00000 - 0000000040000000 (RAM buffer)

I guess that's a good thing not just for robustness: a chipset might 
be faster when DMA or mmio is on some well-isolated physical memory 
range, not too close to real RAM or other devices?

Bits of the low hole:

 00000000-0009fbff : System RAM
 0009fc00-0009ffff : reserved
 000c0000-000dffff : pnp 00:01
 000e0000-000fffff : reserved
 00100000-3ed93fff : System RAM

would still be available to dynamic PCI resources - as the 64K 
rounding would leave it alone.

	Ingo
