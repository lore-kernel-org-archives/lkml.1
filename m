Return-Path: <linux-kernel-owner+w=401wt.eu-S1764643AbXGKOTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764643AbXGKOTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 10:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759978AbXGKOSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 10:18:55 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55144 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758926AbXGKOSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 10:18:54 -0400
Date: Wed, 11 Jul 2007 09:18:50 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Cc: Steve Beattie <sbeattie@suse.de>
Subject: [PATCH 1/1] file capabilities: clear caps cleanup
Message-ID: <20070711141850.GA6690@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 88115394044e697ac852f7fb9f30483e87f4f598 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Wed, 11 Jul 2007 10:01:01 -0400
Subject: [PATCH 1/1] file capabilities: clear caps cleanup

As suggested by Steve Beattie, rather than jump into a
conditional block in certain cases, define and use a
static inline bprm_clear_caps().

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/commoncap.c |   26 +++++++++++++++-----------
 1 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index cc50a61..b08d250 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -109,6 +109,13 @@ void cap_capset_set (struct task_struct *target, kernel_cap_t *effective,
 	target->cap_permitted = *permitted;
 }
 
+static inline void bprm_clear_caps(struct linux_binprm *bprm)
+{
+	cap_clear (bprm->cap_inheritable);
+	cap_clear (bprm->cap_permitted);
+	cap_clear (bprm->cap_effective);
+}
+
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 
 static inline int cap_from_disk(struct vfs_cap_data_disk *dcap,
@@ -144,8 +151,10 @@ static int get_file_caps(struct linux_binprm *bprm)
 	struct inode *inode;
 
 	dcaps = (struct vfs_cap_data_disk *)&v1caps;
-	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID)
-		goto clear_caps;
+	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
+		bprm_clear_caps(bprm);
+		return 0;
+	}
 
 	dentry = dget(bprm->file->f_dentry);
 	inode = dentry->d_inode;
@@ -186,21 +195,16 @@ out:
 	dput(dentry);
 	if ((void *)dcaps != (void *)&v1caps)
 		kfree(dcaps);
-	if (rc) {
-clear_caps:
-		cap_clear (bprm->cap_inheritable);
-		cap_clear (bprm->cap_permitted);
-		cap_clear (bprm->cap_effective);
-	}
+	if (rc)
+		bprm_clear_caps(bprm);
+
 	return rc;
 }
 
 #else
 static inline int get_file_caps(struct linux_binprm *bprm)
 {
-	cap_clear (bprm->cap_inheritable);
-	cap_clear (bprm->cap_permitted);
-	cap_clear (bprm->cap_effective);
+	bprm_clear_caps(bprm);
 	return 0;
 }
 #endif
-- 
1.5.1.1.GIT

