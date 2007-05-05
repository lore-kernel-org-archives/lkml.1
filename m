Return-Path: <linux-kernel-owner+w=401wt.eu-S1161670AbXEEPiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161670AbXEEPiW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161663AbXEEPiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:38:22 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:29479 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161670AbXEEPiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:38:20 -0400
Date: Sat, 5 May 2007 15:19:31 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
Subject: [patch] s390: fix subsystem removal fallout.
Message-ID: <20070505131931.GB13660@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[patch] s390: fix subsystem removal fallout.

From: Cornelia Huck <cornelia.huck@de.ibm.com>

This patch fixes compilation on s390.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/hypfs/inode.c |    2 +-
 arch/s390/kernel/ipl.c  |   26 +++++++++++++-------------
 2 files changed, 14 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/s390/hypfs/inode.c
===================================================================
--- linux-2.6.orig/arch/s390/hypfs/inode.c
+++ linux-2.6/arch/s390/hypfs/inode.c
@@ -477,7 +477,7 @@ static int __init hypfs_init(void)
 			goto fail_diag;
 		}
 	}
-	kset_set_kset_s(&s390_subsys, hypervisor_subsys);
+	kobj_set_kset_s(&s390_subsys, hypervisor_subsys);
 	rc = subsystem_register(&s390_subsys);
 	if (rc)
 		goto fail_sysfs;
Index: linux-2.6/arch/s390/kernel/ipl.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/ipl.c
+++ linux-2.6/arch/s390/kernel/ipl.c
@@ -816,23 +816,23 @@ static int __init ipl_register_fcp_files
 {
 	int rc;
 
-	rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+	rc = sysfs_create_group(&ipl_subsys.kobj,
 				&ipl_fcp_attr_group);
 	if (rc)
 		goto out;
-	rc = sysfs_create_bin_file(&ipl_subsys.kset.kobj,
+	rc = sysfs_create_bin_file(&ipl_subsys.kobj,
 				   &ipl_parameter_attr);
 	if (rc)
 		goto out_ipl_parm;
-	rc = sysfs_create_bin_file(&ipl_subsys.kset.kobj,
+	rc = sysfs_create_bin_file(&ipl_subsys.kobj,
 				   &ipl_scp_data_attr);
 	if (!rc)
 		goto out;
 
-	sysfs_remove_bin_file(&ipl_subsys.kset.kobj, &ipl_parameter_attr);
+	sysfs_remove_bin_file(&ipl_subsys.kobj, &ipl_parameter_attr);
 
 out_ipl_parm:
-	sysfs_remove_group(&ipl_subsys.kset.kobj, &ipl_fcp_attr_group);
+	sysfs_remove_group(&ipl_subsys.kobj, &ipl_fcp_attr_group);
 out:
 	return rc;
 }
@@ -846,7 +846,7 @@ static int __init ipl_init(void)
 		return rc;
 	switch (ipl_info.type) {
 	case IPL_TYPE_CCW:
-		rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+		rc = sysfs_create_group(&ipl_subsys.kobj,
 					&ipl_ccw_attr_group);
 		break;
 	case IPL_TYPE_FCP:
@@ -854,11 +854,11 @@ static int __init ipl_init(void)
 		rc = ipl_register_fcp_files();
 		break;
 	case IPL_TYPE_NSS:
-		rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+		rc = sysfs_create_group(&ipl_subsys.kobj,
 					&ipl_nss_attr_group);
 		break;
 	default:
-		rc = sysfs_create_group(&ipl_subsys.kset.kobj,
+		rc = sysfs_create_group(&ipl_subsys.kobj,
 					&ipl_unknown_attr_group);
 		break;
 	}
@@ -885,7 +885,7 @@ static int __init reipl_nss_init(void)
 
 	if (!MACHINE_IS_VM)
 		return 0;
-	rc = sysfs_create_group(&reipl_subsys.kset.kobj, &reipl_nss_attr_group);
+	rc = sysfs_create_group(&reipl_subsys.kobj, &reipl_nss_attr_group);
 	if (rc)
 		return rc;
 	strncpy(reipl_nss_name, kernel_nss_name, NSS_NAME_SIZE + 1);
@@ -900,7 +900,7 @@ static int __init reipl_ccw_init(void)
 	reipl_block_ccw = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!reipl_block_ccw)
 		return -ENOMEM;
-	rc = sysfs_create_group(&reipl_subsys.kset.kobj, &reipl_ccw_attr_group);
+	rc = sysfs_create_group(&reipl_subsys.kobj, &reipl_ccw_attr_group);
 	if (rc) {
 		free_page((unsigned long)reipl_block_ccw);
 		return rc;
@@ -938,7 +938,7 @@ static int __init reipl_fcp_init(void)
 	reipl_block_fcp = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!reipl_block_fcp)
 		return -ENOMEM;
-	rc = sysfs_create_group(&reipl_subsys.kset.kobj, &reipl_fcp_attr_group);
+	rc = sysfs_create_group(&reipl_subsys.kobj, &reipl_fcp_attr_group);
 	if (rc) {
 		free_page((unsigned long)reipl_block_fcp);
 		return rc;
@@ -990,7 +990,7 @@ static int __init dump_ccw_init(void)
 	dump_block_ccw = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!dump_block_ccw)
 		return -ENOMEM;
-	rc = sysfs_create_group(&dump_subsys.kset.kobj, &dump_ccw_attr_group);
+	rc = sysfs_create_group(&dump_subsys.kobj, &dump_ccw_attr_group);
 	if (rc) {
 		free_page((unsigned long)dump_block_ccw);
 		return rc;
@@ -1014,7 +1014,7 @@ static int __init dump_fcp_init(void)
 	dump_block_fcp = (void *) get_zeroed_page(GFP_KERNEL);
 	if (!dump_block_fcp)
 		return -ENOMEM;
-	rc = sysfs_create_group(&dump_subsys.kset.kobj, &dump_fcp_attr_group);
+	rc = sysfs_create_group(&dump_subsys.kobj, &dump_fcp_attr_group);
 	if (rc) {
 		free_page((unsigned long)dump_block_fcp);
 		return rc;
