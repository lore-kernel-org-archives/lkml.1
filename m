Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZDUPlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZDUPlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbZDUPlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:41:13 -0400
Received: from outbound-mail-126.bluehost.com ([67.222.38.26]:33957 "HELO
	outbound-mail-126.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750966AbZDUPlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:41:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pX20M5eZiZuQqhHa7cW3T5LyHA97xSKL17gNiKptYTD3ghs4rPmC5iqlMZqxZccurGgYVLX5eWKO8XZt416EBb7SDJQyHvad2ePQEV2GnpQXhAG6iKJRA+Cei5V5U1po;
Date: Tue, 21 Apr 2009 08:41:04 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
Message-ID: <20090421084104.3dfedfee@hobbes>
In-Reply-To: <20090420223305.GA15340@jurassic.park.msu.ru>
References: <20090416172803.GB16618@elte.hu>
	<49E7916C.7050701@kernel.org>
	<alpine.LFD.2.00.0904161540590.4042@localhost.localdomain>
	<49E99054.6050208@kernel.org>
	<alpine.LFD.2.00.0904181142530.4042@localhost.localdomain>
	<49EA57C4.1000603@kernel.org>
	<alpine.LFD.2.00.0904181602030.2199@localhost.localdomain>
	<alpine.LFD.2.00.0904182149240.2199@localhost.localdomain>
	<20090419090208.GA30211@elte.hu>
	<20090419090615.GA30631@elte.hu>
	<20090420223305.GA15340@jurassic.park.msu.ru>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009 02:33:05 +0400
Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:
> x86 pci: first cut on 64-bit resource allocation
> 
> I believe that we should consider PCI memory above 4G as yet another
> type of address space. This actually makes sense, as even accesses to
> that memory are physically different - Dual Address Cycle (DAC) vs.
> 32-bit Single Address Cycle (SAC).
> 
> So, platform that can deal with 64-bit allocations would set up an
> additional root bus resource and mark it with IORESOURCE_MEM64 flag.
> 
> The main problem here is how the kernel would detect that hardware can
> actually access a DAC memory (I know for a fact that a lot of Intel
> chipsets cannot access MMIO >4G, even though subordinate p2p bridges
> are 64-bit capable).
> On the other hand, there are PCI devices with 64-bit BARs that do not
> work properly being placed above 4G boundary. For example, some
> radeon cards have 64-bit BAR for video RAM, but allocating that BAR in
> the DAC area doesn't work for various reasons, like video-BIOS
> limitations or drivers not taking into account that GPU is 32-bit.
> 
> So moving stuff into MEM64 area should be considered as generally
> unsafe operation, and the best default policy is to not enable MEM64
> resource unless we find that BIOS has allocated something there.
> At the same time, MEM64 can be easily enabled/disabled based on host
> bridge PCI IDs, kernel command line options and so on.

This sounds like reasonable default behavior given the variety of
chipsets and device quirks out there.  This does muddy up the arch vs.
generic code just a little bit more though; iirc mips & ia64 use full
64 bit ranges for their current IORESOURCE_MEM types (hm now that I've
checked it appears ia64 has changed a bit here, but still other
arches should probably get cleaned up to use the new 64 bit type at
some point).

> Here is a basic implementation of the above for x86. I think it's
> reasonably good starting point for PCI64 work - the next step would
> be to teach pci_bus_alloc_resource() about IORESOURCE_MEM64: logic is
> similar to prefetch vs non-prefetch case - MEM can hold MEM64
> resource, but not vice versa. And eventually bridge sizing code will
> be updated for reasonable 64-bit allocations (it's a non-trivial
> task, though).
> 
> This patch alone should fix cardbus >4G allocations and similar
> nonsense.
> 
> Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Nice.  Any cleanups to existing arch code could be done at the same
time as the updates to the bus allocation.

Anyone care to send me some tested-by lines?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
