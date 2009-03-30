Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZC3S1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZC3S1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbZC3SQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:16:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43343 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbZC3SPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:15:16 -0400
Message-Id: <20090330181010.688733279@suse.com>
User-Agent: quilt/0.47-14.9
Date: Mon, 30 Mar 2009 14:02:26 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 11/35 error-handling] reiserfs: rearrange journal abort
References: <20090330180215.951354436@suse.com>
Content-Disposition: inline; filename=patches.suse/reiserfs-rearrange-journal-abort.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch kills off reiserfs_journal_abort as it is never called, and
 combines __reiserfs_journal_abort_{soft,hard} into one function called
 reiserfs_abort_journal, which performs the same work. It is silent
 as opposed to the old version, since the message was always issued
 after a regular 'abort' message.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---
 fs/reiserfs/journal.c       |   23 ++++-------------------
 fs/reiserfs/prints.c        |    2 +-
 include/linux/reiserfs_fs.h |    2 +-
 3 files changed, 6 insertions(+), 21 deletions(-)

--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -4295,14 +4295,15 @@ static int do_journal_end(struct reiserf
 	return journal->j_errno;
 }
 
-static void __reiserfs_journal_abort_hard(struct super_block *sb)
+/* Send the file system read only and refuse new transactions */
+void reiserfs_abort_journal(struct super_block *sb, int errno)
 {
 	struct reiserfs_journal *journal = SB_JOURNAL(sb);
 	if (test_bit(J_ABORTED, &journal->j_state))
 		return;
 
-	printk(KERN_CRIT "REISERFS: Aborting journal for filesystem on %s\n",
-	       reiserfs_bdevname(sb));
+	if (!journal->j_errno)
+		journal->j_errno = errno;
 
 	sb->s_flags |= MS_RDONLY;
 	set_bit(J_ABORTED, &journal->j_state);
@@ -4312,19 +4313,3 @@ static void __reiserfs_journal_abort_har
 #endif
 }
 
-static void __reiserfs_journal_abort_soft(struct super_block *sb, int errno)
-{
-	struct reiserfs_journal *journal = SB_JOURNAL(sb);
-	if (test_bit(J_ABORTED, &journal->j_state))
-		return;
-
-	if (!journal->j_errno)
-		journal->j_errno = errno;
-
-	__reiserfs_journal_abort_hard(sb);
-}
-
-void reiserfs_journal_abort(struct super_block *sb, int errno)
-{
-	__reiserfs_journal_abort_soft(sb, errno);
-}
--- a/fs/reiserfs/prints.c
+++ b/fs/reiserfs/prints.c
@@ -389,7 +389,7 @@ void reiserfs_abort(struct super_block *
 	       error_buf);
 
 	sb->s_flags |= MS_RDONLY;
-	reiserfs_journal_abort(sb, errno);
+	reiserfs_abort_journal(sb, errno);
 }
 
 /* this prints internal nodes (4 keys/items in line) (dc_number,
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -1771,7 +1771,7 @@ int journal_begin(struct reiserfs_transa
 		  struct super_block *p_s_sb, unsigned long);
 int journal_join_abort(struct reiserfs_transaction_handle *,
 		       struct super_block *p_s_sb, unsigned long);
-void reiserfs_journal_abort(struct super_block *sb, int errno);
+void reiserfs_abort_journal(struct super_block *sb, int errno);
 void reiserfs_abort(struct super_block *sb, int errno, const char *fmt, ...);
 int reiserfs_allocate_list_bitmaps(struct super_block *s,
 				   struct reiserfs_list_bitmap *, unsigned int);


