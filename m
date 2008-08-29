Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbYH2Gak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbYH2Gak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 02:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYH2Gaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 02:30:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48713 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbYH2Ga3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 02:30:29 -0400
Date: Fri, 29 Aug 2008 08:30:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4
Message-ID: <20080829063012.GA19459@elte.hu>
References: <1219973391-9580-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219973391-9580-1-git-send-email-yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Linus said we should register some entries in e820 later,
> so could let BAR res register at first, or even pnp?
> 
> this one replace
> | commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
> | Author: Yinghai Lu <yhlu.kernel@gmail.com>
> | Date:   Mon Aug 25 00:56:08 2008 -0700
> |
> |    x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR, v3
> 
> v2: insert e820 reserve resources before pnp_system_init
> v3: fix merging problem in tip/x86/core
>     please drop the one in tip/x86/core use this one instead
> v4: address Linus's review about comments and condition in _late()
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/x86/core, thanks.

Let me outline the issue that i raised before:

> +               if (!res->parent && res->end)
> +                       insert_resource(&iomem_resource, res);

what if this insertion fails due to partial overlap? Right now we drop 
it silently - which might be fine for most systems, but have a look on 
the specific system that had the hpet regression, there we have these 
reserved e820 entries:

 BIOS-e820: 0000000077ff0000 - 0000000078000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)

which overlaps with the chipset PCI BAR (hpet) resource:

   pci 0000:00:14.0: BAR has HPET at fed00000-fed003ff

so due to this 1K conflict we take the full e820-reserved entry out and 
give the range 0xfec00000-0x100000000 as 'free'.

And that failure to register can cause problems. In this case that 
'reserved' e820 entry definitely has real meaning, both the local APIC 
and the IO-APIC is in that range:

   ACPI: Local APIC address 0xfee00000
   IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23

Which might still be OK for all memory resources we happen to enumerate 
- but we dont necessarily enumerate all of them when we have e.g. an UP 
kernel, and we will definitely not enumerate any 'hidden' state a system 
might have there. (SMM, etc.) If we then allocate a dynamic PCI resource 
into that range later on (thinking it's "free" but in reality it's 
claimed) we get a crash or worse.

So my worry, which i outlined before and which Peter agreed with, was 
that we should not mark areas 'free' that the BIOS thinks are 
'reserved'. According to the map above, the BIOS declared non-RAM 'free' 
range in the first 4GB is 0x78000000..0xe0000000 - 1664 MB, plenty of 
space.

The solution would be to insert such conflicting (even if partially 
overlapping)

Also, a small code structure comment:

> +		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20))
> +			insert_resource(&iomem_resource, res);

this still needs a comment that we deal with resources that start below 
1MB in a special way and insert them early.

Perhaps split it out into a e820_entry_trusted() function and use that 
as a condition in both the early and the late logic. [plus the check for 
->end in the late logic - that should be outside of the 'trust' 
definition]

So whenever we tweak the definition of 'trust', we only have to do it in 
a single place. Agreed?

	Ingo
