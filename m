Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbZDVR3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbZDVR3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZDVR3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:29:00 -0400
Received: from mail.fieldses.org ([141.211.133.115]:34373 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZDVR27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:28:59 -0400
Date: Wed, 22 Apr 2009 13:28:15 -0400
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090422172815.GA9541@fieldses.org>
References: <20090417000142.GF21405@elte.hu> <20090417001345.GH26366@ZenIV.linux.org.uk> <20090417002744.GB29630@elte.hu> <20090417003805.GI26366@ZenIV.linux.org.uk> <20090417165643.GL8253@elte.hu> <1239987885.23397.4817.camel@laptop> <alpine.LFD.2.00.0904171010470.4042@localhost.localdomain> <20090417113142.3151579b@bike.lwn.net> <alpine.LFD.2.00.0904171039080.4042@localhost.localdomain> <20090417184431.GB3719@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417184431.GB3719@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 11:44:31AM -0700, Matthew Wilcox wrote:
> On Fri, Apr 17, 2009 at 11:03:31AM -0700, Linus Torvalds wrote:
> > Hmm. It might also just be my fevered imagination. I'd like to say it was 
> > Matthew Wilcox, but really, my mind is going.
> > 
> > Ahh. Bug google backs me up. As long as I have google, I can keep 
> > Alzheimer's at bay: "Negative scalability by removal of lock_kernel()" 
> > thread on lkml back in October 2000. After we had actually done the BKL 
> > removal.
> > 
> > So we actually did apply it (in 2.4.0-test9, and then reverted it again 
> > (in -test11, I think). Google for "file_lock_sem fs/locks.c" and see some 
> > of the discussion. The end result was to go back to the BKL due to Apache 
> > slowdowns.
> 
> That's some good ancient history ;-)  It probably would make sense to
> use a mutex rather than the BKL these days now that we spin on mutexes
> if the other process is running.  Plus, I don't think modern Apache uses
> file locks any more.
> 
> There was another attempt to remove the BKL from locks.c by Dave Hansen
> a few years later.  That one foundered on the proposed locking scheme
> being unadulterated crap; I seem to remember pointing out that it was
> gathering O(n^2) locks ...
> 
> > But I seem to remember a later patch (in the last year or two) from Willy 
> > too. Google doesn't help me, so that's probably just my fevered mind. But 
> > I'm cc'ing Willy anyway.
> 
> Fortunately, this patch wasn't the product of a fevered anything.  It
> was in response to the performance regressions I introduced by
> introducing the generic semaphores that were too fair.
> 
> It didn't deal with the really knotty problem which was the NFS server
> still running under the BKL and relying on the BKL to prevent other
> CPUs from messing with the list of locks.

It's only lockd that actually runs *entirely* under the BKL--and lockd
obviously has a close relationship with the locks.c code, so there's a
fear of (unknown) dependencies there.

Also, more concretely (and what you probably had in mind), there are a
couple places where the nfs client or server explicitly take the bkl
just to traverse the lock list.

> Since the problem turned out to be the TTY layer and not the file
> locking code, we just dropped the patch, but if we'd like to resurrect
> it again, we need to talk to the NFS folks.  Probably Bruce Fields is
> the appropriate sucker.

I've been saying for a while I'd look into this, but keep getting
distracted, apologies.... I'll see if I can at least deal with the
obvious nfs client/server lock list traversals this time around.

--b.
