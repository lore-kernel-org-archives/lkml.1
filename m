Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYCJPw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYCJPw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYCJPwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:52:23 -0400
Received: from relay2.sgi.com ([192.48.171.30]:57529 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751145AbYCJPwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:52:16 -0400
Date: Mon, 10 Mar 2008 08:51:38 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>
Subject: Re: quicklists confuse meminfo
In-Reply-To: <87ejak12qx.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0803100840430.23575@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
 <20080309111456.GA21690@elte.hu> <alpine.LFD.1.00.0803091244420.3099@apollo.tec.linutronix.de>
 <20080309120124.GB1249@elte.hu> <87ejak12qx.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008, Andi Kleen wrote:

> iirc quicklists were just to avoid rezeroing pages which are known to
> be zero at free time (in theory __GFP_ZERO should handle that at 
> page_alloc.c level, but it doesn't) and to get a little private fast path 
> for the page allocator (might actually predate the current page_alloc
> fast paths)

Quicklists were introduced to increase performance of program termination 
and startup. The avoidance of zeroing is one effect. The other reason that
made this a good optimization is the bad page allocator performance 
in general vs a simple LIFO list.

The numbers that we saw on  x86_64 were around a 90% reduction in overhead 
with the quicklists.

The reason for the throttle is that termination and starting of large 
programs would have to zero large amounts of memory and go through the 
page allocator for all of this if the quicklists would be bounded to a 
fixed limit. Having a fraction of free memory allows preserving large 
amounts of page table pages for the next process that starts.

Right now quicklists do not make much sense because the x86_64 portion was 
removed. IMHO The usefulness for i386 pgd/pud caching is negligible. The 
code came initially from IA64 arch code (I think it was first on sparc64 
though). After it became available in the core it was used by various other arches. 

There have been a couple of people who wanted to continue work on 
quicklists (which made me focus on different things) but so far nothing 
has happened. Replacement of the i386 portion with alloc/free would be 
fairly straightforward I would think.

