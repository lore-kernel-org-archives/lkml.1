Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbZDNVRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbZDNVRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbZDNVRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:17:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989AbZDNVRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:17:08 -0400
Date: Tue, 14 Apr 2009 14:10:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only
In-Reply-To: <49E4F71F.10107@kernel.org>
Message-ID: <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain>
References: <bug-11103-13546@http.bugzilla.kernel.org/> <200904101913.n3AJDhMm018684@demeter.kernel.org> <49DFABCC.3070001@kernel.org> <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Apr 2009, Yinghai Lu wrote:
> 
> Impact: make more big space below 4g for assigning to unassigned pci devices
> 
> don't need to reserved one round after the gapstart.
> 
> Reported-and-tested-by: Yannick <yannick.roehlly@free.fr>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index ef2c356..a0ba9b1 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -642,7 +642,7 @@ __init void e820_setup_gap(void)
>  	while ((gapsize >> 4) > round)
>  		round += round;
>  	/* Fun with two's complement */
> -	pci_mem_start = (gapstart + round) & -round;
> +	pci_mem_start = roundup(gapstart, round);

That thing is called "e820_setup_gap()" for a reason. It's supposed to 
create a _gap_. That's why it historically doesn't just round up (no 
"+round-1" as in round_up()), it rounds up to the _next_ boundary 
("+round") in order to guarantee a gap.

The reason? We've definitely seen ACPI code or integrated graphics stuff 
that steals a lot of memory at the end, which means that end-of-RAM might 
be not at 2GB, but at 2GB-16MB-1MB, for example (1MB of "ACPI data", and 
16MB of "stolen video ram").

Now, the BIOS _hopefully_ marks those areas clearly reserved, and as a 
result we don't end up allocating PCI data in there, but the gap was there 
literally to make sure we always leave that gap, very much on purpose.

So I'm very nervous about this. 

At a minimum, if we do this, I'd like to make sure we round up to a big 
boundary (eg 32MB or something - exactly because a missing 16MB can easily 
be some integrated stolen video memory).

Sure, we do that whole

        while ((gapsize >> 4) > round)
                round += round;

thing, so that if the gap is large, then we'll certainly get to 32MB too, 
but I think your patch matters the most exactly when the gap is small. 
Maybe we could just raise the initial minimum rounding from 1MB to 32MB?

Alternatively, maybe we can make sure that we round up to at least X bytes 
from the end of RAM, and to at least Y bytes from the end of some RESERVED 
thing.

I dunno. Maybe your patch is fine as-is. But I do get nervous.

		Linus
