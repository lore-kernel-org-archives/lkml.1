Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbYJQPka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbYJQPka (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbYJQPkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:40:22 -0400
Received: from smtp.nokia.com ([192.100.105.134]:32801 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbYJQPkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:40:21 -0400
From: Viktor Rosendahl <viktor.rosendahl@nokia.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] RFC: Pass process information to userspace coredump
Date: Fri, 17 Oct 2008 18:46:25 +0300
Message-Id: <1224258385-12984-1-git-send-email-viktor.rosendahl@nokia.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 17 Oct 2008 15:37:46.0915 (UTC) FILETIME=[4DF41F30:01C9306E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dumping core to pipe, set CORE_{EXE,PID,SIG,UID,GID} environment
variables. The userspace helper can then use them or look in
/proc/${CORE_PID} for more information.

This code is from the Nokia N810 kernel; I did not write it.

Signed-off-by: Viktor Rosendahl <viktor.rosendahl@nokia.com>
---
 fs/exec.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a41e790..3a9625d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1771,6 +1771,14 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 		goto fail_unlock;
 
  	if (ispipe) {
+		char env_exe[64];
+		char env_pid[16], env_sig[16];
+		char env_uid[16], env_gid[16];
+		char *envp[] = { env_exe,
+				 env_pid, env_sig,
+				 env_uid, env_gid,
+				 NULL };
+
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
 		/* Terminate the string before the first option */
 		delimit = strchr(corename, ' ');
@@ -1789,8 +1797,16 @@ int do_coredump(long signr, int exit_code, struct pt_regs * regs)
 
 		core_limit = RLIM_INFINITY;
 
+		snprintf(env_exe, sizeof(env_exe), "CORE_EXE=%s",
+			current->comm);
+		snprintf(env_pid, sizeof(env_pid), "CORE_PID=%d",
+			current->tgid);
+		snprintf(env_sig, sizeof(env_sig), "CORE_SIG=%ld", signr);
+		snprintf(env_uid, sizeof(env_uid), "CORE_UID=%u", current->uid);
+		snprintf(env_gid, sizeof(env_gid), "CORE_GID=%u", current->gid);
+
 		/* SIGPIPE can happen, but it's just never processed */
- 		if (call_usermodehelper_pipe(corename+1, helper_argv, NULL,
+		if (call_usermodehelper_pipe(corename+1, helper_argv, envp,
 				&file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
-- 
1.5.6.5

