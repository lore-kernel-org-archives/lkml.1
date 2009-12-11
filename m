Return-Path: <linux-kernel-owner+w=401wt.eu-S1762275AbZLKEuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762275AbZLKEuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760816AbZLKEuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:50:20 -0500
Received: from kroah.org ([198.145.64.141]:36928 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760794AbZLKEgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:15 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:59 2009
Message-Id: <20091211042759.257547227@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:25:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Curt Wohlgemuth <curtw@google.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [48/90] ext4: Handle nested ext4_journal_start/stop calls without a journal
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0048-ext4-Handle-nested-ext4_journal_start-stop-calls-wit.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit d3d1faf6a74496ea4435fd057c6a2cad49f3e523)

This patch fixes a problem with handling nested calls to
ext4_journal_start/ext4_journal_stop, when there is no journal present.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4_jbd2.h |    6 ++++--
 fs/ext4/namei.c     |    3 ++-
 fs/ext4/super.c     |   42 ++++++++++++++++++++++++++++++++----------
 3 files changed, 38 insertions(+), 13 deletions(-)

--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -161,11 +161,13 @@ int __ext4_handle_dirty_metadata(const c
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
 int __ext4_journal_stop(const char *where, handle_t *handle);
 
-#define EXT4_NOJOURNAL_HANDLE	((handle_t *) 0x1)
+#define EXT4_NOJOURNAL_MAX_REF_COUNT ((unsigned long) 4096)
 
+/* Note:  Do not use this for NULL handles.  This is only to determine if
+ * a properly allocated handle is using a journal or not. */
 static inline int ext4_handle_valid(handle_t *handle)
 {
-	if (handle == EXT4_NOJOURNAL_HANDLE)
+	if ((unsigned long)handle < EXT4_NOJOURNAL_MAX_REF_COUNT)
 		return 0;
 	return 1;
 }
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2068,7 +2068,8 @@ int ext4_orphan_del(handle_t *handle, st
 	struct ext4_iloc iloc;
 	int err = 0;
 
-	if (!ext4_handle_valid(handle))
+	/* ext4_handle_valid() assumes a valid handle_t pointer */
+	if (handle && !ext4_handle_valid(handle))
 		return 0;
 
 	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -189,6 +189,36 @@ void ext4_itable_unused_set(struct super
 		bg->bg_itable_unused_hi = cpu_to_le16(count >> 16);
 }
 
+
+/* Just increment the non-pointer handle value */
+static handle_t *ext4_get_nojournal(void)
+{
+	handle_t *handle = current->journal_info;
+	unsigned long ref_cnt = (unsigned long)handle;
+
+	BUG_ON(ref_cnt >= EXT4_NOJOURNAL_MAX_REF_COUNT);
+
+	ref_cnt++;
+	handle = (handle_t *)ref_cnt;
+
+	current->journal_info = handle;
+	return handle;
+}
+
+
+/* Decrement the non-pointer handle value */
+static void ext4_put_nojournal(handle_t *handle)
+{
+	unsigned long ref_cnt = (unsigned long)handle;
+
+	BUG_ON(ref_cnt == 0);
+
+	ref_cnt--;
+	handle = (handle_t *)ref_cnt;
+
+	current->journal_info = handle;
+}
+
 /*
  * Wrappers for jbd2_journal_start/end.
  *
@@ -215,11 +245,7 @@ handle_t *ext4_journal_start_sb(struct s
 		}
 		return jbd2_journal_start(journal, nblocks);
 	}
-	/*
-	 * We're not journaling, return the appropriate indication.
-	 */
-	current->journal_info = EXT4_NOJOURNAL_HANDLE;
-	return current->journal_info;
+	return ext4_get_nojournal();
 }
 
 /*
@@ -235,11 +261,7 @@ int __ext4_journal_stop(const char *wher
 	int rc;
 
 	if (!ext4_handle_valid(handle)) {
-		/*
-		 * Do this here since we don't call jbd2_journal_stop() in
-		 * no-journal mode.
-		 */
-		current->journal_info = NULL;
+		ext4_put_nojournal(handle);
 		return 0;
 	}
 	sb = handle->h_transaction->t_journal->j_private;


