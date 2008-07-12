Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbYGLMel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbYGLMel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 08:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbYGLMee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 08:34:34 -0400
Received: from styx.suse.cz ([82.119.242.94]:58653 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752395AbYGLMed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 08:34:33 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Vladislav Bogdanov <slava@nsys.by>
Subject: [PATCH] quota: Implement sending information via netlink about user below quota
Date: Sat, 12 Jul 2008 14:34:31 +0200
Message-Id: <12158660713206-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it may be useful for userspace to know (e.g. for some hosting guys)
that some user stopped exceeding his hardlimit or softlimit in quotas.
Implement sending of such events to userspace via quota netlink protocol so
that they don't have to poll for such events. Based on idea and initial
implementation by Vladislav Bogdanov <slava@nsys.by>.

CC: Vladislav Bogdanov <slava@nsys.by>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c            |   60 ++++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/quota.h |    4 +++
 2 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 5ac77da..ba1f075 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -875,7 +875,10 @@ static void print_warning(struct dquot *dquot, const int warntype)
 	char *msg = NULL;
 	struct tty_struct *tty;
 
-	if (!need_print_warning(dquot))
+	if (warntype == QUOTA_NL_IHARDBELOW ||
+	    warntype == QUOTA_NL_ISOFTBELOW ||
+	    warntype == QUOTA_NL_BHARDBELOW ||
+	    warntype == QUOTA_NL_BSOFTBELOW || !need_print_warning(dquot))
 		return;
 
 	mutex_lock(&tty_mutex);
@@ -1083,6 +1086,35 @@ static int check_bdq(struct dquot *dquot, qsize_t space, int prealloc, char *war
 	return QUOTA_OK;
 }
 
+static int info_idq_free(struct dquot *dquot, ulong inodes)
+{
+	if (test_bit(DQ_FAKE_B, &dquot->dq_flags) ||
+	    dquot->dq_dqb.dqb_curinodes <= dquot->dq_dqb.dqb_isoftlimit)
+		return QUOTA_NL_NOWARN;
+
+	if (dquot->dq_dqb.dqb_curinodes - inodes <= dquot->dq_dqb.dqb_isoftlimit)
+		return QUOTA_NL_ISOFTBELOW;
+	if (dquot->dq_dqb.dqb_curinodes >= dquot->dq_dqb.dqb_ihardlimit &&
+	    dquot->dq_dqb.dqb_curinodes - inodes < dquot->dq_dqb.dqb_ihardlimit)
+		return QUOTA_NL_IHARDBELOW;
+	return QUOTA_NL_NOWARN;
+}
+
+static int info_bdq_free(struct dquot *dquot, qsize_t space)
+{
+	if (test_bit(DQ_FAKE_B, &dquot->dq_flags) ||
+	    toqb(dquot->dq_dqb.dqb_curspace) <= dquot->dq_dqb.dqb_bsoftlimit)
+		return QUOTA_NL_NOWARN;
+
+	if (toqb(dquot->dq_dqb.dqb_curspace - space) <=
+	    dquot->dq_dqb.dqb_bsoftlimit)
+		return QUOTA_NL_BSOFTBELOW;
+	if (toqb(dquot->dq_dqb.dqb_curspace) >= dquot->dq_dqb.dqb_bhardlimit &&
+	    toqb(dquot->dq_dqb.dqb_curspace - space) <
+						dquot->dq_dqb.dqb_bhardlimit)
+		return QUOTA_NL_BHARDBELOW;
+	return QUOTA_NL_NOWARN;
+}
 /*
  *	Initialize quota pointers in inode
  *	Transaction must be started at entry
@@ -1248,6 +1280,7 @@ warn_put_all:
 int dquot_free_space(struct inode *inode, qsize_t number)
 {
 	unsigned int cnt;
+	char warntype[MAXQUOTAS];
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
@@ -1256,6 +1289,7 @@ out_sub:
 		inode_sub_bytes(inode, number);
 		return QUOTA_OK;
 	}
+
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	/* Now recheck reliably when holding dqptr_sem */
 	if (IS_NOQUOTA(inode)) {
@@ -1266,6 +1300,7 @@ out_sub:
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (inode->i_dquot[cnt] == NODQUOT)
 			continue;
+		warntype[cnt] = info_bdq_free(inode->i_dquot[cnt], number);
 		dquot_decr_space(inode->i_dquot[cnt], number);
 	}
 	inode_sub_bytes(inode, number);
@@ -1274,6 +1309,7 @@ out_sub:
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		if (inode->i_dquot[cnt])
 			mark_dquot_dirty(inode->i_dquot[cnt]);
+	flush_warnings(inode->i_dquot, warntype);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
@@ -1284,11 +1320,13 @@ out_sub:
 int dquot_free_inode(const struct inode *inode, unsigned long number)
 {
 	unsigned int cnt;
+	char warntype[MAXQUOTAS];
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
 	if (IS_NOQUOTA(inode))
 		return QUOTA_OK;
+
 	down_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	/* Now recheck reliably when holding dqptr_sem */
 	if (IS_NOQUOTA(inode)) {
@@ -1299,6 +1337,7 @@ int dquot_free_inode(const struct inode *inode, unsigned long number)
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (inode->i_dquot[cnt] == NODQUOT)
 			continue;
+		warntype[cnt] = info_idq_free(inode->i_dquot[cnt], number);
 		dquot_decr_inodes(inode->i_dquot[cnt], number);
 	}
 	spin_unlock(&dq_data_lock);
@@ -1306,6 +1345,7 @@ int dquot_free_inode(const struct inode *inode, unsigned long number)
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++)
 		if (inode->i_dquot[cnt])
 			mark_dquot_dirty(inode->i_dquot[cnt]);
+	flush_warnings(inode->i_dquot, warntype);
 	up_read(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	return QUOTA_OK;
 }
@@ -1323,7 +1363,8 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 	struct dquot *transfer_to[MAXQUOTAS];
 	int cnt, ret = NO_QUOTA, chuid = (iattr->ia_valid & ATTR_UID) && inode->i_uid != iattr->ia_uid,
 	    chgid = (iattr->ia_valid & ATTR_GID) && inode->i_gid != iattr->ia_gid;
-	char warntype[MAXQUOTAS];
+	char warntype_to[MAXQUOTAS];
+	char warntype_from_inodes[MAXQUOTAS], warntype_from_space[MAXQUOTAS];
 
 	/* First test before acquiring mutex - solves deadlocks when we
          * re-enter the quota code and are already holding the mutex */
@@ -1332,7 +1373,7 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 	/* Clear the arrays */
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		transfer_to[cnt] = transfer_from[cnt] = NODQUOT;
-		warntype[cnt] = QUOTA_NL_NOWARN;
+		warntype_to[cnt] = QUOTA_NL_NOWARN;
 	}
 	down_write(&sb_dqopt(inode->i_sb)->dqptr_sem);
 	/* Now recheck reliably when holding dqptr_sem */
@@ -1364,8 +1405,9 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 		if (transfer_to[cnt] == NODQUOT)
 			continue;
 		transfer_from[cnt] = inode->i_dquot[cnt];
-		if (check_idq(transfer_to[cnt], 1, warntype+cnt) == NO_QUOTA ||
-		    check_bdq(transfer_to[cnt], space, 0, warntype+cnt) == NO_QUOTA)
+		if (check_idq(transfer_to[cnt], 1, warntype_to + cnt) ==
+		    NO_QUOTA || check_bdq(transfer_to[cnt], space, 0,
+		    warntype_to + cnt) == NO_QUOTA)
 			goto warn_put_all;
 	}
 
@@ -1381,6 +1423,10 @@ int dquot_transfer(struct inode *inode, struct iattr *iattr)
 
 		/* Due to IO error we might not have transfer_from[] structure */
 		if (transfer_from[cnt]) {
+			warntype_from_inodes[cnt] =
+				info_idq_free(transfer_from[cnt], 1);
+			warntype_from_space[cnt] =
+				info_bdq_free(transfer_from[cnt], space);
 			dquot_decr_inodes(transfer_from[cnt], 1);
 			dquot_decr_space(transfer_from[cnt], space);
 		}
@@ -1400,7 +1446,9 @@ warn_put_all:
 		if (transfer_to[cnt])
 			mark_dquot_dirty(transfer_to[cnt]);
 	}
-	flush_warnings(transfer_to, warntype);
+	flush_warnings(transfer_to, warntype_to);
+	flush_warnings(transfer_from, warntype_from_inodes);
+	flush_warnings(transfer_from, warntype_from_space);
 	
 	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
 		if (ret == QUOTA_OK && transfer_from[cnt] != NODQUOT)
diff --git a/include/linux/quota.h b/include/linux/quota.h
index dcddfb2..2b577cb 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -138,6 +138,10 @@ struct if_dqinfo {
 #define QUOTA_NL_BHARDWARN 4		/* Block hardlimit reached */
 #define QUOTA_NL_BSOFTLONGWARN 5	/* Block grace time expired */
 #define QUOTA_NL_BSOFTWARN 6		/* Block softlimit reached */
+#define QUOTA_NL_IHARDBELOW 7		/* Usage got below inode hardlimit */
+#define QUOTA_NL_ISOFTBELOW 8		/* Usage got below inode softlimit */
+#define QUOTA_NL_BHARDBELOW 9		/* Usage got below block hardlimit */
+#define QUOTA_NL_BSOFTBELOW 10		/* Usage got below block softlimit */
 
 enum {
 	QUOTA_NL_C_UNSPEC,
-- 
1.5.4.5

