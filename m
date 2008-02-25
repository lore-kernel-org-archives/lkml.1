Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbYBYAz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbYBYAz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbYBYAzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:55:13 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:65214 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbYBYAzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:55:12 -0500
Message-Id: <200802250055.m1P0t4MX060531@www262.sakura.ne.jp>
Subject: [2.6.25-rc2-mm1][2.6.25-rc3] Remove argv_len from struct linux_binprm
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Mon, 25 Feb 2008 09:55:04 +0900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that 2.6.24.2 calculates bprm->argv_len at do_execve().
But it doesn't update bprm->argv_len after
"remove_arg_zero() + copy_strings_kernel()" at load_script() etc.

audit_bprm() is called from search_binary_handler()
and search_binary_handler() is called from load_script() etc.
Thus, I think the condition check

  if (bprm->argv_len > (audit_argv_kb << 10))
          return -E2BIG;

in audit_bprm() might return wrong result
when strlen(removed_arg) != strlen(spliced_args).
Why not update bprm->argv_len at load_script() etc. ?


By the way, 2.6.25-rc3 seems to not doing the condition check.
Is the field bprm->argv_len no longer needed?

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/exec.c               |    3 ---
 include/linux/binfmts.h |    1 -
 2 files changed, 4 deletions(-)

--- linux-2.6.25-rc3.orig/fs/exec.c
+++ linux-2.6.25-rc3/fs/exec.c
@@ -1274,7 +1274,6 @@ int do_execve(char * filename,
 {
 	struct linux_binprm *bprm;
 	struct file *file;
-	unsigned long env_p;
 	int retval;
 
 	retval = -ENOMEM;
@@ -1322,11 +1321,9 @@ int do_execve(char * filename,
 	if (retval < 0)
 		goto out;
 
-	env_p = bprm->p;
 	retval = copy_strings(bprm->argc, argv, bprm);
 	if (retval < 0)
 		goto out;
-	bprm->argv_len = env_p - bprm->p;
 
 	retval = search_binary_handler(bprm,regs);
 	if (retval >= 0) {
--- linux-2.6.25-rc3.orig/include/linux/binfmts.h
+++ linux-2.6.25-rc3/include/linux/binfmts.h
@@ -48,7 +48,6 @@ struct linux_binprm{
 	unsigned interp_flags;
 	unsigned interp_data;
 	unsigned long loader, exec;
-	unsigned long argv_len;
 };
 
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
