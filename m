Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbZBKECT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbZBKECT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 23:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbZBKECH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 23:02:07 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:55144 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbZBKECG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 23:02:06 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] integrity: shmem zero fix
Date: Tue, 10 Feb 2009 23:01:19 -0500
Message-Id: <1234324879-12411-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on comments from Mike Frysinger and Randy Dunlap:
(http://lkml.org/lkml/2009/2/9/262)
- moved ima.h include before CONFIG_SHMEM test to fix compiler error 
  on Blackfin: 
mm/shmem.c: In function 'shmem_zero_setup':
mm/shmem.c:2670: error: implicit declaration of function 'ima_shm_check'

- added 'struct linux_binprm' in ima.h to fix compiler warning on Blackfin:
In file included from mm/shmem.c:32:
include/linux/ima.h:25: warning: 'struct linux_binprm' declared inside
parameter list
include/linux/ima.h:25: warning: its scope is only this definition or
declaration, which is probably not what you want

- moved fs.h include within _LINUX_IMA_H definition

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 6db30a3..0e2aa45 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -7,11 +7,12 @@
  * the Free Software Foundation, version 2 of the License.
  */
 
-#include <linux/fs.h>
-
 #ifndef _LINUX_IMA_H
 #define _LINUX_IMA_H
 
+#include <linux/fs.h>
+struct linux_binprm;
+
 #ifdef CONFIG_IMA
 extern int ima_bprm_check(struct linux_binprm *bprm);
 extern int ima_inode_alloc(struct inode *inode);
diff --git a/mm/shmem.c b/mm/shmem.c
index 7519988..8135fac 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -28,6 +28,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/swap.h>
+#include <linux/ima.h>
 
 static struct vfsmount *shm_mnt;
 
@@ -59,7 +60,6 @@ static struct vfsmount *shm_mnt;
 #include <linux/highmem.h>
 #include <linux/seq_file.h>
 #include <linux/magic.h>
-#include <linux/ima.h>
 
 #include <asm/uaccess.h>
 #include <asm/div64.h>
-- 
1.5.6.6

