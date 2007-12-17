Return-Path: <linux-kernel-owner+w=401wt.eu-S935866AbXLQLTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935866AbXLQLTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 06:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934942AbXLQLS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 06:18:58 -0500
Received: from relay2.sgi.com ([192.48.171.30]:49234 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935012AbXLQLS5 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 06:18:57 -0500
Date: Mon, 17 Dec 2007 22:18:45 +1100
From: David Chinner <dgc@sgi.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Possible recursive locking detected with XFS
Message-ID: <20071217111845.GP4396912@sgi.com>
References: <47614FCC.3090009@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47614FCC.3090009@vlnb.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 06:29:16PM +0300, Vladislav Bolkhovitin wrote:
> I've just got it while running "dbench 200" over a XFS mounted 
> partition. Kernel is 2.6.23. See the attachment.
......
> Dec 13 16:30:45 tst kernel: [  917.365836] =============================================
> Dec 13 16:30:45 tst kernel: [  917.372856] [ INFO: possible recursive locking detected ]
> Dec 13 16:30:45 tst kernel: [  917.378269] 2.6.23-dbg #17
> Dec 13 16:30:45 tst kernel: [  917.381435] ---------------------------------------------
> Dec 13 16:30:45 tst kernel: [  917.386838] dbench/3538 is trying to acquire lock:
> Dec 13 16:30:45 tst kernel: [  917.391687]  (&(&ip->i_iolock)->mr_lock){----}, at: [<f89ad79c>] xfs_ilock+0x90/0x9c [xfs]
> Dec 13 16:30:45 tst kernel: [  917.400262] 
> Dec 13 16:30:45 tst kernel: [  917.400264] but task is already holding lock:
> Dec 13 16:30:45 tst kernel: [  917.406116]  (&(&ip->i_iolock)->mr_lock){----}, at: [<f89ad79c>] xfs_ilock+0x90/0x9c [xfs]
> Dec 13 16:30:45 tst kernel: [  917.414503] 
> Dec 13 16:30:45 tst kernel: [  917.414505] other info that might help us debug this:
> Dec 13 16:30:45 tst kernel: [  917.421242] 3 locks held by dbench/3538:
> Dec 13 16:30:45 tst kernel: [  917.425178]  #0:  (&inode->i_mutex){--..}, at: [<783626a6>] mutex_lock+0x1c/0x1f
> Dec 13 16:30:45 tst kernel: [  917.432805]  #1:  (&(&ip->i_iolock)->mr_lock){----}, at: [<f89ad79c>] xfs_ilock+0x90/0x9c [xfs]
> Dec 13 16:30:45 tst kernel: [  917.441696]  #2:  (&type->s_umount_key#17){----}, at: [<78191411>] writeback_inodes+0x88/0xd5
> Dec 13 16:30:45 tst kernel: [  917.450578] 
> Dec 13 16:30:45 tst kernel: [  917.450582] stack backtrace:
> Dec 13 16:30:45 tst kernel: [  917.455011]  [<78103d59>] show_trace_log_lvl+0x1a/0x30
> Dec 13 16:30:45 tst kernel: [  917.460279]  [<7810488d>] show_trace+0x12/0x14
> Dec 13 16:30:45 tst kernel: [  917.464759]  [<781048a5>] dump_stack+0x16/0x18
> Dec 13 16:30:45 tst kernel: [  917.469262]  [<7813f883>] __lock_acquire+0xdd1/0x106e
> Dec 13 16:30:45 tst kernel: [  917.474360]  [<7813fb89>] lock_acquire+0x69/0x82
> Dec 13 16:30:45 tst kernel: [  917.479000]  [<78136184>] down_write_nested+0x40/0x88
> Dec 13 16:30:45 tst kernel: [  917.484195]  [<f89ad79c>] xfs_ilock+0x90/0x9c [xfs]
> Dec 13 16:30:45 tst kernel: [  917.489180]  [<f89d13b7>] xfs_inactive+0x329/0x4ed [xfs]
> Dec 13 16:30:45 tst kernel: [  917.494565]  [<f89dc052>] xfs_fs_clear_inode+0x7a/0xbe [xfs]
> Dec 13 16:30:45 tst kernel: [  917.500415]  [<78188a78>] clear_inode+0xb2/0x14d
> Dec 13 16:30:45 tst kernel: [  917.505078]  [<78188c0b>] generic_delete_inode+0xf8/0x105
> Dec 13 16:30:45 tst kernel: [  917.510513]  [<78188d27>] generic_drop_inode+0x10f/0x141
> Dec 13 16:30:45 tst kernel: [  917.515854]  [<78188226>] iput+0x5f/0x66
> Dec 13 16:30:45 tst kernel: [  917.519836]  [<781911ae>] sync_sb_inodes+0x1f6/0x25c
> Dec 13 16:30:45 tst kernel: [  917.525032]  [<7819142f>] writeback_inodes+0xa6/0xd5
> Dec 13 16:30:45 tst kernel: [  917.530070]  [<7815c9f3>] balance_dirty_pages_ratelimited_nr+0xdd/0x204
> Dec 13 16:30:45 tst kernel: [  917.536716]  [<781580e4>] generic_file_buffered_write+0x2e2/0x69c
> Dec 13 16:30:45 tst kernel: [  917.542855]  [<f89db3fe>] xfs_write+0x619/0xaab [xfs]
> Dec 13 16:30:45 tst kernel: [  917.547990]  [<f89d776e>] xfs_file_aio_write+0x70/0x7c [xfs]
> Dec 13 16:30:45 tst kernel: [  917.553770]  [<78175d65>] do_sync_write+0xd0/0x106
> Dec 13 16:30:45 tst kernel: [  917.558620]  [<78176552>] vfs_write+0x8b/0x149
> Dec 13 16:30:45 tst kernel: [  917.563113]  [<78176bc4>] sys_write+0x3d/0x64
> Dec 13 16:30:45 tst kernel: [  917.567526]  [<78102ca2>] sysenter_past_esp+0x5f/0x99
> Dec 13 16:30:45 tst kernel: [  917.572635]  =======================

Oh, this is the classic "recurse into the filesystem to do something
that requires locks while holding a lock on a different inode" false positive.

Basically, we are holding the iolock on inode A when we call
generic_file_buffered_write() and that does something that takes the
iolock on inode B which triggers the report because we don't normally
nest iolocks. We also see this regularly with memory reclaim being
triggered from within the filesystem.

AFAICT, there is no way we can annotate these cases because they are
completely disconnected - there is no relationship or dependency between
the two inodes and so false positives due to recursion like this seems
to me to be impossible to annotate away cleanly.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
