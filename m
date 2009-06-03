Return-Path: <linux-kernel-owner+w=401wt.eu-S1755750AbZFCXLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbZFCXLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbZFCXLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:11:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:28422 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbZFCXLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i3OakW/8bSINbRkh3uddCFrCsFabkhnj0umTLaalrg2ew15fWNNp3M2co2te36jYUK
         fZ+h/GgWx/t2BA0aEEkTYHj+B/SQ4Gq7NlYhDzJsxfc4Afn7Sra6c0uW7lcEoi6q3caP
         DHYlBL3Rlg+g3P81p5VUJMzwvvWeda6VoMVUY=
Date: Thu, 4 Jun 2009 03:05:50 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/9] exec_path 3/9: switch TOMOYO to ->exec_path
Message-ID: <20090603230550.GD853@x200.localdomain>
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
 security/tomoyo/common.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index ddfb9cc..d26deea 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/uaccess.h>
+#include <linux/path.h>
 #include <linux/security.h>
 #include <linux/hardirq.h>
 #include "realpath.h"
@@ -700,20 +701,13 @@ bool tomoyo_io_printf(struct tomoyo_io_buffer *head, const char *fmt, ...)
  */
 static const char *tomoyo_get_exe(void)
 {
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
+	struct path exec_path;
 	const char *cp = NULL;
 
-	if (!mm)
-		return NULL;
-	down_read(&mm->mmap_sem);
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		if ((vma->vm_flags & VM_EXECUTABLE) && vma->vm_file) {
-			cp = tomoyo_realpath_from_path(&vma->vm_file->f_path);
-			break;
-		}
-	}
-	up_read(&mm->mmap_sem);
+	get_task_exec_path(current, &exec_path);
+	if (exec_path.mnt && exec_path.dentry)
+		cp = tomoyo_realpath_from_path(&exec_path);
+	path_put(&exec_path);
 	return cp;
 }
 
