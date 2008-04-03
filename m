Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbYDCQMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbYDCQMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 12:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbYDCQLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 12:11:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbYDCQLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 12:11:54 -0400
Date: Thu, 3 Apr 2008 13:15:00 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jan Kara <jack@suse.cz>, David Chinner <dgc@sgi.com>,
       lkml <linux-kernel@vger.kernel.org>, marcelo <marcelo@kvack.org>
Subject: Re: BUG: ext3 hang in transaction commit
Message-ID: <20080403161500.GA21434@dmt>
References: <20080326231612.GC103491721@sgi.com> <20080403100742.GA16314@atrey.karlin.mff.cuni.cz> <1207235335.8514.843.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207235335.8514.843.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 05:08:55PM +0200, Peter Zijlstra wrote:
> 
> Marcelo has seen something similar, kjournald got stuck and the rest of
> userspace piled on top of it.
> 
> The softlockup watchdog triggered because kjournald got stuck in D state
> for over 2 minutes. However Marcelo told me that it did get going
> eventually...
> 
> He had a rather easy to reproduce case IIRC, I'll let him tell you more
> about it :-)

Run iozone (-t 4) with a sufficiently large file size under a KVM guest
with a disk file residing in an ext3 filesystem with ordered data mode.

There's nothing special in this testcase, boils down to the QEMU process
writing data to a file.

Issue is not seen under "writeback" mode. While fsync latency in ordered
data mode is known to be bad, _2 minutes_ feels more like a DoS rather
than latency issue to me.

vmstat 2 output on the host shows that the first write pass (initial
writers and rewriters) blasts at full disk speed:

 0  2      0 6552980 748972 662876    0    0    58 69838  322 9912  5  6 78 10  0
 1  1      0 6493620 779452 693596    0    0    10 54884  417 7032  1  3 78 17  0
 1  2      0 6322968 870556 772156    0    0    58 43042  379 12651  4  7 77 12  0
 1  1      0 6248416 915004 806428    0    0    20 37600  367 7800  2  4 71 23  0
 1  0      0 5981148 1070300 906120    0    0    88    64  243 19734  8 10 80  1  0
 0  4      0 5875992 1165220 906700    0    0    80 62620  332 13192  5  7 76 13  0
 0  4      0 5867244 1177440 906724    0    0    10 66728  385 2753  1  2 66 31  0
 0  2      0 5792912 1252668 907900    0    0    86 26288  401 12130  4  6 72 18  0
 2  0      0 5760280 1290860 908092    0    0    18 34704  487 7130  2  3 80 15  0

But in the "mixed workload" stage write throughtput slows down drastically:

 0  2      0 5666016 468036 1823052    0    0     0  1248  433 8236  5  5 83  7  0
 0  2      0 5666016 468036 1823052    0    0     0  3162  899  679  0  0 78 22  0
 0  2      0 5666016 468036 1823052    0    0     0  3290  864  829  0  0 76 24  0
 0  2      0 5666024 468036 1823052    0    0     0  3414  925 2170  1  1 79 19  0
 1  1      0 5665528 468036 1823052    0    0     0  3148  854 7935  6  6 83  4  0
 0  2      0 5665024 468036 1823052    0    0     0  2570  799 4065  3  4 80 13  0
 0  2      0 5665024 468036 1823052    0    0     0  2462  779  464  0  0 88 12  0
 0  2      0 5664908 468036 1823052    0    0     0  2458  794 1028  0  0 88 12  0
 1  1      0 5664908 468036 1823052    0    0     0  2548  799 4153  2  2 87  9  0

Which can be seen in the iozone performance inside the guest:

        Children see throughput for 4 mixed workload    =  106073.50 KB/sec
        Parent sees throughput for 4 mixed workload     =    2560.13 KB/sec
        Min throughput per process                      =    3700.33 KB/sec
        Max throughput per process                      =   66393.62 KB/sec
        Avg throughput per process                      =   26518.38 KB/sec
        Min xfer                                        =   44424.00 KB

And this is when fsync becomes nasty.

blktrace output shows that the maximum latency for a single write
request io complete is 1.5 seconds, which is similar to what is seen
under "writeback" mode.

I reduced hung_task_timeout_secs to 30 for this report, but vim and
rsyslogd have been seen hung up to 120 seconds.

INFO: task vim:4476 blocked for more than 30 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
vim           D 00000001000e3c44     0  4476   3591
 ffff8101da80dd28 0000000000000046 0000000000000000 00000000001cc549
 ffff8101fe1e8a00 ffff81022f20e740 ffff8101fe1e8c30 0000000600000246
 00000000ffffffff 0000000000000246 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8030985b>] log_wait_commit+0xa9/0xfe
 [<ffffffff80242347>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff80304c19>] journal_stop+0x1a4/0x1ed
 [<ffffffff803056c6>] journal_force_commit+0x23/0x25
 [<ffffffff802fe337>] ext3_force_commit+0x26/0x28
 [<ffffffff802f8756>] ext3_write_inode+0x39/0x3f
 [<ffffffff802a58e9>] __writeback_single_inode+0x18c/0x2ab
 [<ffffffff802a5a2c>] sync_inode+0x24/0x39
 [<ffffffff802f4baf>] ext3_sync_file+0x8f/0xa0
 [<ffffffff802a892d>] do_fsync+0x56/0xac
 [<ffffffff802a89b1>] __do_fsync+0x2e/0x44
 [<ffffffff802a89e2>] sys_fsync+0xb/0xd
 [<ffffffff8020b21b>] system_call_after_swapgs+0x7b/0x80

2 locks held by vim/4476:
 #0:  (&sb->s_type->i_mutex_key#9){--..}, at: [<ffffffff802a891c>] do_fsync+0x45/0xac
 #1:  (jbd_handle){--..}, at: [<ffffffff8030567c>] journal_start+0xef/0x116

2 locks held by rsyslogd/3266:
 #0:  (&sb->s_type->i_mutex_key#9){--..}, at: [<ffffffff802a891c>] do_fsync+0x45/0xac
 #1:  (jbd_handle){--..}, at: [<ffffffff8030567c>] journal_start+0xef/0x116
INFO: task rklogd:3269 blocked for more than 30 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rklogd        D 00000001000fbb55     0  3269      1
 ffff8102280b9d28 0000000000000046 0000000000000000 00000000001cc553
 ffff81022d9b0b40 ffff81022f196540 ffff81022d9b0d70 0000000400000246
 00000000ffffffff 0000000000000246 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8030985b>] log_wait_commit+0xa9/0xfe
 [<ffffffff80242347>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff80304c19>] journal_stop+0x1a4/0x1ed
 [<ffffffff803056c6>] journal_force_commit+0x23/0x25
 [<ffffffff802fe337>] ext3_force_commit+0x26/0x28
 [<ffffffff802f8756>] ext3_write_inode+0x39/0x3f
 [<ffffffff802a58e9>] __writeback_single_inode+0x18c/0x2ab
 [<ffffffff802a5a2c>] sync_inode+0x24/0x39
 [<ffffffff802f4baf>] ext3_sync_file+0x8f/0xa0
 [<ffffffff802a892d>] do_fsync+0x56/0xac
 [<ffffffff802a89b1>] __do_fsync+0x2e/0x44
 [<ffffffff802a89e2>] sys_fsync+0xb/0xd
 [<ffffffff8020b21b>] system_call_after_swapgs+0x7b/0x80


qemu-system-x D 00000001000c1809     0  4359   4356
 ffff8102111fd838 0000000000000046 0000000000000000 0000000000000046
 ffff81021101c080 ffff81022f196540 ffff81021101c2b0 0000000400000002
 00000000ffffffff ffffffff8024bc0b 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8024bc0b>] ? mark_held_locks+0x4a/0x6a
 [<ffffffff805593d1>] io_schedule+0x28/0x34
 [<ffffffff803596dc>] get_request_wait+0x122/0x170
 [<ffffffff8055b685>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffff80242347>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff80357872>] ? elv_merge+0x1df/0x221
 [<ffffffff80359d27>] __make_request+0x33e/0x3dd
 [<ffffffff80245115>] ? up_read+0x26/0x2a
 [<ffffffff803585ad>] generic_make_request+0x33c/0x377
 [<ffffffff802626f3>] ? mempool_alloc_slab+0x11/0x13
 [<ffffffff803599e0>] submit_bio+0xce/0xd7
 [<ffffffff802a970e>] submit_bh+0xea/0x10e
 [<ffffffff802aca88>] sync_dirty_buffer+0x6e/0xd3
 [<ffffffff80305e90>] journal_dirty_data+0xeb/0x1ce
 [<ffffffff802f6805>] ext3_journal_dirty_data+0x18/0x41
 [<ffffffff802f5b74>] walk_page_buffers+0x67/0x8e
 [<ffffffff802f67ed>] ? ext3_journal_dirty_data+0x0/0x41
 [<ffffffff802f84ad>] ext3_ordered_write_end+0x73/0x110
 [<ffffffff8026117d>] generic_file_buffered_write+0x1c2/0x63f
 [<ffffffff8024bda1>] ? trace_hardirqs_on+0xf1/0x115
 [<ffffffff80233eed>] ? current_fs_time+0x22/0x29
 [<ffffffff80261953>] __generic_file_aio_write_nolock+0x359/0x3c3
 [<ffffffff80249d4d>] ? debug_mutex_free_waiter+0x46/0x4a
 [<ffffffff80261a23>] generic_file_aio_write+0x66/0xc2
 [<ffffffff802f4a1e>] ext3_file_write+0x1e/0x9e
 [<ffffffff80289912>] do_sync_write+0xe2/0x126
 [<ffffffff80242347>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8024c6fa>] ? __lock_acquire+0x4e0/0xc0e
 [<ffffffff80246881>] ? getnstimeofday+0x31/0x88
 [<ffffffff8028a09b>] vfs_write+0xae/0x137
 [<ffffffff8028a6f9>] sys_pwrite64+0x55/0x76
 [<ffffffff8020b21b>] system_call_after_swapgs+0x7b/0x80


kjournald     D 00000001000d0612     0  1252      2
 ffff81022c66fcf0 0000000000000046 0000000000000000 ffff81022c4b6280
 ffff81022e90e2c0 ffff81022f196540 ffff81022e90e4f0 000000042c66fd80
 00000000ffffffff ffffffff8805d272 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff8805d272>] ? :dm_mod:dm_unplug_all+0x2d/0x31
 [<ffffffff805593d1>] io_schedule+0x28/0x34
 [<ffffffff802aa7e1>] sync_buffer+0x3e/0x42
 [<ffffffff8055962e>] __wait_on_bit+0x45/0x77
 [<ffffffff802aa7a3>] ? sync_buffer+0x0/0x42
 [<ffffffff802aa7a3>] ? sync_buffer+0x0/0x42
 [<ffffffff805596ce>] out_of_line_wait_on_bit+0x6e/0x7b
 [<ffffffff8024237f>] ? wake_bit_function+0x0/0x2a
 [<ffffffff802aa72b>] __wait_on_buffer+0x1f/0x21
 [<ffffffff80306a02>] journal_commit_transaction+0x516/0xe70
 [<ffffffff8055b685>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffff8024bda1>] ? trace_hardirqs_on+0xf1/0x115

As Peter mentioned it eventually gets out of this state (after several minutes) and fsync
instances complete.


