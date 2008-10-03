Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbYJCFZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbYJCFZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 01:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYJCFZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 01:25:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbYJCFZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 01:25:00 -0400
Date: Thu, 2 Oct 2008 22:24:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-Id: <20081002222438.8f9f90a2.akpm@linux-foundation.org>
In-Reply-To: <20081002220040.7963596c@infradead.org>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<20081002062736.GR19428@kernel.dk>
	<20081001235501.2b7f50fe.akpm@linux-foundation.org>
	<20081002061236.3c71c877@infradead.org>
	<20081002132457.46ad8d05.akpm@linux-foundation.org>
	<20081002210117.0f5062f7@infradead.org>
	<20081002212355.621a4fb6@infradead.org>
	<20081002214000.89420bb3.akpm@linux-foundation.org>
	<20081002214353.30873f98@infradead.org>
	<20081002215026.a63ba0d0.akpm@linux-foundation.org>
	<20081002220040.7963596c@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 22:00:40 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> > Of course, fixing this running-vs-committing contention point would
> > fix a lot more things than just atime updates.
> 
> yes clearly. It's waaay above my paygrade to hack on though; JBD is one
> of those places in the kernel that scare me for doing fundamental
> changes ;-(

If someone has an hour or so to kill, we can pretend to fix it:


 fs/ext3/super.c         |   12 +++++++++++-
 fs/jbd/transaction.c    |   13 +++++++++++--
 include/linux/ext3_fs.h |    1 +
 include/linux/jbd.h     |    1 +
 4 files changed, 24 insertions(+), 3 deletions(-)

diff -puN fs/ext3/super.c~a fs/ext3/super.c
--- a/fs/ext3/super.c~a
+++ a/fs/ext3/super.c
@@ -617,6 +617,8 @@ static int ext3_show_options(struct seq_
 		seq_puts(seq, ",barrier=1");
 	if (test_opt(sb, NOBH))
 		seq_puts(seq, ",nobh");
+	if (test_opt(sb, AKPM))
+		seq_puts(seq, ",akpm");
 
 	if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA)
 		seq_puts(seq, ",data=journal");
@@ -757,7 +759,7 @@ enum {
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
-	Opt_grpquota
+	Opt_grpquota, Opt_akpm,
 };
 
 static match_table_t tokens = {
@@ -808,6 +810,7 @@ static match_table_t tokens = {
 	{Opt_usrquota, "usrquota"},
 	{Opt_barrier, "barrier=%u"},
 	{Opt_resize, "resize"},
+	{Opt_akpm, "akpm"},
 	{Opt_err, NULL},
 };
 
@@ -1097,6 +1100,9 @@ set_qf_format:
 			set_opt(sbi->s_mount_opt, QUOTA);
 			set_opt(sbi->s_mount_opt, GRPQUOTA);
 			break;
+		case Opt_akpm:
+			set_opt(sbi->s_mount_opt, AKPM);
+			break;
 		case Opt_noquota:
 			if (sb_any_quota_enabled(sb) ||
 			    sb_any_quota_suspended(sb)) {
@@ -1986,6 +1992,10 @@ static void ext3_init_journal_params(str
 		journal->j_flags |= JFS_BARRIER;
 	else
 		journal->j_flags &= ~JFS_BARRIER;
+	if (test_opt(sb, AKPM))
+		journal->j_flags |= JFS_AKPM;
+	else
+		journal->j_flags &= ~JFS_AKPM;
 	spin_unlock(&journal->j_state_lock);
 }
 
diff -puN include/linux/ext3_fs.h~a include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~a
+++ a/include/linux/ext3_fs.h
@@ -380,6 +380,7 @@ struct ext3_inode {
 #define EXT3_MOUNT_QUOTA		0x80000 /* Some quota option set */
 #define EXT3_MOUNT_USRQUOTA		0x100000 /* "old" user quota */
 #define EXT3_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
+#define EXT3_MOUNT_AKPM			0x400000
 
 /* Compatibility, for having both ext2_fs.h and ext3_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
diff -puN include/linux/jbd.h~a include/linux/jbd.h
--- a/include/linux/jbd.h~a
+++ a/include/linux/jbd.h
@@ -816,6 +816,7 @@ struct journal_s
 #define JFS_FLUSHED	0x008	/* The journal superblock has been flushed */
 #define JFS_LOADED	0x010	/* The journal superblock has been loaded */
 #define JFS_BARRIER	0x020	/* Use IDE barriers */
+#define JFS_AKPM	0x040
 
 /*
  * Function declarations for the journaling transaction and buffer
diff -puN fs/jbd/transaction.c~a fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~a
+++ a/fs/jbd/transaction.c
@@ -537,6 +537,7 @@ do_get_write_access(handle_t *handle, st
 	int error;
 	char *frozen_buffer = NULL;
 	int need_copy = 0;
+	int locked;
 
 	if (is_handle_aborted(handle))
 		return -EROFS;
@@ -552,7 +553,14 @@ repeat:
 
 	/* @@@ Need to check for errors here at some point. */
 
-	lock_buffer(bh);
+	locked = 0;
+	if (journal->j_flags & JFS_AKPM) {
+		if (trylock_buffer(bh))
+			locked = 1;	/* lolz */
+	} else {
+		lock_buffer(bh);
+		locked = 1;
+	}
 	jbd_lock_bh_state(bh);
 
 	/* We now hold the buffer lock so it is safe to query the buffer
@@ -591,7 +599,8 @@ repeat:
 		jbd_unexpected_dirty_buffer(jh);
 	}
 
-	unlock_buffer(bh);
+	if (locked)
+		unlock_buffer(bh);
 
 	error = -EROFS;
 	if (is_handle_aborted(handle)) {
_


(might emit nasty warnings or assertion failures which will need to be
disabled)


Mount a junk partition with `-oakpm' and run some benchmarks.  If the
results are "wow" then it's worth spending time on.  If the results are
"meh" then we can not bother..

