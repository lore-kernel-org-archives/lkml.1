Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbZHMUCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbZHMUCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbZHMUCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:02:18 -0400
Received: from kroah.org ([198.145.64.141]:41968 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288AbZHMUAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:00:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:34 2009
Message-Id: <20090813195134.630212134@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [patch 68/74] mm_for_maps: shift down_read(mmap_sem) to the caller
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=mm_for_maps-shift-down_read-to-the-caller.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 00f89d218523b9bf6b522349c039d5ac80aa536d upstream.

mm_for_maps() takes ->mmap_sem after security checks, this looks
strange and obfuscates the locking rules. Move this lock to its
single caller, m_start().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/base.c       |    8 +++-----
 fs/proc/task_mmu.c   |    1 +
 fs/proc/task_nommu.c |    1 +
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -235,9 +235,8 @@ static int check_mem_permission(struct t
 struct mm_struct *mm_for_maps(struct task_struct *task)
 {
 	struct mm_struct *mm = get_task_mm(task);
-	if (!mm)
-		return NULL;
-	if (mm != current->mm) {
+
+	if (mm && mm != current->mm) {
 		/*
 		 * task->mm can be changed before security check,
 		 * in that case we must notice the change after.
@@ -245,10 +244,9 @@ struct mm_struct *mm_for_maps(struct tas
 		if (!ptrace_may_access(task, PTRACE_MODE_READ) ||
 		    mm != task->mm) {
 			mmput(mm);
-			return NULL;
+			mm = NULL;
 		}
 	}
-	down_read(&mm->mmap_sem);
 	return mm;
 }
 
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -119,6 +119,7 @@ static void *m_start(struct seq_file *m,
 	mm = mm_for_maps(priv->task);
 	if (!mm)
 		return NULL;
+	down_read(&mm->mmap_sem);
 
 	tail_vma = get_gate_vma(priv->task);
 	priv->tail_vma = tail_vma;
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -189,6 +189,7 @@ static void *m_start(struct seq_file *m,
 		priv->task = NULL;
 		return NULL;
 	}
+	down_read(&mm->mmap_sem);
 
 	/* start from the Nth VMA */
 	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p))


