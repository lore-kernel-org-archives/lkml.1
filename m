Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbZE0R4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbZE0R4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764459AbZE0RyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:54:10 -0400
Received: from THUNK.ORG ([69.25.196.29]:39636 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932816AbZE0RyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:54:07 -0400
Date: Wed, 27 May 2009 13:53:53 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v8
Message-ID: <20090527175353.GE10842@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
	jack@suse.cz, yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
	damien.wyart@free.fr
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com> <20090527144754.GD10842@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527144754.GD10842@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 10:47:54AM -0400, Theodore Tso wrote:
> 
> I'll retry the test with your stock writeback-v8 git branch w/o any
> ext4 patches planned the next mere window mainline to see if I get the
> same soft lockup, but I thought I should give you an early heads up.

Confirmed.  I had to run fsstress twice, but I was able to trigger a
soft hangup with just the per-bdi v8 patches using ext4.

With ext3, fsstress didn't cause a soft lockup while it was running
--- but after the test, when I tried to unmount the filesystem,
/sbin/umount hung:

[ 2040.893469] INFO: task umount:7154 blocked for more than 120 seconds.
[ 2040.893487] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2040.893503] umount        D 000001ba  2600  7154   5885
[ 2040.893531]  ec408db8 00000046 ba2bff0b 000001ba c0be7148 c0e68bc8 c0163ebd c0a78700
[ 2040.893572]  c0a78700 ec408d74 c0164e28 e95c0000 e95c027c c2d13700 00000000 ba2d9a13
[ 2040.893612]  000001ba c0165031 00000006 e95c0000 c05e9594 00000002 ec408d9c e95c027c
[ 2040.893652] Call Trace:
[ 2040.893683]  [<c0163ebd>] ? lock_release_holdtime+0x30/0x131
[ 2040.893702]  [<c0164e28>] ? mark_lock+0x1e/0x1e4
[ 2040.893720]  [<c0165031>] ? mark_held_locks+0x43/0x5b
[ 2040.893742]  [<c05e9594>] ? _spin_unlock_irqrestore+0x3c/0x48
[ 2040.893761]  [<c01652ba>] ? trace_hardirqs_on+0xb/0xd
[ 2040.893782]  [<c05e79ff>] schedule+0x8/0x17
[ 2040.893801]  [<c01d7009>] bdi_sched_wait+0x8/0xc
[ 2040.893818]  [<c05e7ee8>] __wait_on_bit+0x36/0x5d
[ 2040.893836]  [<c01d7001>] ? bdi_sched_wait+0x0/0xc
[ 2040.893854]  [<c05e7fba>] out_of_line_wait_on_bit+0xab/0xb3
[ 2040.893872]  [<c01d7001>] ? bdi_sched_wait+0x0/0xc
[ 2040.893892]  [<c01577ae>] ? wake_bit_function+0x0/0x43
[ 2040.893911]  [<c01d618e>] wait_on_bit+0x20/0x2c
[ 2040.893929]  [<c01d6d06>] bdi_writeback_all+0x161/0x18e
[ 2040.893951]  [<c0199f63>] ? wait_on_page_writeback_range+0x9d/0xdc
[ 2040.894052]  [<c01d6e47>] generic_sync_sb_inodes+0x2f/0xcc
[ 2040.894079]  [<c01d6f52>] sync_inodes_sb+0x6e/0x76
[ 2040.894107]  [<c01c1aa0>] __fsync_super+0x63/0x66
[ 2040.894131]  [<c01c1aae>] fsync_super+0xb/0x19
[ 2040.894149]  [<c01c1d16>] generic_shutdown_super+0x1c/0xde
[ 2040.894167]  [<c01c1df5>] kill_block_super+0x1d/0x31
[ 2040.894186]  [<c01f0a85>] ? vfs_quota_off+0x0/0x12
[ 2040.894204]  [<c01c2350>] deactivate_super+0x57/0x6b
[ 2040.894223]  [<c01d2156>] mntput_no_expire+0xca/0xfb
[ 2040.894242]  [<c01d2633>] sys_umount+0x28f/0x2b4
[ 2040.894262]  [<c01d2665>] sys_oldumount+0xd/0xf
[ 2040.894281]  [<c011c264>] sysenter_do_call+0x12/0x38
[ 2040.894297] 1 lock held by umount/7154:
[ 2040.894307]  #0:  (&type->s_umount_key#31){++++..}, at: [<c01c234b>] deactivate_super+0x52/0x6b


Given that the ext4 hangs were also related to s_umount being taken by
sync_inodes(), there seems to be something going on there:

[ 3720.900031] INFO: task fsstress:8487 blocked for more than 120 seconds.
[ 3720.900041] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3720.900049] fsstress      D 00000330  2060  8487   8484
[ 3720.900063]  eddcde38 00000046 633117b6 00000330 c0be7148 c0e58ba8 c0163ebd c0a78700
[ 3720.900084]  c0a78700 eddcddf4 c0164e28 f45a0000 f45a027c c2d13700 00000000 63320800
[ 3720.900104]  00000330 c0165031 00000006 f45a0000 c05e9594 00000002 eddcde1c f45a027c
[ 3720.900124] Call Trace:
[ 3720.900142]  [<c0163ebd>] ? lock_release_holdtime+0x30/0x131
[ 3720.900151]  [<c0164e28>] ? mark_lock+0x1e/0x1e4
[ 3720.900160]  [<c0165031>] ? mark_held_locks+0x43/0x5b
[ 3720.900172]  [<c05e9594>] ? _spin_unlock_irqrestore+0x3c/0x48
[ 3720.900181]  [<c01652ba>] ? trace_hardirqs_on+0xb/0xd
[ 3720.900192]  [<c05e79ff>] schedule+0x8/0x17
[ 3720.900202]  [<c01d7009>] bdi_sched_wait+0x8/0xc
[ 3720.900211]  [<c05e7ee8>] __wait_on_bit+0x36/0x5d
[ 3720.900220]  [<c01d7001>] ? bdi_sched_wait+0x0/0xc
[ 3720.900229]  [<c05e7fba>] out_of_line_wait_on_bit+0xab/0xb3
[ 3720.900238]  [<c01d7001>] ? bdi_sched_wait+0x0/0xc
[ 3720.900248]  [<c01577ae>] ? wake_bit_function+0x0/0x43
[ 3720.900258]  [<c01d618e>] wait_on_bit+0x20/0x2c
[ 3720.900267]  [<c01d6d06>] bdi_writeback_all+0x161/0x18e
[ 3720.900277]  [<c01d6e47>] generic_sync_sb_inodes+0x2f/0xcc
[ 3720.900287]  [<c01d6f52>] sync_inodes_sb+0x6e/0x76
[ 3720.900297]  [<c01d6f9d>] __sync_inodes+0x43/0x89
[ 3720.900306]  [<c01d6ffe>] sync_inodes+0x1b/0x1e
[ 3720.900314]  [<c01d96f9>] do_sync+0x38/0x5a
[ 3720.900323]  [<c01d973f>] sys_sync+0xd/0x12
[ 3720.900333]  [<c011c264>] sysenter_do_call+0x12/0x38
[ 3720.900340] 1 lock held by fsstress/8487:
[ 3720.900345]  #0:  (&type->s_umount_key#15){++++..}, at: [<c01d6f8e>] __sync_inodes+0x34/0x89

  		     				       	   - Ted
