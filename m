Return-Path: <linux-kernel-owner+w=401wt.eu-S1761143AbYF0NSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761143AbYF0NSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbYF0NSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:18:35 -0400
Received: from brick.kernel.dk ([87.55.233.238]:25330 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbYF0NSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:18:34 -0400
Date: Fri, 27 Jun 2008 15:18:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: [PATCH] Properly notify block layer of sync writes
Message-ID: <20080627131830.GC20826@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

fsync_buffers_list() and sync_dirty_buffer() both issue async writes and
then immediately wait on them. Conceptually, that makes them sync writes
and we should treat them as such so that the IO schedulers can handle
them appropriately.

This patch fixes a write starvation issue that Lin Ming reported, where
xx is stuck for more than 2 minutes because of a large number of
synchronous IO in the system:

INFO: task kjournald:20558 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
kjournald     D ffff810010820978  6712 20558      2
ffff81022ddb1d10 0000000000000046 ffff81022e7baa10 ffffffff803ba6f2
ffff81022ecd0000 ffff8101e6dc9160 ffff81022ecd0348 000000008048b6cb
0000000000000086 ffff81022c4e8d30 0000000000000000 ffffffff80247537
Call Trace:
[<ffffffff803ba6f2>] kobject_get+0x12/0x17
[<ffffffff80247537>] getnstimeofday+0x2f/0x83
[<ffffffff8029c1ac>] sync_buffer+0x0/0x3f
[<ffffffff8066d195>] io_schedule+0x5d/0x9f
[<ffffffff8029c1e7>] sync_buffer+0x3b/0x3f
[<ffffffff8066d3f0>] __wait_on_bit+0x40/0x6f
[<ffffffff8029c1ac>] sync_buffer+0x0/0x3f
[<ffffffff8066d48b>] out_of_line_wait_on_bit+0x6c/0x78
[<ffffffff80243909>] wake_bit_function+0x0/0x23
[<ffffffff8029e3ad>] sync_dirty_buffer+0x98/0xcb
[<ffffffff8030056b>] journal_commit_transaction+0x97d/0xcb6
[<ffffffff8023a676>] lock_timer_base+0x26/0x4b
[<ffffffff8030300a>] kjournald+0xc1/0x1fb
[<ffffffff802438db>] autoremove_wake_function+0x0/0x2e
[<ffffffff80302f49>] kjournald+0x0/0x1fb
[<ffffffff802437bb>] kthread+0x47/0x74
[<ffffffff8022de51>] schedule_tail+0x28/0x5d
[<ffffffff8020cac8>] child_rip+0xa/0x12
[<ffffffff80243774>] kthread+0x0/0x74
[<ffffffff8020cabe>] child_rip+0x0/0x12

Lin Ming confirms that this patch fixes the issue. I've run tests with
it for the past week and no ill effects have been observed, so I'm
proposing it for inclusion into 2.6.26.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/buffer.c        |   13 ++++++++-----
 include/linux/fs.h |    1 +
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index a073f3f..0f51c0f 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -821,7 +821,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 				 * contents - it is a noop if I/O is still in
 				 * flight on potentially older contents.
 				 */
-				ll_rw_block(SWRITE, 1, &bh);
+				ll_rw_block(SWRITE_SYNC, 1, &bh);
 				brelse(bh);
 				spin_lock(lock);
 			}
@@ -2940,16 +2940,19 @@ void ll_rw_block(int rw, int nr, struct buffer_head *bhs[])
 	for (i = 0; i < nr; i++) {
 		struct buffer_head *bh = bhs[i];
 
-		if (rw == SWRITE)
+		if (rw == SWRITE || rw == SWRITE_SYNC)
 			lock_buffer(bh);
 		else if (test_set_buffer_locked(bh))
 			continue;
 
-		if (rw == WRITE || rw == SWRITE) {
+		if (rw == WRITE || rw == SWRITE || rw == SWRITE_SYNC) {
 			if (test_clear_buffer_dirty(bh)) {
 				bh->b_end_io = end_buffer_write_sync;
 				get_bh(bh);
-				submit_bh(WRITE, bh);
+				if (rw == SWRITE_SYNC)
+					submit_bh(WRITE_SYNC, bh);
+				else
+					submit_bh(WRITE, bh);
 				continue;
 			}
 		} else {
@@ -2978,7 +2981,7 @@ int sync_dirty_buffer(struct buffer_head *bh)
 	if (test_clear_buffer_dirty(bh)) {
 		get_bh(bh);
 		bh->b_end_io = end_buffer_write_sync;
-		ret = submit_bh(WRITE, bh);
+		ret = submit_bh(WRITE_SYNC, bh);
 		wait_on_buffer(bh);
 		if (buffer_eopnotsupp(bh)) {
 			clear_buffer_eopnotsupp(bh);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d490779..f25f95d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -83,6 +83,7 @@ extern int dir_notify_enable;
 #define READ_SYNC	(READ | (1 << BIO_RW_SYNC))
 #define READ_META	(READ | (1 << BIO_RW_META))
 #define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNC))
+#define SWRITE_SYNC	(SWRITE | (1 << BIO_RW_SYNC))
 #define WRITE_BARRIER	((1 << BIO_RW) | (1 << BIO_RW_BARRIER))
 
 #define SEL_IN		1
-- 
1.5.6


-- 
Jens Axboe

