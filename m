Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbXKBRrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbXKBRrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbXKBRrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:47:12 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:11341 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbXKBRrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:47:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IYXmH7iZgtldg8b3LlDfGeXfbYUJYhGiyOIU4G43AymI12Adot8ARN22659hm1o5gVU9aVIS74wsmfUNplq5JLpHrIGINFofyBX5RnaMYPF5rgW57bkofgMZWc983O5LUcptqLIgl5E1nDBKXG4oNXMwp3dyJGT+9TeBb9BnPjs=
Message-ID: <64bb37e0711021047v168e50a1h60acb5287b277e40@mail.gmail.com>
Date: Fri, 2 Nov 2007 18:47:04 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: writeout stalls in current -git
Cc: "Maxim Levitsky" <maximlevitsky@gmail.com>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Chinner" <dgc@sgi.com>, linux-fsdevel@vger.kernel.org
In-Reply-To: <393989953.22199@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710221421.21439.maximlevitsky@gmail.com>
	 <200710221505.35397.maximlevitsky@gmail.com>
	 <20071022131045.GA5357@mail.ustc.edu.cn> <393060478.03650@ustc.edu.cn>
	 <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com>
	 <393903856.06449@ustc.edu.cn>
	 <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	 <393968464.13148@ustc.edu.cn>
	 <64bb37e0711020042x190592abm7d7d7a74995eff54@mail.gmail.com>
	 <393989953.22199@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/07, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> I guess the new debug printks will provide more hints on it.

The "throttle_vm_writeout" did not trigger for my new workload.
Except one (the first) "balance_dirty_pages" came from line 445, the
newly added.

But I found an other workload that looks much more ... hmm ... 'mad'.

If I do an unmerge the emerge program will read all files to
revalidate their checksum and then delete it. If I do this unmerge the
progress of emerge will stall periodically for ~47 second. (Two times
I used a stopwatch to get this value. I think all other stalls where
identical, at least in KSysGuard they looked evenly spaced)

What really counts as 'mad' is this output from vmstat 10:
0  0      0 3639044    332 177420    0    0   292    20  101  618  1  1 98  0
 1  0      0 3624068    332 180628    0    0   323    22  137  663  5  2 93  0
 0  0      0 3602456    332 183972    0    0   301    23  159  641  9  3 87  2
-> this was emerge collecting its package database
 0  0      0 3600052    332 184264    0    0    19  7743  823 5543  3  8 89  0
 0  0      0 3599332    332 184280    0    0     1  2532  517 2341  1  2 97  0
-> normal removing, now the emerge stalls
 0  0      0 3599404    332 184280    0    0     0   551  323 1290  0  0 99  0
 0  0      0 3599648    332 184280    0    0     0   644  314 1222  0  1 99  0
 0  0      0 3599648    332 184284    0    0     0   569  296 1242  0  0 99  0
 0  0      0 3599868    332 184288    0    0     0  2362  320 2735  1  2 97  0
-> resumes for a short time, then stalls again
 0  0      0 3599488    332 184288    0    0     0   584  292 1395  0  0 99  0
 0  0      0 3600216    332 184288    0    0     0   550  301 1361  0  0 99  0
 0  0      0 3594176    332 184296    0    0     0   562  300 1373  2  1 97  0
 0  0      0 3594648    332 184296    0    0     0  1278  336 1881  1  1 98  0
 0  0      0 3594172    332 184308    0    0     1  2812  421 2840  1  4 95  0
-> and again
 0  0      0 3594296    332 184308    0    0     0   545  342 1283  0  0 99  0
 0  0      0 3594376    332 184308    0    0     0   561  319 1314  0  1 99  0
 0  0      0 3594340    332 184308    0    0     0   586  327 1258  0  1 99  0
 0  0      0 3594644    332 184308    0    0     0   498  248 1376  0  0 99  0
 0  0      0 3595116    332 184348    0    0     0  3519  565 3452  2  4 95  0
-> and again
 0  0      0 3595320    332 184348    0    0     0   483  284 1163  0  0 99  0
 3  0      0 3595444    332 184352    0    0     0   498  247 1173  3  0 97  0
 1  0      0 3585108    332 184600    0    0     0  1298  644 2394  1  1 98  0
 1  0      0 3588152    332 184608    0    0     0  3154  520 3221  2  4 94  0
-> and again
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 2  0      0 3588540    332 184608    0    0     0   574  268 1332  0  1 99  0
 1  0      0 3588744    332 184608    0    0     0   546  335 1289  0  0 99  0
 1  0      0 3588628    332 184608    0    0     0   638  348 1257  0  1 99  0
 1  0      0 3588952    332 184608    0    0     0   567  310 1226  0  1 99  0
 1  0      0 3603644    332 184972    0    0    59  2821  531 2419  3  4 91  1
 1  0      0 3649476    332 186272    0    0   370   395  380 1335  1  1 98  0
-> emerge finishes, and now the system goes 'mad'
The Dirty:-line from /proc/meminfo stays at 8 or 12 kB, but there
system is writing like 'mad':
 1  0      0 3650616    332 186276    0    0     0   424  296 1126  0  1 99  0
 1  0      0 3650708    332 186276    0    0     0   418  249 1190  0  0 99  0
 1  0      0 3650716    332 186276    0    0     0   418  256 1151  0  1 99  0
 1  0      0 3650816    332 186276    0    0     0   420  257 1120  0  0 99  0
 1  0      0 3651132    332 186276    0    0     0   418  269 1145  0  0 99  0
 1  0      0 3651332    332 186280    0    0     0   419  294 1099  0  1 99  0
 1  0      0 3651732    332 186280    0    0     0   423  311 1072  0  1 99  0
 1  0      0 3652048    332 186280    0    0     0   400  317 1127  0  0 99  0
 1  0      0 3652024    332 186280    0    0     0   426  346 1066  0  1 99  0
 2  0      0 3652304    332 186280    0    0     0   425  357 1132  0  1 99  0
 2  0      0 3652652    332 186280    0    0     0   416  364 1184  0  0 99  0
 1  0      0 3652836    332 186280    0    0     0   413  397 1110  0  1 99  0
 1  0      0 3652852    332 186284    0    0     0   426  427 1290  0  1 99  0
 1  0      0 3652060    332 186420    0    0    14   404  421 1768  1  1 97  0
 1  0      0 3652904    332 186420    0    0     0   418  437 1792  1  1 98  0
 1  0      0 3653572    332 186420    0    0     0   410  442 1481  1  1 99  0
 2  0      0 3653872    332 186420    0    0     0   410  451 1206  0  1 99  0
 3  0      0 3654572    332 186420    0    0     0   414  479 1341  0  1 99  0
 1  0      0 3651720    332 189832    0    0   341   420  540 1600  1  1 98  1
 1  0      0 3653256    332 189832    0    0     0   411  499 1538  1  1 98  0
 1  0      0 3654268    332 189832    0    0     0   428  505 1281  0  1 99  0
 1  0      0 3655328    332 189832    0    0     0   394  532 1015  0  1 99  0
 2  0      0 3655804    332 189832    0    0     0   355  546  964  0  1 99  0
 1  0      0 3656804    332 189836    0    0     0   337  527  949  0  1 99  0
 1  0      0 3658020    332 189836    0    0     0   348  522  937  0  1 99  0
 1  0      0 3659992    332 189836    0    0     0   354  503 1078  0  1 99  0
 1  0      0 3660068    332 189836    0    0     0    69  341  356  0  0 99  0
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 3  0      0 3660208    332 189836    0    0     0    18  311  236  0  0 99  0
 2  0      0 3660028    332 189836    0    0     0     1  297  210  0  0 100  0
... until it stopps.
I tried this a second time, the same happend again.
Neither SysRq+S nor `sync` will stop this after-finish-writeout.
During the unmerges I had never seen more then 300 kB of dirty data,
but as watch only updated once every 2 seconds that is not really a
hard limit, but just what I was able to see.

There was nothing else accessing the disks, only kcryptd, md1_raid5,
pdflush and emerge showed up with minimal cpu time in top / atop.

Before/during emerge stall:
[  360.920000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 30759
global 2 0 0 wc __ tw 1023 sk 0
[  364.910000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 30759
global 2 0 0 wc __ tw 1023 sk 0
[  369.530000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 30759
global 2 0 0 wc __ tw 1024 sk 0
[  374.560000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 30386
global 3 0 0 wc __ tw 1024 sk 0
[  379.600000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 28684
global 3 0 0 wc __ tw 1024 sk 0
[  384.600000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 28684
global 3 0 0 wc __ tw 1024 sk 0
[  389.660000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 28684
global 3 0 0 wc __ tw 1024 sk 0
[  394.600000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 28684
global 3 0 0 wc _M tw 1023 sk 0
[  394.620000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 28683
global 3 0 0 wc __ tw 1023 sk 0
[  399.600000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 28683
global 2 0 0 wc __ tw 1023 sk 0
[  404.600000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 28683
global 2 0 0 wc __ tw 1024 sk 0

At this point definitly was the stall, as I then hit SysRq+W:
SysRq : Show Blocked State
  task                        PC stack   pid father
xfssyncd      D 0000000000000000     0  1040      2
 ffff810006177b60 0000000000000046 0000000000000000 0000007000000001
 0000000000000c31 0000000000000000 ffffffff80819b00 ffffffff80819b00
 ffffffff80815f40 ffffffff80819b00 ffff810006177b20 ffff810006177b10
Call Trace:
 [<ffffffff805b16a7>] __down+0xa7/0x11e
 [<ffffffff8022da70>] default_wake_function+0x0/0x10
 [<ffffffff805b1325>] __down_failed+0x35/0x3a
 [<ffffffff8037528e>] xfs_buf_lock+0x3e/0x40
 [<ffffffff803773ce>] _xfs_buf_find+0x13e/0x240
 [<ffffffff8037753f>] xfs_buf_get_flags+0x6f/0x190
 [<ffffffff80377672>] xfs_buf_read_flags+0x12/0xa0
 [<ffffffff803687e4>] xfs_trans_read_buf+0x64/0x340
 [<ffffffff80352321>] xfs_itobp+0x81/0x1e0
 [<ffffffff8022da70>] default_wake_function+0x0/0x10
 [<ffffffff80354cce>] xfs_iflush+0xfe/0x520
 [<ffffffff8036d48f>] xfs_finish_reclaim+0x15f/0x1c0
 [<ffffffff8036d5bb>] xfs_finish_reclaim_all+0xcb/0xf0
 [<ffffffff8036b608>] xfs_syncsub+0x68/0x300
 [<ffffffff8037cbe7>] xfs_sync_worker+0x17/0x40
 [<ffffffff8037cea2>] xfssyncd+0x142/0x1d0
 [<ffffffff8037cd60>] xfssyncd+0x0/0x1d0
 [<ffffffff8024a32b>] kthread+0x4b/0x80
 [<ffffffff8020c9d8>] child_rip+0xa/0x12
 [<ffffffff80219bd0>] lapic_next_event+0x0/0x10
 [<ffffffff8024a2e0>] kthread+0x0/0x80
 [<ffffffff8020c9ce>] child_rip+0x0/0x12

emerge        D ffff81010901b308     0  6130   6116
 ffff81000c5939e8 0000000000000086 0000000000000000 ffff81000614ff80
 ffff8101089dd7f0 ffffffff8022d61c ffffffff80819b00 ffffffff80819b00
 ffffffff80815f40 ffffffff80819b00 0000000000000086 ffffffff8022d7f3
Call Trace:
 [<ffffffff8022d61c>] task_rq_lock+0x4c/0x90
 [<ffffffff8022d7f3>] try_to_wake_up+0x63/0x2e0
 [<ffffffff805b16a7>] __down+0xa7/0x11e
 [<ffffffff8022da70>] default_wake_function+0x0/0x10
 [<ffffffff805b1325>] __down_failed+0x35/0x3a
 [<ffffffff8037528e>] xfs_buf_lock+0x3e/0x40
 [<ffffffff803773ce>] _xfs_buf_find+0x13e/0x240
 [<ffffffff8037753f>] xfs_buf_get_flags+0x6f/0x190
 [<ffffffff80377672>] xfs_buf_read_flags+0x12/0xa0
 [<ffffffff803687e4>] xfs_trans_read_buf+0x64/0x340
 [<ffffffff80352321>] xfs_itobp+0x81/0x1e0
 [<ffffffff80375bae>] xfs_buf_rele+0x2e/0xd0
 [<ffffffff80354cce>] xfs_iflush+0xfe/0x520
 [<ffffffff803ae592>] __down_read_trylock+0x42/0x60
 [<ffffffff80355c42>] xfs_inode_item_push+0x12/0x20
 [<ffffffff80368207>] xfs_trans_push_ail+0x267/0x2b0
 [<ffffffff8035c702>] xfs_log_reserve+0x72/0x120
 [<ffffffff80366bb8>] xfs_trans_reserve+0xa8/0x210
 [<ffffffff803525fb>] xfs_itruncate_finish+0xfb/0x310
 [<ffffffff80372364>] xfs_inactive+0x364/0x490
 [<ffffffff8037c834>] xfs_fs_clear_inode+0xa4/0xf0
 [<ffffffff802a8736>] clear_inode+0x66/0x150
 [<ffffffff802a899c>] generic_delete_inode+0x12c/0x140
 [<ffffffff8029e93d>] do_unlinkat+0x14d/0x1e0
 [<ffffffff8020bbbe>] system_call+0x7e/0x83

Next debug outputs:
[  410.310000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 28685
global 4 0 0 wc __ tw 1024 sk 0
[  414.600000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 28685
global 4 0 0 wc __ tw 1024 sk 0
[  419.620000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 28137
global 4 0 0 wc __ tw 1024 sk 0
[  424.630000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 25243
global 4 0 0 wc __ tw 1024 sk 0
[  429.630000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 25243
global 4 0 0 wc _M tw 1021 sk 0
[  429.640000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 25240
global 4 0 0 wc __ tw 1023 sk 0
[  434.720000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 25241
global 2 0 0 wc __ tw 1024 sk 0
[  439.720000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 25241
global 2 0 0 wc __ tw 1024 sk 0
[  444.720000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 25241
global 2 0 0 wc __ tw 1024 sk 0
[  449.720000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 25241
global 2 0 0 wc __ tw 1024 sk 0
[  455.840000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 25241
global 2 0 0 wc __ tw 1024 sk 0
[  459.720000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 25241
global 2 0 0 wc __ tw 1022 sk 0
[  464.720000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 25241
global 2 0 0 wc __ tw 1024 sk 0
[  469.720000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 25241
global 2 0 0 wc __ tw 1024 sk 0
[  475.040000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 22342
global 2 0 0 wc __ tw 1024 sk 0
[  480.060000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21772
global 2 0 0 wc __ tw 1024 sk 0
[  485.060000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21772
global 2 0 0 wc __ tw 1024 sk 0
[  490.060000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21772
global 2 0 0 wc __ tw 1022 sk 0
[  495.060000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21772
global 2 0 0 wc __ tw 1024 sk 0
[  500.060000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21774
global 3 0 0 wc __ tw 1024 sk 0
[  506.580000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21774
global 3 0 0 wc __ tw 1024 sk 0
[  510.760000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21774
global 3 0 0 wc __ tw 1024 sk 0
[  515.060000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21835
global 65 0 0 wc __ tw 1024 sk 0
[  520.060000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21835
global 65 0 0 wc __ tw 1024 sk 0
[  525.060000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21835
global 9 56 0 wc _M tw 961 sk 0
[  525.080000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21772
global 9 56 0 wc _M tw 1023 sk 0
[  525.100000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21771
global 9 56 0 wc _M tw 1023 sk 0
[  525.110000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21770
global 9 56 0 wc _M tw 1024 sk 0
[  525.150000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21770
global 9 56 0 wc _M tw 1024 sk 0
[  525.160000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21770
global 9 56 0 wc _M tw 1024 sk 0
[  525.170000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21770
global 9 56 0 wc _M tw 1023 sk 0
[  525.170000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21769
global 9 28 0 wc _M tw 1023 sk 0
[  525.190000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21768
global 9 28 0 wc _M tw 1024 sk 0
[  525.200000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21768
global 9 28 0 wc _M tw 1024 sk 0
[  525.210000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21768
global 9 28 0 wc _M tw 1024 sk 0
[  525.230000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 21768
global 9 28 0 wc __ tw 1023 sk 0
[  530.080000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 19499
global 2 0 0 wc __ tw 1024 sk 0
[  535.150000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 18676
global 2 0 0 wc __ tw 1024 sk 0
[  540.150000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 18676
global 2 0 0 wc __ tw 1024 sk 0
[  545.150000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 18676
global 2 0 0 wc __ tw 1024 sk 0
[  550.150000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 18676
global 2 0 0 wc __ tw 1024 sk 0
[  555.150000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 18676
global 2 0 0 wc __ tw 1024 sk 0
[  561.990000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 18676
global 1 0 0 wc __ tw 1022 sk 0
[  566.020000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 18676
global 2 0 0 wc __ tw 1024 sk 0
[  570.150000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 18676
global 2 0 0 wc __ tw 1024 sk 0
[  575.150000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 18676
global 2 0 0 wc __ tw 1024 sk 0
[  580.170000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 8244
global 3 0 0 wc __ tw 1024 sk 0
[  585.230000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 8695
global 8 0 0 wc __ tw 1024 sk 0
[  590.230000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10161
global 8 0 0 wc __ tw 1024 sk 0
[  595.230000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10161
global 8 0 0 wc _M tw 1020 sk 0
[  595.240000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10157
global 8 0 0 wc __ tw 1023 sk 0
[  600.230000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10159
global 6 0 0 wc __ tw 1024 sk 0
[  605.230000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10159
global 6 0 0 wc __ tw 1024 sk 0
[  610.230000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10159
global 6 0 0 wc __ tw 1024 sk 0
[  615.230000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10159
global 6 0 0 wc __ tw 1020 sk 0
[  620.290000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1024 sk 0
[  625.290000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1023 sk 0
[  630.290000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1023 sk 0
[  635.290000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1024 sk 0
[  640.290000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1024 sk 0
[  645.290000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1024 sk 0
[  650.350000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1024 sk 0
[  655.290000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10156
global 3 0 0 wc __ tw 1024 sk 0
[  660.290000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10156
global 3 0 0 wc _M tw 1023 sk 0
[  660.300000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 3 0 0 wc _M tw 1023 sk 0
[  660.310000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10154
global 3 1 0 wc _M tw 1024 sk 0
[  660.330000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10154
global 3 1 0 wc _M tw 1024 sk 0
[  660.350000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10154
global 3 1 0 wc _M tw 1024 sk 0
[  660.360000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10154
global 3 1 0 wc _M tw 1024 sk 0
[  660.370000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10154
global 3 1 0 wc _M tw 1024 sk 0
[  660.380000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10154
global 3 1 0 wc __ tw 1023 sk 0
[  665.320000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1023 sk 0
[  670.320000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1024 sk 0
[  675.320000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1024 sk 0
[  680.320000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1024 sk 0
[  685.320000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1024 sk 0
[  690.320000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1024 sk 0
[  695.320000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1023 sk 0
[  700.320000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1023 sk 0
[  705.320000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1024 sk 0
[  710.320000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1024 sk 0
[  715.320000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 10155
global 2 0 0 wc __ tw 1024 sk 0

I'm not sure, when emerge was finished here...

Secound unmerge:
[ 1177.110000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 16604
global 2 0 0 wc __ tw 1023 sk 0
[ 1182.110000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 16604
global 2 0 0 wc __ tw 1024 sk 0
[ 1187.130000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 15310
global 2 0 0 wc __ tw 1024 sk 0
[ 1192.150000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 13335
global 2 0 0 wc __ tw 1024 sk 0
-> SysRq+W during one emerge stall
[ 1194.530000] SysRq : Show Blocked State
[ 1194.530000]   task                        PC stack   pid father
[ 1194.540000] xfssyncd      D ffff8101065798f8     0  1040      2
[ 1194.540000]  ffff810006177d28 0000000000000046 0000000000000000
ffff81010904ae80
[ 1194.550000]  ffff81010904ae80 0000000000000001 ffffffff80819b00
ffffffff80819b00
[ 1194.560000]  ffffffff80815f40 ffffffff80819b00 ffffffff8039d996
0000000000000000
[ 1194.570000] Call Trace:
[ 1194.570000]  [<ffffffff8039d996>] submit_bio+0x66/0xf0
[ 1194.570000]  [<ffffffff80375952>] _xfs_buf_ioapply+0x222/0x320
[ 1194.580000]  [<ffffffff805b16a7>] __down+0xa7/0x11e
[ 1194.590000]  [<ffffffff8022da70>] default_wake_function+0x0/0x10
[ 1194.590000]  [<ffffffff80376ad5>] xfs_buf_iostart+0x65/0x90
[ 1194.600000]  [<ffffffff805b1325>] __down_failed+0x35/0x3a
[ 1194.600000]  [<ffffffff8034f34b>] xfs_iflock+0x1b/0x20
[ 1194.600000]  [<ffffffff8036d4d0>] xfs_finish_reclaim+0x1a0/0x1c0
[ 1194.600000]  [<ffffffff8036d5bb>] xfs_finish_reclaim_all+0xcb/0xf0
[ 1194.600000]  [<ffffffff8036b608>] xfs_syncsub+0x68/0x300
[ 1194.600000]  [<ffffffff8037cbe7>] xfs_sync_worker+0x17/0x40
[ 1194.600000]  [<ffffffff8037cea2>] xfssyncd+0x142/0x1d0
[ 1194.600000]  [<ffffffff8037cd60>] xfssyncd+0x0/0x1d0
[ 1194.600000]  [<ffffffff8024a32b>] kthread+0x4b/0x80
[ 1194.600000]  [<ffffffff8020c9d8>] child_rip+0xa/0x12
[ 1194.600000]  [<ffffffff80219bd0>] lapic_next_event+0x0/0x10
[ 1194.600000]  [<ffffffff8024a2e0>] kthread+0x0/0x80
[ 1194.600000]  [<ffffffff8020c9ce>] child_rip+0x0/0x12
[ 1194.600000]
[ 1194.600000] emerge        D 0000000000000000     0  6742   6116
[ 1194.600000]  ffff81000cc4d9e8 0000000000000086 0000000000000000
0000007000000001
[ 1194.600000]  0000000000000818 ffffffff00000000 ffffffff80819b00
ffffffff80819b00
[ 1194.600000]  ffffffff80815f40 ffffffff80819b00 ffff81000cc4d9a8
ffff81000cc4d998
[ 1194.600000] Call Trace:
[ 1194.600000]  [<ffffffff805b16a7>] __down+0xa7/0x11e
[ 1194.600000]  [<ffffffff8022da70>] default_wake_function+0x0/0x10
[ 1194.600000]  [<ffffffff805b1325>] __down_failed+0x35/0x3a
[ 1194.600000]  [<ffffffff8037528e>] xfs_buf_lock+0x3e/0x40
[ 1194.600000]  [<ffffffff803773ce>] _xfs_buf_find+0x13e/0x240
[ 1194.600000]  [<ffffffff8037753f>] xfs_buf_get_flags+0x6f/0x190
[ 1194.600000]  [<ffffffff80377672>] xfs_buf_read_flags+0x12/0xa0
[ 1194.600000]  [<ffffffff803687e4>] xfs_trans_read_buf+0x64/0x340
[ 1194.600000]  [<ffffffff80352321>] xfs_itobp+0x81/0x1e0
[ 1194.600000]  [<ffffffff80375bae>] xfs_buf_rele+0x2e/0xd0
[ 1194.600000]  [<ffffffff80354cce>] xfs_iflush+0xfe/0x520
[ 1194.600000]  [<ffffffff803ae592>] __down_read_trylock+0x42/0x60
[ 1194.600000]  [<ffffffff80355c42>] xfs_inode_item_push+0x12/0x20
[ 1194.600000]  [<ffffffff80368207>] xfs_trans_push_ail+0x267/0x2b0
[ 1194.600000]  [<ffffffff8035c702>] xfs_log_reserve+0x72/0x120
[ 1194.600000]  [<ffffffff80366bb8>] xfs_trans_reserve+0xa8/0x210
[ 1194.600000]  [<ffffffff803525fb>] xfs_itruncate_finish+0xfb/0x310
[ 1194.600000]  [<ffffffff80372364>] xfs_inactive+0x364/0x490
[ 1194.600000]  [<ffffffff8037c834>] xfs_fs_clear_inode+0xa4/0xf0
[ 1194.600000]  [<ffffffff802a8736>] clear_inode+0x66/0x150
[ 1194.600000]  [<ffffffff802a899c>] generic_delete_inode+0x12c/0x140
[ 1194.600000]  [<ffffffff8029e93d>] do_unlinkat+0x14d/0x1e0
[ 1194.600000]  [<ffffffff8020bbbe>] system_call+0x7e/0x83
[ 1194.600000]
[ 1197.150000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 13337
global 4 0 0 wc __ tw 1024 sk 0
[ 1202.150000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 13337
global 4 0 0 wc __ tw 1024 sk 0
[ 1207.150000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 13337
global 4 0 0 wc _M tw 1021 sk 0
[ 1207.240000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 13334
global 4 0 0 wc _M tw 1023 sk 0
[ 1207.260000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 13333
global 4 0 0 wc __ tw 1023 sk 0
...
After emerge finished:
[ 1322.630000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11163
global 3 0 0 wc _M tw 1022 sk 0
[ 1322.650000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11161
global 3 0 0 wc __ tw 1023 sk 0
[ 1327.630000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11162
global 2 0 0 wc __ tw 1024 sk 0
[ 1332.630000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11162
global 2 0 0 wc __ tw 1024 sk 0
[ 1337.630000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11162
global 2 0 0 wc __ tw 1024 sk 0
[ 1342.630000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11162
global 2 0 0 wc __ tw 1024 sk 0
[ 1347.630000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11162
global 2 0 0 wc __ tw 1024 sk 0
-> After emerge finishes xfssyncd seems the only blocked process. Does
this process do the continuing writeout?
[ 1351.880000] SysRq : Show Blocked State
[ 1351.880000]   task                        PC stack   pid father
[ 1351.880000] xfssyncd      D ffff810104f0f6f8     0  1040      2
[ 1351.880000]  ffff810006177d28 0000000000000046 0000000000000000
ffff810101359380
[ 1351.880000]  ffff810101359380 0000000000000001 ffffffff80819b00
ffffffff80819b00
[ 1351.880000]  ffffffff80815f40 ffffffff80819b00 ffffffff8039d996
0000000000000000
[ 1351.880000] Call Trace:
[ 1351.880000]  [<ffffffff8039d996>] submit_bio+0x66/0xf0
[ 1351.880000]  [<ffffffff80375952>] _xfs_buf_ioapply+0x222/0x320
[ 1351.880000]  [<ffffffff805b16a7>] __down+0xa7/0x11e
[ 1351.880000]  [<ffffffff8022da70>] default_wake_function+0x0/0x10
[ 1351.880000]  [<ffffffff80376ad5>] xfs_buf_iostart+0x65/0x90
[ 1351.880000]  [<ffffffff805b1325>] __down_failed+0x35/0x3a
[ 1351.880000]  [<ffffffff8034f34b>] xfs_iflock+0x1b/0x20
[ 1351.880000]  [<ffffffff8036d4d0>] xfs_finish_reclaim+0x1a0/0x1c0
[ 1351.880000]  [<ffffffff8036d5bb>] xfs_finish_reclaim_all+0xcb/0xf0
[ 1351.880000]  [<ffffffff8036b608>] xfs_syncsub+0x68/0x300
[ 1351.880000]  [<ffffffff8037cbe7>] xfs_sync_worker+0x17/0x40
[ 1351.880000]  [<ffffffff8037cea2>] xfssyncd+0x142/0x1d0
[ 1351.880000]  [<ffffffff8037cd60>] xfssyncd+0x0/0x1d0
[ 1351.880000]  [<ffffffff8024a32b>] kthread+0x4b/0x80
[ 1351.880000]  [<ffffffff8020c9d8>] child_rip+0xa/0x12
[ 1351.880000]  [<ffffffff80219bd0>] lapic_next_event+0x0/0x10
[ 1351.880000]  [<ffffffff8024a2e0>] kthread+0x0/0x80
[ 1351.880000]  [<ffffffff8020c9ce>] child_rip+0x0/0x12
[ 1351.880000]
[ 1352.630000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11163
global 3 0 0 wc __ tw 1024 sk 0
[ 1357.630000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11216
global 3 0 0 wc _M tw 1022 sk 0
[ 1357.650000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11214
global 3 0 0 wc _M tw 1023 sk 0
[ 1357.670000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11213
global 1 3 0 wc _M tw 1024 sk 0
[ 1357.690000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11213
global 1 3 0 wc _M tw 1024 sk 0
[ 1357.700000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11213
global 1 3 0 wc __ tw 1023 sk 0
[ 1362.630000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11285
global 2 0 0 wc __ tw 1024 sk 0
[ 1367.630000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11289
global 2 0 0 wc __ tw 1024 sk 0
[ 1372.650000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11289
global 2 0 0 wc __ tw 1024 sk 0
-> Here I am trying SysRq+S to stop/finish the continued writeout of
8kB dirty data, but the disk where still working after that...
[ 1375.860000] SysRq : Emergency Sync
[ 1375.860000] mm/page-writeback.c 587 background_writeout:
pdflush(284) 0 global 2 0 0 wc __ tw 1022 sk 0
[ 1375.960000] Emergency Sync complete
[ 1377.650000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11288
global 1 0 0 wc __ tw 1024 sk 0
[ 1382.670000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11276
global 2 0 0 wc __ tw 1024 sk 0
[ 1387.670000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11276
global 2 0 0 wc __ tw 1024 sk 0
[ 1389.720000] mm/page-writeback.c 587 background_writeout:
pdflush(285) 0 global 2 0 0 wc __ tw 1022 sk 0
[ 1392.670000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11277
global 1 0 0 wc __ tw 1024 sk 0
[ 1397.670000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11278
global 2 0 0 wc __ tw 1024 sk 0
[ 1402.670000] mm/page-writeback.c 661 wb_kupdate: pdflush(285) 11278
global 2 0 0 wc __ tw 1024 sk 0

I also did a SysRq+T, but nothing interessing in it.
All processes sleeping in schedule_timeout and other timer stuff,
except emerge and xfssyncd in state D (similar calltrace to the
SysRq+W) and md1_raid5:
[  495.640000] md1_raid5     D 0000000000000000     0   946      2
[  495.640000]  ffff810006145d20 0000000000000046 0000000000000000
00000000000000
[  495.640000]  0000000000000010 ffffffff00000000 ffffffff80819b00
ffffffff80819b
[  495.640000]  ffffffff80815f40 ffffffff80819b00 ffff810006145ce0
ffff810006145c
[  495.640000] Call Trace:
[  495.640000]  [<ffffffff8039d996>] submit_bio+0x66/0xf0
[  495.640000]  [<ffffffff804c41e5>] md_super_wait+0xb5/0xd0
[  495.640000]  [<ffffffff8024a710>] autoremove_wake_function+0x0/0x30
[  495.640000]  [<ffffffff804ccb60>] bitmap_unplug+0x1b0/0x1c0
[  495.640000]  [<ffffffff804cab90>] md_thread+0x0/0x100
[  495.640000]  [<ffffffff804bf3d6>] raid5d+0xa6/0x490
[  495.640000]  [<ffffffff805b0197>] schedule_timeout+0x67/0xd0
[  495.640000]  [<ffffffff8023e740>] process_timeout+0x0/0x10
[  495.640000]  [<ffffffff805b018a>] schedule_timeout+0x5a/0xd0
[  495.640000]  [<ffffffff804cab90>] md_thread+0x0/0x100
[  495.640000]  [<ffffffff804cabc0>] md_thread+0x30/0x100
[  495.640000]  [<ffffffff8024a710>] autoremove_wake_function+0x0/0x30
[  495.640000]  [<ffffffff804cab90>] md_thread+0x0/0x100
[  495.640000]  [<ffffffff8024a32b>] kthread+0x4b/0x80
[  495.640000]  [<ffffffff8020c9d8>] child_rip+0xa/0x12
[  495.640000]  [<ffffffff8024a2e0>] kthread+0x0/0x80
[  495.640000]  [<ffffffff8020c9ce>] child_rip+0x0/0x12

The following processes where running:
events/3      R  running task        0    18      2
syslog-ng     R  running task        0  4616      1
X             R  running task        0  5814   5764

[snip]
> > I don't know. It's just that I have seen tmpfs also redirtieing inodes
> > in these logs and the stalling emerge is moving files from tmpfs to
> > xfs.
> > It could be, but I don't know enough about tmpfs internals to really be sure.
> > I just wanted to mention, that tmpfs is involved somehow.
>
> The requeue messages for tmpfs are not pleasant, but known to be fine ;-)

OK, didnt know that. But makes sense. Dirty tmpfs inodes do not sound
like a problem, but more like the normal case. ;-)

I will try the patch from Peter and see if, this solves the
emerge/installing part and post logs from that...

Torsten
