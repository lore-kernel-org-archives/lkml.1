Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbYJ2TH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbYJ2TH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 15:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYJ2THN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 15:07:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37674 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbYJ2THK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 15:07:10 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v1 3/3] filesystems: use has_capability_noaudit interface for
	reserved blocks checks
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Cc: sds@tycho.nsa.gov, jmorris@nameil.org, serue@us.ibm.com, morgan@kernel.org,
       casey@schaufler-ca.com, esandeen@redhat.com
Date: Wed, 29 Oct 2008 15:07:03 -0400
Message-ID: <20081029190703.31292.55701.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081029190652.31292.5901.stgit@paris.rdu.redhat.com>
References: <20081029190652.31292.5901.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext2, ext3, ufs, and ubifs all check for  CAP_SYS_RESOURCE to determine
if they should allow reserved blocks to be used.  A process not having
this capability is not failing some security decision and should not be
audited.  Thus move to using has_capability_noaudit.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/ext2/balloc.c     |    3 ++-
 fs/ext3/balloc.c     |    3 ++-
 fs/ubifs/budget.c    |    4 +++-
 fs/ufs/balloc.c      |    3 ++-
 security/commoncap.c |    1 +
 security/security.c  |    1 +
 6 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 6dac7ba..bf34375 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -16,6 +16,7 @@
 #include <linux/sched.h>
 #include <linux/buffer_head.h>
 #include <linux/capability.h>
+#include <linux/security.h>
 
 /*
  * balloc.c contains the blocks allocation and deallocation routines
@@ -1192,7 +1193,7 @@ static int ext2_has_free_blocks(struct ext2_sb_info *sbi)
 
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
-	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
+	if (free_blocks < root_blocks + 1 && !has_capability_noaudit(current, CAP_SYS_RESOURCE) &&
 		sbi->s_resuid != current->fsuid &&
 		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
 		return 0;
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index f5b57a2..e60dd8e 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -13,6 +13,7 @@
 
 #include <linux/time.h>
 #include <linux/capability.h>
+#include <linux/security.h>
 #include <linux/fs.h>
 #include <linux/jbd.h>
 #include <linux/ext3_fs.h>
@@ -1421,7 +1422,7 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
 
 	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
-	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
+	if (free_blocks < root_blocks + 1 && !has_capability_noaudit(current, CAP_SYS_RESOURCE) &&
 		sbi->s_resuid != current->fsuid &&
 		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
 		return 0;
diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index 1a4973e..6d13259 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -32,6 +32,8 @@
 
 #include "ubifs.h"
 #include <linux/writeback.h>
+#include <linux/capability.h>
+#include <linux/security.h>
 #include <asm/div64.h>
 
 /*
@@ -363,7 +365,7 @@ long long ubifs_calc_available(const struct ubifs_info *c, int min_idx_lebs)
  */
 static int can_use_rp(struct ubifs_info *c)
 {
-	if (current->fsuid == c->rp_uid || capable(CAP_SYS_RESOURCE) ||
+	if (current->fsuid == c->rp_uid || has_capability_noaudit(current, CAP_SYS_RESOURCE) ||
 	    (c->rp_gid != 0 && in_group_p(c->rp_gid)))
 		return 1;
 	return 0;
diff --git a/fs/ufs/balloc.c b/fs/ufs/balloc.c
index 0d9ada1..a0a7425 100644
--- a/fs/ufs/balloc.c
+++ b/fs/ufs/balloc.c
@@ -15,6 +15,7 @@
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 #include <linux/capability.h>
+#include <linux/security.h>
 #include <linux/bitops.h>
 #include <asm/byteorder.h>
 
@@ -411,7 +412,7 @@ u64 ufs_new_fragments(struct inode *inode, void *p, u64 fragment,
 	/*
 	 * There is not enough space for user on the device
 	 */
-	if (!capable(CAP_SYS_RESOURCE) && ufs_freespace(uspi, UFS_MINFREE) <= 0) {
+	if (!has_capability_noaudit(current, CAP_SYS_RESOURCE) && ufs_freespace(uspi, UFS_MINFREE) <= 0) {
 		unlock_super (sb);
 		UFSD("EXIT (FAILED)\n");
 		return 0;
diff --git a/security/commoncap.c b/security/commoncap.c
index 243e223..ef0083f 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -55,6 +55,7 @@ int cap_capable(struct task_struct *tsk, int cap, int audit)
 		return 0;
 	return -EPERM;
 }
+EXPORT_SYMBOL(cap_capable);
 
 int cap_settime(struct timespec *ts, struct timezone *tz)
 {
diff --git a/security/security.c b/security/security.c
index 271f9a7..157e3a3 100644
--- a/security/security.c
+++ b/security/security.c
@@ -170,6 +170,7 @@ int security_capable_noaudit(struct task_struct *tsk, int cap)
 {
 	return security_ops->capable(tsk, cap, 0);
 }
+EXPORT_SYMBOL(security_capable_noaudit);
 
 int security_acct(struct file *file)
 {

