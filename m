Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbZDQAbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbZDQAbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758897AbZDQAbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:31:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757616AbZDQAbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:31:34 -0400
Date: Thu, 16 Apr 2009 17:24:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
In-Reply-To: <20090416235452.GE21405@elte.hu>
Message-ID: <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain>
References: <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain> <49E52A7A.4070607@kernel.org> <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu>
 <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <20090416235452.GE21405@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Apr 2009, Ingo Molnar wrote:
> 
> Could we perhaps round up to 1MB in this case too?

(The below 1MB one). 

I'd argue against it, at least in this incarnation. I can well imagine 
somebody wanting to do resource management in the 640k-1M window, so..

> Would it make sense to round up everything that is listed in the 
> E820 map? Just in case the BIOS is not entirely honest about the 
> true extent of that area.

Well, it would probably work, but on the other hand, when we see 
"E820_RAM", that means that we really _can_ trust that that E820 entry is 
right, since we're going to use it as RAM (and Windows would too), and if 
it wasn't RAM, really bad things would happen.

So E820_RAM is a _lot_ more trustworthy than the other cases. If we're 
rounding up by reasonably large amounts like 32MB or even more, I really 
think we should do so for the things we really know are there, and that we 
really fundamentally know come in big granularities.

The other entries in the e820 map can reasonably be 4kB or something, 
because they are an IO-APIC or whatever. I can't say that I'd feel happy 
putting a guard area around something like that. But RAM? Sure, it can 
come in 384kB chunks (think RAM remapping for the low 1MB area), but it 
doesn't tend to happen when we're talking gigs any more.

> > +		start = entry->addr + entry->size;
> > +		end = round_up(start, ram_alignment(start));
> > +		if (start == end)
> > +			continue;
> 
> Hm, indeed, the continue is needed - reserve_region_with_split() 
> lets zero-sized resources be inserted silently. I'd have missed this 
> case. Do zero-sized memory resources have a special role somewhere?

No. But it wouldn't be a zero-size region, it would be a one-byte sized 
region. It's just that my patch was missing the "-1" from the end that I 
meant to put there:

> > +		reserve_region_with_split(&iomem_resource, start, end, "RAM buffer");

That 'end' there should be 'end-1', and that also explains why "start == 
end" must have a continue.

The 'end' in a resource region is the last byte, not the 'byte after'. 

So there was a small buglet in the patch, but as I mentioned, using 
"reserve_region_with_split()" is really wrong anyway, because we do not 
want to recurse into existing regions, just split _around_ them. So the 
patch was meant as 

			Linus
