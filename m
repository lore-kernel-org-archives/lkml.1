Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab0BWHY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 02:24:29 -0500
Received: from swm.pp.se ([212.247.200.143]:36630 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab0BWHY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 02:24:27 -0500
Date: Tue, 23 Feb 2010 08:24:26 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Dave Chinner <david@fromorbit.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: disk/crypto performance regression 2.6.31 -> 2.6.32 (mmap
 problem?)
In-Reply-To: <20100223044818.GD22370@discord.disaster>
Message-ID: <alpine.DEB.1.10.1002230820110.12694@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1002191729220.28940@uplift.swm.pp.se> <alpine.DEB.1.10.1002221337170.28940@uplift.swm.pp.se> <20100223044818.GD22370@discord.disaster>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, Dave Chinner wrote:

> XFS issues IO barriers by default. They were recently enabled in md
> for raid5/6, so that might be the cause of the slowdown/latency. You
> could try using the "nobarrier" mount option to see if this make the
> problem go away, but beware that this can result in filesystem
> corruption if the machine crashes.

I don't think the crypto layer supports it so I think my barriers are off, 
that's what I'm used to seeing every time it mounts the partition.

> If it is not barriers that are causing this, then the other thing
> you might want to look at is if XFS is configured with lazy-count=1
> (xfs_info <mntpt>). If it is not enabled (0), then a significant
> amount of latency could be coming from the superblock buffer being
> locked during transaction commits. Unfortunately enabling this
> feature is an offline operation (via xfs_admin) so enabling may not
> be feasible for you.

Currently it's "lazy-count=0", so I'll change that setting tonight.

The behaviour I'm seeing right now causes things like "sync" to take very 
long time, I just saw this as well (I've seen the same once when I ran 
"sync" manually):

[210846.031875] INFO: task xfssyncd:3167 blocked for more than 120 seconds.
[210846.031879] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[210846.031883] xfssyncd      D 00000000ffffffff     0  3167      2 0x00000000
[210846.031889]  ffff880208569c50 0000000000000046 ffff880208569c10 0000000000015880
[210846.031895]  ffff88020b0ec7c0 0000000000015880 0000000000015880 0000000000015880
[210846.031900]  0000000000015880 ffff88020b0ec7c0 0000000000015880 0000000000015880
[210846.031905] Call Trace:
[210846.031935]  [<ffffffffa02767d5>] __xfs_iunpin_wait+0x95/0xd0 [xfs]
[210846.031943]  [<ffffffff810789c0>] ? autoremove_wake_function+0x0/0x40
[210846.031964]  [<ffffffffa0279dad>] xfs_iflush+0x8d/0x2b0 [xfs]
[210846.031971]  [<ffffffff815299cb>] ? __down_write+0xb/0x10
[210846.031992]  [<ffffffffa02a06f4>] xfs_reclaim_inode+0x114/0x180 [xfs]
[210846.032013]  [<ffffffffa02a07e2>] xfs_reclaim_inode_now+0x82/0x90 [xfs]
[210846.032033]  [<ffffffffa02a0760>] ? xfs_reclaim_inode_now+0x0/0x90 [xfs]
[210846.032053]  [<ffffffffa02a11d2>] xfs_inode_ag_walk+0x72/0xd0 [xfs]
[210846.032073]  [<ffffffffa02a0760>] ? xfs_reclaim_inode_now+0x0/0x90 [xfs]
[210846.032094]  [<ffffffffa02a1297>] xfs_inode_ag_iterator+0x67/0xa0 [xfs]
[210846.032114]  [<ffffffffa02a12e4>] xfs_reclaim_inodes+0x14/0x20 [xfs]
[210846.032134]  [<ffffffffa02a1349>] xfs_sync_worker+0x59/0x90 [xfs]
[210846.032154]  [<ffffffffa02a0a0a>] xfssyncd+0x17a/0x220 [xfs]
[210846.032174]  [<ffffffffa02a0890>] ? xfssyncd+0x0/0x220 [xfs]
[210846.032179]  [<ffffffff810785d6>] kthread+0xa6/0xb0
[210846.032183]  [<ffffffff810130ea>] child_rip+0xa/0x20
[210846.032188]  [<ffffffff81078530>] ? kthread+0x0/0xb0
[210846.032191]  [<ffffffff810130e0>] ? child_rip+0x0/0x20

So something weird is going on, I don't really see why it wouldn't be able 
to write enough data in 120 seconds in an orderly fashion.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
