Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYDCKHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYDCKHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 06:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYDCKHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 06:07:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:37919 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbYDCKHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 06:07:44 -0400
Date: Thu, 3 Apr 2008 12:07:42 +0200
From: Jan Kara <jack@suse.cz>
To: David Chinner <dgc@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: BUG: ext3 hang in transaction commit
Message-ID: <20080403100742.GA16314@atrey.karlin.mff.cuni.cz>
References: <20080326231612.GC103491721@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080326231612.GC103491721@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> ia32 XFS QA machine, ext3 root on a raw partition. 2.6.25-rc3.
> 
> kjournald hung journal_commit_transaction():
> 
> Stack traceback for pid 2046
> 0xf6e0b350     2046        2  0    0   D  0xf6e0b550  kjournald
> esp        eip        Function (args)
> 0xf68d5e70 0xc04c20b2 schedule+0x51e
> 0xf68d5ec0 0xc04c2394 io_schedule+0x1d
> 0xf68d5ecc 0xc0179b64 sync_buffer+0x33 (invalid)
> 0xf68d5ed4 0xc04c2570 __wait_on_bit+0x36 (0xc2000b78, 0xf68d5f00, 0xc0179b31, 0x2)
> 0xf68d5ef0 0xc04c25ef out_of_line_wait_on_bit+0x58 (0xde89bc18, 0x2, 0xc0179b31, 0x2)
> 0xf68d5f2c 0xc0179adf __wait_on_buffer+0x19
> 0xf68d5f38 0xc01cecba journal_commit_transaction+0x40b (0xf6d94a00)
> 0xf68d5fa0 0xc01d180a kjournald+0xa4 (0xf6d94a00)
> 0xf68d5fd4 0xc01301f1 kthread+0x3b (invalid)

  I suppose this is wait_on_buffer() in line 444 in fs/jbd/commit.c, isn't it?


> The buffer kjournald is stuck on:
> 
> [0]kdb> bh 0xde89bc18
> buffer_head at 0xde89bc18
>   bno 9695555 size 4096 dev 0x300002
>   count 3 state 0x802d [Uptodate Lock Req Mapped Private]
>   b_data 0x00000000
>   b_page 0xc1a23e60 b_this_page 0xde89bc18 b_private 0xf76237f0
>   b_end_io 0xc017afe0 end_buffer_write_sync
> [0]kdb> page 0xc1a23e60
> struct page at 0xc1a23e60
>   addr space 0xf565917c index 279 (offset 0x117000)
>   count 2 flags PG_referenced PG_uptodate PG_dirty PG_lru PG_private
>   virtual 0x00000000
>   buffers 0xde89bc18
> [0]kdb> inode f56590d4
> struct inode at  0xf56590d4
>  i_ino = 4833353 i_count = 1 i_size 1145510
>  i_mode = 0100644  i_nlink = 1  i_rdev = 0x0
>  i_hash.nxt = 0x00000000 i_hash.pprev = 0xc20ec880
>  i_list.nxt = 0xf772749c i_list.prv = 0xf75aa0d4
>  i_dentry.nxt = 0xf7795a5c i_dentry.prv = 0xf7795a5c
>  i_sb = 0xf73ca400 i_op = 0xc04d9160 i_data = 0xf565917c nrpages = 280
>  i_fop= 0xc04d90e0 i_flock = 0x00000000 i_mapping = 0xf565917c
>  i_flags 0x0 i_state 0x4 [I_DIRTY_PAGES]  fs specific info @ 0xf565921c
> 
> We're waiting on the last page/buffer in the file, and it doesn't appear
> to be under writeback....
  We wait for write of ordered-data to finish. Which seems to never
happen. Page isn't under writeback, but that just means we submitted the
buffer from the commit code (that doesn't change the page state).
  Anyway, the cause is that either due to some bug IO never finished and
so buffer never got unlocked, or we somewhere locked the buffer and
forgot to unlock it (but I've checked all the relevant places and think
they are correct). The traces of all the processes seem harmless - I see
no place trace where we are holding a buffer lock.
  If you happen to hit this again, please let me know and I'll look into
it further...
 
> Everything train-smashed up behind it such as:
> 
> Stack traceback for pid 4876
> 0xf7390910     4876        1  0    0   D  0xf7390b10  nscd
> esp        eip        Function (args)
> 0xf6009d5c 0xc04c20b2 schedule+0x51e
> 0xf6009dac 0xc04c2394 io_schedule+0x1d
> 0xf6009db8 0xc0179b64 sync_buffer+0x33 (invalid)
> 0xf6009dc0 0xc04c24b1 __wait_on_bit_lock+0x30 (0xc20024a4, 0xf6009de8, 0xc0179b31, 0x2)
> 0xf6009dd8 0xc04c2532 out_of_line_wait_on_bit_lock+0x58 (0xf7643780, 0x2, 0xc0179b31, 0x2)
> 0xf6009e14 0xc0179ca1 __lock_buffer+0x24 (0xf7643780)
> 0xf6009e24 0xc01cd686 do_get_write_access+0x4f (0xf5db748c, 0xf761fe70, 0x0)
> 0xf6009e68 0xc01cd99a journal_get_write_access+0x1b (0xf5db748c, invalid)
> 0xf6009e78 0xc01cada0 __ext3_journal_get_write_access+0x19 (0xc04d9230, 0xf5db748c, 0xf7643780)
> 0xf6009e90 0xc01bffaa ext3_reserve_inode_write+0x34 (0xf5db748c, 0xf76b5e10, 0xf6009eac)
> 0xf6009ea8 0xc01bfffe ext3_mark_inode_dirty+0x20 (0xf5db748c, 0xf76b5e10)
> 0xf6009ec8 0xc01c281a ext3_dirty_inode+0x53 (0xf76b5e10)
> 0xf6009edc 0xc0175e2b __mark_inode_dirty+0x26 (0xf76b5e10, 0x1)
> 0xf6009ef4 0xc016ea8e file_update_time+0x74 (invalid)
> 0xf6009f04 0xc014d681 do_wp_page+0x356 (0xf6e15880, 0xf6d6941c, 0xb5d8db71, 0xf6134634, 0xf68ecb5c, 0xc16c268c, 0x7ed7a025)
> 0xf6009f3c 0xc014ed6c handle_mm_fault+0x450 (0xf6e15880, 0xf6d6941c, 0xb5d8db71, 0x1)
> 0xf6009f88 0xc04c4d09 do_page_fault+0x233 (0xf6009fb8, 0x7, invalid)
> 0xf6009fb4 0xc04c3712 error_code+0x72 (invalid, invalid, invalid)
> 
> 
> The only processes that aren't hung in touch_atime() are:
> 
> Stack traceback for pid 4995
> 0xf6b79150     4995        1  0    1   D  0xf6b79350  cupsd
> esp        eip        Function (args)
> 0xf6d09ddc 0xc04c20b2 schedule+0x51e
> 0xf6d09e2c 0xc04c2394 io_schedule+0x1d
> 0xf6d09e38 0xc014285f sync_page+0x36 (invalid)
> 0xf6d09e40 0xc04c2570 __wait_on_bit+0x36 (0xc2006574, 0xf6d09e64, 0xc0142829, 0x2)
> 0xf6d09e5c 0xc0142a51 wait_on_page_bit+0x56 (0xc1f76a00, 0xc)
> 0xf6d09e88 0xc014998f truncate_inode_pages_range+0x23a (0xf76fb90c, 0x0, 0x0, 0xffffffff, 0xffffffff)
> 0xf6d09ef8 0xc0149a04 truncate_inode_pages+0xc
> 0xf6d09f08 0xc01c1ed6 ext3_delete_inode+0x16 (0xf76fb864)
> 0xf6d09f18 0xc016e3ef generic_delete_inode+0x8b (0xf76fb864)
> 0xf6d09f28 0xc016e467 generic_drop_inode+0x12 (0xf76fb864)
> 0xf6d09f38 0xc016db1b iput+0x63 (0xf76fb864)
> 0xf6d09f44 0xc0166984 do_unlinkat+0xa8 (invalid, invalid)
> 0xf6d09fac 0xc0166a02 sys_unlink+0x10 (0xbfbf3488)
> 
> The page it's stuck on:
> 
> [0]kdb> page 0xc1f76a00
> struct page at 0xc1f76a00
>   addr space 0xf76fb90c index 0 (offset 0x0)
>   count 3 flags PG_locked PG_uptodate PG_lru PG_private PG_writeback
>   virtual 0x00000000
>   buffers 0xf1991e48
> [0]kdb> inode f76fb864
> struct inode at  0xf76fb864
>  i_ino = 5981454 i_count = 0 i_size 32
>  i_mode = 0100440  i_nlink = 0  i_rdev = 0x0
>  i_hash.nxt = 0x00000000 i_hash.pprev = 0xc20cd990
>  i_list.nxt = 0xf76fb864 i_list.prv = 0xf76fb864
>  i_dentry.nxt = 0xf76fb83c i_dentry.prv = 0xf76fb83c
>  i_sb = 0xf73ca400 i_op = 0xc04d9160 i_data = 0xf76fb90c nrpages = 1
>  i_fop= 0xc04d90e0 i_flock = 0x00000000 i_mapping = 0xf76fb90c
>  i_flags 0x0 i_state 0x20 [I_FREEING]  fs specific info @ 0xf76fb9ac
> [0]kdb> inode_pages f76fb864
> page_struct       index   cnt zone nid flags
> 00000000              0     3   2   0 0x1829 Locked Uptodate LRU Private Writeback HighMem
>         bh 0xf1991e48 bno 11968107 [Uptodate Lock Req Mapped Async_write Priavate]
>  mapping= f76fb90c
> 
> 
> Appears to be under writeback.
> 
> Stack traceback for pid 28191
> 0xf6e0adf0    28191    28016  0    1   D  0xf6e0aff0  umount
> esp        eip        Function (args)
> 0xf3913cd0 0xc04c20b2 schedule+0x51e
> 0xf3913d20 0xc04c2394 io_schedule+0x1d
> 0xf3913d2c 0xc0179b64 sync_buffer+0x33 (invalid)
> 0xf3913d34 0xc04c24b1 __wait_on_bit_lock+0x30 (0xc20009bc, 0xf3913d5c, 0xc0179b31, 0x2)
> 0xf3913d4c 0xc04c2532 out_of_line_wait_on_bit_lock+0x58 (0xf74ec4a8, 0x2, 0xc0179b31, 0x2)
> 0xf3913d88 0xc0179ca1 __lock_buffer+0x24 (0xf74ec4a8)
> 0xf3913d98 0xc01cddb2 journal_invalidatepage+0x66 (0xf6d94a00, 0xc1fb65a0, 0x0)
> 0xf3913dc8 0xc01c1a12 ext3_invalidatepage+0x2f (0xc1fb65a0, invalid)
> 0xf3913dd4 0xc01493b5 do_invalidatepage+0x19 (invalid)
> 0xf3913de0 0xc014972e truncate_complete_page+0x1f (invalid, 0xc1fb65a0)
> 0xf3913dec 0xc0149818 truncate_inode_pages_range+0xc3 (0xf5659af0, 0x0, 0x0, 0xffffffff, 0xffffffff)
> 0xf3913e5c 0xc0149a04 truncate_inode_pages+0xc
> 0xf3913e6c 0xc01c1ed6 ext3_delete_inode+0x16 (0xf5659a48)
> 0xf3913e7c 0xc016e3ef generic_delete_inode+0x8b (0xf5659a48)
> 0xf3913e8c 0xc016e467 generic_drop_inode+0x12 (0xf5659a48)
> 0xf3913e9c 0xc016db1b iput+0x63 (0xf5659a48)
> 0xf3913ea8 0xc016bf74 dentry_iput+0x70 (0xf7795954)
> 0xf3913eb8 0xc016c013 d_kill+0x30 (0xf7795954)
> 0xf3913ec8 0xc016cde2 dput+0xc1 (invalid)
> 0xf3913ed4 0xc016679b sys_renameat+0x17a (0xffffff9c, 0x80523c0, 0xffffff9c, 0x805234a)
> 0xf3913f9c 0xc0166810 sys_rename+0x12 (0x80523c0, 0x805234a)
> 
> [0]kdb> page 0xc1fb65a0
> struct page at 0xc1fb65a0
>   addr space 0xf5659af0 index 0 (offset 0x0)
>   count 3 flags PG_locked PG_referenced PG_uptodate PG_dirty PG_lru PG_active
>             PG_private
>   virtual 0x00000000
>   buffers 0xf74ec4a8
> [0]kdb> md4c1 0xf5659af0
> 0xf5659af0 f5659a48                              H.e.
> [0]kdb> inode f5659a48
> struct inode at  0xf5659a48
>  i_ino = 5984203 i_count = 0 i_size 261
>  i_mode = 0100644  i_nlink = 0  i_rdev = 0x0
>  i_hash.nxt = 0x00000000 i_hash.pprev = 0xc20e121c
>  i_list.nxt = 0xf5659a48 i_list.prv = 0xf5659a48
>  i_dentry.nxt = 0xf5659a20 i_dentry.prv = 0xf5659a20
>  i_sb = 0xf73ca400 i_op = 0xc04d9160 i_data = 0xf5659af0 nrpages = 1
>  i_fop= 0xc04d90e0 i_flock = 0x00000000 i_mapping = 0xf5659af0
>  i_flags 0x0 i_state 0x27 [I_DIRTY_SYNC I_DIRTY_DATASYNC I_DIRTY_PAGES I_FREEING]  fs specific info @ 0xf5659b90
> [0]kdb> inode_pages f5659a48
> page_struct       index   cnt zone nid flags
> 00000000              0     3   2   0 0x87d Locked Referenced Uptodate Dirty LRU Active Private HighMem
>         bh 0xf74ec4a8 bno 11984903 [Uptodate Lock Req Mapped Priavate]
>  mapping= f5659af0
> 
> 
> There's no I/O errors in the syslog and the XFS tests were running on
> a different disk so there should have been no interaction with them.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
