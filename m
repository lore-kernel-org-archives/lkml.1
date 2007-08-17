Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbXHQTqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbXHQTqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 15:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbXHQTqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 15:46:07 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:33541 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbXHQTqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 15:46:05 -0400
Subject: [PATCH] Reset current->pdeath_signal on SUID binary execution
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mtk-manpages@gmx.net
Content-Type: multipart/mixed; boundary="=-bf922VW4uDUt5XP9gIA4"
Date: Fri, 17 Aug 2007 21:47:58 +0200
Message-Id: <1187380078.6698.448.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bf922VW4uDUt5XP9gIA4
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Linus,

the attached patch fixes a flaw in the "parent process death signal"
when executing SUID binaries. An unprivileged user may send arbitrary
signal to a child process even if it is running with higher privileges.

The idea to fix this issue is to reset pdeath_signal not only on fork,
but also on the execution of a SUID binary.

Michael, if we fix it this way, then the prctl() manual page should
reflect that behavior.

>From comments it seems that we have to also reset pdeath_signal inside
LSM when it comes to capability-raised executes, but I must admit that I
got lost there.

Regards

Marcel


--=-bf922VW4uDUt5XP9gIA4
Content-Disposition: attachment; filename=patch-reset-pdeath-signal-on-suid
Content-Type: text/plain; name=patch-reset-pdeath-signal-on-suid; charset=UTF-8
Content-Transfer-Encoding: 7bit

[PATCH] Reset current->pdeath_signal on SUID binary execution

This fixes a vulnerability in the "parent process death signal"
implementation discoverd by Wojciech Purczynski of COSEINC PTE Ltd.
and iSEC Security Research.

http://marc.info/?l=bugtraq&m=118711306802632&w=2

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

---
commit 8542f23e44f591480ca53d215481cbec43b8cbed
tree d72f29856adb306f20e828d4bab244685fe24bf2
parent 6adb31c90c47262c8a25bf5097de9b3426caf3ae
author Marcel Holtmann <marcel@holtmann.org> Fri, 17 Aug 2007 21:41:52 +0200
committer Marcel Holtmann <marcel@holtmann.org> Fri, 17 Aug 2007 21:41:52 +0200

 fs/exec.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 7bdea79..ce62f7b 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1084,9 +1084,12 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 */
 	current->mm->task_size = TASK_SIZE;
 
-	if (bprm->e_uid != current->euid || bprm->e_gid != current->egid || 
-	    file_permission(bprm->file, MAY_READ) ||
-	    (bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)) {
+	if (bprm->e_uid != current->euid || bprm->e_gid != current->egid) {
+		suid_keys(current);
+		set_dumpable(current->mm, suid_dumpable);
+		current->pdeath_signal = 0;
+	} else if (file_permission(bprm->file, MAY_READ) ||
+			(bprm->interp_flags & BINPRM_FLAGS_ENFORCE_NONDUMP)) {
 		suid_keys(current);
 		set_dumpable(current->mm, suid_dumpable);
 	}
@@ -1177,8 +1180,10 @@ void compute_creds(struct linux_binprm *bprm)
 {
 	int unsafe;
 
-	if (bprm->e_uid != current->uid)
+	if (bprm->e_uid != current->uid) {
 		suid_keys(current);
+		current->pdeath_signal = 0;
+	}
 	exec_keys(current);
 
 	task_lock(current);

--=-bf922VW4uDUt5XP9gIA4--

