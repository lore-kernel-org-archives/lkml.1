Return-Path: <linux-kernel-owner+w=401wt.eu-S1765106AbZLQR2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765106AbZLQR2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765057AbZLQR2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:28:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765038AbZLQR2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:28:38 -0500
Date: Thu, 17 Dec 2009 09:27:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alain Knaff <alain@knaff.lu>
cc: markh@compro.net, fdutils@fdutils.linux.lu, linux-kernel@vger.kernel.org
Subject: Re: DMA cache consistency bug introduced in 2.6.28 (Was: Re: [Fdutils]
 Cannot format floppies under kernel 2.6.*?)
In-Reply-To: <4B2A6394.3080705@knaff.lu>
Message-ID: <alpine.LFD.2.00.0912170916420.15740@localhost.localdomain>
References: <4AFB3962.2020106@ntlworld.com> <4B26884C.8000306@knaff.lu> <4B2697C4.2040204@compro.net> <4B26A82E.5040902@knaff.lu> <4B26B031.4060301@compro.net> <4B26BAE3.2090408@knaff.lu> <4B275975.8040509@cfl.rr.com> <4B275B18.80704@knaff.lu>
 <4B275D37.4090807@cfl.rr.com> <4B2761E9.2030301@knaff.lu> <4B276513.6030509@cfl.rr.com> <4B276753.80807@knaff.lu> <4B27983F.5090600@compro.net> <4B27EF18.7050101@knaff.lu> <4B28FDEB.3030800@compro.net> <4B290029.90602@knaff.lu> <4B2901DB.8040403@compro.net>
 <4B29052B.9070406@knaff.lu> <4B292D84.5040306@compro.net> <4B29624F.2080109@knaff.lu> <4B2A3805.8040707@compro.net> <4B2A3E3E.8060405@knaff.lu> <4B2A4975.8020809@compro.net> <4B2A49F4.6070402@compro.net> <4B2A4B86.8060307@knaff.lu> <4B2A4C78.10107@compro.net>
 <4B2A4CF7.6040000@knaff.lu> <4B2A4EC9.2030902@compro.net> <4B2A4FA5.5000701@knaff.lu> <4B2A5192.6090602@compro.net> <4B2A530D.3080606@knaff! .lu> <4B2A6394.3080705@knaff.lu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, Alain Knaff wrote:
> 
> 1. initial contents:  33 44 55 66
> 2. one DMA transfer is performed
> 3. program changes buffer to: 77 88 99 aa
> 4. new DMA transfer is performed => instead it transmits 33 88 99 aa
>    (i.e. first byte is from previous contents)
> 
> This used to work in 2.6.27.41, but broke in 2.6.28 . It doesn't happen on
> all hardware though.

Do you have a list of hardware it works on? Especially chipsets.

On x86, where all caches are supposed to be totally coherent (except for 
I$ under very special circumstances), the above should never be able to 
happen. At least not unless there is really buggy hardware involved.

> It does indeed seem to be related to a DMA-side cache (rather than the
> processor's cache not being flushed to main memory), as doing lots of
> memory intensive work (kernel compilation) between 2 and 3 doesn't fix the
> problem.

I'm not entirely surprised. Actual CPU bugs are pretty rare in the x86 
world. But chipset bugs? Another thing entirely. There are buffers and 
caches there, and those are sometimes software-visible. The most obvious 
case of that is just the IOMMU's themselves, but from your description I 
don't think you actually change the DMA _mappings_ do you? Just the 
actual buffer (that was then mapped earlier)?

So I don't think it's the IOMMU code itself necessarily, although an IOMMU 
may well be involved (eg I could easily see a few cachelines worth of 
actual DMA data caching going on in the whole IOMMU too)

And to some degree the floppy driver might be _more_ likely to see some 
kinds of bugs, because it uses that crazy legacy DMA engine. So it's not 
going to go through the regular PCI DMA hardware paths, it's going to go 
through its own special paths that nobody else uses any more (and thus has 
probably not had as much testing).

> In the diff between 2.6.27.41 and 2.6.28, I noticed a lot of changes in
> arch/x86/kernel/amd_iommu.c and related files, could any of these have
> triggered this behavior?

Could it have triggered? Sure. Chipset caches are often flushed by certain 
trivial operations (often the caches are small, and operations like "any 
PIO access" will make sure they are flushed). Different IOMMU flush 
patterns could easily account for it.

But I think we'd like to see a list of hardware where this can be 
triggered, and quite frankly, a 'git bisect' would be absolutely wonderful 
especially if the list of hardware is not showing any really obvious 
patterns (and I assume they aren't all _that_ obvious, or you'd have 
mentioned them).

			Linus
