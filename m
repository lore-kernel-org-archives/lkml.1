Return-Path: <linux-kernel-owner+w=401wt.eu-S932959AbYDPQmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbYDPQmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbYDPQmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:42:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55207 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848AbYDPQmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:42:35 -0400
Date: Wed, 16 Apr 2008 11:42:32 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH 1/3] ipc: sysvsem: implement sys_unshare(CLONE_SYSVSEM)
Message-ID: <20080416164232.GB22748@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(patches 1 and 2 were originally by Manfred Spraul)

sys_unshare(CLONE_NEWIPC) doesn't handle the undo lists properly, this can
cause a kernel memory corruption. CLONE_NEWIPC must detach from the existing
undo lists.

Fix, part 1: add support for sys_unshare(CLONE_SYSVSEM)

The original reason to not support it was the potential (inevitable?)
confusion due to the fact that sys_unshare(CLONE_SYSVSEM) has the
inverse meaning of clone(CLONE_SYSVSEM).

Our two most reasonable options then appear to be (1) fully support
CLONE_SYSVSEM, or (2) continue to refuse explicit CLONE_SYSVSEM,
but always do it anyway on unshare(CLONE_SYSVSEM).  This patch does
(1).

Changelog:
	Apr 16: SEH: switch to Manfred's alternative patch which
		removes the unshare_semundo() function which
		always refused CLONE_SYSVSEM.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 ipc/sem.c     |    1 +
 kernel/fork.c |   29 +++++++++++------------------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index d56d3ab..e9418df 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1250,6 +1250,7 @@ void exit_sem(struct task_struct *tsk)
 	undo_list = tsk->sysvsem.undo_list;
 	if (!undo_list)
 		return;
+	tsk->sysvsem.undo_list = NULL;
 
 	if (!atomic_dec_and_test(&undo_list->refcnt))
 		return;
diff --git a/kernel/fork.c b/kernel/fork.c
index addab87..56fa5ae 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1678,18 +1678,6 @@ static int unshare_fd(unsigned long unshare_flags, struct files_struct **new_fdp
 }
 
 /*
- * Unsharing of semundo for tasks created with CLONE_SYSVSEM is not
- * supported yet
- */
-static int unshare_semundo(unsigned long unshare_flags, struct sem_undo_list **new_ulistp)
-{
-	if (unshare_flags & CLONE_SYSVSEM)
-		return -EINVAL;
-
-	return 0;
-}
-
-/*
  * unshare allows a process to 'unshare' part of the process
  * context which was originally shared using clone.  copy_*
  * functions used by do_fork() cannot be used here directly
@@ -1704,8 +1692,8 @@ asmlinkage long sys_unshare(unsigned long unshare_flags)
 	struct sighand_struct *new_sigh = NULL;
 	struct mm_struct *mm, *new_mm = NULL, *active_mm = NULL;
 	struct files_struct *fd, *new_fd = NULL;
-	struct sem_undo_list *new_ulist = NULL;
 	struct nsproxy *new_nsproxy = NULL;
+	int do_sysvsem = 0;
 
 	check_unshare_flags(&unshare_flags);
 
@@ -1717,6 +1705,8 @@ asmlinkage long sys_unshare(unsigned long unshare_flags)
 				CLONE_NEWNET))
 		goto bad_unshare_out;
 
+	if (unshare_flags & CLONE_SYSVSEM)
+		do_sysvsem = 1;
 	if ((err = unshare_thread(unshare_flags)))
 		goto bad_unshare_out;
 	if ((err = unshare_fs(unshare_flags, &new_fs)))
@@ -1727,13 +1717,17 @@ asmlinkage long sys_unshare(unsigned long unshare_flags)
 		goto bad_unshare_cleanup_sigh;
 	if ((err = unshare_fd(unshare_flags, &new_fd)))
 		goto bad_unshare_cleanup_vm;
-	if ((err = unshare_semundo(unshare_flags, &new_ulist)))
-		goto bad_unshare_cleanup_fd;
 	if ((err = unshare_nsproxy_namespaces(unshare_flags, &new_nsproxy,
 			new_fs)))
-		goto bad_unshare_cleanup_semundo;
+		goto bad_unshare_cleanup_fd;
 
-	if (new_fs ||  new_mm || new_fd || new_ulist || new_nsproxy) {
+	if (new_fs ||  new_mm || new_fd || do_sysvsem || new_nsproxy) {
+		if (do_sysvsem) {
+			/*
+			 * CLONE_SYSVSEM is equivalent to sys_exit().
+			 */
+			exit_sem(current);
+		}
 
 		if (new_nsproxy) {
 			switch_task_namespaces(current, new_nsproxy);
@@ -1769,7 +1763,6 @@ asmlinkage long sys_unshare(unsigned long unshare_flags)
 	if (new_nsproxy)
 		put_nsproxy(new_nsproxy);
 
-bad_unshare_cleanup_semundo:
 bad_unshare_cleanup_fd:
 	if (new_fd)
 		put_files_struct(new_fd);
-- 
1.5.1.1.GIT

