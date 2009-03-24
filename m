Return-Path: <linux-kernel-owner+w=401wt.eu-S1760757AbZCXNhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757AbZCXNhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZCXNhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:37:34 -0400
Received: from THUNK.ORG ([69.25.196.29]:45355 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbZCXNhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:37:33 -0400
Date: Tue, 24 Mar 2009 09:37:06 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324133706.GL5814@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324041249.1133efb6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 04:12:49AM -0700, Andrew Morton wrote:
> But mainly because the problem lies elsewhere - in an area of contention
> between the committing and running transactions which we knowingly and
> reluctantly added to fix a bug in "[PATCH] fix ext3 buffer-stealing"

Well, let's be clear here.  The contention between committing and
running transaction is an issue, even if we solved this problem, it
wouldn't solve the issue of fsync() taking a long time in ext3's
data=ordered mode in the case of massive write starvation caused by a
read-heavy workload, or a vast number of dirty buffers associated with
an inode which is about to be committed, and a process triggers an
fsync().  So fixing this issue wouldn't have solved the problem which
Ingo complained about (which was an editor calling fsync() leading to
long delay when saving a file during or right after a
distcc-accelerated kernel compile) or the infamous Firefox 3.0 bug.

Fixing this contention *would* fix the problem where a normal process
which is doing normal file I/O could end up getting stalled
unnecessarily, but that's not what most people are complaining about
--- and shortening the amount of time that it takes do a commit
(either with ext4's delayed allocation or ext3's data=writeback mount
option) would also address this problem.  That doesn't mean that it's
not worth it to fix this particular contention, but there are multiple
issues going on here.

(Basically we're here:

http://www.kernel.org/pub/linux/kernel/people/paulmck/Confessions/FOSSElephant.html

... in Paul Mckenney's version of parable of the blind men and the elephant:

http://www.kernel.org/pub/linux/kernel/people/paulmck/Confessions/

:-)

> Now this:
> 
> > Resolution was that Tytso indicated it went into some sort of ext4 
> > patch queue:
> 
> was not a fix at all.  It was a known-buggy hack which I proposed simply to
> remove that contention point to let us find out if we're on the right
> track.  IIRC Ric was going to ask someone to do some performance testing of
> that hack, but we never heard back.

Ric did do some preliminary performance testing, and it wasn't
encouraging.  It's still in the unstable portion of the ext4 patch
queue, and it's in my "wish I had more time to look at it; I don't get
to work on ext3/4 full-time" queue.

> The bottom line is that someone needs to do some serious rooting through
> the very heart of JBD transaction logic and nobody has yet put their hand
> up.  If we do that, and it turns out to be just too hard to fix then yes,
> perhaps that's the time to start looking at palliative bandaids.

I disagree that they are _just_ palliative bandaids, because you need
these in order to make sure fsync() completes in a reasonable time, so
that people like Ingo don't get cranky.  :-)   Fixing the contention
between the running and committing transaction is a good thing, and I
hope someone puts up their hand or I magically get the time I need to
really dive into the jbd layer, but it won't help the Firefox 3.0
problem or Ingo's problem with saving files during a distcc run.

						- Ted

