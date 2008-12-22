Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYLVVyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYLVVyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbYLVVtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:49:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbYLVVtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:49:09 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 14/56] quota: Allow negative usage of space and inodes
Date: Mon, 22 Dec 2008 13:47:55 -0800
Message-Id: <1229982517-3455-15-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

For clustered filesystems, it can happen that space / inode usage goes
negative temporarily (because some node is allocating another node
is freeing and they are not completely in sync). So let quota code
allow this and change qsize_t so a signed type so that we don't
underflow the variables.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/dquot.c            |    6 ++++--
 include/linux/quota.h |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index f4d6f7e..cf0dac7 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -847,7 +847,8 @@ static inline void dquot_incr_space(struct dquot *dquot, qsize_t number)
 
 static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
 {
-	if (dquot->dq_dqb.dqb_curinodes > number)
+	if (sb_dqopt(dquot->dq_sb)->flags & DQUOT_NEGATIVE_USAGE ||
+	    dquot->dq_dqb.dqb_curinodes >= number)
 		dquot->dq_dqb.dqb_curinodes -= number;
 	else
 		dquot->dq_dqb.dqb_curinodes = 0;
@@ -858,7 +859,8 @@ static inline void dquot_decr_inodes(struct dquot *dquot, qsize_t number)
 
 static inline void dquot_decr_space(struct dquot *dquot, qsize_t number)
 {
-	if (dquot->dq_dqb.dqb_curspace > number)
+	if (sb_dqopt(dquot->dq_sb)->flags & DQUOT_NEGATIVE_USAGE ||
+	    dquot->dq_dqb.dqb_curspace >= number)
 		dquot->dq_dqb.dqb_curspace -= number;
 	else
 		dquot->dq_dqb.dqb_curspace = 0;
diff --git a/include/linux/quota.h b/include/linux/quota.h
index e51dfdc..75bf761 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -168,7 +168,7 @@ enum {
 #include <asm/atomic.h>
 
 typedef __kernel_uid32_t qid_t; /* Type in which we store ids in memory */
-typedef __u64 qsize_t;          /* Type in which we store sizes */
+typedef long long qsize_t;	/* Type in which we store sizes */
 
 extern spinlock_t dq_data_lock;
 
@@ -336,6 +336,7 @@ enum {
 						 * responsible for setting
 						 * S_NOQUOTA, S_NOATIME flags
 						 */
+#define DQUOT_NEGATIVE_USAGE	(1 << 7)	/* Allow negative quota usage */
 
 static inline unsigned int dquot_state_flag(unsigned int flags, int type)
 {
-- 
1.5.6

