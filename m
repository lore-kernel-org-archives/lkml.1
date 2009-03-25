Return-Path: <linux-kernel-owner+w=401wt.eu-S1761122AbZCYPBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761122AbZCYPBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZCYPBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:01:43 -0400
Received: from THUNK.ORG ([69.25.196.29]:45580 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbZCYPBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:01:42 -0400
Date: Wed, 25 Mar 2009 11:00:41 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090325150041.GM32307@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain> <49C87B87.4020108@krogh.cc> <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com> <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325123744.GK23439@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 01:37:44PM +0100, Jan Kara wrote:
> >     Also, we do have to reliably get a lock on the buffer when moving it
> >     between lists and inspecting its internal state.  Otherwise a competing
> >     read from the underlying block device can trigger an assertion failure,
> >     and a competing write to the underlying block device can confuse ext3
> >     journalling state completely.
>
>   I've looked at this a bit. I suppose you mean the contention arising from
> us taking the buffer lock in do_get_write_access()? But it's not obvious
> to me why we'd be contending there... We call this function only for
> metadata buffers (unless in data=journal mode) so there isn't huge amount
> of these blocks.

There isn't a huge number of those blocks, but if inode #1220 was
modified in the previous transaction which is now being committed, and
we then need to modify and write out inode #1221 in the current
contention, and they share the same inode table block, that would
cause the contention.  That probably doesn't happen that often in a
synchronous code path, but it probably happens more often that you're
thinking.  I still think the fsync() problem is the much bigger deal,
and solving the contention problem isn't going to solve the fsync()
latency problem with ext3 data=ordered mode.

>   Also when I emailed with a few people about these sync problems, they
> wrote that switching to data=writeback mode helps considerably so this
> would indicate that handling of ordered mode data buffers is causing most
> of the slowdown...

Yes, but we need to be clear whether this was an fsync() problem or
some other random delay problem.  If it's the fsync() problem,
obviously data=writeback will solve the fsync() latency delay problem.
(As will using delayed allocation in ext4 or XFS.)

    	       	       		     	  - Ted
