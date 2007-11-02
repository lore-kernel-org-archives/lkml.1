Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbXKBMBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbXKBMBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 08:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbXKBMBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 08:01:44 -0400
Received: from users.jesse.de ([62.206.119.132]:51211 "EHLO users.jesse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbXKBMBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 08:01:41 -0400
X-Greylist: delayed 1638 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2007 08:01:40 EDT
Date: Fri, 2 Nov 2007 12:33:47 +0100
To: linux-kernel@vger.kernel.org
Subject: Re: Strange system hangs
Message-ID: <20071102113347.GA30477@jesse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
From: Thomas Osterried <osterried@jesse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This report tends to become a novel. In short, the most important facts:
  - after some days uptime, suddenly a process like rsync is in
    a write congestion; other processes follow.
  - balance_dirty_pages_ratelimited_nr Problem
  - great amount of dirty pages
  - processes do not terminate and cause a heavy load
  - process accounting, even though not enabled?


We have serious problems on some servers running kernel 2.6.19 and up.
The thread
  http://marc.info/?l=linux-kernel&m=119252148829463&w=2
matches exactly our problem. In particular, the
balance_dirty_pages_ratelimited_nr problem in Krzysztof Oledzki's trace.

It seems to be the same problem like in
  http://marc.info/?l=linux-kernel&m=119125485615927&w=2
which may be fixed by this patch for 2.6.23-git
  http://marc.info/?l=git-commits-head&m=119263941428270&w=2
but may differ, because
  - we do not have any nfs, loop or fuse mounts
  - it's regarded as speed issue which resovles in seconds but not hours



We have observed that the problem occurs within about 10 days,
(but one kernel version showed it within 24h on the same machine).
For some machines it takes one or two months for the problem to come up.
But we also have machines (comparable setup, same linux installation
(debian sarge), same kernel config, completely different hardware) running
kernel 2.6.20 where it does not emerge.
We also have machines running kernel <= 2.6.18 which never showed the problem.
Our kernel config always derived from previous kernels.
Our kernel is vanilla and comes from ftp.kernel.org. But for a test,
we also tried kernel 2.6.20-16 from ubuntu, which also showed the problem.
Of course, we have tried the kernel without commercial modules (not tainted).

Unfortunately we could not force the error to happen (we have to wait).
And very interestingly, we completely exchanged all hardware components
(taken from a machine where the bug did not happen) and the unstable
server still left unstable.

We observe that the dirty pages count increases (/prov/vmstat) and
/proc/meminfo shows an amount of 400 MB (!) when the problem appears.
It's mostly during the backup process (rsync). But we also had the
failure when backup was turned off; we just had to wait longer for it
to happen; rsync seems to be a catalysator for the problem.

When the error occurs, then processes do not terminate: they try to exit,
but still remain in the process list. The machine is powerful, and thus
even if the load is above 500, the program itself is fast and responsive,
and after the last expectet lines of a program (i.e. "uptime") it does not
terminate and remains in 'D' state.
When killing the "rsync" process (or / and others), the machine may recover.
Or if we have time to wait (we usually have not), the lock resolves after
several hours. In a test we "waited" 14 hours. The number of dirty pages
decreases from 400 MB to <100 MB.
We observed, that after the machine has run into trouble (i.e. after 10
days troubleless uptime), it then always shows this error on the daily rsync
backup.

Diagnostics:
with "echo t > /proc/sysrq-trigger" we see, that many processes hang in a
mutex_lock after ext3_file_write(). Some of these are in congestion_wait()
after balance_dirty_pages_ratelimited_nr() after ext3_file_write().
We could not enforce this long time deadlock by hand. But it's obvoiously
the same (due to the call trace) because we can trigger a short-time
with multible concurrent "dd if=/dev/zero of=foo bs=4000k" processes.

I could only speculate if the non-terminating processes cause or tighten
the problem, or if they're just the cause of process accounting (see
below) which is also in wait state for writing the data to a file.

Nevertheless the sysrq-trigger method allowed us to see what causes
terminating processes to wait in their exit()-call:
do_group_exit() calls do_exit() which calls acct_process(). acct_process()
does a do_sync_write() which hangs in a mutex_lock.

If we boot a machine, then enable process accounting (acct(2)) and 
then do the file-I/O tests mentioned above, we have the same effect of
non-terminating processes, and the sysrq-trigger result corresponds. They
terminate after some outstanding blocks from "dd" are written.
If process accounting is off, the kernel does not call acct_process() (tested),
which is expected.

Ok, this explains the many non-terminating processes and the load.
But it raises another question. We do not have and do not need process
accounting and we do not even have installed the accton tools.
Thus, why does the buggy machine calls acct_process() during the exit
of processes?

Unfortunately, the kernel has no fence (/sys would be nice) for looking if
the process accounting is really on, and if, to which file it actually writes.
For the next error, which we tensly await to happen, we are prepared to:
  - force process-accounting off with call acct(0) and examine the output
    of sysrq-trigger
  - install a patched kernel which gives us the opportunity to see if 
    process accounting is on and to which file it writes


Thank you for reading this. Even if it rises more questions than answers,
i'd deeply appreciate to hear from other readers if i'm almost alone with
these problems.

Kindly regards,

	- Thomas Osterried


Appendix I: "t > sysreq" data (excerpt) on hanging machine,
            high load, hanging processes on exit, process accounting not
	    switched on
------------------------------------------------------------------------
[1042634.288264]  [unfortunately cut off]
[1042634.288264]  [<c02f48ca>] mutex_lock+0xa/0x10
[1042634.288291]  [<c0159872>] generic_file_aio_write+0x42/0xd0
[1042634.288326]  [<f8a4c5c0>] ext3_file_write+0x30/0xc0 [ext3]
[1042634.288363]  [<c0177845>] do_sync_write+0xd5/0x120
[1042634.288397]  [<c013b370>] autoremove_wake_function+0x0/0x50
[1042634.288429]  [<c015be8f>] __pagevec_free+0x1f/0x30
[1042634.288459]  [<c0108eb6>] read_tsc+0x6/0x10
[1042634.288486]  [<c012f906>] getnstimeofday+0x36/0xc0
[1042634.288517]  [<c014b7ca>] do_acct_process+0x36a/0x5a0
[1042634.288550]  [<c015be8f>] __pagevec_free+0x1f/0x30
[1042634.288578]  [<c015e89b>] release_pages+0x13b/0x170
[1042634.288610]  [<c01739f9>] cache_flusharray+0x29/0xd0
[1042634.288647]  [<c014bce4>] acct_process+0x34/0x50
[1042634.288676]  [<c0129c0d>] do_exit+0x59d/0x800
[1042634.288703]  [<c02f76a3>] do_page_fault+0x3b3/0x6b0
[1042634.288732]  [<c0178c6f>] __fput+0x10f/0x170
[1042634.288763]  [<c0129e96>] do_group_exit+0x26/0x80
[1042634.288792]  [<c0103238>] syscall_call+0x7/0xb
[1042634.288822]  [<c02f0033>] clip_neigh_solicit+0x3/0x20
[1042634.288853]  =======================
[1042634.288877] exim4         D DC095E48     0 15069  15052                     (NOTLB)
[1042634.288932]        dc095e5c 00000082 00000002 dc095e48 dc095e44 00000000 c018c1fe dfcd3c00 
[1042634.288977]        00000000 00000000 a70fd52a 00000007 c459100f 00000007 c2206560 bb2a3a16 
[1042634.289038]        0003b424 0003e821 c220666c c200c640 00000000 f7dc75b8 c20fc8c0 00000005 
[1042634.289099] Call Trace:
[1042634.289138]  [<c018c1fe>] touch_atime+0x9e/0x110
[1042634.289174]  [<c02f4a73>] __mutex_lock_slowpath+0x53/0x90
[1042634.289205]  [<c02f48ca>] mutex_lock+0xa/0x10
[1042634.289233]  [<c0159872>] generic_file_aio_write+0x42/0xd0
[1042634.289263]  [<c0165073>] __handle_mm_fault+0x6c3/0xe50
[1042634.289297]  [<f8a4c5c0>] ext3_file_write+0x30/0xc0 [ext3]
[1042634.289334]  [<c0177845>] do_sync_write+0xd5/0x120
[1042634.289367]  [<c013b370>] autoremove_wake_function+0x0/0x50
[1042634.289404]  [<c017817e>] vfs_write+0xbe/0x180
[1042634.289432]  [<c0177770>] do_sync_write+0x0/0x120
[1042634.289460]  [<c01788e1>] sys_write+0x41/0x70
[1042634.289489]  [<c0103238>] syscall_call+0x7/0xb
[1042634.289519]  [<c02f0033>] clip_neigh_solicit+0x3/0x20
[1042634.289550]  =======================
[1042634.289574] exim4         D C70F6E58     0 15071  15067                     (NOTLB)
[1042634.289629]        cca45e5c 00000086 00000101 c70f6e58 e1748240 00000000 c018c1fe 472661fc 
[1042634.289674]        00000000 00000000 a70fd52a 00000007 c459100f 00000007 cb5c6a90 c41ab6d5 
[1042634.289735]        0003b424 00035539 cb5c6b9c c200c640 00000000 f7dc75b8 c20fc8c0 00000005 
[1042634.289796] Call Trace:
[1042634.289834]  [<c018c1fe>] touch_atime+0x9e/0x110
[1042634.289868]  [<c0157580>] find_get_page+0x20/0x60
[1042634.289898]  [<c02f4a73>] __mutex_lock_slowpath+0x53/0x90
[1042634.289930]  [<c02f48ca>] mutex_lock+0xa/0x10
[1042634.289957]  [<c0159872>] generic_file_aio_write+0x42/0xd0
[1042634.289987]  [<c0165073>] __handle_mm_fault+0x6c3/0xe50
[1042634.290020]  [<f8a4c5c0>] ext3_file_write+0x30/0xc0 [ext3]
[1042634.290057]  [<c0177845>] do_sync_write+0xd5/0x120
[1042634.290090]  [<c013b370>] autoremove_wake_function+0x0/0x50
[1042634.290127]  [<c017817e>] vfs_write+0xbe/0x180
[1042634.290155]  [<c0177770>] do_sync_write+0x0/0x120
[1042634.291921]  [<c01788e1>] sys_write+0x41/0x70
[1042634.291949]  [<c0103238>] syscall_call+0x7/0xb
[1042634.291979]  [<c02f0033>] clip_neigh_solicit+0x3/0x20
[1042634.292010]  =======================
[1042634.292034] exim4         D 00000080     0 15076   5768         15115       (NOTLB)
[1042634.292089]        da21dcac 00000086 00000003 00000080 c200d000 00000002 00000000 00000086 
[1042634.292134]        f8848491 c15987c0 657c1dcf 0003b42c d6cb8860 00000009 c225ca90 31a1a8ed 
[1042634.292195]        0003b445 00000872 c225cb9c c200c640 00000000 00000282 c01308a0 da21dcbc 
[1042634.292256] Call Trace:
[1042634.292295]  [<f8848491>] scsi_finish_command+0x51/0xa0 [scsi_mod]
[1042634.292341]  [<c01308a0>] lock_timer_base+0x20/0x50
[1042634.292371]  [<c01309d8>] __mod_timer+0x98/0xb0
[1042634.292400]  [<c02f460a>] schedule_timeout+0x4a/0xc0
[1042634.292430]  [<c0130030>] process_timeout+0x0/0x10
[1042634.292459]  [<c02f3f83>] io_schedule_timeout+0x23/0x30
[1042634.292489]  [<c01622d7>] congestion_wait+0x77/0xa0
[1042634.292518]  [<c013b370>] autoremove_wake_function+0x0/0x50
[1042634.292550]  [<c015d598>] balance_dirty_pages_ratelimited_nr+0x118/0x1d0
[1042634.292594]  [<c0158f25>] generic_file_buffered_write+0x3c5/0x6c0
[1042634.292632]  [<c0281c93>] __alloc_skb+0x53/0x110
[1042634.292661]  [<c012b330>] current_fs_time+0x50/0x60
[1042634.292695]  [<c015950d>] __generic_file_aio_write_nolock+0x2ed/0x610
[1042634.292733]  [<c027d5e7>] sock_common_recvmsg+0x47/0x70
[1042634.292764]  [<c027b05f>] sock_aio_read+0x11f/0x130
[1042634.292794]  [<c0159885>] generic_file_aio_write+0x55/0xd0
[1042634.292825]  [<f8a560d4>] __ext3_journal_stop+0x24/0x50 [ext3]
[1042634.292865]  [<f8a4c5c0>] ext3_file_write+0x30/0xc0 [ext3]
[1042634.292901]  [<c0177845>] do_sync_write+0xd5/0x120
[1042634.292930]  [<c0108eb6>] read_tsc+0x6/0x10
[1042634.292957]  [<c012f906>] getnstimeofday+0x36/0xc0
[1042634.292990]  [<c013b370>] autoremove_wake_function+0x0/0x50
[1042634.293022]  [<c013df0d>] __remove_hrtimer+0x1d/0x40
[1042634.293051]  [<c013e483>] hrtimer_try_to_cancel+0x33/0x50
[1042634.293081]  [<c012a556>] do_setitimer+0xf6/0x4a0
[1042634.293112]  [<c017817e>] vfs_write+0xbe/0x180
[1042634.293140]  [<c0177770>] do_sync_write+0x0/0x120
[1042634.293170]  [<c01788e1>] sys_write+0x41/0x70
[1042634.293199]  [<c0103238>] syscall_call+0x7/0xb
[1042634.293229]  [<c02f0033>] clip_neigh_solicit+0x3/0x20
[1042634.293260]  =======================
[1042634.293284] rsmtp         D 0000008F     0 15081  15046                     (NOTLB)
[1042634.293338]        ddf9bcac 00000082 00000003 0000008f c200d000 00000002 00000000 c2015598 
[1042634.293383]        c2015540 00000002 519d1133 0003b43e df834000 00000007 f6401030 31a1e144 
[1042634.293444]        0003b445 00000811 f640113c c200c640 00000000 00000282 c01308a0 ddf9bcbc 
[1042634.293506] Call Trace:
[1042634.293549]  [<c01308a0>] lock_timer_base+0x20/0x50
[1042634.293579]  [<c01309d8>] __mod_timer+0x98/0xb0
[1042634.293608]  [<c02f460a>] schedule_timeout+0x4a/0xc0
[1042634.293638]  [<c0130030>] process_timeout+0x0/0x10
[1042634.293668]  [<c02f3f83>] io_schedule_timeout+0x23/0x30
[1042634.293697]  [<c01622d7>] congestion_wait+0x77/0xa0
[1042634.293726]  [<c013b370>] autoremove_wake_function+0x0/0x50
[1042634.293758]  [<c015d598>] balance_dirty_pages_ratelimited_nr+0x118/0x1d0
[1042634.293796]  [<c0158f25>] generic_file_buffered_write+0x3c5/0x6c0
[1042634.293832]  [<c015e182>] blockable_page_cache_readahead+0x72/0xd0
[1042634.293864]  [<c015e259>] make_ahead_window+0x79/0xc0
[1042634.293894]  [<c012b330>] current_fs_time+0x50/0x60
[1042634.293926]  [<c015950d>] __generic_file_aio_write_nolock+0x2ed/0x610
[1042634.293968]  [<c0159885>] generic_file_aio_write+0x55/0xd0
[1042634.293998]  [<c01573e0>] file_read_actor+0x0/0xf0
[1042634.294029]  [<f8a4c5c0>] ext3_file_write+0x30/0xc0 [ext3]
[1042634.294066]  [<c0177845>] do_sync_write+0xd5/0x120
[1042634.294094]  [<c0108eb6>] read_tsc+0x6/0x10
[1042634.294121]  [<c012f906>] getnstimeofday+0x36/0xc0
[1042634.294153]  [<c013b370>] autoremove_wake_function+0x0/0x50
[1042634.294185]  [<c013df0d>] __remove_hrtimer+0x1d/0x40
[1042634.294214]  [<c013e483>] hrtimer_try_to_cancel+0x33/0x50
[1042634.294248]  [<c017817e>] vfs_write+0xbe/0x180
[1042634.294275]  [<c0177770>] do_sync_write+0x0/0x120
[1042634.294304]  [<c01788e1>] sys_write+0x41/0x70
[1042634.294333]  [<c0103238>] syscall_call+0x7/0xb
[1042634.294363]  [<c02f0033>] clip_neigh_solicit+0x3/0x20
[1042634.294394]  =======================
[1042634.294418] exim4         D C70F6E58     0 15083  15070                     (NOTLB)
[1042634.294473]        e037be5c 00000082 00000101 c70f6e58 e1748240 00000000 c018c1fe 472661fc 
[1042634.294518]        00000000 00000000 a70fd52a 00000007 c459100f 00000007 f6f27560 d7c5bc15 
[1042634.294578]        0003b424 000362cf f6f2766c c200c640 00000000 f7dc75b8 c20fc8c0 00000005 
[1042634.294639] Call Trace:
[1042634.294678]  [<c018c1fe>] touch_atime+0x9e/0x110
[1042634.294712]  [<c0157580>] find_get_page+0x20/0x60
[1042634.294742]  [<c02f4a73>] __mutex_lock_slowpath+0x53/0x90
[1042634.294774]  [<c02f48ca>] mutex_lock+0xa/0x10
[1042634.294801]  [<c0159872>] generic_file_aio_write+0x42/0xd0
[1042634.294831]  [<c0165073>] __handle_mm_fault+0x6c3/0xe50
[1042634.294864]  [<f8a4c5c0>] ext3_file_write+0x30/0xc0 [ext3]
[1042634.294901]  [<c0177845>] do_sync_write+0xd5/0x120
[1042634.294934]  [<c013b370>] autoremove_wake_function+0x0/0x50
[1042634.294971]  [<c017817e>] vfs_write+0xbe/0x180
[1042634.294999]  [<c0177770>] do_sync_write+0x0/0x120
[1042634.295028]  [<c01788e1>] sys_write+0x41/0x70
[1042634.295057]  [<c0103238>] syscall_call+0x7/0xb
[1042634.295086]  [<c02f0033>] clip_neigh_solicit+0x3/0x20
[1042634.295117]  =======================
[1042634.295141] uux           D E23F3C98     0 15085  15084         15086       (NOTLB)
[1042634.295196]        e23f3cac 00000082 00000002 e23f3c98 e23f3c94 00000000 c16ca3a0 c16d6340 
[1042634.295242]        c122ba00 c1127a40 f0ac583c 0003b419 c13f5900 00000007 c428f030 32d5da09 
[1042634.295302]        0003b445 000008fd c428f13c c2014640 00000001 00000286 c01308a0 e23f3cbc 
[1042634.295363] Call Trace:
[1042634.295407]  [<c01308a0>] lock_timer_base+0x20/0x50
[1042634.295436]  [<c01309d8>] __mod_timer+0x98/0xb0
[1042634.295465]  [<c02f460a>] schedule_timeout+0x4a/0xc0
[1042634.295495]  [<c011007b>] acpi_unmap_lsapic+0x2b/0x70
[1042634.295524]  [<c0130030>] process_timeout+0x0/0x10
[1042634.295554]  [<c02f3f83>] io_schedule_timeout+0x23/0x30
[1042634.295584]  [<c01622d7>] congestion_wait+0x77/0xa0
[1042634.295613]  [<c013b370>] autoremove_wake_function+0x0/0x50
[1042634.295644]  [<c015d598>] balance_dirty_pages_ratelimited_nr+0x118/0x1d0
[1042634.295682]  [<c0158f25>] generic_file_buffered_write+0x3c5/0x6c0
[1042634.295718]  [<f8a4e1b9>] ext3_mark_inode_dirty+0x29/0x40 [ext3]
[1042634.295757]  [<f8a560d4>] __ext3_journal_stop+0x24/0x50 [ext3]
[1042634.295795]  [<c0194dbc>] __mark_inode_dirty+0x5c/0x190
[1042634.295828]  [<c015950d>] __generic_file_aio_write_nolock+0x2ed/0x610
[1042634.295869]  [<c0159885>] generic_file_aio_write+0x55/0xd0
[1042634.295899]  [<c01573e0>] file_read_actor+0x0/0xf0
[1042634.295930]  [<f8a4c5c0>] ext3_file_write+0x30/0xc0 [ext3]
[1042634.295966]  [<c0177845>] do_sync_write+0xd5/0x120
[1042634.296000]  [<c013b370>] autoremove_wake_function+0x0/0x50
[1042634.296031]  [<c02f367b>] __sched_text_start+0x2fb/0xa80
[1042634.296066]  [<c017817e>] vfs_write+0xbe/0x180
[1042634.296093]  [<c0177770>] do_sync_write+0x0/0x120
[1042634.296122]  [<c01788e1>] sys_write+0x41/0x70
[1042634.296151]  [<c0103238>] syscall_call+0x7/0xb
[1042634.296184]  =======================
[1042634.296207] exim4         D C70F6E58     0 15087  15080                     (NOTLB)
[1042634.296262]        c6ca3e5c 00000086 00000101 c70f6e58 e1748240 00000000 c018c1fe dfcd3c00 
[1042634.296308]        00000000 00000000 f7f523eb 0003b424 c459100f 0000000a f751b030 f7f523eb 
[1042634.296369]        0003b424 0003970f f751b13c c200c640 00000000 00039d61 00000000 00000005 
[1042634.296429] Call Trace:
[1042634.296468]  [<c018c1fe>] touch_atime+0x9e/0x110
[1042634.296502]  [<c0157580>] find_get_page+0x20/0x60
[1042634.296532]  [<c02f4a73>] __mutex_lock_slowpath+0x53/0x90
[1042634.296564]  [<c02f48ca>] mutex_lock+0xa/0x10
[1042634.296591]  [<c0159872>] generic_file_aio_write+0x42/0xd0
[1042634.296621]  [<c0165073>] __handle_mm_fault+0x6c3/0xe50
[1042634.296655]  [<f8a4c5c0>] ext3_file_write+0x30/0xc0 [ext3]
[1042634.296692]  [<c0177845>] do_sync_write+0xd5/0x120
[1042634.296725]  [<c013b370>] autoremove_wake_function+0x0/0x50
[1042634.296762]  [<c017817e>] vfs_write+0xbe/0x180
[1042634.296790]  [<c0177770>] do_sync_write+0x0/0x120
[1042634.296819]  [<c01788e1>] sys_write+0x41/0x70
[1042634.296847]  [<c0103238>] syscall_call+0x7/0xb
[1042634.296877]  [<c02f0033>] clip_neigh_solicit+0x3/0x20
[1042634.296908]  =======================
[1042634.296932] exim4         D C70F6E58     0 15088  15078                     (NOTLB)
[1042634.296987]        ddc05e5c 00000086 00000101 c70f6e58 e17480c0 00000000 c018c1fe 472661fd 
[1042634.297032]        00000000 00000000 a70fd52a 00000007 c459100f 0000000a db816560 f7f79156 
[1042634.297093]        0003b424 00026d6b db81666c c200c640 00000000 f7dc75b8 c20fc8c0 00000005 
[1042634.297154] Call Trace:
[1042634.297193]  [<c018c1fe>] touch_atime+0x9e/0x110
[1042634.297227]  [<c0157580>] find_get_page+0x20/0x60
[1042634.297257]  [<c02f4a73>] __mutex_lock_slowpath+0x53/0x90
[1042634.297289]  [<c02f48ca>] mutex_lock+0xa/0x10
[1042634.297316]  [<c0159872>] generic_file_aio_write+0x42/0xd0
[1042634.297346]  [<c0165073>] __handle_mm_fault+0x6c3/0xe50
[1042634.297380]  [<f8a4c5c0>] ext3_file_write+0x30/0xc0 [ext3]
[1042634.297416]  [<c0177845>] do_sync_write+0xd5/0x120
[1042634.299201]  [<c013b370>] autoremove_wake_function+0x0/0x50
[1042634.299238]  [<c017817e>] vfs_write+0xbe/0x180
[1042634.299266]  [<c0177770>] do_sync_write+0x0/0x120
[1042634.299295]  [<c01788e1>] sys_write+0x41/0x70
[1042634.299324]  [<c0103238>] syscall_call+0x7/0xb
[1042634.299354]  [<c02f0033>] clip_neigh_solicit+0x3/0x20
[1042634.299385]  =======================
[1042634.299408] exim4         D EAB7FE48     0 15090  15089                     (NOTLB)
[1042634.299463]        eab7fe5c 00000086 00000002 eab7fe48 eab7fe44 00000000 c018c1fe 472661fd 
[1042634.299508]        00000000 00000000 a70fd52a 00000007 c459100f 0000000a f6cffa90 0642c74f 
[1042634.299569]        0003b425 000367bc f6cffb9c c200c640 00000000 f7dc75b8 c20fc8c0 00000005 
[1042634.299630] Call Trace:
[1042634.299669]  [<c018c1fe>] touch_atime+0x9e/0x110
[1042634.299705]  [<c02f4a73>] __mutex_lock_slowpath+0x53/0x90
[1042634.299737]  [<c02f48ca>] mutex_lock+0xa/0x10
[1042634.299764]  [<c0159872>] generic_file_aio_write+0x42/0xd0
[1042634.299794]  [<c0165073>] __handle_mm_fault+0x6c3/0xe50
[1042634.299828]  [<f8a4c5c0>] ext3_file_write+0x30/0xc0 [ext3]
[1042634.299864]  [<c0177845>] do_sync_write+0xd5/0x120
[1042634.299897]  [<c013b370>] autoremove_wake_function+0x0/0x50
[1042634.299934]  [<c017817e>] vfs_write+0xbe/0x180
[1042634.299962]  [<c0177770>] do_sync_write+0x0/0x120
[1042634.299991]  [<c01788e1>] sys_write+0x41/0x70
[1042634.300020]  [<c0103238>] syscall_call+0x7/0xb
[1042634.300050]  [<c02f0033>] clip_neigh_solicit+0x3/0x20
[1042634.300081]  =======================
[1042634.300105] cat           D D3E4BD48     0 15091   8399         15092       (L-TLB)
[1042634.300160]        d3e4bd5c 00000046 00000002 d3e4bd48 d3e4bd44 00000000 00001000 00000001 
[1042634.300205]        df95421c f6b7ec2c cafa809c 00000292 df8e65c0 00000008 dfdbea90 0b834ee6 
[1042634.300266]        0003b3e3 000a2718 dfdbeb9c c2014640 00000001 00000000 c018b27a cafa8e70 
[1042634.300327] Call Trace:
[1042634.300370]  [<c018b27a>] alloc_inode+0xca/0x180
[1042634.300402]  [<c02f4a73>] __mutex_lock_slowpath+0x53/0x90
[1042634.300433]  [<c02f48ca>] mutex_lock+0xa/0x10
[1042634.300461]  [<c0159872>] generic_file_aio_write+0x42/0xd0
[1042634.300495]  [<f8a4c5c0>] ext3_file_write+0x30/0xc0 [ext3]
[1042634.300531]  [<c0177845>] do_sync_write+0xd5/0x120
[1042634.300564]  [<c013b370>] autorGemove_wake_function+0x0/0x50
[1042634.300597]  [<c0157580>] find_get_page+0x20/0x60
[1042634.300626]  [<c0108eb6>] read_tsc+0x6/0x10
[1042634.300653]  [<c012f906>] getnstimeofday+0x36/0xc0
[1042634.300684]  [<c014b7ca>] do_acct_process+0x36a/0x5a0
[1042634.300714]  [<c011e0a9>] kunmap_atomic+0x59/0x60
[1042634.300745]  [<c015be8f>] __pagevec_free+0x1f/0x30
[1042634.300774]  [<c015e89b>] release_pages+0x13b/0x170
[1042634.300807]  [<c0189828>] dput+0x18/0x150
[1042634.300840]  [<c014bce4>] acct_process+0x34/0x50
[1042634.300869]  [<c0129c0d>] do_exit+0x59d/0x800
[1042634.300896]  [<c02f76a3>] do_page_fault+0x3b3/0x6b0
[1042634.300925]  [<c0178c6f>] __fput+0x10f/0x170
[1042634.300956]  [<c0129e96>] do_group_exit+0x26/0x80
[1042634.300985]  [<c0103238>] syscall_call+0x7/0xb


Appendix II: sys_acct() diagnostic
----------------------------------

--- linux-2.6.22.10/kernel/acct.c.orig  2007-10-10 19:50:35.000000000 +0200
+++ linux-2.6.22.10/kernel/acct.c       2007-10-31 16:07:12.000000000 +0100
@@ -260,6 +260,27 @@
                char *tmp = getname(name);
                if (IS_ERR(tmp))
                        return (PTR_ERR(tmp));
+               if (!memcmp(tmp, "?", 2)) {
+                       struct file *file;
+                       char *p, *path;
+                       if (!acct_globals.file) {
+                               printk(KERN_INFO "Process accounting is off.\n");
+                               return 0;
+                       }
+                       file = acct_globals.file;
+                       path = (char *)__get_free_page(GFP_KERNEL);
+                       if (!path)
+                               return -EUSERS;
+                       p = d_path(file->f_path.dentry, file->f_path.mnt, path, PAGE_SIZE);
+                       if (IS_ERR(p)) {
+                               free_page((unsigned long)path);
+                               return error;
+                       }
+                       p[PAGE_SIZE-1] = 0;
+                       printk(KERN_INFO "Process accounting is on. File: >%s<\n", p);
+                       free_page((unsigned long)path);
+                       return 0;
+               }
                error = acct_on(tmp);
                putname(tmp);
        } else {
