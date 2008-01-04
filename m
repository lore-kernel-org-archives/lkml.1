Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbYADN7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbYADN7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbYADN6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:58:09 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:49747 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbYADN6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:58:08 -0500
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH] proc: return -EPERM when preventing read of /proc/*/maps
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2008 14:57:31 +0100
Message-ID: <20080104135731.2908.90012.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return an error instead of successfully reading an empty file.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
---

 fs/proc/base.c       |    2 +-
 fs/proc/task_mmu.c   |    6 +++---
 fs/proc/task_nommu.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7411bfb..3aebc85 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -219,7 +219,7 @@ out:
 	task_unlock(task);
 	up_read(&mm->mmap_sem);
 	mmput(mm);
-	return NULL;
+	return ERR_PTR(-EPERM);
 }
 
 static int proc_pid_cmdline(struct task_struct *task, char * buffer)
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 8043a3e..74b4829 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -398,8 +398,8 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 		return NULL;
 
 	mm = mm_for_maps(priv->task);
-	if (!mm)
-		return NULL;
+	if (IS_ERR(mm) || !mm)
+		return mm;
 
 	priv->tail_vma = tail_vma = get_gate_vma(priv->task);
 
@@ -437,7 +437,7 @@ out:
 
 static void vma_stop(struct proc_maps_private *priv, struct vm_area_struct *vma)
 {
-	if (vma && vma != priv->tail_vma) {
+	if (vma && !IS_ERR(vma) && vma != priv->tail_vma) {
 		struct mm_struct *mm = vma->vm_mm;
 		up_read(&mm->mmap_sem);
 		mmput(mm);
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 1932c2c..53cb062 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -166,10 +166,10 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 		return NULL;
 
 	mm = mm_for_maps(priv->task);
-	if (!mm) {
+	if (IS_ERR(mm) || !mm) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
-		return NULL;
+		return mm;
 	}
 
 	/* start from the Nth VMA */

