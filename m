Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbZFCXFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbZFCXFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbZFCXFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:05:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:42868 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZFCXFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:05:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dE5alvbTs2s2k3D3nsgtdM0t0hJVvP5mtzEg61TNeKHadr5baUTMaDTMffcEgqo0Lv
         zBs0FqN24fGI+UBKAxNABkw61ZkpzB9mrPyrmAhYZVhVz5cp0MG0ymzoEua3zd8pEdHv
         QhRp9i3N5xin87qTFn6jLGHC35IiKK9EDBrkc=
Date: Thu, 4 Jun 2009 03:05:20 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/9] exec_path 2/9: switch audit to ->exec_path
Message-ID: <20090603230520.GC853@x200.localdomain>
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
 kernel/auditsc.c |   23 +++++++----------------
 1 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 7d6ac7c..76829b6 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -53,6 +53,7 @@
 #include <linux/socket.h>
 #include <linux/mqueue.h>
 #include <linux/audit.h>
+#include <linux/path.h>
 #include <linux/personality.h>
 #include <linux/time.h>
 #include <linux/netlink.h>
@@ -949,8 +950,7 @@ EXPORT_SYMBOL(audit_log_task_context);
 static void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
 {
 	char name[sizeof(tsk->comm)];
-	struct mm_struct *mm = tsk->mm;
-	struct vm_area_struct *vma;
+	struct path exec_path;
 
 	/* tsk == current */
 
@@ -958,20 +958,11 @@ static void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk
 	audit_log_format(ab, " comm=");
 	audit_log_untrustedstring(ab, name);
 
-	if (mm) {
-		down_read(&mm->mmap_sem);
-		vma = mm->mmap;
-		while (vma) {
-			if ((vma->vm_flags & VM_EXECUTABLE) &&
-			    vma->vm_file) {
-				audit_log_d_path(ab, "exe=",
-						 &vma->vm_file->f_path);
-				break;
-			}
-			vma = vma->vm_next;
-		}
-		up_read(&mm->mmap_sem);
-	}
+	get_task_exec_path(tsk, &exec_path);
+	if (exec_path.mnt && exec_path.dentry)
+		audit_log_d_path(ab, "exe=", &exec_path);
+	path_put(&exec_path);
+
 	audit_log_task_context(ab);
 }
 
