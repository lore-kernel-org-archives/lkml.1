Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYDMJT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYDMJT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 05:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754847AbYDMJTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 05:19:38 -0400
Received: from sing.entic.net ([208.64.63.147]:50562 "EHLO mail.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbYDMJTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:19:37 -0400
Message-Id: <200804130848.m3D8mdo2007124@mail.q-ag.de>
From: Manfred Spraul <manfred@colorfullife.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Pavel Emelyanov <xemul@openvz.org>
CC: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Date: Sun, 13 Apr 2008 10:09:30 +0200
Subject: [PATCH 2/2] fix sys_unshare()+SEM_UNDO: perform an implicit CLONE_SYSVSEM in CLONE_NEWIPC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_unshare(CLONE_NEWIPC) doesn't handle the undo lists properly, this can
cause a kernel memory corruption. CLONE_NEWIPC must detach from the existing
undo lists.
Fix, part 2: perform an implicit CLONE_SYSVSEM in CLONE_NEWIPC.
CLONE_NEWIPC creates a new IPC namespace, the task cannot access the
existing semaphore arrays after the unshare syscall. Thus the task
can/must detach from the existing undo list entries, too.

This fixes the kernel corruption, because it makes it impossible that
undo records from two different namespaces are in sysvsem.undo_list.

I'm not sure who's the right maintainer, Andrew, could you merge it?

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 kernel/fork.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 7f242b0..6f956a7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1735,9 +1735,13 @@ asmlinkage long sys_unshare(unsigned long unshare_flags)
 		goto bad_unshare_cleanup_semundo;
 
 	if (new_fs ||  new_mm || new_fd || new_ulist || new_nsproxy) {
-		if (unshare_flags & CLONE_SYSVSEM) {
+		if (unshare_flags & (CLONE_NEWIPC|CLONE_SYSVSEM)) {
 			/*
 			 * CLONE_SYSVSEM is equivalent to sys_exit().
+			 *
+			 * CLONE_NEWIPC must also detach from the undolist: after switching
+			 * to a new ipc namespace, the semaphore arrays from the old
+			 * namespace are unreachable.
 			 */
 			exit_sem(current);
 		}
-- 
1.5.4.1

