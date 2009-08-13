Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZHMUAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZHMUAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbZHMUAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:00:12 -0400
Received: from kroah.org ([198.145.64.141]:41932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbZHMUAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:00:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:34 2009
Message-Id: <20090813195134.500277035@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@redhat.com>, James Morris <jmorris@namei.org>
Subject: [patch 67/74] mm_for_maps: simplify, use ptrace_may_access()
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=mm_for_maps-simplify-use-ptrace_may_access.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 13f0feafa6b8aead57a2a328e2fca6a5828bf286 upstream.

It would be nice to kill __ptrace_may_access(). It requires task_lock(),
but this lock is only needed to read mm->flags in the middle.

Convert mm_for_maps() to use ptrace_may_access(), this also simplifies
the code a little bit.

Also, we do not need to take ->mmap_sem in advance. In fact I think
mm_for_maps() should not play with ->mmap_sem at all, the caller should
take this lock.

With or without this patch, without ->cred_guard_mutex held we can race
with exec() and get the new ->mm but check old creds.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/base.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -237,20 +237,19 @@ struct mm_struct *mm_for_maps(struct tas
 	struct mm_struct *mm = get_task_mm(task);
 	if (!mm)
 		return NULL;
+	if (mm != current->mm) {
+		/*
+		 * task->mm can be changed before security check,
+		 * in that case we must notice the change after.
+		 */
+		if (!ptrace_may_access(task, PTRACE_MODE_READ) ||
+		    mm != task->mm) {
+			mmput(mm);
+			return NULL;
+		}
+	}
 	down_read(&mm->mmap_sem);
-	task_lock(task);
-	if (task->mm != mm)
-		goto out;
-	if (task->mm != current->mm &&
-	    __ptrace_may_access(task, PTRACE_MODE_READ) < 0)
-		goto out;
-	task_unlock(task);
 	return mm;
-out:
-	task_unlock(task);
-	up_read(&mm->mmap_sem);
-	mmput(mm);
-	return NULL;
 }
 
 static int proc_pid_cmdline(struct task_struct *task, char * buffer)


