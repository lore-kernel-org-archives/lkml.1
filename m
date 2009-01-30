Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZA3LdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZA3LdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 06:33:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZA3Lc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 06:32:56 -0500
Received: from brick.kernel.dk ([93.163.65.50]:10234 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbZA3Lcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 06:32:55 -0500
Date: Fri, 30 Jan 2009 12:31:06 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] block/splice bits for 2.6.29
Message-ID: <20090130113105.GK30821@kernel.dk>
References: <20090127115709.GR30821@kernel.dk> <m3bptsygt3.fsf@dmon-lap.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3bptsygt3.fsf@dmon-lap.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27 2009, Dmitri Monakhov wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > Hi,
> >
> > Collection of fixes for 2.6.29, please pull.
> >
> >   git://git.kernel.dk/linux-2.6-block.git for-linus
> >
> > Alberto Bertogli (1):
> >       Fix small typo in bio.h's documentation
> >
> > Bartlomiej Zolnierkiewicz (1):
> >       block: export SSD/non-rotational queue flag through sysfs
> >
> > Boaz Harrosh (1):
> >       include/linux: Add bsg.h to the Kernel exported headers
> >
> > Jens Axboe (5):
> >       block: get rid of the manual directory counting in blktrace
> >       block: seperate bio/request unplug and sync bits
> >       block: add bio_rw_flagged() for testing bio->bi_rw
> >       block: silently error an unsupported barrier bio
> >       block: add sysfs file for controlling io stats accounting
> >
> > Martin K. Petersen (3):
> >       block: Don't verify integrity metadata on read error
> >       block: Remove obsolete BUG_ON
> >       block: Allow empty integrity profile
> >
> > Nikanth Karthikesan (1):
> >       Mark mandatory elevator functions in the biodoc.txt
> >
> > Theodore Ts'o (1):
> >       block: Fix documentation for blkdev_issue_flush()
> >
> > Vegard Nossum (1):
> >       splice: fix deadlock with pipe_wait() and inode locking
> This patch is wrong, in fact Vergard has noted this in patch log.

Hmm weird, I don't recall any such discussion. I did test it here, but
alas that doesn't of course catch all problems.

> We have two problems
> 1) pure bug : After the patch __splice_from_pipe() looks like follows
>  __splice_from_pipe( pipe, sd, actor) {
> ..
>         pipe_wait(pipe, sd->u.file->f_mapping->host);
> ..
> }
>    But only "actor" callback allowed to touch sd->u structure because it has
>    knowledge about it's type. For example:
>    ->vmsplice_to_user
>     sd.u.userptr = base;
>     ->__splice_from_pipe(pipe, &sd, pipe_to_user);
>      ->pipe_wait(pipe, sd->u.file->f_mapping->host);

That is obviously true. Others can access it though, but only if they
know what the caller has put there. We do that in other places. As a
generic thing, it can't work.

> 2) File systems which use generic_file_splice_write_nolock() (filesystems
> with external locking)
> This filesystems may not being happy if we internally drop file's mutex
> inside generic_file_splice_write_nolock(). At least this behaviour not
> well documented.
> 
> Definitely patch must be redesigned.
> IMHO we have to choices:
> 1) The simplest one:
>   Redesing splice locking ordering in following way
>    ->file->i_mutex ; so file always locked before pipe
>      ->pipe->inode->i_mutex
>   This allows us to preserve current pipe_wait() logic without touching
>   file's lock.
> 
> 2) a good one:
>  Redesing __splice_from_pipe(),  simular to do_tee()
>  /* ipipe: lock(); pipe_wait() if necessary; unlock()
>  ret = link_ipipe_prep(ipipe, flags); 
>  if (!ret) { 
>  /* opipe: lock(); pipe_wait() if necessary ;unlock() */
>  ret = link_opipe_prep(opipe, flags);// 
>  if (!ret)
>        /* inode_double_lock(ipipe->inode, opipe->inode); */
>        ret = link_pipe(ipipe, opipe, len, flags);

Not sure I agree with your assessment on what is the best approach. The
do_tee() approach is lossy and not very solid imho, so I'd greatly
prefer just unifying the lock ordering. So some "wrapper" around the
doublelock to take the file into account would be fine. Not sure
dropping the file lock is a huge problem, but it very well could be. So
it would be better to just be able to drop the pipe lock unconditionally
as we do now, and not care for the upper lock.

I'll axe this patch until a final and proven solution is done.

-- 
Jens Axboe

