Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZDYPRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZDYPRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 11:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZDYPRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 11:17:12 -0400
Received: from thunk.org ([69.25.196.29]:46201 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbZDYPRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 11:17:10 -0400
Date: Sat, 25 Apr 2009 11:16:56 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: get_fs_excl/put_fs_excl/has_fs_excl
Message-ID: <20090425151656.GH13608@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <jens.axboe@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
References: <20090423191817.GA22521@lst.de> <20090423192123.GL4593@kernel.dk> <20090424184047.GA17001@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424184047.GA17001@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 08:40:47PM +0200, Christoph Hellwig wrote:
> On Thu, Apr 23, 2009 at 09:21:24PM +0200, Jens Axboe wrote:
> > The intent was to add some sort of notification mechanism from the file
> > system to inform the IO scheduler (and others?) that this process is how
> > holding a file system wide resource. So if you have a low priority
> > process getting access to such a resource, you want to boost its
> > priority to avoid higher priority apps getting stuck beind it. Sort of a
> > poor mans priority inheritance.
> > 
> > It would be wonderful if you could kick this process more into gear on
> > the fs side...

I have to agree with Christoph; it would be nice if this were actually
documented somewhere.  Filesystem authors can't do something if they
don't understand what the semantics are and how it is supposed to be
used!

I'm kind of curious why you implemented things in this way, though.
Is there a reason why the bosting is happening deep in the guts of the
cfq code, instead of in blk-core.c when the submission of the block
I/O request is processed?

> So what are the calls in lock_super/unlock_super supposed to be for?
> ->write_super?  While that can sync bits out most of the heavy lifting
> is now done in ->sync_fs for most filesystems.  ->remount_fs?  This is
> going to block all other I/O anyway.  ->put_super?  Surely not :)
> 
> ext3/4 internal bits?  Doesn't seem to be used for any journal related
> activity but mostly as protection against resizing (the whole lock_super
> usage in ext3/4 looks odd to me, interestingly there's none at all in
> ext2.  Maybe someone of the extN crowd should audit and get rid of it in
> favour of a better fs-specific lock)

Yeah, the use of lock_super is definitely very funny in ext3/4.  There
seems to be 3 primary usages; one is blocking write_super(), although
I'm not entirely sure that's needed in all of the places where we do
it.  Another is in protecting the orphan list handling; and the final
one seems to be in the resizing handling.  The last
seems... interesting, especially given this comment:

	/*
	 * We need to protect s_groups_count against other CPUs seeing
	 * inconsistent state in the superblock.
	 *
	 * The precise rules we use are:
	 *
	 * * Writers of s_groups_count *must* hold lock_super
	 * AND
	 * * Writers must perform a smp_wmb() after updating all dependent
	 *   data and before modifying the groups count
	 *
	 * * Readers must hold lock_super() over the access
	 * OR
	 * * Readers must perform an smp_rmb() after reading the groups count
	 *   and before reading any dependent data.
	 *
	 * NB. These rules can be relaxed when checking the group count
	 * while freeing data, as we can only allocate from a block
	 * group after serialising against the group count, and we can
	 * only then free after serialising in turn against that
	 * allocation.
	 */

... but mballoc.c appears not to follow the above protocol at all, as
it relates to using smp_rmb() --- although balloc.c does.  Fortunately
resizes don't happen all that often, but there is definitely some
scary potential problems hiding here, I suspect.

						- Ted
