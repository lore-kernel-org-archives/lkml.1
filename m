Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbYADLPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbYADLPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYADLPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:15:37 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:60063 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbYADLPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:15:36 -0500
Date: Fri, 4 Jan 2008 12:15:02 +0100
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: advertise new restrictions on /proc/*/maps &
 /proc/*/smaps
Message-ID: <20080104121502.2e6ccaa1@inria.fr>
In-Reply-To: <20080103235736.GW27894@ZenIV.linux.org.uk>
References: <20080103235150.2870.31703.stgit@localhost.localdomain>
 <20080103235736.GW27894@ZenIV.linux.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> The whole point is that we have to reject it at read() time, not open()
> time.

Yes, my patch was a complement to yours to propagate the -EPERM in easy
cases. As you noted it added restrictions on reading /proc/*/maps, even
though I found them acceptable.

How about this instead?

Maybe you'd prefer to propagate the actual -EPERM from
__ptrace_may_attach but that would be more invasive.

Sidenote: do you think a sparse annotation to check IS_ERR/PTR_ERR
usage would make sense?

proc: return -EPERM when preventing read of /proc/*/maps

Return an error instead of successfully reading an empty file.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
---

 fs/proc/base.c       |    2 +-
 fs/proc/task_mmu.c   |    8 +++++---
 fs/proc/task_nommu.c |    4 ++--
 3 files changed, 8 insertions(+), 6 deletions(-)


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
index 8043a3e..db57e65 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -398,8 +398,8 @@ static void *m_start(struct seq_file *m, loff_t
*pos) return NULL;
 
 	mm = mm_for_maps(priv->task);
-	if (!mm)
-		return NULL;
+	if (IS_ERR(mm) || !mm)
+		return mm;
 
 	priv->tail_vma = tail_vma = get_gate_vma(priv->task);
 
@@ -437,7 +437,7 @@ out:
 
 static void vma_stop(struct proc_maps_private *priv, struct
vm_area_struct *vma) {
-	if (vma && vma != priv->tail_vma) {
+	if (vma && !IS_ERR(vma) && vma != priv->tail_vma) {
 		struct mm_struct *mm = vma->vm_mm;
 		up_read(&mm->mmap_sem);
 		mmput(mm);
@@ -451,6 +451,8 @@ static void *m_next(struct seq_file *m, void *v,
loff_t *pos) struct vm_area_struct *tail_vma = priv->tail_vma;
 
 	(*pos)++;
+	if (IS_ERR(vma))
+		return vma;
 	if (vma && (vma != tail_vma) && vma->vm_next)
 		return vma->vm_next;
 	vma_stop(priv, vma);
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 1932c2c..53cb062 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -166,10 +166,10 @@ static void *m_start(struct seq_file *m, loff_t
*pos) return NULL;
 
 	mm = mm_for_maps(priv->task);
-	if (!mm) {
+	if (IS_ERR(mm) || !mm) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
-		return NULL;
+		return mm;
 	}
 
 	/* start from the Nth VMA */


-- 
Guillaume
