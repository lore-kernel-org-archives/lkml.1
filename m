Return-Path: <linux-kernel-owner+w=401wt.eu-S1763660AbZE1TdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763660AbZE1TdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 15:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759813AbZE1TdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 15:33:09 -0400
Received: from thunk.org ([69.25.196.29]:36554 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392AbZE1TdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 15:33:07 -0400
Date: Thu, 28 May 2009 15:32:46 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr,
       Alex Chiang <achiang@hp.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v8
Message-ID: <20090528193246.GX26625@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
	akpm@linux-foundation.org, yanmin_zhang@linux.intel.com,
	richard@rsk.demon.co.uk, damien.wyart@free.fr,
	Alex Chiang <achiang@hp.com>,
	"Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com> <20090527144754.GD10842@mit.edu> <20090527175353.GE10842@mit.edu> <20090527175830.GF10842@mit.edu> <20090527181402.GP11363@kernel.dk> <20090527191524.GS11363@kernel.dk> <20090527194543.GT11363@kernel.dk> <20090528004959.GH26625@mit.edu> <20090528092803.GE29199@duck.suse.cz> <m1octdw8sv.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1octdw8sv.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 08:23:28AM -0700, Eric W. Biederman wrote:
> I thought the network stack was the only piece of code silly enough
> to hold locks while deleting sysfs files.
> 
> Holding any lock while deleting a objects from sysfs, sysctl or proc,
> is asking for serious mischief, and unfixable from the fs side.
> 
> The usual problem is that lockdep doesn't yet understand
> sysfs_deactivate which waits for any running sysfs operations to
> complete before it deletes the sysfs files.
> 
> Which means any lock you hold in a show or store method is can deadlock
> with any lock you hold while deleting from sysfs.
> 
> ext4 appears lock loose and fancy free in it's show and store methods
> so it might be ok except for this issue of mmap_sem vs sysfs_mutex.
> But apparently even that isn't enough to git rid of the requirement
> to not hold locks when deleting objects.

I ran into this problem, and I attempted to work around the fact that
the core VFS layer calls the fs's put_super() while holding the BKL
and the super block lock as follows at the very end of ext4's
put_super() function:

	/*
	 * Now that we are completely done shutting down the
	 * superblock, we need to actually destroy the kobject.
	 */
	unlock_kernel();
	unlock_super(sb);
	kobject_put(&sbi->s_kobj);
	wait_for_completion(&sbi->s_kobj_unregister);
	lock_super(sb);
	lock_kernel();

I'm pretty sure that after the first call to invalidate_inodes() in
fs/super.c's generic_shutdown_super(), we really don't need to hold
the BKL or the superblock lock (and let the filesystems' low-level
write_super(0 and put_super() take the lock if they really need it),
but we probably need to take a closer look at this to make sure it's
true for all filesystems.  (IIRC, I think Christoph was looking to
clean up lock_super(); at least with respect to the write_super call.
I don't know what his plans regarding the BKL and put_super(),
though.)

Fundamentally, right now it's rather painful to use sysfs from within
a filesystem driver, since the generic VFS layer doesn't have any
explicit kobject support functionality.

						- Ted
