Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbZIZPRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbZIZPRi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 11:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZIZPRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 11:17:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56574 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZIZPRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 11:17:37 -0400
Date: Sat, 26 Sep 2009 17:17:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
       fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [origin tree build failure] Re: [PULL] Please pull hwpoison code for 2.6.32
Message-ID: <20090926151740.GN30185@one.firstfloor.org>
References: <20090916125116.GA12751@basil.fritz.box> <20090926141352.GA26117@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926141352.GA26117@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 04:13:53PM +0200, Ingo Molnar wrote:
> 
> >       HWPOISON: Add page flag for poisoned pages
> 
> -tip testing found that this change broke 32-bit NUMA builds:
> 
>   In file included from include/linux/suspend.h:8,
>                  from arch/x86/kernel/asm-offsets_32.c:11,
>                  from arch/x86/kernel/asm-offsets.c:2:
>   include/linux/mm.h:503:2: error: #error SECTIONS_WIDTH+NODES_WIDTH+ZONES_WIDTH > BITS_PER_LONG - NR_PAGEFLAGS
> 
> 32-bit NUMA works fine and it was quite useful in finding various bugs 
> in the past so we dont want to kill it - would be nice to fix this 
> regression instead. (and preferably not by hacking around this corner of 
> the Kconfig space)

Thanks for the report. The issue comes from NODES_SHIFT=4

I think I tested the NUMA case, but perhaps not with full NODES_SHIFT.

The easy fix would be to limit NODES_SHIFT to 3 for 32bit (8 nodes max). Do you
have any problems with that? I doubt there are any >8 nodes NUMAQs left.
(last time I heard the last machine at IBM was down to < 4)

Another way would be to add a new hash table to move the nodes
out of the page flags in this case, but that would have more overhead and be
more complicated.

> btw., this bit in mm/Kconfig:
> 
>  config MEMORY_FAILURE
>         depends on MMU
>         depends on X86_MCE
>         bool "Enable recovery from hardware memory errors"
> 
> caught my attention. Why is a generic MM facility dependent on an x86 
> specific config option?

x86 mce is the only code that calls it currently (minus the injector)

It builds on other architectures without trouble and doesn't
depend on anything x86 specific, but just without a caller it's not very 
useful, so i made it dependent. I expect other callers in the not too far
future.

At some point could probably switch over to ARCH_SUPPORTS_MCE_RECOVERY
or so, but it seemed overkill for the first step.

-Andi

