Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbXKBGmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbXKBGmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 02:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXKBGmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 02:42:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:52682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbXKBGmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 02:42:22 -0400
Date: Fri, 2 Nov 2007 07:42:20 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>,
       Gregory Haskins <gregory.haskins.ml@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/4] x86: FIFO ticket spinlocks
Message-ID: <20071102064220.GC20967@wotan.suse.de>
References: <20071101140146.GA26879@wotan.suse.de> <20071101140320.GC26879@wotan.suse.de> <4729E567.1050402@gmail.com> <alpine.LFD.0.999.0711010935060.3342@woody.linux-foundation.org> <20071101203526.293cd7f0@bree.surriel.com> <alpine.LFD.0.999.0711011819110.3342@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0711011819110.3342@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 06:19:41PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 1 Nov 2007, Rik van Riel wrote:
> > 
> > Larry Woodman managed to wedge the VM into a state where, on his
> > 4x dual core system, only 2 cores (on the same CPU) could get the
> > zone->lru_lock overnight.  The other 6 cores on the system were
> > just spinning, without being able to get the lock.

That's quite incredible, considering that the CPUs actually _taking_
the locks also drop the locks and do quite a bit of work before taking
them again (ie. they take them to pull pages off the LRU, but then
do a reasonable amount of work to remove each one from pagecache before
refilling from the LRU).

Possibly actually that is a *more* difficult case for the HW to handle:
once the CPU actually goes away and operates on other cachelines, it 
may get a little more difficult to detect that it is causing starvation
issues.


> .. and this is almost always the result of a locking *bug*, not unfairness 
> per se. IOW, unfairness just ends up showing the bug in the first place.

I'd almost agree, but there are always going to be corner cases where
we get multiple contentions on a spinlock -- the fact that a lock is
needed at all obviously suggests that it can be contended. The LRU locking
could be improved, but you could have eg. scheduler runqueue lock starvation
if the planets lined up just right, and it is a little more difficult to
improve on runqueue locking.

Anyway, I also think this is partially a hardware issue, and as muliple
cores, threads, and sockets get more common, I hope it will improve (it
affects Intel CPUs as well as AMD). So it is possible to have an option
to switch between locks if the hardware is fairer, but I want to get
as much exposure with this locking as possible for now, to see if there
is any funny performance corner cases exposed (which quite possibly will
turn out to be caused by suboptimal locking itself).

Anyway, if this can make its way to the x86 tree, I think it will get
pulled into -mm (?) and get some exposure...

