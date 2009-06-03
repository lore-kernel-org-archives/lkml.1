Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbZFCXH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbZFCXH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755360AbZFCXHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:07:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:11635 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbZFCXHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WVV6c9MnWYTz7N93Sx+so9Mha/9JcNc9y9sE+KVzl4C/lJO7GzAy7lpKo/QvPgEy9T
         0S4FPm/7TbPVGprjnclL/hvFvERAp1FbI5NHyndmeA6+WpqQAnptNhAZaow7EG5ioV5/
         hlyr1/9b35tMQ8iarbECwvieCR+psFYCRtI44=
Date: Thu, 4 Jun 2009 03:07:12 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH 7/9] exec_path 7/9: switch cell SPU thing to ->exec_path
Message-ID: <20090603230712.GH853@x200.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org> <20090531215427.GA29534@x200.localdomain> <20090531151953.8f8b14b5.akpm@linux-foundation.org> <20090603230422.GB853@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090603230422.GB853@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/powerpc/oprofile/cell/spu_task_sync.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/oprofile/cell/spu_task_sync.c b/arch/powerpc/oprofile/cell/spu_task_sync.c
index 6b793ae..fe17a0a 100644
--- a/arch/powerpc/oprofile/cell/spu_task_sync.c
+++ b/arch/powerpc/oprofile/cell/spu_task_sync.c
@@ -26,6 +26,7 @@
 #include <linux/notifier.h>
 #include <linux/numa.h>
 #include <linux/oprofile.h>
+#include <linux/path.h>
 #include <linux/spinlock.h>
 #include "pr_util.h"
 
@@ -303,9 +304,8 @@ static inline unsigned long fast_get_dcookie(struct path *path)
 	return cookie;
 }
 
-/* Look up the dcookie for the task's first VM_EXECUTABLE mapping,
- * which corresponds loosely to "application name". Also, determine
- * the offset for the SPU ELF object.  If computed offset is
+/*
+ * Determine the offset for the SPU ELF object.  If computed offset is
  * non-zero, it implies an embedded SPU object; otherwise, it's a
  * separate SPU binary, in which case we retrieve it's dcookie.
  * For the embedded case, we must determine if SPU ELF is embedded
@@ -320,26 +320,22 @@ get_exec_dcookie_and_offset(struct spu *spu, unsigned int *offsetp,
 {
 	unsigned long app_cookie = 0;
 	unsigned int my_offset = 0;
-	struct file *app = NULL;
 	struct vm_area_struct *vma;
+	struct task_struct *tsk = spu->tsk;
 	struct mm_struct *mm = spu->mm;
+	struct path exec_path;
 
 	if (!mm)
 		goto out;
 
-	down_read(&mm->mmap_sem);
-
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		if (!vma->vm_file)
-			continue;
-		if (!(vma->vm_flags & VM_EXECUTABLE))
-			continue;
-		app_cookie = fast_get_dcookie(&vma->vm_file->f_path);
-		pr_debug("got dcookie for %s\n",
-			 vma->vm_file->f_dentry->d_name.name);
-		app = vma->vm_file;
-		break;
+	get_task_exec_path(tsk, &exec_path);
+	if (exec_path.mnt && exec_path.dentry) {
+		app_cookie = fast_get_dcookie(&exec_path);
+		pr_debug("got dcookie for %s\n", exec_path.dentry->d_name.name);
 	}
+	path_put(&exec_path);
+
+	down_read(&mm->mmap_sem);
 
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (vma->vm_start > spu_ref || vma->vm_end <= spu_ref)
