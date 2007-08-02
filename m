Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbXHBKJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbXHBKJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbXHBKJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:09:37 -0400
Received: from 1wt.eu ([62.212.114.60]:1087 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbXHBKJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:09:36 -0400
Date: Thu, 2 Aug 2007 12:07:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070802100737.GA9756@1wt.eu>
References: <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <p73wswfo0hf.fsf@bingen.suse.de> <Pine.LNX.4.64.0708011525560.1817@scrub.home> <alpine.LFD.0.999.0708011903300.3582@woody.linux-foundation.org> <20070802045710.GA8720@1wt.eu> <p73643ynrn2.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73643ynrn2.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 12:43:29PM +0200, Andi Kleen wrote:
> > However, I undertand why Ingo chose to use 64 bits. It has the advantage
> > that the numbers never wrap within 584 years. I'm well aware that it's
> > very difficult to keep tasks ordered according to a key which can wrap.
> 
> If you define an appropiate window and use some macros for the comparisons
> it shouldn't be a big problem.

It should not, but the hardest thing is often to keep values sorted within a
window. When you store your values in a tree according to a key, it's not
always easy to do find the first one relative to a sliding offset.

> > But if we consider that we don't need to be more precise than the return
> > value from gettimeofday() that all applications use,
> 
> gettimeofday() has too strict requirements, that make it unnecessarily slow
> for this task.

maybe we would use (TSC >> (x bits)) when TSC is available, or jiffies in other
cases. I believe that people not interested in high time accuracies are not
much interested in perfect fairness either. However, we should do the best to
avoid any form of starvation, otherwise we jump back to the problem with the
current scheduler.

> > every hour. We may accept to recompute all keys every hour.
> 
> You don't need to recompute keys; just use careful comparisons using
> subtractions and a window. TCPs have done that for decades. 
> 
> > Have all keys use 32-bit resolution, and monitor the 32nd bit. All tasks
> 
> If you're worried about wrapping in one hour why is wrapping in two
> hours not a problem? 

I've not said I was worried about that (or maybe I explained myself poorly).
Even if it was once a minute, it would not bother me. I wanted to explain
that if the solution requires to do it that often, it should be acceptable.

> I have one request though. If anybody adds anything complicated
> for this please make it optional so that 64bit platforms are not 
> burdened by it.

Fair enough. But the solution is not there yet. Maybe once it's there, it
will be better than current design for all platforms and the only difference
will be the accuracy due to optional use of the TSC.

> -Andi

Willy

