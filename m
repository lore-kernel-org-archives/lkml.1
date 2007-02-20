Return-Path: <linux-kernel-owner+w=401wt.eu-S964896AbXBTOS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896AbXBTOS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:18:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964915AbXBTOS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:18:59 -0500
Received: from ns1.suse.de ([195.135.220.2]:58600 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964896AbXBTOS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:18:58 -0500
Date: Tue, 20 Feb 2007 15:18:56 +0100
From: Nick Piggin <npiggin@suse.de>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] perfmon ia64: fix file/vma lifetime
Message-ID: <20070220141856.GB31343@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patch is against 2.6.20.

Nick
--
From: Nick Piggin <npiggin@suse.de>

Perfmon associates vmalloc()ed memory with a file descriptor, and installs
a vma mapping that memory. Unfortunately, the vm_file field is not filled in,
so processes with mappings to that memory do not prevent the file from being
closed and the memory freed. This results in use-after-free bugs and multiple
freeing of pages, etc.

I saw this bug on an Altix on SLES9. Haven't reproduced upstream but it looks
like the same issue is there.

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/arch/ia64/kernel/perfmon.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/perfmon.c
+++ linux-2.6/arch/ia64/kernel/perfmon.c
@@ -2261,7 +2261,7 @@ pfm_remap_buffer(struct vm_area_struct *
  * allocate a sampling buffer and remaps it into the user address space of the task
  */
 static int
-pfm_smpl_buffer_alloc(struct task_struct *task, pfm_context_t *ctx, unsigned long rsize, void **user_vaddr)
+pfm_smpl_buffer_alloc(struct task_struct *task, struct file *filp, pfm_context_t *ctx, unsigned long rsize, void **user_vaddr)
 {
 	struct mm_struct *mm = task->mm;
 	struct vm_area_struct *vma = NULL;
@@ -2312,6 +2312,7 @@ pfm_smpl_buffer_alloc(struct task_struct
 	 * partially initialize the vma for the sampling buffer
 	 */
 	vma->vm_mm	     = mm;
+	vma->vm_file	     = filp;
 	vma->vm_flags	     = VM_READ| VM_MAYREAD |VM_RESERVED;
 	vma->vm_page_prot    = PAGE_READONLY; /* XXX may need to change */
 
@@ -2350,6 +2351,8 @@ pfm_smpl_buffer_alloc(struct task_struct
 		goto error;
 	}
 
+	get_file(filp);
+
 	/*
 	 * now insert the vma in the vm list for the process, must be
 	 * done with mmap lock held
@@ -2427,7 +2430,7 @@ pfarg_is_sane(struct task_struct *task, 
 }
 
 static int
-pfm_setup_buffer_fmt(struct task_struct *task, pfm_context_t *ctx, unsigned int ctx_flags,
+pfm_setup_buffer_fmt(struct task_struct *task, struct file *filp, pfm_context_t *ctx, unsigned int ctx_flags,
 		     unsigned int cpu, pfarg_context_t *arg)
 {
 	pfm_buffer_fmt_t *fmt = NULL;
@@ -2468,7 +2471,7 @@ pfm_setup_buffer_fmt(struct task_struct 
 		/*
 		 * buffer is always remapped into the caller's address space
 		 */
-		ret = pfm_smpl_buffer_alloc(current, ctx, size, &uaddr);
+		ret = pfm_smpl_buffer_alloc(current, filp, ctx, size, &uaddr);
 		if (ret) goto error;
 
 		/* keep track of user address of buffer */
@@ -2679,7 +2682,7 @@ pfm_context_create(pfm_context_t *ctx, v
 	 * does the user want to sample?
 	 */
 	if (pfm_uuid_cmp(req->ctx_smpl_buf_id, pfm_null_uuid)) {
-		ret = pfm_setup_buffer_fmt(current, ctx, ctx_flags, 0, req);
+		ret = pfm_setup_buffer_fmt(current, filp, ctx, ctx_flags, 0, req);
 		if (ret) goto buffer_error;
 	}
 
