Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZAEQX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZAEQX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbZAEQXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:23:17 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:48503 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbZAEQXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:23:16 -0500
Date: Mon, 5 Jan 2009 09:23:11 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: Btrfs for mainline
Message-ID: <20090105162311.GG2002@parisc-linux.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <200901060147.24285.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901060147.24285.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 01:47:23AM +1100, Nick Piggin wrote:
> adaptive locks have traditionally (read: Linus says) indicated the locking
> is suboptimal from a performance perspective and should be reworked. This
> is definitely the case for the -rt patchset, because they deliberately
> trade performance by change even very short held spinlocks to sleeping locks. 
> 
> So I don't really know if -rt justifies adaptive locks in mainline/btrfs.
> Is there no way for the short critical sections to be decoupled from the
> long/sleeping ones?

I wondered about that option too.  Let's see if we have other users that
will benefit from adaptive locks -- my gut says that Linus is right, but
then there's a lot of lazy programmers out there using mutexes when they
should be using spinlocks.

I wonder about a new lockdep-style debugging option that adds a bit per
mutex class to determine whether the holder ever slept while holding it.
Then a periodic check could determine which mutexes were needlessly held
would find one style of bad lock management.

The comment in btrfs certainly indicates that locking redesign is a
potential solution:

 * locks the per buffer mutex in an extent buffer.  This uses adaptive locks
 * and the spin is not tuned very extensively.  The spinning does make a big
 * difference in almost every workload, but spinning for the right amount of
 * time needs some help.
 *
 * In general, we want to spin as long as the lock holder is doing btree searches,
 * and we should give up if they are in more expensive code.

btrfs almost wants its own hybrid locks (like lock_sock(), to choose
a new in-tree example).  One where it will spin, unless a flag is set
to not spin, in which case it sleeps.  Then the 'more expensive code'
can set the flag to not bother spinning.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
