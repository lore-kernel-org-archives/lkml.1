Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbXH0KbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbXH0KbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 06:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbXH0Ka4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 06:30:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57733 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbXH0Kay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 06:30:54 -0400
Date: Mon, 27 Aug 2007 11:30:53 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, axboe@kernel.dk
Subject: [RFC] block_device_operations prototype changes
Message-ID: <20070827103053.GF21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	It's time to sanitize prototypes of bdev ->open(), ->release()
and ->ioctl().  This stuff had sat in "need to fix" for a long time
and there is a bunch of bugs hard to fix without dealing with it.

1) ->open() gets inode * and file *.  Almost all instances use only
	inode->i_bdev
	file->f_mode
	file->f_flags - O_ACCMODE|O_NDELAY|O_EXCL
and nothing else.  Most actually use only inode->i_bdev->bd_disk and
those are easy; the trouble begins when we use f_mode and/or f_flags
in non-trivial ways.  One good example is cdrom.c - its behaviour
depends on whether we have O_NDELAY (doesn't lock the door, among
other things) and on whether we are opening for write.  Unfortunately,
it's not just something we care about at open() time - we need different
cleanups at close(), and that doesn't work at all.

At the very least, we need to know whether we want to unlock the door.
Suppose somebody opens it with O_NDELAY (ioctl-only) when it's already
opened for data (or mounted, for that matter).  Now we close it; how
do we know if we need to unlock?  Even if we did get struct file * (and
we do not, but that's a separate story), we could not rely on file->f_flags.
Why?  Because O_NDELAY can be flipped at will by fcntl() after the file
got opened.  IOW, we can't rely on it.

Most of that crap can be solved by saving the relevant information from
f_flags into f_mode (e.g. fs/block_dev.c::do_open()), where they'd remain
safe.  However, that's not quite enough - struct file we pass to ->open()
is often a fake one and it certainly won't live until ->release().

One thing that _can_ be solved that way, though, and it alone makes the
scheme worthwhile: floppy.c abuses can be finally killed.  Just saving
->f_flags & 2 in ->f_mode is enough to eliminate the need for floppy_open()
to play games with permission(9) and modify *file in any way.  Anything
close to current fdutils either passes O_RDWR |... or 3 | ... to open()
when it wants to do priveleged ioctls and then we get open_namei check
that we can write to file.  So we can check that bit saved in ->f_mode
for "can we do that kind of ioctl"; no need to mess with anything.

That's a *big* win, since this is eliminates the only place that uses
more than the fields mentioned above and the only place that tries to
modify struct file and check for modifications in later method calls.

So having done that, we get to the situation where ->open() only uses
inode->i_bdev and file->f_mode (and only reads these).  I.e. we will be
able to go for much saner
	int (*open)(struct block_device *bdev, mode_t mode)

We even can kill that fake struct file.  At that point we have sanitized
->open(), no regressions and a chance to solve the problems with mode-dependent
cleanups on close().  However, to use that chance we'll need to do something
with ->release().

2) ->release() gets struct inode * and struct file * too.  It only uses
inode->i_bdev->bd_disk and, sometimes, file->f_mode.  Tries to use
file->f_mode, that is.  Even all way back in 2.2 when it was ->release()
of file_operations, we used to get NULL on operations like umount, etc.,
so users of file->f_mode/file->f_flags had to check for file != NULL
first.  And pray that all such users will want some reasonable default
behaviour.

For one thing, that's not true anymore.  E.g. pktcdvd.c does blkdev_get()
with O_NDELAY and blkdev_put() as matching close.  IOW, blkdev_put() can't
expect that matching open had no O_NDELAY.

For another, blkdev_put() is used by blkdev_close() since 2.3, so we _always_
get NULL now.  IOW, the cleanup-related logics doesn't work properly, period.

The obvious first step is to switch to
	int (*release)(struct gendisk *disk, mode_t mode)
(there are good reasons why open wants bdev and release does not).  At least
that way we can start passing the right value without fake struct file, etc.

Now, the only thing we need is a way to pass that mode_t to blkdev_put().
IOW, blkdev_put() needs an extra argument.  And that's where the things
get really interesting.  blkdev_close() should just pass file->f_mode to
it; that's easy.  However, we have more callers and need case-by-case
analysis for those.

We don't have too many of those callers, fortunately, and almost all of them
are easy - we know what had matching blkdev_open() got and that's it.

Exceptions are interesting.
	* we have reiserfs journal that could've been opened r/o or r/w.
BFD - we can store the mode_t just fine along with the reference to bdev.
	* a bug (AFAICT) in md.c - we open raid components r/w and if it
fails, it fails.  Good for our purposes, but... how about raid0 on read-only
devices?  In any case, we have a ready place to store mode_t, so it's not a
problem for getting the right value to blkdev_put().  FWIW, I think that
allowing fallback to r/o (and making the entire array r/o, of course) would
be a good thing to have.  Any comments from drivers/md folks?
	* open_bdev_excl()/close_bdev_excl().  Needs an extra argument for
the latter.  Two interesting callers:
	* kill_block_super() - need to store relevant mode_t in superblock,
along with reference to bdev.  Note that just looking at sb->s_flags is *not*
enough - some filesystems go read-only on errors and that changes ->s_flags.
Another side of that is explicit remount from r/o to r/w and there we have
a bug - we do _not_ tell the driver that something had happened.  Proper
fix is simple enough - bdget() + blkdev_get() for write + blkdev_put() with
old mode_t (i.e. FMODE_READ) once we are done remounting (and similar for
explicit remount to r/o).
	* mtd2block may do unbalanced close_bdev_excl() and it passes bogus
arguments to open_bdev_excl() - NULL holder.  Easy to fix.

So with that having dealt with we'll get reliable mode_t passed to ->release(),
matching those passed on ->open().  Victory.

3) ->ioctl().  What a mess...  First of all, we have 3 methods with different
calling conventions:
	->ioctl(inode, file, cmd, arg)
	->unlocked_ioctl(inode, file, cmd, arg)
	->compat_ioctl(file, cmd, arg)
The first one returns int; other two return long, bugger if I know why.
ioctl(3) returns int.  So any value that doesn't fit into native int
will be truncated anyway.  ->compat_ioctl() is even more ridiculous,
since it's called from 32bit task doing ioctl(2) and returning native
long is particulary dumb.

Moreover, we don't have enough instances of ->ioctl() to justify a separate
methods for locked and unlocked; taking BKL into the former and merging
them is easy enough.

Now, as with ->open(), we care only about inode->i_bdev and file->f_mode
(assuming we'd dealt with ->f_flags -> ->f_mode transition above).  Which
is what these suckers need to get.  IOW, we get to
	int (*ioctl)(bdev, mode, cmd, arg)
	int (*compat_ioctl)(bdev, mode, cmd, arg)
both assuming that BKL had not been taken by caller.

That will take a series of preparatory patches changing the prototypes of
common helpers (scsi_cmd_ioctl() and its ilk).  BTW, what the hell is
block/bsg.c doing with passing NULL bd_disk to scsi_cmd_ioctl()?  Not a
problem for this patch series, but it looks fishy...

That's more or less it; resulting APIs will be a lot saner and entire thing
is reasonably easy to split into bisect-friendly chunks.  It is an API breaker,
of course, but we don't have a lot of affected modules and anything not
converted will be (a) immediately caught by gcc and (b) trivial to convert.

I have the beginning of that series done and the rest mapped out in enough
details to implement it over this week.  If somebody has objections,
questions or comments - yell.
