Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbZFCXND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbZFCXND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbZFCXMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:12:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:44862 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbZFCXMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:12:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LfxRl+gHHIsFJ4J+ZuY5sWu2FkExuFUwZ0R1o877UtxntO7AFp6pPfJM46W12RFBsu
         Rd+JAJFdkm1QTI0kKSa5GvVbNJqOqOAUEWe61o7om+BBIWCs2tldhlQrTqoHvK5xZurz
         io7YDSnAuDOM4Cmn9e57u3JhgR1ckVN27HXtU=
Date: Thu, 4 Jun 2009 03:06:13 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/9] exec_path 4/9: switch oprofile to ->exec_path
Message-ID: <20090603230613.GE853@x200.localdomain>
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
 drivers/oprofile/buffer_sync.c |   30 ++++++++----------------------
 1 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 8574622..64c6d7d 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -25,6 +25,7 @@
 #include <linux/workqueue.h>
 #include <linux/notifier.h>
 #include <linux/dcookies.h>
+#include <linux/path.h>
 #include <linux/profile.h>
 #include <linux/module.h>
 #include <linux/fs.h>
@@ -213,30 +214,15 @@ static inline unsigned long fast_get_dcookie(struct path *path)
 	return cookie;
 }
 
-
-/* Look up the dcookie for the task's first VM_EXECUTABLE mapping,
- * which corresponds loosely to "application name". This is
- * not strictly necessary but allows oprofile to associate
- * shared-library samples with particular applications
- */
-static unsigned long get_exec_dcookie(struct mm_struct *mm)
+static unsigned long get_exec_dcookie(struct task_struct *tsk)
 {
 	unsigned long cookie = NO_COOKIE;
-	struct vm_area_struct *vma;
+	struct path exec_path;
 
-	if (!mm)
-		goto out;
-
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		if (!vma->vm_file)
-			continue;
-		if (!(vma->vm_flags & VM_EXECUTABLE))
-			continue;
-		cookie = fast_get_dcookie(&vma->vm_file->f_path);
-		break;
-	}
-
-out:
+	get_task_exec_path(tsk, &exec_path);
+	if (exec_path.mnt && exec_path.dentry)
+		cookie = fast_get_dcookie(&exec_path);
+	path_put(&exec_path);
 	return cookie;
 }
 
@@ -543,7 +529,7 @@ void sync_buffer(int cpu)
 				release_mm(oldmm);
 				mm = take_tasks_mm(new);
 				if (mm != oldmm)
-					cookie = get_exec_dcookie(mm);
+					cookie = get_exec_dcookie(new);
 				add_user_ctx_switch(new, cookie);
 			}
 			if (op_cpu_buffer_get_size(&entry))
