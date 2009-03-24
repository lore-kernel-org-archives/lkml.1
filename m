Return-Path: <linux-kernel-owner+w=401wt.eu-S1759641AbZCXLZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641AbZCXLZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758588AbZCXLYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:24:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758708AbZCXLYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:24:49 -0400
Date: Tue, 24 Mar 2009 04:12:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-Id: <20090324041249.1133efb6.akpm@linux-foundation.org>
In-Reply-To: <20090324103111.GA26691@elte.hu>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<20090324091545.758d00f5@lxorguk.ukuu.org.uk>
	<20090324093245.GA22483@elte.hu>
	<20090324101011.6555a0b9@lxorguk.ukuu.org.uk>
	<20090324103111.GA26691@elte.hu>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009 11:31:11 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > > > I have not had this problem since I applied Arjan's (for some reason
> > > > repeatedly rejected) patch to change the ioprio of the various writeback
> > > > daemons. Under some loads changing to the noop I/O scheduler also seems
> > > > to help (as do most of the non default ones)
> > > 
> > > (link would be useful)
> > 
> > 
> > "Give kjournald a IOPRIO_CLASS_RT io priority"
> > 
> > October 2007 (yes its that old)
> 
> thx. A more recent submission from Arjan would be:
> 
>     http://lkml.org/lkml/2008/10/1/405
> 
> Resolution was that Tytso indicated it went into some sort of ext4 
> patch queue:
> 
> | I've ported the patch to the ext4 filesystem, and dropped it into 
> | the unstable portion of the ext4 patch queue.
> |
> |   ext4: akpm's locking hack to fix locking delays
> 
> but 6 months down the line and i can find no trace of this upstream 
> anywhere.
> 
> <let-me-rant-too>
> 
> The thing is ... this is a _bad_ ext3 design bug affecting ext3 
> users in the last decade or so of ext3 existence. Why is this issue 
> not handled with the utmost high priority and why wasnt it fixed 5 
> years ago already? :-)
> 
> It does not matter whether we have extents or htrees when there are 
> _trivially reproducible_ basic usability problems with ext3.
> 

It's all there in that Oct 2008 thread.

The proposed tweak to kjournald is a bad fix - partly because it will
elevate the priority of vast amounts of IO whose priority we don't _want_
elevated.

But mainly because the problem lies elsewhere - in an area of contention
between the committing and running transactions which we knowingly and
reluctantly added to fix a bug in 

commit 773fc4c63442fbd8237b4805627f6906143204a8
Author:     akpm <akpm>
AuthorDate: Sun May 19 23:23:01 2002 +0000
Commit:     akpm <akpm>
CommitDate: Sun May 19 23:23:01 2002 +0000

    [PATCH] fix ext3 buffer-stealing
    
    Patch from sct fixes a long-standing (I did it!) and rather complex
    problem with ext3.
    
    The problem is to do with buffers which are continually being dirtied
    by an external agent.  I had code in there (for easily-triggerable
    livelock avoidance) which steals the buffer from checkpoint mode and
    reattaches it to the running transaction.  This violates ext3 ordering
    requirements - it can permit journal space to be reclaimed before the
    relevant data has really been written out.
    
    Also, we do have to reliably get a lock on the buffer when moving it
    between lists and inspecting its internal state.  Otherwise a competing
    read from the underlying block device can trigger an assertion failure,
    and a competing write to the underlying block device can confuse ext3
    journalling state completely.
    

Now this:

> Resolution was that Tytso indicated it went into some sort of ext4 
> patch queue:

was not a fix at all.  It was a known-buggy hack which I proposed simply to
remove that contention point to let us find out if we're on the right
track.  IIRC Ric was going to ask someone to do some performance testing of
that hack, but we never heard back.

The bottom line is that someone needs to do some serious rooting through
the very heart of JBD transaction logic and nobody has yet put their hand
up.  If we do that, and it turns out to be just too hard to fix then yes,
perhaps that's the time to start looking at palliative bandaids.

The number of people who can be looked at to do serious ext3/JBD work is
pretty small now.  Ted, Stephen and I got old and died.  Jan does good work
but is spread thinly.

