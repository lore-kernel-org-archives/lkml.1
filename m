Return-Path: <linux-kernel-owner+w=401wt.eu-S1751341AbXCHDU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbXCHDU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 22:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbXCHDU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 22:20:58 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45900 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbXCHDU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 22:20:58 -0500
Date: Wed, 7 Mar 2007 19:20:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
cc: Anton Blanchard <anton@samba.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
In-Reply-To: <f2b55d220703071725w7c09b93bgbf357aeb25a21c2b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703071911330.10832@woody.linux-foundation.org>
References: <45ED1A3C.6030707@argo.co.il>  <200703071906.58405.dada1@cosmosbay.com>
  <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org> 
 <200703071952.13219.dada1@cosmosbay.com>  <20070307221401.GA16938@kryten> 
 <Pine.LNX.4.64.0703071453080.5963@woody.linux-foundation.org>
 <f2b55d220703071725w7c09b93bgbf357aeb25a21c2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Michael K. Edwards wrote:
> 
> People's prejudices against prefetch instructions are sometimes
> traceable to the 3DNow! prefetch(w) botch, which some processors
> "support" as no-ops and others are too aggressive about (Opteron
> prefetches are reputed to be "strong", i. e., not dropped on DTLB
> miss).

No, I just checked, and Intel's own optimization manual makes it clear 
that you should be careful. They talk about performance penalties due to 
resource constraints - which makes tons of sense with a core that is good 
at handling its own resources and could quite possibly use those resources 
better to actually execute the loads and stores deeper down the 
instruction pipeline.

So it's not just 3DNow! making AMD look bad, or Intel would obviously 
suggest people use it out of the wazoo ;)

> XScale gets it right.

Blah. XScale isn't even an OoO CPU, *of*course* it needs prefetching. 
Calling that "getting it right" is ludicrous. If anything, it gets things 
so wrong that prefetching is *required* for good performance.

I'm talking about real CPU's with real memory pipelines that already do 
prefetching in hardware. The better the core is, the less the prefetch 
helps (and often the more it hurts in comparison to how much it helps).

But if you mean "doesn't try to fill the TLB on data prefetches", then 
yes, that's generally the right thing to do.

> (Oddly, Prescott seems to have initiated a page table walk on DTLB miss 
> during software prefetch -- just one of many weird Prescott flaws.)  

Netburst in general is *very* happy to do speculative TLB fills, I think.

> I'm guessing Pentium M and its descendants (Core Solo and Duo) get it 
> right but I'm having a hell of a time finding out for sure.  Can any of 
> the x86 experts answer this?

I just suspect that the upside for Core 2 Due is likely fairly low. The L2 
cache is good, the memory re-ordering is working.. I doubt "prefetch" 
helps in generic code that much for things like linked list following, you 
should probably limit it to code that has *known* access patterns and you 
know it's not going to be in the cache.

(In other words, I bet prefetching can help a lot with MMX/media kind of 
code, I doubt it's a huge win for "for_each_entry()")

		Linus
