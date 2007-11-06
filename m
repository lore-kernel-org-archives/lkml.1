Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbXKFJSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbXKFJSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 04:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbXKFJRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 04:17:48 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:33313 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753775AbXKFJRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 04:17:46 -0500
Message-ID: <394340668.31055@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Tue, 6 Nov 2007 17:17:42 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: writeout stalls in current -git
References: <200710221505.35397.maximlevitsky@gmail.com> <20071022131045.GA5357@mail.ustc.edu.cn> <393060478.03650@ustc.edu.cn> <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com> <393903856.06449@ustc.edu.cn> <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com> <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com> <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins> <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Message-Id: <E1IpKZ4-0004je-Lb@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 08:22:10PM +0100, Torsten Kaiser wrote:
> [  547.200000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 58858 > global 12829 72 0 wc __ tw 0 sk 0
> [  550.480000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 57834 > global 12017 62 0 wc __ tw 0 sk 0
> [  552.710000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 56810 > global 11133 83 0 wc __ tw 0 sk 0
> [  558.660000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 55786 > global 10470 33 0 wc _M tw 0 sk 0
        4s
> [  562.750000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 54762 > global 10555 69 0 wc _M tw 0 sk 0
        3s
> [  565.150000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 53738 > global 9562 498 0 wc _M tw -2 sk 0
        4s
> [  569.490000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 52712 > global 8960 2 0 wc _M tw 0 sk 0
        3s
> [  572.910000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 51688 > global 8088 205 0 wc _M tw -13 sk 0
        2s
> [  574.610000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 50651 > global 7114 188 0 wc _M tw -1 sk 0
        10s
> [  584.270000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 49626 > global 14544 0 0 wc _M tw -1 sk 0
        9s
> [  593.050000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 48601 > global 24583 736 0 wc _M tw -1 sk 0
        7s
> [  600.180000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 47576 > global 27004 6 0 wc _M tw 587 sk 0
> [  600.180000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 47139 > global 27004 6 0 wc __ tw 1014 sk 0

The above messages and the below 'D' state pdflush indicate that one
single writeback_inodes(4MB) call takes a long time(up to 10s!) to complete.

Let's try reverting the below patch with `patch -R`? It looks like
the most relevant change - if it's not a low level bug.

> [note] first stall, the output from emerge stops, so it seems it can
> not start processing the next file until the stall ends
> [  630.000000] SysRq : Emergency Sync
> [  630.120000] Emergency Sync complete
> [  632.850000] SysRq : Show Blocked State
> [  632.850000]   task                        PC stack   pid father
> [  632.850000] pdflush       D ffff81000f091788     0   285      2
> [  632.850000]  ffff810005d4da80 0000000000000046 0000000000000800
> 0000007000000001
> [  632.850000]  ffff81000fd52400 ffffffff8022d61c ffffffff80819b00
> ffffffff80819b00
> [  632.850000]  ffffffff80815f40 ffffffff80819b00 ffff810100316f98
> 0000000000000000
> [  632.850000] Call Trace:
> [  632.850000]  [<ffffffff8022d61c>] task_rq_lock+0x4c/0x90
> [  632.850000]  [<ffffffff8022c8ea>] __wake_up_common+0x5a/0x90
> [  632.850000]  [<ffffffff805b16e7>] __down+0xa7/0x11e
> [  632.850000]  [<ffffffff8022da70>] default_wake_function+0x0/0x10
> [  632.850000]  [<ffffffff805b1365>] __down_failed+0x35/0x3a
> [  632.850000]  [<ffffffff803752ce>] xfs_buf_lock+0x3e/0x40
> [  632.850000]  [<ffffffff8037740e>] _xfs_buf_find+0x13e/0x240
> [  632.850000]  [<ffffffff8037757f>] xfs_buf_get_flags+0x6f/0x190
> [  632.850000]  [<ffffffff803776b2>] xfs_buf_read_flags+0x12/0xa0
> [  632.850000]  [<ffffffff80368824>] xfs_trans_read_buf+0x64/0x340
> [  632.850000]  [<ffffffff80352361>] xfs_itobp+0x81/0x1e0
> [  632.850000]  [<ffffffff8026b293>] write_cache_pages+0x123/0x330
> [  632.850000]  [<ffffffff80354d0e>] xfs_iflush+0xfe/0x520
> [  632.850000]  [<ffffffff803ae5d2>] __down_read_trylock+0x42/0x60
> [  632.850000]  [<ffffffff8036ed49>] xfs_inode_flush+0x179/0x1b0
> [  632.850000]  [<ffffffff8037ca8f>] xfs_fs_write_inode+0x2f/0x90
> [  632.850000]  [<ffffffff802b3aac>] __writeback_single_inode+0x2ac/0x380
> [  632.850000]  [<ffffffff804d074e>] dm_table_any_congested+0x2e/0x80
> [  632.850000]  [<ffffffff802b3f9d>] generic_sync_sb_inodes+0x20d/0x330
> [  632.850000]  [<ffffffff802b4532>] writeback_inodes+0xa2/0xe0
> [  632.850000]  [<ffffffff8026bfd6>] wb_kupdate+0xa6/0x140
> [  632.850000]  [<ffffffff8026c4b0>] pdflush+0x0/0x1e0
> [  632.850000]  [<ffffffff8026c5c0>] pdflush+0x110/0x1e0
> [  632.850000]  [<ffffffff8026bf30>] wb_kupdate+0x0/0x140
> [  632.850000]  [<ffffffff8024a32b>] kthread+0x4b/0x80
> [  632.850000]  [<ffffffff8020c9d8>] child_rip+0xa/0x12
> [  632.850000]  [<ffffffff8024a2e0>] kthread+0x0/0x80
> [  632.850000]  [<ffffffff8020c9ce>] child_rip+0x0/0x12
> [  632.850000]
> [  632.850000] emerge        D 0000000000000000     0  6220   6129
> [  632.850000]  ffff810103ced9f8 0000000000000086 0000000000000000
> 0000007000000001
> [  632.850000]  ffff81000fd52cf8 ffffffff00000000 ffffffff80819b00
> ffffffff80819b00
> [  632.850000]  ffffffff80815f40 ffffffff80819b00 ffff810103ced9b8
> ffff810103ced9a8
> [  632.850000] Call Trace:
> [  632.850000]  [<ffffffff805b16e7>] __down+0xa7/0x11e
> [  632.850000]  [<ffffffff8022da70>] default_wake_function+0x0/0x10
> [  632.850000]  [<ffffffff805b1365>] __down_failed+0x35/0x3a
> [  632.850000]  [<ffffffff803752ce>] xfs_buf_lock+0x3e/0x40
> [  632.850000]  [<ffffffff8037740e>] _xfs_buf_find+0x13e/0x240
> [  632.850000]  [<ffffffff8037757f>] xfs_buf_get_flags+0x6f/0x190
> [  632.850000]  [<ffffffff803776b2>] xfs_buf_read_flags+0x12/0xa0
> [  632.850000]  [<ffffffff80368824>] xfs_trans_read_buf+0x64/0x340
> [  632.850000]  [<ffffffff80352361>] xfs_itobp+0x81/0x1e0
> [  632.850000]  [<ffffffff80375bee>] xfs_buf_rele+0x2e/0xd0
> [  632.850000]  [<ffffffff80354d0e>] xfs_iflush+0xfe/0x520
> [  632.850000]  [<ffffffff803ae5d2>] __down_read_trylock+0x42/0x60
> [  632.850000]  [<ffffffff80355c82>] xfs_inode_item_push+0x12/0x20
> [  632.850000]  [<ffffffff80368247>] xfs_trans_push_ail+0x267/0x2b0
> [  632.850000]  [<ffffffff8035c742>] xfs_log_reserve+0x72/0x120
> [  632.850000]  [<ffffffff80366bf8>] xfs_trans_reserve+0xa8/0x210
> [  632.850000]  [<ffffffff803731f2>] kmem_zone_zalloc+0x32/0x50
> [  632.850000]  [<ffffffff8035263b>] xfs_itruncate_finish+0xfb/0x310
> [  632.850000]  [<ffffffff8036daeb>] xfs_free_eofblocks+0x23b/0x280
> [  632.850000]  [<ffffffff80371f93>] xfs_release+0x153/0x200
> [  632.850000]  [<ffffffff80378010>] xfs_file_release+0x10/0x20
> [  632.850000]  [<ffffffff80294251>] __fput+0xb1/0x220
> [  632.850000]  [<ffffffff802910a4>] filp_close+0x54/0x90
> [  632.850000]  [<ffffffff802929bf>] sys_close+0x9f/0x100
> [  632.850000]  [<ffffffff8020bbbe>] system_call+0x7e/0x83
> [  632.850000]
> [  662.180000] mm/page-writeback.c 676 wb_kupdate: pdflush(285) 73045
> global 39157 0 0 wc __ tw 0 sk 0
> [note] emerge resumed
> [  664.030000] SysRq : HELP : loglevel0-8 reBoot tErm Full kIll saK
> showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks
> Unmount shoW-blocked-tasks

------------------------------------------------------
Subject: writeback: remove pages_skipped accounting in __block_write_full_page()
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Miklos Szeredi <miklos@szeredi.hu> and me identified a writeback bug:

> The following strange behavior can be observed:
>
> 1. large file is written
> 2. after 30 seconds, nr_dirty goes down by 1024
> 3. then for some time (< 30 sec) nothing happens (disk idle)
> 4. then nr_dirty again goes down by 1024
> 5. repeat from 3. until whole file is written
>
> So basically a 4Mbyte chunk of the file is written every 30 seconds.
> I'm quite sure this is not the intended behavior.

It can be produced by the following test scheme:

# cat bin/test-writeback.sh
grep nr_dirty /proc/vmstat
echo 1 > /proc/sys/fs/inode_debug
dd if=/dev/zero of=/var/x bs=1K count=204800&
while true; do grep nr_dirty /proc/vmstat; sleep 1; done

# bin/test-writeback.sh
nr_dirty 19207
nr_dirty 19207
nr_dirty 30924
204800+0 records in
204800+0 records out
209715200 bytes (210 MB) copied, 1.58363 seconds, 132 MB/s
nr_dirty 47150
nr_dirty 47141
nr_dirty 47142
nr_dirty 47142
nr_dirty 47142
nr_dirty 47142
nr_dirty 47205
nr_dirty 47214
nr_dirty 47214
nr_dirty 47214
nr_dirty 47214
nr_dirty 47214
nr_dirty 47215
nr_dirty 47216
nr_dirty 47216
nr_dirty 47216
nr_dirty 47154
nr_dirty 47143
nr_dirty 47143
nr_dirty 47143
nr_dirty 47143
nr_dirty 47143
nr_dirty 47142
nr_dirty 47142
nr_dirty 47142
nr_dirty 47142
nr_dirty 47134
nr_dirty 47134
nr_dirty 47135
nr_dirty 47135
nr_dirty 47135
nr_dirty 46097 <== -1038
nr_dirty 46098
nr_dirty 46098
nr_dirty 46098
[...]
nr_dirty 46091
nr_dirty 46092
nr_dirty 46092
nr_dirty 45069 <== -1023
nr_dirty 45056
nr_dirty 45056
nr_dirty 45056
[...]
nr_dirty 37822
nr_dirty 36799 <== -1023
[...]
nr_dirty 36781
nr_dirty 35758 <== -1023
[...]
nr_dirty 34708
nr_dirty 33672 <== -1024
[...]
nr_dirty 33692
nr_dirty 32669 <== -1023

% ls -li /var/x
847824 -rw-r--r-- 1 root root 200M 2007-08-12 04:12 /var/x

% dmesg|grep 847824  # generated by a debug printk
[  529.263184] redirtied inode 847824 line 548
[  564.250872] redirtied inode 847824 line 548
[  594.272797] redirtied inode 847824 line 548
[  629.231330] redirtied inode 847824 line 548
[  659.224674] redirtied inode 847824 line 548
[  689.219890] redirtied inode 847824 line 548
[  724.226655] redirtied inode 847824 line 548
[  759.198568] redirtied inode 847824 line 548

# line 548 in fs/fs-writeback.c:
543                 if (wbc->pages_skipped != pages_skipped) {
544                         /*
545                          * writeback is not making progress due to locked
546                          * buffers.  Skip this inode for now.
547                          */
548                         redirty_tail(inode);
549                 }

More debug efforts show that __block_write_full_page()
never has the chance to call submit_bh() for that big dirty file:
the buffer head is *clean*. So basicly no page io is issued by
__block_write_full_page(), hence pages_skipped goes up.

Also the comment in generic_sync_sb_inodes():

544                         /*
545                          * writeback is not making progress due to locked
546                          * buffers.  Skip this inode for now.
547                          */

and the comment in __block_write_full_page():

1713                 /*
1714                  * The page was marked dirty, but the buffers were
1715                  * clean.  Someone wrote them back by hand with
1716                  * ll_rw_block/submit_bh.  A rare case.
1717                  */

do not quite agree with each other. The page writeback should be skipped for
'locked buffer', but here it is 'clean buffer'!

This patch fixes this bug. Though I'm not sure why __block_write_full_page()
is called only to do nothing and who actually issued the writeback for us.

This is the two possible new behaviors after the patch:

1) pretty nice: wait 30s and write ALL:)
2) not so good:
	- during the dd: ~16M
	- after 30s:      ~4M
	- after 5s:       ~4M
	- after 5s:     ~176M

The next patch will fix case (2).

Cc: David Chinner <dgc@sgi.com>
Cc: Ken Chen <kenchen@google.com>
Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |    1 -
 fs/xfs/linux-2.6/xfs_aops.c |    5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/buffer.c~writeback-remove-pages_skipped-accounting-in-__block_write_full_page fs/buffer.c
--- a/fs/buffer.c~writeback-remove-pages_skipped-accounting-in-__block_write_full_page
+++ a/fs/buffer.c
@@ -1730,7 +1730,6 @@ done:
 		 * The page and buffer_heads can be released at any time from
 		 * here on.
 		 */
-		wbc->pages_skipped++;	/* We didn't write this page */
 	}
 	return err;
 
diff -puN fs/xfs/linux-2.6/xfs_aops.c~writeback-remove-pages_skipped-accounting-in-__block_write_full_page fs/xfs/linux-2.6/xfs_aops.c
--- a/fs/xfs/linux-2.6/xfs_aops.c~writeback-remove-pages_skipped-accounting-in-__block_write_full_page
+++ a/fs/xfs/linux-2.6/xfs_aops.c
@@ -402,10 +402,9 @@ xfs_start_page_writeback(
 		clear_page_dirty_for_io(page);
 	set_page_writeback(page);
 	unlock_page(page);
-	if (!buffers) {
+	/* If no buffers on the page are to be written, finish it here */
+	if (!buffers)
 		end_page_writeback(page);
-		wbc->pages_skipped++;	/* We didn't write this page */
-	}
 }
 
 static inline int bio_add_buffer(struct bio *bio, struct buffer_head *bh)
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch

