Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbZAGNI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbZAGNI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZAGNIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:08:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59747 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZAGNIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:08:14 -0500
Date: Wed, 7 Jan 2009 14:07:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Mason <chris.mason@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: Btrfs for mainline
Message-ID: <20090107130742.GD3529@elte.hu>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <200901060147.24285.nickpiggin@yahoo.com.au> <1231173015.4290.129.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231173015.4290.129.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Mason <chris.mason@oracle.com> wrote:

> On Tue, 2009-01-06 at 01:47 +1100, Nick Piggin wrote:
> 
> [ adaptive locking in btrfs ]
> 
> > adaptive locks have traditionally (read: Linus says) indicated the locking
> > is suboptimal from a performance perspective and should be reworked. This
> > is definitely the case for the -rt patchset, because they deliberately
> > trade performance by change even very short held spinlocks to sleeping locks. 
> > 
> > So I don't really know if -rt justifies adaptive locks in mainline/btrfs.
> > Is there no way for the short critical sections to be decoupled from the
> > long/sleeping ones?
> 
> Yes and no.  The locks are used here to control access to the btree
> leaves and nodes.  Some of these are very hot and tend to stay in cache
> all the time, while others have to be read from the disk.
> 
> As the btree search walks down the tree, access to the hot nodes is best 
> controlled by a spinlock.  Some operations (like a balance) will need to 
> read other blocks from the disk and keep the node/leaf locked.  So it 
> also needs to be able to sleep.
> 
> I try to drop the locks where it makes sense before sleeping operatinos, 
> but in some corner cases it isn't practical.
> 
> For leaves, once the code has found the item in the btree it was looking 
> for, it wants to go off and do something useful (insert an inode etc 
> etc). Those operations also tend to block, and the lock needs to be held 
> to keep the tree block from changing.
> 
> All of this is a long way of saying the btrfs locking scheme is far from 
> perfect.  I'll look harder at the loop and ways to get rid of it.

<ob'plug>

adaptive spinning mutexes perhaps? Such as:

   http://lkml.org/lkml/2009/1/7/119

(also pullable via the URI below)

If you have a BTRFS performance test where you know such details matter 
you might want to try Peter's patch and send us the test results.

	Ingo

------------->

You can pull the latest core/locking git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/locking

------------------>
Peter Zijlstra (1):
      mutex: implement adaptive spinning


 include/linux/mutex.h   |    4 +-
 include/linux/sched.h   |    2 +
 kernel/mutex-debug.c    |   10 +------
 kernel/mutex-debug.h    |    8 -----
 kernel/mutex.c          |   46 ++++++++++++++++++++++--------
 kernel/mutex.h          |    2 -
 kernel/sched.c          |   73 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched_debug.c    |    2 +
 kernel/sched_features.h |    1 +
 9 files changed, 115 insertions(+), 33 deletions(-)
