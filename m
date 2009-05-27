Return-Path: <linux-kernel-owner+w=401wt.eu-S932209AbZE0OsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbZE0OsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763872AbZE0OsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:48:11 -0400
Received: from THUNK.ORG ([69.25.196.29]:33308 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763101AbZE0OsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:48:08 -0400
Date: Wed, 27 May 2009 10:47:54 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v8
Message-ID: <20090527144754.GD10842@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
	jack@suse.cz, yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
	damien.wyart@free.fr
References: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243417312-7444-1-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

FYI, just for yucks I tried to merge your bdi patches and the ext4
patch queue to make sure there were no patch conflicts, and started a
quick regression run.  I got the following soft lockup report when
running "fsstress -d /mnt/tmp -s 12345 -S -p 20 -n 1000".

I'll retry the test with your stock writeback-v8 git branch w/o any
ext4 patches planned the next mere window mainline to see if I get the
same soft lockup, but I thought I should give you an early heads up.

						- Ted


[46283.324099] kjournald2 starting: pid 23258, dev dm-4:8, commit interval 5 seconds
[46283.326503] EXT4 FS on dm-4, internal journal on dm-4:8
[46283.326523] EXT4-fs: delayed allocation enabled
[46283.326538] EXT4-fs: file extents enabled
[46283.336368] EXT4-fs: mballoc enabled
[46283.337053] EXT4-fs: mounted filesystem dm-4 with ordered data mode
[46440.889702] INFO: task umount:22890 blocked for more than 120 seconds.
[46440.889715] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[46440.889725] umount        D 00002a0d  2288 22890  19517
[46440.889742]  df5b0db8 00000046 d8a93c7f 00002a0d c0be7148 c0e5cbc8 c0163ebd c0a78700
[46440.889770]  c0a78700 df5b0d74 c0164e28 f145a980 f145abfc c2d13700 00000000 d8ad1b4f
[46440.889797]  00002a0d c0165031 00000006 f145a980 c05e9dd4 00000002 df5b0d9c f145abfc
[46440.889823] Call Trace:
[46440.889844]  [<c0163ebd>] ? lock_release_holdtime+0x30/0x131
[46440.889856]  [<c0164e28>] ? mark_lock+0x1e/0x1e4
[46440.889868]  [<c0165031>] ? mark_held_locks+0x43/0x5b
[46440.889882]  [<c05e9dd4>] ? _spin_unlock_irqrestore+0x3c/0x48
[46440.889894]  [<c01652ba>] ? trace_hardirqs_on+0xb/0xd
[46440.889909]  [<c05e823f>] schedule+0x8/0x17
[46440.889922]  [<c01d7031>] bdi_sched_wait+0x8/0xc
[46440.889933]  [<c05e8728>] __wait_on_bit+0x36/0x5d
[46440.889944]  [<c01d7029>] ? bdi_sched_wait+0x0/0xc
[46440.889956]  [<c05e87fa>] out_of_line_wait_on_bit+0xab/0xb3
[46440.889968]  [<c01d7029>] ? bdi_sched_wait+0x0/0xc
[46440.889981]  [<c01577ae>] ? wake_bit_function+0x0/0x43
[46440.889993]  [<c01d61b6>] wait_on_bit+0x20/0x2c
[46440.890005]  [<c01d6d2e>] bdi_writeback_all+0x161/0x18e
[46440.890019]  [<c0199f63>] ? wait_on_page_writeback_range+0x9d/0xdc
[46440.890032]  [<c01d6e6f>] generic_sync_sb_inodes+0x2f/0xcc
[46440.890044]  [<c01d6f7a>] sync_inodes_sb+0x6e/0x76
[46440.890057]  [<c01c1aa0>] __fsync_super+0x63/0x66
[46440.890069]  [<c01c1aae>] fsync_super+0xb/0x19
[46440.890080]  [<c01c1d16>] generic_shutdown_super+0x1c/0xde
[46440.890092]  [<c01c1df5>] kill_block_super+0x1d/0x31
[46440.890104]  [<c01f0acd>] ? vfs_quota_off+0x0/0x12
[46440.890115]  [<c01c2350>] deactivate_super+0x57/0x6b
[46440.890128]  [<c01d217e>] mntput_no_expire+0xca/0xfb
[46440.890141]  [<c01d265b>] sys_umount+0x28f/0x2b4
[46440.890153]  [<c01d268d>] sys_oldumount+0xd/0xf
[46440.890166]  [<c011c264>] sysenter_do_call+0x12/0x38
[46440.890176] 1 lock held by umount/22890:
[46440.890182]  #0:  (&type->s_umount_key#31){++++..}, at: [<c01c234b>] deactivate_super+0x52/0x6b
[46560.889079] INFO: task umount:22890 blocked for more than 120 seconds.
[46560.889097] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[46560.889113] umount        D 00002a0d  2288 22890  19517
[46560.889140]  df5b0db8 00000046 d8a93c7f 00002a0d c0be7148 c0e5cbc8 c0163ebd c0a78700
[46560.889181]  c0a78700 df5b0d74 c0164e28 f145a980 f145abfc c2d13700 00000000 d8ad1b4f
[46560.889221]  00002a0d c0165031 00000006 f145a980 c05e9dd4 00000002 df5b0d9c f145abfc
[46560.889260] Call Trace:
[46560.889291]  [<c0163ebd>] ? lock_release_holdtime+0x30/0x131
[46560.889309]  [<c0164e28>] ? mark_lock+0x1e/0x1e4
[46560.889327]  [<c0165031>] ? mark_held_locks+0x43/0x5b
[46560.889348]  [<c05e9dd4>] ? _spin_unlock_irqrestore+0x3c/0x48
[46560.889366]  [<c01652ba>] ? trace_hardirqs_on+0xb/0xd
[46560.889387]  [<c05e823f>] schedule+0x8/0x17
[46560.889406]  [<c01d7031>] bdi_sched_wait+0x8/0xc
[46560.889422]  [<c05e8728>] __wait_on_bit+0x36/0x5d
[46560.889439]  [<c01d7029>] ? bdi_sched_wait+0x0/0xc
[46560.889457]  [<c05e87fa>] out_of_line_wait_on_bit+0xab/0xb3
[46560.889475]  [<c01d7029>] ? bdi_sched_wait+0x0/0xc
[46560.889495]  [<c01577ae>] ? wake_bit_function+0x0/0x43
[46560.889512]  [<c01d61b6>] wait_on_bit+0x20/0x2c
[46560.889605]  [<c01d6d2e>] bdi_writeback_all+0x161/0x18e
[46560.889635]  [<c0199f63>] ? wait_on_page_writeback_range+0x9d/0xdc
[46560.889664]  [<c01d6e6f>] generic_sync_sb_inodes+0x2f/0xcc
[46560.889689]  [<c01d6f7a>] sync_inodes_sb+0x6e/0x76
[46560.889709]  [<c01c1aa0>] __fsync_super+0x63/0x66
[46560.889726]  [<c01c1aae>] fsync_super+0xb/0x19
[46560.889743]  [<c01c1d16>] generic_shutdown_super+0x1c/0xde
[46560.889761]  [<c01c1df5>] kill_block_super+0x1d/0x31
[46560.889780]  [<c01f0acd>] ? vfs_quota_off+0x0/0x12
[46560.889797]  [<c01c2350>] deactivate_super+0x57/0x6b
[46560.889816]  [<c01d217e>] mntput_no_expire+0xca/0xfb
[46560.889835]  [<c01d265b>] sys_umount+0x28f/0x2b4
[46560.889855]  [<c01d268d>] sys_oldumount+0xd/0xf
[46560.889874]  [<c011c264>] sysenter_do_call+0x12/0x38
[46560.889889] 1 lock held by umount/22890:
[46560.889899]  #0:  (&type->s_umount_key#31){++++..}, at: [<c01c234b>] deactivate_super+0x52/0x6b
[46680.889028] INFO: task umount:22890 blocked for more than 120 seconds.
[46680.889046] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[46680.889061] umount        D 00002a0d  2288 22890  19517
[46680.889088]  df5b0db8 00000046 d8a93c7f 00002a0d c0be7148 c0e5cbc8 c0163ebd c0a78700
[46680.889130]  c0a78700 df5b0d74 c0164e28 f145a980 f145abfc c2d13700 00000000 d8ad1b4f
[46680.889169]  00002a0d c0165031 00000006 f145a980 c05e9dd4 00000002 df5b0d9c f145abfc
[46680.889209] Call Trace:
[46680.889240]  [<c0163ebd>] ? lock_release_holdtime+0x30/0x131
[46680.889259]  [<c0164e28>] ? mark_lock+0x1e/0x1e4
[46680.889276]  [<c0165031>] ? mark_held_locks+0x43/0x5b
[46680.889297]  [<c05e9dd4>] ? _spin_unlock_irqrestore+0x3c/0x48
[46680.889315]  [<c01652ba>] ? trace_hardirqs_on+0xb/0xd
[46680.889336]  [<c05e823f>] schedule+0x8/0x17
[46680.889355]  [<c01d7031>] bdi_sched_wait+0x8/0xc
[46680.889372]  [<c05e8728>] __wait_on_bit+0x36/0x5d
[46680.889389]  [<c01d7029>] ? bdi_sched_wait+0x0/0xc
[46680.889407]  [<c05e87fa>] out_of_line_wait_on_bit+0xab/0xb3
[46680.889425]  [<c01d7029>] ? bdi_sched_wait+0x0/0xc
[46680.889444]  [<c01577ae>] ? wake_bit_function+0x0/0x43
[46680.889462]  [<c01d61b6>] wait_on_bit+0x20/0x2c
[46680.889480]  [<c01d6d2e>] bdi_writeback_all+0x161/0x18e
[46680.889501]  [<c0199f63>] ? wait_on_page_writeback_range+0x9d/0xdc
[46680.889605]  [<c01d6e6f>] generic_sync_sb_inodes+0x2f/0xcc
[46680.889633]  [<c01d6f7a>] sync_inodes_sb+0x6e/0x76
[46680.889662]  [<c01c1aa0>] __fsync_super+0x63/0x66
[46680.889685]  [<c01c1aae>] fsync_super+0xb/0x19
[46680.889711]  [<c01c1d16>] generic_shutdown_super+0x1c/0xde
[46680.889737]  [<c01c1df5>] kill_block_super+0x1d/0x31
[46680.889766]  [<c01f0acd>] ? vfs_quota_off+0x0/0x12
[46680.889793]  [<c01c2350>] deactivate_super+0x57/0x6b
[46680.889824]  [<c01d217e>] mntput_no_expire+0xca/0xfb
[46680.889853]  [<c01d265b>] sys_umount+0x28f/0x2b4
[46680.889884]  [<c01d268d>] sys_oldumount+0xd/0xf
[46680.889913]  [<c011c264>] sysenter_do_call+0x12/0x38
[46680.889936] 1 lock held by umount/22890:
[46680.889950]  #0:  (&type->s_umount_key#31){++++..}, at: [<c01c234b>] deactivate_super+0x52/0x6b
[46800.889776] INFO: task umount:22890 blocked for more than 120 seconds.
[46800.889793] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[46800.889809] umount        D 00002a0d  2288 22890  19517
[46800.889836]  df5b0db8 00000046 d8a93c7f 00002a0d c0be7148 c0e5cbc8 c0163ebd c0a78700
[46800.889877]  c0a78700 df5b0d74 c0164e28 f145a980 f145abfc c2d13700 00000000 d8ad1b4f
[46800.889917]  00002a0d c0165031 00000006 f145a980 c05e9dd4 00000002 df5b0d9c f145abfc
[46800.889956] Call Trace:
[46800.889987]  [<c0163ebd>] ? lock_release_holdtime+0x30/0x131
[46800.890006]  [<c0164e28>] ? mark_lock+0x1e/0x1e4
[46800.890023]  [<c0165031>] ? mark_held_locks+0x43/0x5b
[46800.890044]  [<c05e9dd4>] ? _spin_unlock_irqrestore+0x3c/0x48
[46800.890062]  [<c01652ba>] ? trace_hardirqs_on+0xb/0xd
[46800.890083]  [<c05e823f>] schedule+0x8/0x17
[46800.890102]  [<c01d7031>] bdi_sched_wait+0x8/0xc
[46800.890119]  [<c05e8728>] __wait_on_bit+0x36/0x5d
[46800.890136]  [<c01d7029>] ? bdi_sched_wait+0x0/0xc
[46800.890153]  [<c05e87fa>] out_of_line_wait_on_bit+0xab/0xb3
[46800.890171]  [<c01d7029>] ? bdi_sched_wait+0x0/0xc
[46800.890191]  [<c01577ae>] ? wake_bit_function+0x0/0x43
[46800.890209]  [<c01d61b6>] wait_on_bit+0x20/0x2c
[46800.890227]  [<c01d6d2e>] bdi_writeback_all+0x161/0x18e
[46800.890248]  [<c0199f63>] ? wait_on_page_writeback_range+0x9d/0xdc
[46800.890268]  [<c01d6e6f>] generic_sync_sb_inodes+0x2f/0xcc
[46800.890286]  [<c01d6f7a>] sync_inodes_sb+0x6e/0x76
[46800.890306]  [<c01c1aa0>] __fsync_super+0x63/0x66
[46800.890323]  [<c01c1aae>] fsync_super+0xb/0x19
[46800.890340]  [<c01c1d16>] generic_shutdown_super+0x1c/0xde
[46800.890357]  [<c01c1df5>] kill_block_super+0x1d/0x31
[46800.890376]  [<c01f0acd>] ? vfs_quota_off+0x0/0x12
[46800.890393]  [<c01c2350>] deactivate_super+0x57/0x6b
[46800.890413]  [<c01d217e>] mntput_no_expire+0xca/0xfb
[46800.890431]  [<c01d265b>] sys_umount+0x28f/0x2b4
[46800.890451]  [<c01d268d>] sys_oldumount+0xd/0xf
[46800.890470]  [<c011c264>] sysenter_do_call+0x12/0x38
[46800.890485] 1 lock held by umount/22890:
[46800.890494]  #0:  (&type->s_umount_key#31){++++..}, at: [<c01c234b>] deactivate_super+0x52/0x6b
[46920.888925] INFO: task umount:22890 blocked for more than 120 seconds.
[46920.888943] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[46920.888959] umount        D 00002a0d  2288 22890  19517
[46920.888986]  df5b0db8 00000046 d8a93c7f 00002a0d c0be7148 c0e5cbc8 c0163ebd c0a78700
[46920.889027]  c0a78700 df5b0d74 c0164e28 f145a980 f145abfc c2d13700 00000000 d8ad1b4f
[46920.889067]  00002a0d c0165031 00000006 f145a980 c05e9dd4 00000002 df5b0d9c f145abfc
[46920.889106] Call Trace:
[46920.889137]  [<c0163ebd>] ? lock_release_holdtime+0x30/0x131
[46920.889155]  [<c0164e28>] ? mark_lock+0x1e/0x1e4
[46920.889173]  [<c0165031>] ? mark_held_locks+0x43/0x5b
[46920.889194]  [<c05e9dd4>] ? _spin_unlock_irqrestore+0x3c/0x48
[46920.889212]  [<c01652ba>] ? trace_hardirqs_on+0xb/0xd
[46920.889233]  [<c05e823f>] schedule+0x8/0x17
[46920.889252]  [<c01d7031>] bdi_sched_wait+0x8/0xc
[46920.889268]  [<c05e8728>] __wait_on_bit+0x36/0x5d
[46920.889286]  [<c01d7029>] ? bdi_sched_wait+0x0/0xc
[46920.889303]  [<c05e87fa>] out_of_line_wait_on_bit+0xab/0xb3
[46920.889321]  [<c01d7029>] ? bdi_sched_wait+0x0/0xc
[46920.889341]  [<c01577ae>] ? wake_bit_function+0x0/0x43
[46920.889359]  [<c01d61b6>] wait_on_bit+0x20/0x2c
[46920.889376]  [<c01d6d2e>] bdi_writeback_all+0x161/0x18e
[46920.889397]  [<c0199f63>] ? wait_on_page_writeback_range+0x9d/0xdc
[46920.889418]  [<c01d6e6f>] generic_sync_sb_inodes+0x2f/0xcc
[46920.889436]  [<c01d6f7a>] sync_inodes_sb+0x6e/0x76
[46920.889456]  [<c01c1aa0>] __fsync_super+0x63/0x66
[46920.889472]  [<c01c1aae>] fsync_super+0xb/0x19
[46920.889567]  [<c01c1d16>] generic_shutdown_super+0x1c/0xde
[46920.889594]  [<c01c1df5>] kill_block_super+0x1d/0x31
[46920.889623]  [<c01f0acd>] ? vfs_quota_off+0x0/0x12
[46920.889647]  [<c01c2350>] deactivate_super+0x57/0x6b
[46920.889675]  [<c01d217e>] mntput_no_expire+0xca/0xfb
[46920.889703]  [<c01d265b>] sys_umount+0x28f/0x2b4
[46920.889734]  [<c01d268d>] sys_oldumount+0xd/0xf
[46920.889762]  [<c011c264>] sysenter_do_call+0x12/0x38
[46920.889786] 1 lock held by umount/22890:
[46920.889800]  #0:  (&type->s_umount_key#31){++++..}, at: [<c01c234b>] deactivate_super+0x52/0x6b
[46920.889866] INFO: task fsstress:23920 blocked for more than 120 seconds.
[46920.889886] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[46920.889906] fsstress      D 00002a89  2032 23920  23919
[46920.889942]  e8968f20 00000046 9fb7a303 00002a89 00000000 f5815c6c e8968ed0 c0a78700
[46920.890005]  c0a78700 c0e5c7a0 e89604f0 e8960000 e896027c c2e61700 00000001 9fc1cb54
[46920.890070]  00002a89 00000000 e8960000 00000007 e8968f04 c0165031 00000006 e896027c
[46920.890133] Call Trace:
[46920.890163]  [<c0165031>] ? mark_held_locks+0x43/0x5b
[46920.890191]  [<c05e9d8f>] ? _spin_unlock_irq+0x22/0x2b
[46920.890219]  [<c016528e>] ? trace_hardirqs_on_caller+0x103/0x124
[46920.890251]  [<c05e823f>] schedule+0x8/0x17
[46920.890277]  [<c05e9a8c>] rwsem_down_failed_common+0x6d/0x84
[46920.890306]  [<c05e9ae3>] rwsem_down_read_failed+0x1d/0x26
[46920.890335]  [<c05e9b27>] call_rwsem_down_read_failed+0x7/0xc
[46920.890363]  [<c05e90e5>] ? down_read+0x5e/0x6f
[46920.890390]  [<c01d6fb6>] __sync_inodes+0x34/0x89
[46920.890418]  [<c01d7018>] sync_inodes+0xd/0x1e
[46920.890444]  [<c01d96fd>] do_sync+0x14/0x5a
[46920.890472]  [<c01d9767>] sys_sync+0xd/0x12
[46920.890498]  [<c011c264>] sysenter_do_call+0x12/0x38
[46920.890521] 1 lock held by fsstress/23920:
[46920.890535]  #0:  (&type->s_umount_key#31){++++..}, at: [<c01d6fb6>] __sync_inodes+0x34/0x89
[46920.890594] INFO: task fsstress:23921 blocked for more than 120 seconds.
[46920.890613] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[46920.890633] fsstress      D 00002a89  2212 23921  23919
[46920.890670]  f14abf20 00000046 adcb3cde 00002a89 00000000 f5815c6c f14abed0 c0a78700
[46920.890732]  c0a78700 c0e5c7a0 e8964330 e8963e40 e89640bc c2d13700 00000000 adf1f741
[46920.890796]  00002a89 00000000 e8963e40 00000007 f14abf04 c0165031 00000006 e89640bc
[46920.890858] Call Trace:
[46920.890887]  [<c0165031>] ? mark_held_locks+0x43/0x5b
[46920.890915]  [<c05e9d8f>] ? _spin_unlock_irq+0x22/0x2b
[46920.890943]  [<c016528e>] ? trace_hardirqs_on_caller+0x103/0x124
[46920.890975]  [<c05e823f>] schedule+0x8/0x17
[46920.891001]  [<c05e9a8c>] rwsem_down_failed_common+0x6d/0x84
[46920.891030]  [<c05e9ae3>] rwsem_down_read_failed+0x1d/0x26
[46920.891059]  [<c05e9b27>] call_rwsem_down_read_failed+0x7/0xc
[46920.891087]  [<c05e90e5>] ? down_read+0x5e/0x6f
[46920.891114]  [<c01d6fb6>] __sync_inodes+0x34/0x89
[46920.891142]  [<c01d7018>] sync_inodes+0xd/0x1e
[46920.891168]  [<c01d96fd>] do_sync+0x14/0x5a
[46920.891195]  [<c01d9767>] sys_sync+0xd/0x12
[46920.891221]  [<c011c264>] sysenter_do_call+0x12/0x38
[46920.891244] 1 lock held by fsstress/23921:
[46920.891258]  #0:  (&type->s_umount_key#31){++++..}, at: [<c01d6fb6>] __sync_inodes+0x34/0x89
[46920.891318] INFO: task fsstress:23922 blocked for more than 120 seconds.
[46920.891336] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[46920.891356] fsstress      D 00002a89  2508 23922  23919
[46920.891393]  e89b1f20 00000046 9f55d644 00002a89 00000000 00000001 00000001 c0a78700
[46920.891456]  c0a78700 c0e5c7a0 00962e70 e8962980 e8962bfc c2d13700 00000000 9f589dea
[46920.891522]  00002a89 00000000 e8962980 00000007 e89b1f04 c0165031 00000006 e8962bfc
[46920.891584] Call Trace:
[46920.891613]  [<c0165031>] ? mark_held_locks+0x43/0x5b
[46920.891641]  [<c05e9d8f>] ? _spin_unlock_irq+0x22/0x2b
[46920.891669]  [<c016528e>] ? trace_hardirqs_on_caller+0x103/0x124
[46920.891700]  [<c05e823f>] schedule+0x8/0x17
[46920.891727]  [<c05e9a8c>] rwsem_down_failed_common+0x6d/0x84
[46920.891756]  [<c05e9ae3>] rwsem_down_read_failed+0x1d/0x26
[46920.891785]  [<c05e9b27>] call_rwsem_down_read_failed+0x7/0xc
[46920.891812]  [<c05e90e5>] ? down_read+0x5e/0x6f
[46920.891839]  [<c01d6fb6>] __sync_inodes+0x34/0x89
[46920.891867]  [<c01d7018>] sync_inodes+0xd/0x1e
[46920.891893]  [<c01d96fd>] do_sync+0x14/0x5a
[46920.891921]  [<c01d9767>] sys_sync+0xd/0x12
[46920.891947]  [<c011c264>] sysenter_do_call+0x12/0x38
[46920.891969] 1 lock held by fsstress/23922:
[46920.891983]  #0:  (&type->s_umount_key#31){++++..}, at: [<c01d6fb6>] __sync_inodes+0x34/0x89
[46920.892038] INFO: task fsstress:23923 blocked for more than 120 seconds.
[46920.892055] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[46920.892075] fsstress      D 00002a89  2524 23923  23919
[46920.892113]  e89f8f20 00000046 9f62c022 00002a89 00000000 f5815c6c e89f8ed0 c0a78700
[46920.892176]  c0a78700 c0e5c7a0 f75299b0 f75294c0 f752973c c2e61700 00000001 9f6e75d6
[46920.892238]  00002a89 00000000 f75294c0 00000007 e89f8f04 c0165031 00000006 f752973c
[46920.892302] Call Trace:
[46920.892332]  [<c0165031>] ? mark_held_locks+0x43/0x5b
[46920.892362]  [<c05e9d8f>] ? _spin_unlock_irq+0x22/0x2b
[46920.892390]  [<c016528e>] ? trace_hardirqs_on_caller+0x103/0x124
[46920.892423]  [<c05e823f>] schedule+0x8/0x17
[46920.892450]  [<c05e9a8c>] rwsem_down_failed_common+0x6d/0x84
[46920.892478]  [<c05e9ae3>] rwsem_down_read_failed+0x1d/0x26
[46920.892507]  [<c05e9b27>] call_rwsem_down_read_failed+0x7/0xc
[46920.892535]  [<c05e90e5>] ? down_read+0x5e/0x6f
[46920.892562]  [<c01d6fb6>] __sync_inodes+0x34/0x89
[46920.892589]  [<c01d7018>] sync_inodes+0xd/0x1e
[46920.892616]  [<c01d96fd>] do_sync+0x14/0x5a
[46920.892643]  [<c01d9767>] sys_sync+0xd/0x12
[46920.892669]  [<c011c264>] sysenter_do_call+0x12/0x38
[46920.892692] 1 lock held by fsstress/23923:
[46920.892706]  #0:  (&type->s_umount_key#31){++++..}, at: [<c01d6fb6>] __sync_inodes+0x34/0x89
[46920.892765] INFO: task fsstress:23924 blocked for more than 120 seconds.
[46920.892784] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[46920.892804] fsstress      D 00002a89  2472 23924  23919
[46920.892911]  f1495f20 00000046 a24d3c01 00002a89 00000000 f5815c6c f1495ed0 c0a78700
[46920.892977]  c0a78700 c0e5c7a0 f5994330 f5993e40 f59940bc c2e61700 00000001 a287d873
[46920.893039]  00002a89 00000000 f5993e40 00000007 f1495f04 c0165031 00000006 f59940bc
[46920.893101] Call Trace:
[46920.893132]  [<c0165031>] ? mark_held_locks+0x43/0x5b
[46920.893161]  [<c05e9d8f>] ? _spin_unlock_irq+0x22/0x2b
[46920.893189]  [<c016528e>] ? trace_hardirqs_on_caller+0x103/0x124
[46920.893219]  [<c05e823f>] schedule+0x8/0x17
[46920.893247]  [<c05e9a8c>] rwsem_down_failed_common+0x6d/0x84
[46920.893276]  [<c05e9ae3>] rwsem_down_read_failed+0x1d/0x26
[46920.893307]  [<c05e9b27>] call_rwsem_down_read_failed+0x7/0xc
[46920.893333]  [<c05e90e5>] ? down_read+0x5e/0x6f
[46920.893361]  [<c01d6fb6>] __sync_inodes+0x34/0x89
[46920.893388]  [<c01d7018>] sync_inodes+0xd/0x1e
[46920.893416]  [<c01d96fd>] do_sync+0x14/0x5a
[46920.893442]  [<c01d9767>] sys_sync+0xd/0x12
[46920.893470]  [<c011c264>] sysenter_do_call+0x12/0x38
[46920.893492] 1 lock held by fsstress/23924:
[46920.893508]  #0:  (&type->s_umount_key#31){++++..}, at: [<c01d6fb6>] __sync_inodes+0x34/0x89
