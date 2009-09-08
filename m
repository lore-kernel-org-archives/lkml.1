Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbZIHSGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbZIHSGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZIHSGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:06:11 -0400
Received: from THUNK.ORG ([69.25.196.29]:49065 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbZIHSGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:06:10 -0400
Date: Tue, 8 Sep 2009 14:06:01 -0400
From: Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090908180601.GN22901@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, david@fromorbit.com,
	hch@infradead.org, akpm@linux-foundation.org, jack@suse.cz
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-9-git-send-email-jens.axboe@oracle.com> <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins> <20090908162936.GA2975@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908162936.GA2975@think>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 12:29:36PM -0400, Chris Mason wrote:
> > 
> > Clearly the current limit isn't sufficient for some people,
> >  - xfs/btrfs seem generally stuck in balance_dirty_pages()'s
> > congestion_wait()
> >  - ext4 generates inconveniently small extents
> 
> This is actually two different side of the same problem.  The filesystem
> knows that bytes 0-N in the file are setup for delayed allocation.
> Writepage is called on byte 0, and now the filesystem gets to decide how
> big an extent to make.
> 
> It could decide to make an extent based on the total number of bytes
> under delayed allocation, and hope the caller of writepage will be kind
> enough to send down the pages contiguously afterward (xfs), or it could
> make a smaller extent based on something closer to the total number of
> bytes this particular writepages() call plans on writing (I guess what
> ext4 is doing).
>
> Either way, if pdflush or the bdi thread or whoever ends up switching to
> another file during a big streaming write, the end result is that we
> fragment.  We may fragment the file (ext4) or we may fragment the
> writeback (xfs), but the end result isn't good.

Yep; the question is whether we want to fragment the read operation in
the future (ext4) or write operation now (XFS).   

> > Now, suppose it were to do something useful, I'd think we'd want to
> > limit write-out to whatever it takes so saturate the BDI.
> 
> If we don't want a blanket increase, I'd suggest that we just give the
> FS a way to say: 'I know nr_to_write is only 32, but if you just write a
> few blocks more, the system will be better off'.

Well, we can mostly do this now, using the XFS hack:

      wbc->nr_to_write *= 4;

Which is another way of saying, we *know* the page writeback routines
are on crack, so we'll ignore their suggestion of how many pages to
write, and we'll try to write more than what they asked us to write.

(This wasn't a proposed change; it's in Linux 2.6 mainline already;
see fs/xfs/linux-2.6/xfs_aops.c, in xfs_vm_writepage).  The fact that
filesystems are playing games like this should be a clear indication
that things are badly broken above....

> > As to the extends, shouldn't ext4 allocate extends based on the amount
> > of dirty pages in the file instead of however much we're going to write
> > out now?
> 
> It probably does a mixture of both.

It does do a mixture, but in a fairly primitive way.  I was thinking
about writing some ugly code to more precisely determine how many
dirty-and-delayed-allocation-pages exist beyond what we've currently
requested to write, but it seemed like most of the problem would be
solved simply by having the page writeback routines simply send more
pages down to the filesystem, instead of having the file system work
around brain damage in the VM writeback routines.

						- Ted
