Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbZDRS7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbZDRS7P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 14:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760646AbZDRS5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 14:57:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759587AbZDRS5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 14:57:41 -0400
Date: Sat, 18 Apr 2009 11:50:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
In-Reply-To: <49E99054.6050208@kernel.org>
Message-ID: <alpine.LFD.2.00.0904181142530.4042@localhost.localdomain>
References: <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes>
 <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain>
 <49E99054.6050208@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Apr 2009, Yinghai Lu wrote:
> 
> except need to change 
> > +		reserve_region_with_split(&iomem_resource, start, end, "RAM buffer");
> ==> > +		reserve_region_with_split(&iomem_resource, start, end - 1, "RAM buffer");

Yes, I sent out a later email pointing that out.

> it will make sure dynmical allocating code will not use those range.
> 
> and could make e820_setup_gap much simple.

ACK. In fact:

> Index: linux-2.6/arch/x86/kernel/e820.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/e820.c
> +++ linux-2.6/arch/x86/kernel/e820.c
> @@ -635,14 +635,12 @@ __init void e820_setup_gap(void)
>  #endif
>  
>  	/*
> -	 * See how much we want to round up: start off with
> -	 * rounding to the next 1MB area.
> +	 * e820_reserve_resources_late will protect stolen RAM
> +	 * so just round it to 1M
>  	 */
>  	round = 0x100000;
> -	while ((gapsize >> 4) > round)
> -		round += round;
> -	/* Fun with two's complement */
> -	pci_mem_start = (gapstart + round) & -round;
> +
> +	pci_mem_start = roundup(gapstart, round);

You can just remove "round" entirely. It's no longer a variable, it's just 
an odd way of saying 1M ;)

> Ingo, can you put those two patches in tip?

I would suggest that we first change "reserve_region_with_split()" to not 
recurse into the region.

That function isn't used by anything else (we ended up using 
"expand_to_fit()" instead in the one place that migth have used it), and 
now th eone caller we do have would not want the recursion - if there 
already exists a resource at the top level, we want to just avoid it.

This - again TOTALLY UNTESTED - patch removes the "recurse into conflicts" 
code. Comments? Testing?

			Linus
---
 kernel/resource.c |   46 ++++++++++++----------------------------------
 1 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index fd5d7d5..ac5f3a3 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -533,43 +533,21 @@ static void __init __reserve_region_with_split(struct resource *root,
 	res->end = end;
 	res->flags = IORESOURCE_BUSY;
 
-	for (;;) {
-		conflict = __request_resource(parent, res);
-		if (!conflict)
-			break;
-		if (conflict != parent) {
-			parent = conflict;
-			if (!(conflict->flags & IORESOURCE_BUSY))
-				continue;
-		}
-
-		/* Uhhuh, that didn't work out.. */
-		kfree(res);
-		res = NULL;
-		break;
-	}
-
-	if (!res) {
-		/* failed, split and try again */
-
-		/* conflict covered whole area */
-		if (conflict->start <= start && conflict->end >= end)
-			return;
+	conflict = __request_resource(parent, res);
+	if (!conflict)
+		return;
 
-		if (conflict->start > start)
-			__reserve_region_with_split(root, start, conflict->start-1, name);
-		if (!(conflict->flags & IORESOURCE_BUSY)) {
-			resource_size_t common_start, common_end;
+	/* failed, split and try again */
+	kfree(res);
 
-			common_start = max(conflict->start, start);
-			common_end = min(conflict->end, end);
-			if (common_start < common_end)
-				__reserve_region_with_split(root, common_start, common_end, name);
-		}
-		if (conflict->end < end)
-			__reserve_region_with_split(root, conflict->end+1, end, name);
-	}
+	/* conflict covered whole area */
+	if (conflict->start <= start && conflict->end >= end)
+		return;
 
+	if (conflict->start > start)
+		__reserve_region_with_split(root, start, conflict->start-1, name);
+	if (conflict->end < end)
+		__reserve_region_with_split(root, conflict->end+1, end, name);
 }
 
 void __init reserve_region_with_split(struct resource *root,
