Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZJGV6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZJGV6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZJGV63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:58:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448AbZJGV62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:58:28 -0400
Date: Wed, 7 Oct 2009 14:57:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andi Kleen <andi@firstfloor.org>
cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
In-Reply-To: <alpine.LFD.2.01.0910071417300.3432@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910071450510.3432@localhost.localdomain>
References: <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain> <alpine.LFD.2.01.0910070911080.3432@localhost.localdomain>
 <20091007164622.GX30316@wotan.suse.de> <alpine.LFD.2.01.0910071222230.3432@localhost.localdomain> <87eipfymcv.fsf@basil.nowhere.org> <alpine.LFD.2.01.0910071349190.3432@localhost.localdomain> <20091007210651.GB1656@one.firstfloor.org>
 <alpine.LFD.2.01.0910071417300.3432@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Oct 2009, Linus Torvalds wrote:
>
> Every extra line you fetch pushes out another line. No amount of 
> prefetching will hide that.

Side note: what it _will_ do is hide the cost, and spread it out to other 
places where you don't see it any more, or you see it but can't do 
anything about it.

And that's not a good thing. You end up with "muddy" profiles that don't 
have nice clear problem spots any more, so you may think that your profile 
looks better ("Look ma, no nasty hotspots!"), but actual performance 
hasn't improved one whit, and may well have decreased.

This, btw, is exactly the kind of thing we saw with some of the 
non-temporal work, when we used nontemporal stores to copy pages on COW 
faults, or when doing pre-zeroing of pages. You get rid of some of the 
hot-spots in the kernel, and you then replace them with user space taking 
the cache misses in random spots instead. The kernel profile looks better, 
and system time may go down, but actual performace never went down - you 
just moved your cache miss cost from one place to another.

There's no question that prefetching cannot help, but it helps only if 
it's about fetching data that you would need anyway early. In contrast, if 
the option is "don't touch the other cacheline at all", prefetching is 
_always_ a loss. No ifs, buts and maybes about it.

			Linus
