Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbXKBXBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbXKBXBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 19:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbXKBXBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 19:01:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:58793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbXKBXBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 19:01:43 -0400
Date: Sat, 3 Nov 2007 00:01:42 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
Message-ID: <20071102230142.GC26562@wotan.suse.de>
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de> <472B4ECE.7010602@redhat.com> <alpine.LFD.0.999.0711020950250.3342@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0711020950250.3342@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 09:51:27AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 2 Nov 2007, Chuck Ebbert wrote:
> > 
> > There's also a very easy way to get better fairness with our current spinlocks:
> > use xchg to release the lock instead of mov.
> 
> That does nothing at all.
> 
> Yes, it slows the unlock down, which in turn on some machines will make it 
> easier for another core/socket to get it, but it's purely about the 
> slowdown, nothing else. 

Yeah, it's not such a good idea... it slows down the single threaded case
like crazy. On my dual core core2:

_Single thread_
inc-lock in cache takes 21.94ns
xadd-lock in cache takes 22.64ns
xchg-lock in cache takes 35.21ns

inc-lock out of cache takes 140.73ns
xadd-lock out of cache takes 141.15ns
xchg-lock out of cache takes 155.13ns


In the contended multi-threaded tight loop, the xchg lock is slower than inc
lock but still beats the fair xadd lock, but that's only because it is
just as unfair if not more so on this hardware (runtime difference of up to
about 10%)
