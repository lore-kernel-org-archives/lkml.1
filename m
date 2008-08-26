Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbYHZTUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbYHZTUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbYHZTUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:20:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753844AbYHZTUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:20:00 -0400
Date: Tue, 26 Aug 2008 12:18:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jamie Lokier <jamie@shareable.org>
cc: Adrian Bunk <bunk@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <20080826190213.GA30255@shareable.org>
Message-ID: <alpine.LFD.1.10.0808261212530.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <200808261111.19205.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
 <20080826183051.GB10925@cs181140183.pp.htv.fi> <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org> <20080826190213.GA30255@shareable.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Jamie Lokier wrote:
> 
> A function which is only called from one place should, if everything
> made sense, _never_ use more stack through being inlined.

But that's simply not true.

See the whole discussion.

The problem is that if you inline that function, the stack usage of the 
newly inlined function is now added to ALL THE OTHER paths too!

So the case we had in module loading was that yes, we had a function with 
a big stack footprint, but it was NOT in the deep path.

But by inlining it, it now moved the stack footprint "up" one level to 
another function, and now the big stack footprint really _was_ in the deep 
path, because the caller was involved in a much deeper chain. 

So inlining moves the code up the callchain, and that is a problem for the 
backtrace, but that's "just" a debugging issue. But it also moves the 
stack footprint up the callchain, and that can actually be a correctness 
issue.

Of course, a compiler doesn't _have_ to do that. A compiler _could_ have 
multiple different stack footprints for a single function, and do liveness 
analysis etc. But no sane compiler probably does that, because it's very 
painful indeed, and it's not even an issue if you aren't stack-limited 
(and being stack-limited is really just a kernel thing).

(Yeah, it can be an issue even if you have a big stack, in that you get 
worse cache behaviour, so a dense stack footprint _would_ help. But the 
complexity of stack liveness analysis is almost certainly not worth the 
relatively small gains it would get on some odd cases).

			Linus
