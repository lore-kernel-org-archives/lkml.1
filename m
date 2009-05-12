Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZELTPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZELTPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZELTPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:15:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37727 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbZELTPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:15:38 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] IMA: remove read permissions on the ima policy file
To: zohar@linux.vnet.ibm.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org
Date: Tue, 12 May 2009 15:13:55 -0400
Message-ID: <20090512191355.6874.31248.stgit@dhcp231-142.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IMA policy file does not implement read.  Trying to just open/read/close
the file will load a blank policy and you cannot then change the policy
without a reboot.  This removes the read permission from the file so one must
at least be attempting to write...

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 security/integrity/ima/ima_fs.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
index 510186f..2a829da 100644
--- a/security/integrity/ima/ima_fs.c
+++ b/security/integrity/ima/ima_fs.c
@@ -15,6 +15,7 @@
  *	implemenents security file system for reporting
  *	current measurement list and IMA statistics
  */
+#include <linux/fcntl.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/rculist.h>
@@ -283,6 +284,9 @@ static atomic_t policy_opencount = ATOMIC_INIT(1);
  */
 int ima_open_policy(struct inode * inode, struct file * filp)
 {
+	/* No point in being allowed to open it if you aren't going to write */
+	if (!(filp->f_flags & O_WRONLY))
+		return -EACCES;
 	if (atomic_dec_and_test(&policy_opencount))
 		return 0;
 	return -EBUSY;
@@ -349,7 +353,7 @@ int ima_fs_init(void)
 		goto out;
 
 	ima_policy = securityfs_create_file("policy",
-					    S_IRUSR | S_IRGRP | S_IWUSR,
+					    S_IWUSR,
 					    ima_dir, NULL,
 					    &ima_measure_policy_ops);
 	if (IS_ERR(ima_policy))

