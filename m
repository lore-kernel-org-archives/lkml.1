Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbZCZOEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbZCZOEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbZCZOEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:04:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55476 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbZCZOEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:04:12 -0400
Date: Thu, 26 Mar 2009 15:03:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326140312.GB14822@elte.hu>
References: <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326113705.GV32307@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@mit.edu> wrote:

> Ingo,
> 
> Interesting.  I wonder if the problem is the journal is cycling 
> fast enough that it is checkpointing all the time.  If so, it 
> could be that a bigger-sized journal might help.  Can you try this 
> as an experiment? Mount the filesystem using ext4, with the mount 
> option nodelalloc. With an filesystem formatted as ext3, and with 
> delayed allocation disabled, it should behave mostly the same as 
> ext3; try and make sure you're still seeing the same problems.
> 
> Then could you grab /proc/fs/jbd2/<dev>:8/history and
> /proc/fs/jbd2/<dev>:8/info while running your test workload?

i tried it:

  /dev/sda2 on /home type ext4 (rw,nodelalloc)

I still see similarly bad latencies in Vim:

aldebaran:~> cat /proc/10227/stack
[<ffffffff80370cad>] jbd2_log_wait_commit+0xbd/0x110
[<ffffffff8036bc70>] jbd2_journal_stop+0x1f3/0x221
[<ffffffff8036ccb0>] jbd2_journal_force_commit+0x28/0x2c
[<ffffffff80352660>] ext4_force_commit+0x2e/0x34
[<ffffffff80346682>] ext4_write_inode+0x3e/0x44
[<ffffffff802eb941>] __sync_single_inode+0xc1/0x2ad
[<ffffffff802ebc7a>] __writeback_single_inode+0x14d/0x15a
[<ffffffff802ebcb0>] sync_inode+0x29/0x34
[<ffffffff80343e16>] ext4_sync_file+0xf6/0x138
[<ffffffff802eef21>] vfs_fsync+0x78/0xaf
[<ffffffff802eef8f>] do_fsync+0x37/0x4d
[<ffffffff802eefcc>] sys_fsync+0x10/0x14
[<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

Vim is still almost unusable during this workload - even if i dont 
write out the source file just use it interactively to edit it.

The read-test is somewhat better. There are occasional blips of 4-5 
seconds:

 file # 928 (253560 bytes), reading it took: 0.76 seconds.
 file # 929 (253560 bytes), reading it took: 3.98 seconds.
 file # 930 (253560 bytes), reading it took: 3.45 seconds.
 file # 931 (253560 bytes), reading it took: 0.04 seconds.

I have also written a 'vim open' test which does vim -c q, i.e. it 
just opens a source file and closes it without writing the file. 
That too takes a lot of time:

file #   0 (253560 bytes), Vim-opening it took: 2.04 seconds.
file #   1 (253560 bytes), Vim-opening it took: 2.39 seconds.
file #   2 (253560 bytes), Vim-opening it took: 2.03 seconds.
file #   3 (253560 bytes), Vim-opening it took: 2.81 seconds.
file #   4 (253560 bytes), Vim-opening it took: 2.11 seconds.
file #   5 (253560 bytes), Vim-opening it took: 2.44 seconds.
file #   6 (253560 bytes), Vim-opening it took: 2.04 seconds.
file #   7 (253560 bytes), Vim-opening it took: 3.59 seconds.
file #   8 (253560 bytes), Vim-opening it took: 2.06 seconds.
file #   9 (253560 bytes), Vim-opening it took: 3.26 seconds.
file #  10 (253560 bytes), Vim-opening it took: 2.04 seconds.
file #  11 (253560 bytes), Vim-opening it took: 2.38 seconds.
file #  12 (253560 bytes), Vim-opening it took: 2.04 seconds.
file #  13 (253560 bytes), Vim-opening it took: 3.05 seconds.

Here's a few snapshots of Vim waiting spots:

aldebaran:~> cat /proc/$(ps aux | grep -m 1 'vim -c' | cut -d' ' 
-f5)/stack
[<ffffffff8036c1ae>] do_get_write_access+0x22b/0x452
[<ffffffff8036c3fc>] jbd2_journal_get_write_access+0x27/0x38
[<ffffffff8035aa8c>] __ext4_journal_get_write_access+0x51/0x59
[<ffffffff80346f30>] ext4_reserve_inode_write+0x3d/0x79
[<ffffffff80346f9f>] ext4_mark_inode_dirty+0x33/0x187
[<ffffffff8034724e>] ext4_dirty_inode+0x6a/0x9f
[<ffffffff802ec4eb>] __mark_inode_dirty+0x38/0x199
[<ffffffff802e27f5>] touch_atime+0xf6/0x101
[<ffffffff8029cc83>] do_generic_file_read+0x37c/0x3c7
[<ffffffff8029d770>] generic_file_aio_read+0x15b/0x197
[<ffffffff802d0816>] do_sync_read+0xec/0x132
[<ffffffff802d11de>] vfs_read+0xb0/0x139
[<ffffffff802d1335>] sys_read+0x4c/0x74
[<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

aldebaran:~> cat /proc/$(ps aux | grep -m 1 'vim -c' | cut -d' ' 
-f5)/stack
[<ffffffff8029c0ed>] sync_page+0x41/0x45
[<ffffffff8029c274>] wait_on_page_bit+0x73/0x7a
[<ffffffff802a5a76>] truncate_inode_pages_range+0x2f6/0x37b
[<ffffffff802a5b0d>] truncate_inode_pages+0x12/0x15
[<ffffffff8034b97b>] ext4_delete_inode+0x6a/0x25f
[<ffffffff802e378e>] generic_delete_inode+0xe7/0x174
[<ffffffff802e382f>] generic_drop_inode+0x14/0x1d
[<ffffffff802e2866>] iput+0x66/0x6a
[<ffffffff802db889>] do_unlinkat+0x107/0x15d
[<ffffffff802db8f5>] sys_unlink+0x16/0x18
[<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

aldebaran:~> cat /proc/$(ps aux | grep -m 1 'vim -c' | cut -d' ' 
-f5)/stack
[<ffffffff8036c1ae>] do_get_write_access+0x22b/0x452
[<ffffffff8036c3fc>] jbd2_journal_get_write_access+0x27/0x38
[<ffffffff8035aa8c>] __ext4_journal_get_write_access+0x51/0x59
[<ffffffff80346f30>] ext4_reserve_inode_write+0x3d/0x79
[<ffffffff80346f9f>] ext4_mark_inode_dirty+0x33/0x187
[<ffffffff8034724e>] ext4_dirty_inode+0x6a/0x9f
[<ffffffff802ec4eb>] __mark_inode_dirty+0x38/0x199
[<ffffffff802e27f5>] touch_atime+0xf6/0x101
[<ffffffff8029cc83>] do_generic_file_read+0x37c/0x3c7
[<ffffffff8029d770>] generic_file_aio_read+0x15b/0x197
[<ffffffff802d0816>] do_sync_read+0xec/0x132
[<ffffffff802d11de>] vfs_read+0xb0/0x139
[<ffffffff802d1335>] sys_read+0x4c/0x74
[<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

aldebaran:~> cat /proc/$(ps aux | grep -m 1 'vim -c' | cut -d' ' 
-f5)/stack
[<ffffffff8036c1ae>] do_get_write_access+0x22b/0x452
[<ffffffff8036c3fc>] jbd2_journal_get_write_access+0x27/0x38
[<ffffffff8035aa8c>] __ext4_journal_get_write_access+0x51/0x59
[<ffffffff80346f30>] ext4_reserve_inode_write+0x3d/0x79
[<ffffffff80346f9f>] ext4_mark_inode_dirty+0x33/0x187
[<ffffffff8034724e>] ext4_dirty_inode+0x6a/0x9f
[<ffffffff802ec4eb>] __mark_inode_dirty+0x38/0x199
[<ffffffff802e27f5>] touch_atime+0xf6/0x101
[<ffffffff8029cc83>] do_generic_file_read+0x37c/0x3c7
[<ffffffff8029d770>] generic_file_aio_read+0x15b/0x197
[<ffffffff802d0816>] do_sync_read+0xec/0x132
[<ffffffff802d11de>] vfs_read+0xb0/0x139
[<ffffffff802d1335>] sys_read+0x4c/0x74
[<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

aldebaran:~> cat /proc/$(ps aux | grep -m 1 'vim -c' | cut -d' ' 
-f5)/stack
[<ffffffff8036c1ae>] do_get_write_access+0x22b/0x452
[<ffffffff8036c3fc>] jbd2_journal_get_write_access+0x27/0x38
[<ffffffff8035aa8c>] __ext4_journal_get_write_access+0x51/0x59
[<ffffffff80346f30>] ext4_reserve_inode_write+0x3d/0x79
[<ffffffff80346f9f>] ext4_mark_inode_dirty+0x33/0x187
[<ffffffff8034724e>] ext4_dirty_inode+0x6a/0x9f
[<ffffffff802ec4eb>] __mark_inode_dirty+0x38/0x199
[<ffffffff802e27f5>] touch_atime+0xf6/0x101
[<ffffffff8029cc83>] do_generic_file_read+0x37c/0x3c7
[<ffffffff8029d770>] generic_file_aio_read+0x15b/0x197
[<ffffffff802d0816>] do_sync_read+0xec/0x132
[<ffffffff802d11de>] vfs_read+0xb0/0x139
[<ffffffff802d1335>] sys_read+0x4c/0x74
[<ffffffff8020bd1b>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

That's in good deal atime update latencies. We still appear to 
default to atime enabled in ext4.

That's stupid - only around 0.01% of all Linux systems relies on 
atime - and even those who rely on it would be well served by 
relatime. Why arent the relatime patches upstream? Why isnt it the 
default? They have been submitted several times.

Atime in its current mandatory do-a-write-for-every-read form is a 
stupid relic and we have been paying the fool's tax for it in the 
past 10 years.

	Ingo
