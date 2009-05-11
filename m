Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbZEKSBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbZEKSBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZEKSAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:00:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38156 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756938AbZEKSAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:00:49 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/3] IMA: Handle dentry_open failures
To: zohar@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org
Date: Mon, 11 May 2009 13:59:16 -0400
Message-ID: <20090511175916.7719.34187.stgit@dhcp231-142.rdu.redhat.com>
In-Reply-To: <20090511175909.7719.94816.stgit@dhcp231-142.rdu.redhat.com>
References: <20090511175909.7719.94816.stgit@dhcp231-142.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently IMA does not handle failures from dentry_open().  This means that we
leave a pointer set to ERR_PTR(errno) and then try to use it just a few lines
later in fput().  Oops.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 security/integrity/ima/ima_main.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index cdae13c..1987424 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -116,10 +116,6 @@ static int get_path_measurement(struct ima_iint_cache *iint, struct file *file,
 {
 	int rc = 0;
 
-	if (IS_ERR(file)) {
-		pr_info("%s dentry_open failed\n", filename);
-		return rc;
-	}
 	iint->opencount++;
 	iint->readcount++;
 
@@ -185,6 +181,12 @@ int ima_path_check(struct path *path, int mask)
 		struct vfsmount *mnt = mntget(path->mnt);
 
 		file = dentry_open(dentry, mnt, O_RDONLY, current_cred());
+		if (IS_ERR(file)) {
+			pr_info("%s dentry_open failed\n", dentry->d_name.name);
+			rc = PTR_ERR(file);
+			file = NULL;
+			goto out;
+		}
 		rc = get_path_measurement(iint, file, dentry->d_name.name);
 	}
 out:

