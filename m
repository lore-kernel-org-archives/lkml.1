Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYGTQMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYGTQMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 12:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbYGTQMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 12:12:23 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:54285 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbYGTQMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 12:12:23 -0400
Date: Sun, 20 Jul 2008 20:15:48 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] coredump: format_corename: fix the "core_uses_pid" logic
Message-ID: <20080720161548.GA10730@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't understand why the multi-thread coredump implies the core_uses_pid
behaviour, but we shouldn't use mm->mm_users for that. This counter can be
incremented by get_task_mm(). Use the valued returned by coredump_wait()
instead.

Also, remove the "const char *pattern" argument, format_corename() can use
core_pattern directly.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 26-rc2/fs/exec.c~FORMAT_CORENAME	2008-07-20 17:06:07.000000000 +0400
+++ 26-rc2/fs/exec.c	2008-07-20 17:31:40.000000000 +0400
@@ -1373,17 +1373,14 @@ EXPORT_SYMBOL(set_binfmt);
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
  */
-static int format_corename(char *corename, const char *pattern, long signr)
+static int format_corename(char *corename, int nr_threads, long signr)
 {
-	const char *pat_ptr = pattern;
+	const char *pat_ptr = core_pattern;
+	int ispipe = (*pat_ptr == '|');
 	char *out_ptr = corename;
 	char *const out_end = corename + CORENAME_MAX_SIZE;
 	int rc;
 	int pid_in_pattern = 0;
-	int ispipe = 0;
-
-	if (*pattern == '|')
-		ispipe = 1;
 
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
@@ -1484,7 +1481,7 @@ static int format_corename(char *corenam
 	 * and core_uses_pid is set, then .%pid will be appended to
 	 * the filename. Do not do this for piped commands. */
 	if (!ispipe && !pid_in_pattern
-            && (core_uses_pid || atomic_read(&current->mm->mm_users) != 1)) {
+            && (core_uses_pid || nr_threads)) {
 		rc = snprintf(out_ptr, out_end - out_ptr,
 			      ".%d", task_tgid_vnr(current));
 		if (rc > out_end - out_ptr)
@@ -1748,7 +1745,7 @@ int do_coredump(long signr, int exit_cod
 	 * uses lock_kernel()
 	 */
  	lock_kernel();
-	ispipe = format_corename(corename, core_pattern, signr);
+	ispipe = format_corename(corename, retval, signr);
 	unlock_kernel();
 	/*
 	 * Don't bother to check the RLIMIT_CORE value if core_pattern points

