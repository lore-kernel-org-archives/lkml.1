Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbYIDIC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbYIDIC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYIDICW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:02:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621AbYIDICT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:02:19 -0400
Date: Thu, 4 Sep 2008 01:02:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: linux-next: Tree for September 3
In-Reply-To: <20080903223318.84b6ce8b.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809040045190.3378@nehalem.linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au> <20080903214634.ea17ff53.akpm@linux-foundation.org> <alpine.LFD.1.10.0809032201510.3378@nehalem.linux-foundation.org> <20080903223318.84b6ce8b.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Sep 2008, Andrew Morton wrote:

> On Wed, 3 Sep 2008 22:21:54 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > Can you apply this patch, just to see if it fixes things.
> 
> Below..
> 
> > And do you know when this started happening? It shouldn't have been all 
> > that recent. Maybe you haven't tried your Vaio in a while?
> 
> Yes, the Vaio had a vacation in New York.  Last kernel it booted was
> 2.6.26-rc8-mm1.
> 
> --- x	2008-09-03 21:38:24.000000000 -0700
> +++ y	2008-09-03 22:29:04.000000000 -0700
> ...
> @@ -503,15 +503,15 @@
>  calling  init_acpi_pm_clocksource+0x0/0x14a
>  initcall init_acpi_pm_clocksource+0x0/0x14a returned 0 after 32 msecs
>  calling  pcibios_assign_resources+0x0/0x70
> -pci 0000:06:05.0: BAR 9 too large: 0x00000000000000-0x00000003ffffff

Ok, it fixed that particular thing, and now the mem windows look fine:

>  pci 0000:06:05.0: CardBus bridge, secondary bus 0000:07
>  pci 0000:06:05.0:   IO window: 0x002400-0x0024ff
>  pci 0000:06:05.0:   IO window: 0x002800-0x0028ff
> -pci 0000:06:05.0:   MEM window: 0x54000000-0x57ffffff
> +pci 0000:06:05.0:   PREFETCH window: 0x50000000-0x53ffffff
> +pci 0000:06:05.0:   MEM window: 0x58000000-0x5bffffff

so it fixed _one_ issue.

This also then changes the parent bus bridge:

>  pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
>  pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
>  pci 0000:00:1e.0:   MEM window: 0xb0100000-0xb01fffff
> -pci 0000:00:1e.0:   PREFETCH window: disabled
> +pci 0000:00:1e.0:   PREFETCH window: 0x00000050000000-0x00000053ffffff

ie it has now allocated a prefetch window in the parent PCI bridge too 
in order to fit that cardbus bridge in.

So this all looks ok. I'd be happier if you also actually had some actual 
_device_ in the Cardbus slot and reported that that works, but the patch 
clearly 

 - fixes a very bogus alignment calculation

 - actually fixes a Cardbus setup issue for you.

so I'll commit it.

> also...
> 
>  calling  yenta_socket_init+0x0/0x16
>  yenta_cardbus 0000:06:05.0: CardBus bridge found [104d:818f]
> -yenta_cardbus 0000:06:05.0: CardBus bridge, secondary bus 0000:07
> -yenta_cardbus 0000:06:05.0:   IO window: 0x002400-0x0024ff
> -yenta_cardbus 0000:06:05.0:   IO window: 0x002800-0x0028ff
> -yenta_cardbus 0000:06:05.0:   PREFETCH window: 0x50400000-0x507fffff
> -yenta_cardbus 0000:06:05.0:   MEM window: 0x54000000-0x57ffffff

these went away, because yenta_allocate_resources() will not try to 
reprogram the controller if it's already been fully set up. So because 
yenta_alloc_resources() is happy with the resource setup and leaves it 
alone, there's no more noise about it.

So I would say that the PCI resource issue is fixed.

[ Side note: I actually suspect that your cardbus slot actually worked 
  fine _despite_ the problems, because

 (a) the whole yenta_allocate_resources() -> pci_setup_cardbus() sequence 
     did end up setting things up correctly int he end, even if the 
     prefetchable memory resource ended up being in a non-prefetchable 
     area

 (b) Very few cardbus cards would have any prefetchable resources, much 
     less care about the theoretical performance difference even if they 
     did.

 but that allocation issue was still a bug ]

And you seem to have found your non-console problem separately.

			Linus
