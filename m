Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZHMTsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZHMTsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932192AbZHMTsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:48:07 -0400
Received: from kroah.org ([198.145.64.141]:36808 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175AbZHMTsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:48:03 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:39 2009
Message-Id: <20090813194339.506180651@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [patch 25/28] mm_for_maps: shift down_read(mmap_sem) to the caller
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=mm_for_maps-shift-down_read-to-the-caller.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -240,9 +240,8 @@ static int check_mem_permission(struct t
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
@@ -250,10 +249,9 @@ struct mm_struct *mm_for_maps(struct tas
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
@@ -137,6 +137,7 @@ static void *m_start(struct seq_file *m,
 		priv->task = NULL;
 		return NULL;
 	}
+	down_read(&mm->mmap_sem);
 
 	/* start from the Nth VMA */
 	for (vml = mm->context.vmlist; vml; vml = vml->next)


