Return-Path: <linux-kernel-owner+w=401wt.eu-S1761564AbZCYMh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761564AbZCYMh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 08:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZCYMht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 08:37:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbZCYMht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:37:49 -0400
Date: Wed, 25 Mar 2009 13:37:44 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090325123744.GK23439@duck.suse.cz>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324041249.1133efb6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 24-03-09 04:12:49, Andrew Morton wrote:
> On Tue, 24 Mar 2009 11:31:11 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> > The thing is ... this is a _bad_ ext3 design bug affecting ext3 
> > users in the last decade or so of ext3 existence. Why is this issue 
> > not handled with the utmost high priority and why wasnt it fixed 5 
> > years ago already? :-)
> > 
> > It does not matter whether we have extents or htrees when there are 
> > _trivially reproducible_ basic usability problems with ext3.
> > 
> 
> It's all there in that Oct 2008 thread.
> 
> The proposed tweak to kjournald is a bad fix - partly because it will
> elevate the priority of vast amounts of IO whose priority we don't _want_
> elevated.
> 
> But mainly because the problem lies elsewhere - in an area of contention
> between the committing and running transactions which we knowingly and
> reluctantly added to fix a bug in 
> 
> commit 773fc4c63442fbd8237b4805627f6906143204a8
> Author:     akpm <akpm>
> AuthorDate: Sun May 19 23:23:01 2002 +0000
> Commit:     akpm <akpm>
> CommitDate: Sun May 19 23:23:01 2002 +0000
> 
>     [PATCH] fix ext3 buffer-stealing
>     
>     Patch from sct fixes a long-standing (I did it!) and rather complex
>     problem with ext3.
>     
>     The problem is to do with buffers which are continually being dirtied
>     by an external agent.  I had code in there (for easily-triggerable
>     livelock avoidance) which steals the buffer from checkpoint mode and
>     reattaches it to the running transaction.  This violates ext3 ordering
>     requirements - it can permit journal space to be reclaimed before the
>     relevant data has really been written out.
>     
>     Also, we do have to reliably get a lock on the buffer when moving it
>     between lists and inspecting its internal state.  Otherwise a competing
>     read from the underlying block device can trigger an assertion failure,
>     and a competing write to the underlying block device can confuse ext3
>     journalling state completely.
  I've looked at this a bit. I suppose you mean the contention arising from
us taking the buffer lock in do_get_write_access()? But it's not obvious
to me why we'd be contending there... We call this function only for
metadata buffers (unless in data=journal mode) so there isn't huge amount
of these blocks. This buffer should be locked for a longer time only when
we do writeout for checkpoint (hmm, maybe you meant this one?). In
particular, note that we don't take the buffer lock when committing this
block to journal - we lock only the BJ_IO buffer. But in this case we wait
when the buffer is on BJ_Shadow list later so there is some contention in
this case.
  Also when I emailed with a few people about these sync problems, they
wrote that switching to data=writeback mode helps considerably so this
would indicate that handling of ordered mode data buffers is causing most
of the slowdown...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
