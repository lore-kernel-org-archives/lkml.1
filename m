Return-Path: <linux-kernel-owner+w=401wt.eu-S1763531AbXHVJIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763531AbXHVJIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757749AbXHVIxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:46 -0400
Received: from 1wt.eu ([62.212.114.60]:2158 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757565AbXHVIxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:43 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084046.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:42 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 58/58] Reset current->pdeath_signal on SUID binary execution (CVE-2007-3848)
Content-Disposition: inline; filename=0058-Reset-current-pdeath_signal-on-SUID-binary-executio.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a vulnerability in the "parent process death signal"
implementation discoverd by Wojciech Purczynski of COSEINC PTE Ltd.
and iSEC Security Research.

http://marc.info/?l=bugtraq&m=118711306802632&w=2

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/exec.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 0f8573a..bd1ab3f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -881,9 +881,12 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 */
 	current->mm->task_size = TASK_SIZE;
 
-	if (bprm->e_uid != current->euid || bprm->e_gid != current->egid || 
-	    file_permission(bprm->file, MAY_READ) ||
-	    (bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)) {
+	if (bprm->e_uid != current->euid || bprm->e_gid != current->egid) {
+		suid_keys(current);
+		current->mm->dumpable = suid_dumpable;
+		current->pdeath_signal = 0;
+	} else if (file_permission(bprm->file, MAY_READ) ||
+			(bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)) {
 		suid_keys(current);
 		current->mm->dumpable = suid_dumpable;
 	}
@@ -974,8 +977,10 @@ void compute_creds(struct linux_binprm *bprm)
 {
 	int unsafe;
 
-	if (bprm->e_uid != current->uid)
+	if (bprm->e_uid != current->uid) {
 		suid_keys(current);
+		current->pdeath_signal = 0;
+	}
 	exec_keys(current);
 
 	task_lock(current);
-- 
1.5.2.5

-- 
