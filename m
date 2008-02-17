Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbYBQRP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbYBQRP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYBQRPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:15:21 -0500
Received: from pas38-1-82-67-71-117.fbx.proxad.net ([82.67.71.117]:55972 "EHLO
	siegfried.gbfo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbYBQRPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:15:20 -0500
X-Greylist: delayed 789 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Feb 2008 12:15:20 EST
Date: Sun, 17 Feb 2008 18:02:07 +0100 (CET)
From: Jean-Marc Saffroy <saffroy@gmail.com>
X-X-Sender: saffroy@erda.mds
To: linux-kernel@vger.kernel.org
cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] return useful error when accessing /proc/<pid>/maps
Message-ID: <Pine.LNX.4.64.0802171735470.5339@erda.mds>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

Access to /proc/<pid>/maps is now restricted to legitimate users, but 
read(2) simply returns 0 instead of a more explicit error. The patch below 
fixes this.

Signed-off-by: Jean-Marc Saffroy <saffroy@gmail.com>

---

Index: linux-2.6.24.2/fs/proc/base.c
===================================================================
--- linux-2.6.24.2.orig/fs/proc/base.c	2008-02-17 16:43:49.000000000 +0100
+++ linux-2.6.24.2/fs/proc/base.c	2008-02-17 17:18:13.000000000 +0100
@@ -204,6 +204,7 @@

  struct mm_struct *mm_for_maps(struct task_struct *task)
  {
+	int rc = 0;
  	struct mm_struct *mm = get_task_mm(task);
  	if (!mm)
  		return NULL;
@@ -211,7 +212,7 @@
  	task_lock(task);
  	if (task->mm != mm)
  		goto out;
-	if (task->mm != current->mm && __ptrace_may_attach(task) < 0)
+	if (task->mm != current->mm && (rc = __ptrace_may_attach(task)) < 0)
  		goto out;
  	task_unlock(task);
  	return mm;
@@ -219,7 +220,7 @@
  	task_unlock(task);
  	up_read(&mm->mmap_sem);
  	mmput(mm);
-	return NULL;
+	return rc ? ERR_PTR(rc) : NULL;
  }

  static int proc_pid_cmdline(struct task_struct *task, char * buffer)
Index: linux-2.6.24.2/fs/proc/task_mmu.c
===================================================================
--- linux-2.6.24.2.orig/fs/proc/task_mmu.c	2008-02-17 16:43:49.000000000 +0100
+++ linux-2.6.24.2/fs/proc/task_mmu.c	2008-02-17 17:27:55.000000000 +0100
@@ -398,8 +398,8 @@
  		return NULL;

  	mm = mm_for_maps(priv->task);
-	if (!mm)
-		return NULL;
+	if (!mm || IS_ERR(mm))
+		return mm;

  	priv->tail_vma = tail_vma = get_gate_vma(priv->task);

@@ -437,7 +437,7 @@

  static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
  {
-	if (vma && vma != priv->tail_vma) {
+	if (vma && !IS_ERR(vma) && vma != priv->tail_vma) {
  		struct mm_struct *mm = vma->vm_mm;
  		up_read(&mm->mmap_sem);
  		mmput(mm);
Index: linux-2.6.24.2/fs/proc/task_nommu.c
===================================================================
--- linux-2.6.24.2.orig/fs/proc/task_nommu.c	2008-02-17 16:43:49.000000000 +0100
+++ linux-2.6.24.2/fs/proc/task_nommu.c	2008-02-17 17:18:13.000000000 +0100
@@ -166,10 +166,10 @@
  		return NULL;

  	mm = mm_for_maps(priv->task);
-	if (!mm) {
+	if (!mm || IS_ERR(mm)) {
  		put_task_struct(priv->task);
  		priv->task = NULL;
-		return NULL;
+		return mm;
  	}

  	/* start from the Nth VMA */
