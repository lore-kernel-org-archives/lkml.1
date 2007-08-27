Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbXH0XeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbXH0XeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 19:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbXH0Xdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 19:33:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbXH0Xdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 19:33:51 -0400
From: Neil Brown <neilb@suse.de>
To: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 28 Aug 2007 09:33:41 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18131.24405.451485.40460@notabene.brown>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [RFC] block_device_operations prototype changes
In-Reply-To: message from Al Viro on Monday August 27
References: <20070827103053.GF21089@ftp.linux.org.uk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday August 27, viro@ftp.linux.org.uk wrote:
> 	* a bug (AFAICT) in md.c - we open raid components r/w and if it
> fails, it fails.  Good for our purposes, but... how about raid0 on read-only
> devices?  In any case, we have a ready place to store mode_t, so it's not a
> problem for getting the right value to blkdev_put().  FWIW, I think that
> allowing fallback to r/o (and making the entire array r/o, of course) would
> be a good thing to have.  Any comments from drivers/md folks?

I've never heard any suggestion of anybody wanting to include a
readonly device in an md array -  I guess one could imagine an array
of CDROMs, but I doubt anyone would actually create one.
However I agree that falling back to read-only (particular if the
error value indicated that this was the only problem) would be a
sensible thing to do in some circumstances.

More interestingly:  one could argue that when the md array is
switched to read-only, each component device should be reopened as
read-only.  So I would really like the interface to have a way to
switch a device between read-only and read-write without closing and
re-opening.

Though I guess opening and then closing as you suggest below would be OK.

> 	* open_bdev_excl()/close_bdev_excl().  Needs an extra argument for
> the latter.  Two interesting callers:
> 	* kill_block_super() - need to store relevant mode_t in superblock,
> along with reference to bdev.  Note that just looking at sb->s_flags is *not*
> enough - some filesystems go read-only on errors and that changes ->s_flags.
> Another side of that is explicit remount from r/o to r/w and there we have
> a bug - we do _not_ tell the driver that something had happened.  Proper
> fix is simple enough - bdget() + blkdev_get() for write + blkdev_put() with
> old mode_t (i.e. FMODE_READ) once we are done remounting (and similar for
> explicit remount to r/o).


I would *really* like to see this.  When the root filesystem gets
mounted read-only, I want md to know so that it can mark the array as
'clean' straight away.  I really don't like having a reboot-notifier
to mark all arrays as 'clean' on shutdown.

So each device would be responsible for keeping a count of 'readonly'
and 'read-write' accesses?  Or would that be in common code?

I look forward to this all getting cleaned up!

NeilBrown
