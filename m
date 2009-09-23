Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZIXAhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZIXAhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZIXAgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:36:46 -0400
Received: from smtp231.iad.emailsrvr.com ([207.97.245.231]:39156 "EHLO
	smtp231.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbZIXA3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:29:51 -0400
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: [PATCH v18 61/80] c/r: restore file->f_cred
Date: Wed, 23 Sep 2009 19:51:41 -0400
Message-Id: <1253749920-18673-62-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253749920-18673-1-git-send-email-orenl@librato.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

Restore a file's f_cred.  This is set to the cred of the task doing
the open, so often it will be the same as that of the restarted task.

Changelog[v1]:
  - [Nathan Lynch] discard const from struct cred * where appropriate

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 checkpoint/files.c             |   18 ++++++++++++++++--
 include/linux/checkpoint_hdr.h |    2 +-
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/checkpoint/files.c b/checkpoint/files.c
index 190c95b..1de89d6 100644
--- a/checkpoint/files.c
+++ b/checkpoint/files.c
@@ -147,12 +147,18 @@ static int scan_fds(struct files_struct *files, int **fdtable)
 int checkpoint_file_common(struct ckpt_ctx *ctx, struct file *file,
 			   struct ckpt_hdr_file *h)
 {
+	struct cred *f_cred = (struct cred *) file->f_cred;
+
 	h->f_flags = file->f_flags;
 	h->f_mode = file->f_mode;
 	h->f_pos = file->f_pos;
 	h->f_version = file->f_version;
 
-	/* FIX: need also file->uid, file->gid, file->f_owner, etc */
+	h->f_credref = checkpoint_obj(ctx, f_cred, CKPT_OBJ_CRED);
+	if (h->f_credref < 0)
+		return h->f_credref;
+
+	/* FIX: need also file->f_owner, etc */
 
 	return 0;
 }
@@ -489,8 +495,16 @@ int restore_file_common(struct ckpt_ctx *ctx, struct file *file,
 	fmode_t new_mode = file->f_mode;
 	fmode_t saved_mode = (__force fmode_t) h->f_mode;
 	int ret;
+	struct cred *cred;
+
+	/* FIX: need to restore owner etc */
 
-	/* FIX: need to restore uid, gid, owner etc */
+	/* restore the cred */
+	cred = ckpt_obj_fetch(ctx, h->f_credref, CKPT_OBJ_CRED);
+	if (IS_ERR(cred))
+		return PTR_ERR(cred);
+	put_cred(file->f_cred);
+	file->f_cred = get_cred(cred);
 
 	/* safe to set 1st arg (fd) to 0, as command is F_SETFL */
 	ret = vfs_fcntl(0, F_SETFL, h->f_flags & CKPT_SETFL_MASK, file);
diff --git a/include/linux/checkpoint_hdr.h b/include/linux/checkpoint_hdr.h
index 3f00bce..ca24112 100644
--- a/include/linux/checkpoint_hdr.h
+++ b/include/linux/checkpoint_hdr.h
@@ -350,7 +350,7 @@ struct ckpt_hdr_file {
 	__u32 f_type;
 	__u32 f_mode;
 	__u32 f_flags;
-	__u32 _padding;
+	__s32 f_credref;
 	__u64 f_pos;
 	__u64 f_version;
 } __attribute__((aligned(8)));
-- 
1.6.0.4

