Return-Path: <linux-kernel-owner+w=401wt.eu-S1761953AbYEAPQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761953AbYEAPQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbYEAPQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:16:17 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38271 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbYEAPQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:16:15 -0400
Subject: [PATCH] jbd_commit_transaction() races with
	journal_try_to_drop_buffers() causing DIO failures
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Mingming Cao <cmm@us.ibm.com>, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080429124321.GD1987@duck.suse.cz>
References: <20080306174209.GA14193@duck.suse.cz>
	 <1209166706.6040.20.camel@localhost.localdomain>
	 <20080428122626.GC17054@duck.suse.cz>
	 <1209402694.23575.5.camel@badari-desktop>
	 <20080428180932.GI17054@duck.suse.cz>
	 <1209409764.11872.6.camel@localhost.localdomain>
	 <20080429124321.GD1987@duck.suse.cz>
Content-Type: text/plain
Date: Thu, 01 May 2008 08:16:21 -0700
Message-Id: <1209654981.27240.19.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew & Jan,

I was able to reproduce the customer problem involving DIO
(invalidate_inode_pages2) problem by writing simple testcase
to keep writing to a file using buffered writes and DIO writes
forever in a loop. I see DIO writes fail with -EIO.

After a long debug, found 2 cases how this could happen.
These are race conditions with journal_try_to_free_buffers()
and journal_commit_transaction().

1) journal_submit_data_buffers() tries to get bh_state lock. If
try lock fails, it drops the j_list_lock and sleeps for
bh_state lock, while holding a reference on the buffer.
In the meanwhile, journal_try_to_free_buffers() can clean up the
journal head could call try_to_free_buffers(). try_to_free_buffers()
would fail due to the reference held by journal_submit_data_buffers()
- which in turn causes failues for DIO (invalidate_inode_pages2()).

2) When the buffer is on t_locked_list waiting for IO to finish,
we hold a reference and give up the cpu, if we can't get
bh_state lock. This causes try_to_free_buffers() to fail.

Fix is to drop the reference on the buffer if we can't get
bh_state lock, give up the cpu and re-try the whole operation -
instead of waiting for the vh_state lock.

Does this look like a resonable fix ?

Thanks,
Badari

1) journal_submit_data_buffers() tries to get bh_state lock. If
try lock fails, it drops the j_list_lock and sleeps for
bh_state lock, while holding a reference on the buffer head.
In the meanwhile, journal_try_to_free_buffers() can clean up the
journal head could call try_to_free_buffers(). try_to_free_buffers()
would fail due to the reference held by journal_submit_data_buffers()
- which inturn causes failues for DIO (invalidate_inode_pages2()).

2) When the buffer is on t_locked_list waiting for IO to finish,
we hold a reference and give up the cpu, if we can't get 
bh_state lock. This causes try_to_free_buffers() to fail.

Fix is to drop the reference on the buffer, give up the cpu
and re-try the whole operation.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Reviewed-by: Mingming Cao <mcao@us.ibm.com>
---
 fs/jbd/commit.c  |   20 +++++++++++++-------
 fs/jbd2/commit.c |   20 +++++++++++++-------
 2 files changed, 26 insertions(+), 14 deletions(-)

Index: linux-2.6.25/fs/jbd/commit.c
===================================================================
--- linux-2.6.25.orig/fs/jbd/commit.c	2008-04-30 08:47:14.000000000 -0700
+++ linux-2.6.25/fs/jbd/commit.c	2008-05-01 07:56:20.000000000 -0700
@@ -79,12 +79,16 @@ nope:
 
 /*
  * Try to acquire jbd_lock_bh_state() against the buffer, when j_list_lock is
- * held.  For ranking reasons we must trylock.  If we lose, schedule away and
+ * held.  For ranking reasons we must trylock.  If we lose,  unlock the buffer
+ * if needed, drop the reference on the buffer, schedule away and
  * return 0.  j_list_lock is dropped in this case.
  */
-static int inverted_lock(journal_t *journal, struct buffer_head *bh)
+static int inverted_lock(journal_t *journal, struct buffer_head *bh, int locked)
 {
 	if (!jbd_trylock_bh_state(bh)) {
+		if (locked)
+			unlock_buffer(bh);
+		put_bh(bh);
 		spin_unlock(&journal->j_list_lock);
 		schedule();
 		return 0;
@@ -218,10 +222,13 @@ write_out_data:
 			}
 			locked = 1;
 		}
-		/* We have to get bh_state lock. Again out of order, sigh. */
-		if (!inverted_lock(journal, bh)) {
-			jbd_lock_bh_state(bh);
+		/*
+		 * We have to get bh_state lock.  If the try lock fails, give up
+		 * cpu and retry the whole operation.
+		 */
+		if (!inverted_lock(journal, bh, locked)) {
 			spin_lock(&journal->j_list_lock);
+			continue;
 		}
 		/* Someone already cleaned up the buffer? */
 		if (!buffer_jbd(bh)
@@ -430,8 +437,7 @@ void journal_commit_transaction(journal_
 				err = -EIO;
 			spin_lock(&journal->j_list_lock);
 		}
-		if (!inverted_lock(journal, bh)) {
-			put_bh(bh);
+		if (!inverted_lock(journal, bh, 0)) {
 			spin_lock(&journal->j_list_lock);
 			continue;
 		}
Index: linux-2.6.25/fs/jbd2/commit.c
===================================================================
--- linux-2.6.25.orig/fs/jbd2/commit.c	2008-04-30 08:47:14.000000000 -0700
+++ linux-2.6.25/fs/jbd2/commit.c	2008-05-01 07:56:26.000000000 -0700
@@ -81,12 +81,16 @@ nope:
 
 /*
  * Try to acquire jbd_lock_bh_state() against the buffer, when j_list_lock is
- * held.  For ranking reasons we must trylock.  If we lose, schedule away and
+ * held.  For ranking reasons we must trylock.  If we lose,  unlock the buffer
+ * if needed, drop the reference on the buffer, schedule away and
  * return 0.  j_list_lock is dropped in this case.
  */
-static int inverted_lock(journal_t *journal, struct buffer_head *bh)
+static int inverted_lock(journal_t *journal, struct buffer_head *bh, int locked)
 {
 	if (!jbd_trylock_bh_state(bh)) {
+		if (locked)
+			unlock_buffer(bh);
+		put_bh(bh);
 		spin_unlock(&journal->j_list_lock);
 		schedule();
 		return 0;
@@ -217,8 +221,7 @@ static int journal_wait_on_locked_list(j
 				ret = -EIO;
 			spin_lock(&journal->j_list_lock);
 		}
-		if (!inverted_lock(journal, bh)) {
-			put_bh(bh);
+		if (!inverted_lock(journal, bh, 0)) {
 			spin_lock(&journal->j_list_lock);
 			continue;
 		}
@@ -296,10 +299,13 @@ write_out_data:
 			}
 			locked = 1;
 		}
-		/* We have to get bh_state lock. Again out of order, sigh. */
-		if (!inverted_lock(journal, bh)) {
-			jbd_lock_bh_state(bh);
+		/*
+		 * We have to get bh_state lock.  If the try lock fails, give up
+		 * cpu and retry the whole operation.
+		 */
+		if (!inverted_lock(journal, bh, locked)) {
 			spin_lock(&journal->j_list_lock);
+			continue;
 		}
 		/* Someone already cleaned up the buffer? */
 		if (!buffer_jbd(bh)


