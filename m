Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbZACHQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbZACHQk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759546AbZACHQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:16:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41525 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441AbZACHQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:16:25 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] sanitize ifdefs in binfmt_aout
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LJ0kB-0006PQ-2a@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 03 Jan 2009 07:16:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	They are actually alpha vs. i386/arm/m68k i.e. ecoff vs. aout.
In the only place where we actually tried to handle arm and i386/m68k
in different ways (START_DATA() in coredump handling), the arm variant
works for all of them (i386 and m68k have u.start_code set to 0).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/binfmt_aout.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index 8a3b32f..b639dcf 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -95,12 +95,10 @@ static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, u
 	int has_dumped = 0;
 	unsigned long dump_start, dump_size;
 	struct user dump;
-#if defined(__alpha__)
+#ifdef __alpha__
 #       define START_DATA(u)	(u.start_data)
-#elif defined(__arm__)
+#else
 #	define START_DATA(u)	((u.u_tsize << PAGE_SHIFT) + u.start_code)
-#elif defined(__i386__) || defined(__mc68000__) || defined(__arch_um__)
-#       define START_DATA(u)	(u.u_tsize << PAGE_SHIFT)
 #endif
 #       define START_STACK(u)   (u.start_stack)
 
@@ -176,18 +174,18 @@ static unsigned long __user *create_aout_tables(char __user *p, struct linux_bin
 	put_user(0, --sp);
 	if (bprm->loader) {
 		put_user(0, --sp);
-		put_user(0x3eb, --sp);
+		put_user(1003, --sp);
 		put_user(bprm->loader, --sp);
-		put_user(0x3ea, --sp);
+		put_user(1002, --sp);
 	}
 	put_user(bprm->exec, --sp);
-	put_user(0x3e9, --sp);
+	put_user(1001, --sp);
 #endif
 	sp -= envc+1;
 	envp = (char __user * __user *) sp;
 	sp -= argc+1;
 	argv = (char __user * __user *) sp;
-#if defined(__i386__) || defined(__mc68000__) || defined(__arm__) || defined(__arch_um__)
+#ifndef __alpha__
 	put_user((unsigned long) envp,--sp);
 	put_user((unsigned long) argv,--sp);
 #endif
@@ -260,7 +258,7 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 		return retval;
 
 	/* OK, This is the point of no return */
-#if defined(__alpha__)
+#ifdef __alpha__
 	SET_AOUT_PERSONALITY(bprm, ex);
 #else
 	set_personality(PER_LINUX);
-- 
1.5.6.5


