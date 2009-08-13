Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbZHMUCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbZHMUCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZHMUCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:02:16 -0400
Received: from kroah.org ([198.145.64.141]:41978 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310AbZHMUAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:00:12 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:34 2009
Message-Id: <20090813195134.782760213@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [patch 69/74] mm_for_maps: take ->cred_guard_mutex to fix the race with exec
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=mm_for_maps-take-cred_guard_mutex-to-fix-the-race-with-exec.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 704b836cbf19e885f8366bccb2e4b0474346c02d upstream.

The problem is minor, but without ->cred_guard_mutex held we can race
with exec() and get the new ->mm but check old creds.

Now we do not need to re-check task->mm after ptrace_may_access(), it
can't be changed to the new mm under us.

Strictly speaking, this also fixes another very minor problem. Unless
security check fails or the task exits mm_for_maps() should never
return NULL, the caller should get either old or new ->mm.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/base.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -234,19 +234,19 @@ static int check_mem_permission(struct t
 
 struct mm_struct *mm_for_maps(struct task_struct *task)
 {
-	struct mm_struct *mm = get_task_mm(task);
+	struct mm_struct *mm;
 
-	if (mm && mm != current->mm) {
-		/*
-		 * task->mm can be changed before security check,
-		 * in that case we must notice the change after.
-		 */
-		if (!ptrace_may_access(task, PTRACE_MODE_READ) ||
-		    mm != task->mm) {
-			mmput(mm);
-			mm = NULL;
-		}
+	if (mutex_lock_killable(&task->cred_exec_mutex))
+		return NULL;
+
+	mm = get_task_mm(task);
+	if (mm && mm != current->mm &&
+			!ptrace_may_access(task, PTRACE_MODE_READ)) {
+		mmput(mm);
+		mm = NULL;
 	}
+	mutex_unlock(&task->cred_exec_mutex);
+
 	return mm;
 }
 


