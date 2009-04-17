Return-Path: <linux-kernel-owner+w=401wt.eu-S1762090AbZDQSon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090AbZDQSon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbZDQSof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:44:35 -0400
Received: from mga05.intel.com ([192.55.52.89]:49306 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755507AbZDQSoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:44:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,205,1239001200"; 
   d="scan'208";a="448900716"
Date: Fri, 17 Apr 2009 11:44:31 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090417184431.GB3719@linux.intel.com>
References: <20090416235649.GF26366@ZenIV.linux.org.uk> <20090417000142.GF21405@elte.hu> <20090417001345.GH26366@ZenIV.linux.org.uk> <20090417002744.GB29630@elte.hu> <20090417003805.GI26366@ZenIV.linux.org.uk> <20090417165643.GL8253@elte.hu> <1239987885.23397.4817.camel@laptop> <alpine.LFD.2.00.0904171010470.4042@localhost.localdomain> <20090417113142.3151579b@bike.lwn.net> <alpine.LFD.2.00.0904171039080.4042@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904171039080.4042@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 11:03:31AM -0700, Linus Torvalds wrote:
> Hmm. It might also just be my fevered imagination. I'd like to say it was 
> Matthew Wilcox, but really, my mind is going.
> 
> Ahh. Bug google backs me up. As long as I have google, I can keep 
> Alzheimer's at bay: "Negative scalability by removal of lock_kernel()" 
> thread on lkml back in October 2000. After we had actually done the BKL 
> removal.
> 
> So we actually did apply it (in 2.4.0-test9, and then reverted it again 
> (in -test11, I think). Google for "file_lock_sem fs/locks.c" and see some 
> of the discussion. The end result was to go back to the BKL due to Apache 
> slowdowns.

That's some good ancient history ;-)  It probably would make sense to
use a mutex rather than the BKL these days now that we spin on mutexes
if the other process is running.  Plus, I don't think modern Apache uses
file locks any more.

There was another attempt to remove the BKL from locks.c by Dave Hansen
a few years later.  That one foundered on the proposed locking scheme
being unadulterated crap; I seem to remember pointing out that it was
gathering O(n^2) locks ...

> But I seem to remember a later patch (in the last year or two) from Willy 
> too. Google doesn't help me, so that's probably just my fevered mind. But 
> I'm cc'ing Willy anyway.

Fortunately, this patch wasn't the product of a fevered anything.  It
was in response to the performance regressions I introduced by
introducing the generic semaphores that were too fair.

It didn't deal with the really knotty problem which was the NFS server
still running under the BKL and relying on the BKL to prevent other
CPUs from messing with the list of locks.

Since the problem turned out to be the TTY layer and not the file
locking code, we just dropped the patch, but if we'd like to resurrect
it again, we need to talk to the NFS folks.  Probably Bruce Fields is
the appropriate sucker.
