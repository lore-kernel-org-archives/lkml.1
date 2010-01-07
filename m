Return-Path: <linux-kernel-owner+w=401wt.eu-S1753010Ab0AGWeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab0AGWeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 17:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456Ab0AGWeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 17:34:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259Ab0AGWeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 17:34:24 -0500
Date: Thu, 7 Jan 2010 14:33:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <1262900683.4049.139.camel@laptop>
Message-ID: <alpine.LFD.2.00.1001071426590.7821@localhost.localdomain>
References: <20100104182429.833180340@chello.nl>  <20100104182813.753545361@chello.nl>  <20100105054536.44bf8002@infradead.org>  <alpine.DEB.2.00.1001050916300.1074@router.home>  <20100105192243.1d6b2213@infradead.org>  <alpine.DEB.2.00.1001071007210.901@router.home>
  <alpine.LFD.2.00.1001070814080.7821@localhost.localdomain>  <1262884960.4049.106.camel@laptop>  <alpine.LFD.2.00.1001070934060.7821@localhost.localdomain>  <alpine.LFD.2.00.1001070937180.7821@localhost.localdomain>  <alpine.LFD.2.00.1001071031440.7821@localhost.localdomain>
 <1262900683.4049.139.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jan 2010, Peter Zijlstra wrote:
>
> I haven't yet looked at the patch, but isn't expand_stack() kinda like
> what you want? That serializes using anon_vma_lock().

Yeah, that sounds like the right thing to do.  It is the same operation, 
after all (and has the same effects, especially for the special case of 
upwards-growing stacks).

So basically the idea is to extend that stack expansion to brk(), and 
possibly mmap() in general.

Doing the same for munmap() (or shrinking thigns in general, which you can 
do with brk but not with the stack) is quite a bit harder. As can be seen 
by the fact that all the problems with the speculative approach are in the 
unmap cases.

But the good news is that shrinking mappings is _much_ less common than 
growing them. Many memory allocators never shrink at all, or shrink only 
when they hit certain big chunks. In a lot of cases, the only time you 
shrink a mapping ends up being at the final exit, which doesn't have any 
locking issues anyway, since even if we take the mmap_sem lock for 
writing, there aren't going to be any readers possibly left.

And a lot of growing mmaps end up just extending an old one. No, not 
always, but I suspect that if we really put some effort into it, we could 
probably make the write-lock frequency go down by something like an order 
of magnitude on many loads.

Not all loads, no. Some loads will do a lot of file mmap's, or use 
MAP_FIXED and/or mprotect to split vma's on purpose. But that is certainly 
not likely to be the common case.

			Linus
