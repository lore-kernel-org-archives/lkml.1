Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYKDQBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYKDQBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYKDQBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:01:43 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:50704 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbYKDQBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:01:43 -0500
Date: Tue, 4 Nov 2008 14:03:14 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: PATCH: __bprm_mm_init(): remove uneeded goto
Message-ID: <20081104140314.1b196764@doriath.conectiva>
Organization: Mandriva
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is only really used if insert_vm_struct() fails, we can inline it
and drop some (uneeded) lines of code.

Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>

---
 fs/exec.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c
+++ linux-2.6/fs/exec.c
@@ -232,13 +232,13 @@ static void flush_arg_page(struct linux_
 
 static int __bprm_mm_init(struct linux_binprm *bprm)
 {
-	int err = -ENOMEM;
+	int err;
 	struct vm_area_struct *vma = NULL;
 	struct mm_struct *mm = bprm->mm;
 
 	bprm->vma = vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (!vma)
-		goto err;
+		return -ENOMEM;
 
 	down_write(&mm->mmap_sem);
 	vma->vm_mm = mm;
@@ -257,7 +257,9 @@ static int __bprm_mm_init(struct linux_b
 	err = insert_vm_struct(mm, vma);
 	if (err) {
 		up_write(&mm->mmap_sem);
-		goto err;
+		kmem_cache_free(vm_area_cachep, vma);
+		bprm->vma = NULL;
+		return err;
 	}
 
 	mm->stack_vm = mm->total_vm = 1;
@@ -266,14 +268,6 @@ static int __bprm_mm_init(struct linux_b
 	bprm->p = vma->vm_end - sizeof(void *);
 
 	return 0;
-
-err:
-	if (vma) {
-		bprm->vma = NULL;
-		kmem_cache_free(vm_area_cachep, vma);
-	}
-
-	return err;
 }
 
 static bool valid_arg_len(struct linux_binprm *bprm, long len)


-- 
Luiz Fernando N. Capitulino
