Return-Path: <linux-kernel-owner+w=401wt.eu-S1761673AbZE3Lnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761673AbZE3Lnq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbZE3Lnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:43:39 -0400
Received: from r00tworld.com ([212.85.137.21]:60041 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbZE3Lni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:43:38 -0400
From: pageexec@freemail.hu
To: "Larry H." <research@subreption.com>,
       Peter Zijlstra <peterz@infradead.org>
Date: Sat, 30 May 2009 13:42:32 +0200
MIME-Version: 1.0
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page allocator
Reply-to: pageexec@freemail.hu
CC: Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>
Message-ID: <4A211BA8.8585.17B52182@pageexec.freemail.hu>
In-reply-to: <1243679973.6645.131.camel@laptop>
References: <20090522073436.GA3612@elte.hu>, <20090530054856.GG29711@oblivion.subreption.com>, <1243679973.6645.131.camel@laptop>
X-mailer: Pegasus Mail for Windows (4.50 PB1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Sat, 30 May 2009 13:41:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 May 2009 at 12:39, Peter Zijlstra wrote:

> On Fri, 2009-05-29 at 22:48 -0700, Larry H. wrote:
> > On 07:32 Fri 29 May     , Arjan van de Ven wrote:
> > > On Thu, 28 May 2009 21:36:01 +0200
> > > Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > > ... and if we zero on free, we don't need to zero on allocate.
> > > > > While this is a little controversial, it does mean that at least
> > > > > part of the cost is just time-shifted, which means it'll not be TOO
> > > > > bad hopefully...
> > > > 
> > > > zero on allocate has the advantage of cache hotness, we're going to
> > > > use the memory, why else allocate it.
> > 
> > Because zero on allocate kills the very purpose of this patch and it has
> > obvious security implications. Like races (in information leak
> > scenarios, that is). What happens in-between the release of the page and
> > the new allocation that yields the same page? What happens if no further
> > allocations happen in a while (that can return the old page again)?
> > That's the idea.
> 
> I don't get it, these are in-kernel data leaks, you need to be able to
> run kernel code to exploit these, if someone can run kernel code, you've
> lost anyhow.
> 
> Why waste time on this?

e.g., when userland executes a syscall, it 'can run kernel code'. if that kernel
code (note: already exists, isn't provided by the attacker) gives unintended
kernel memory back to userland, there is a problem. that problem is addressed
in part by early sanitizing of freed data.

> > > So if you zero on free, the next allocation will reuse the zeroed page.
> > > And due to LIFO that is not too far out "often", which makes it likely
> > > the page is still in L2 cache.
> > 
> > Thanks for pointing this out clearly, Arjan.
> 
> Thing is, the time between allocation and use is typically orders of
> magnitude less than between free and use. 

so you are saying that in the sequence of events (free -> alloc -> use) the lifetime
of freed data is overwhelmingly dominated by the free -> alloc interval. this is
*exactly* what sanitization addresses.

also you sort of give away your misunderstanding the threat this patch addresses:
it's not about being 'typically' good, but in every possible case involving freed
data. to give you an idea why 'typically' isn't good enough: imagine you have a
firefox process consuming hundreds of MBs of memory (fact of life, whether fortunate
or not) that then crashes (or the user quits it, doesn't matter). all that data will
be freed on the crash. how long do think it takes for all those hundreds of MBs of
memory to be reused ? in the meantime all your passwords, cryptographic state, etc
are in RAM.

no need to guess actually, just read the paper Larry referenced in his first post:

 http://www.stanford.edu/~blp/papers/shredding.html

one of their experiments showed that around a MB (!) of data of an initial 64 MB
allocation survived for *days*.

> Really, get a life, go fix real bugs. Don't make our kernel slower for
> wanking rights.

ignoring the ad hominem and less than civilized response, the point is not to
slow down everyone. memory sanitization is an option and won't slow down anyone
not explicitly enabling it. if you believe you can actually measure a few extra
conditional jumps in real life workloads, go ahead and show us the numbers.

