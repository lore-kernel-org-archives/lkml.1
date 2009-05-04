Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbZEDRPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbZEDRPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbZEDRPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:15:09 -0400
Received: from [192.16.179.4] ([192.16.179.4]:47019 "EHLO sh.osrg.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754227AbZEDRPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:15:08 -0400
Date: Tue, 05 May 2009 02:11:29 +0900 (JST)
Message-Id: <20090505.021129.103520156.ryusuke@osrg.net>
To: viro@ZenIV.linux.org.uk
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: sget() misuse in nilfs
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20090503225136.GC8633@ZenIV.linux.org.uk>
References: <20090503225136.GC8633@ZenIV.linux.org.uk>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 05 May 2009 02:11:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Sun, 3 May 2009 23:51:36 +0100, Al Viro wrote:
> OK, I give up; what _is_ get_sb/remount code supposed to implement?

Oh, these functions lack spec comments.

I first explain some specs. (I think part of them should be added on
the code, later)

The nilfs_get_sb() allocates a new super_block struct (sb) or assigns
an existing sb to the mount point through sget().  For newly allocated
sb it calls nilfs_fill_super() for initialization.

The following things are supposed here:

 1) Every rw-mount on a device shares the same sb (as usual).

 2) Every sb of snapshot is independent with that of rw-mount or other
    snapshots if their checkpoint numbers differ.  On the other hand,
    two or more snapshots having the same checkpoint number share a sb
    wherever possible.

 3) Snapshots are mountable concurrently with a rw-mount, but a
    ro-mount is not so because the ro-mount cannot follow changes
    brought by the rw-mount.

 4) Every sb on a device shares the same nilfs struct
    (i.e. the_nilfs), which stores their common information.

    The existing nilfs struct is acquired from an existing sb.
    Otherwise, a new nilfs struct is allocated through alloc_nilfs()
    function.  The lifetime of the nilfs struct is managed with a
    reference counter.

The nilfs_remount() function follows the change by given mount
options.  This does not replace sb, so it involves the following
actions and confirmation:

 a) A segment constructor (i.e. log writer of nilfs) is invoked on
    ro->rw remount, and it is shut down for ro->rw remount.

 b) ro->rw remount is possible only if there is no rw-mount on the
    device and the checkpoint number of the ro-mount is latest.

 c) Remounting snapshot to different checkpoints or rw-mount is not
    allowed.

> Not to mention the reliability of down_read_trylock() in there (what
> happens if somebody tries to e.g. remount fs we are looking at the
> time?  That's right, s_umount held exclusive, down_read_trulock()
> failing, fs instance skipped during the search), what is all that
> stuff trying to achieve?

It tries to find out the existing snapshot instance having a
checkpoint number which equals with the specified cp number (2).

Yeah, it may fail in the situation.  I allow the miss at present
because it's harmless and rare though it wastes memory due to unwanted
duplication of the snapshot instance.

> What protects MS_RDONLY in sd->s_flags during these searches?

sd->s_flags is a local variable of the call sites of sget(), but, ugh,
s->s_flags is not protected.  It may have problem...

BTW, MS_RDONLY in s->s_flags is also referred to in get_sb_bdev() and
do_remount_sb().  How is the protection achieved for these functions?

For example, ext3_remount() or ext3_handle_error() manipulates this
flag, and get_sb_bdev() or do_remount_sb() could see it for other
existing fs-instances.

> What makes parse_options() in remount straight into sb (with reversal
> if we'd done something bad) safe?

Well, it's not protected except lock_kernel() in the call sites.
I should add an argument to the parse_options() in order to forbid
destructive changes like ext3/4 does.

> Do we ever reassign snapshot_cno
> other than on sb creation and remounting between r/o and r/w?

We don't allow reassigning the snapshot_cno.
But, ugh, nilfs_remount() is rewriting it temporarily. It seems bad.
I'll fix it.

> Is there any reason why we free sbi early (== in put_super()) and
> not after kill_block_super() in ->kill_sb() of your own?

No, just I didn't think we have to delay it until ->kill_sb() because
bdev->bd_mount_sem and s->s_umount are protecting ->s_fs_info until
removing the sb from the type->fs_supers list and the super_blocks
list.

> That alone would make sbi stay with superblock for as long as it
> could be found by any means, killing the locking mess in your test
> callbacks.

If the advice turned out to be required or help for simplification,
I'll take it in.  I need some time to think about it.

> Can SNAPSHOT even be there unless you have MS_RDONLY?

Yes, it can.  Nilfs snapshots can exist concurrently with rw-mount.
 
> And what are the rules for exclusion in case of r/w mounts?

(answered in the first explanation)

> What, do we get -EBUSY on attempt to mount r/w something that is
> already mounted r/w (instead of simply sharing superblock, as other
> filesystems would do)?
>
> Or am I misreading that
>         } else if (!(s->s_flags & MS_RDONLY)) {
>                 err = -EBUSY;
>         }
> in there?

Hmm, this looks strange to me, too.  Nilfs is sharing a r/w-mount as
described in (1).  I'll confirm the -EBUSY case.

> 						Very confused Al...

Sorry.  I recongize these are rather confusing.
The use of sget() and the test routines should be reduced to a minimum
if feasible.

Anyway, thanks for many questions and comments.

Regards,
Ryusuke Konishi
