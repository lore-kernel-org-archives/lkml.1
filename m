Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbZACHQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbZACHQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZACHQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:16:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41521 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZACHQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:16:15 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] remove the rudiment of a.out for sparc
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1LJ0k1-0006Ou-2B@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 03 Jan 2009 07:16:13 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


it's been used only in sunos compat

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/binfmt_aout.c |   65 +-----------------------------------------------------
 1 files changed, 1 insertions(+), 64 deletions(-)

diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index f1f3f41..8a3b32f 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -99,88 +99,53 @@ static int aout_core_dump(long signr, struct pt_regs *regs, struct file *file, u
 #       define START_DATA(u)	(u.start_data)
 #elif defined(__arm__)
 #	define START_DATA(u)	((u.u_tsize << PAGE_SHIFT) + u.start_code)
-#elif defined(__sparc__)
-#       define START_DATA(u)    (u.u_tsize)
 #elif defined(__i386__) || defined(__mc68000__) || defined(__arch_um__)
 #       define START_DATA(u)	(u.u_tsize << PAGE_SHIFT)
 #endif
-#ifdef __sparc__
-#       define START_STACK(u)   ((regs->u_regs[UREG_FP]) & ~(PAGE_SIZE - 1))
-#else
 #       define START_STACK(u)   (u.start_stack)
-#endif
 
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 	has_dumped = 1;
 	current->flags |= PF_DUMPCORE;
        	strncpy(dump.u_comm, current->comm, sizeof(dump.u_comm));
-#ifndef __sparc__
 	dump.u_ar0 = offsetof(struct user, regs);
-#endif
 	dump.signal = signr;
 	aout_dump_thread(regs, &dump);
 
 /* If the size of the dump file exceeds the rlimit, then see what would happen
    if we wrote the stack, but not the data area.  */
-#ifdef __sparc__
-	if ((dump.u_dsize + dump.u_ssize) > limit)
-		dump.u_dsize = 0;
-#else
 	if ((dump.u_dsize + dump.u_ssize+1) * PAGE_SIZE > limit)
 		dump.u_dsize = 0;
-#endif
 
 /* Make sure we have enough room to write the stack and data areas. */
-#ifdef __sparc__
-	if (dump.u_ssize > limit)
-		dump.u_ssize = 0;
-#else
 	if ((dump.u_ssize + 1) * PAGE_SIZE > limit)
 		dump.u_ssize = 0;
-#endif
 
 /* make sure we actually have a data and stack area to dump */
 	set_fs(USER_DS);
-#ifdef __sparc__
-	if (!access_ok(VERIFY_READ, (void __user *)START_DATA(dump), dump.u_dsize))
-		dump.u_dsize = 0;
-	if (!access_ok(VERIFY_READ, (void __user *)START_STACK(dump), dump.u_ssize))
-		dump.u_ssize = 0;
-#else
 	if (!access_ok(VERIFY_READ, (void __user *)START_DATA(dump), dump.u_dsize << PAGE_SHIFT))
 		dump.u_dsize = 0;
 	if (!access_ok(VERIFY_READ, (void __user *)START_STACK(dump), dump.u_ssize << PAGE_SHIFT))
 		dump.u_ssize = 0;
-#endif
 
 	set_fs(KERNEL_DS);
 /* struct user */
 	DUMP_WRITE(&dump,sizeof(dump));
 /* Now dump all of the user data.  Include malloced stuff as well */
-#ifndef __sparc__
 	DUMP_SEEK(PAGE_SIZE);
-#endif
 /* now we start writing out the user space info */
 	set_fs(USER_DS);
 /* Dump the data area */
 	if (dump.u_dsize != 0) {
 		dump_start = START_DATA(dump);
-#ifdef __sparc__
-		dump_size = dump.u_dsize;
-#else
 		dump_size = dump.u_dsize << PAGE_SHIFT;
-#endif
 		DUMP_WRITE(dump_start,dump_size);
 	}
 /* Now prepare to dump the stack area */
 	if (dump.u_ssize != 0) {
 		dump_start = START_STACK(dump);
-#ifdef __sparc__
-		dump_size = dump.u_ssize;
-#else
 		dump_size = dump.u_ssize << PAGE_SHIFT;
-#endif
 		DUMP_WRITE(dump_start,dump_size);
 	}
 /* Finally dump the task struct.  Not be used by gdb, but could be useful */
@@ -205,11 +170,6 @@ static unsigned long __user *create_aout_tables(char __user *p, struct linux_bin
 	int envc = bprm->envc;
 
 	sp = (void __user *)((-(unsigned long)sizeof(char *)) & (unsigned long) p);
-#ifdef __sparc__
-	/* This imposes the proper stack alignment for a new process. */
-	sp = (void __user *) (((unsigned long) sp) & ~7);
-	if ((envc+argc+3)&1) --sp;
-#endif
 #ifdef __alpha__
 /* whee.. test-programs are so much fun. */
 	put_user(0, --sp);
@@ -302,11 +262,6 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 	/* OK, This is the point of no return */
 #if defined(__alpha__)
 	SET_AOUT_PERSONALITY(bprm, ex);
-#elif defined(__sparc__)
-	set_personality(PER_SUNOS);
-#if !defined(__sparc_v9__)
-	memcpy(&current->thread.core_exec, &ex, sizeof(struct exec));
-#endif
 #else
 	set_personality(PER_LINUX);
 #endif
@@ -322,24 +277,6 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 
 	install_exec_creds(bprm);
  	current->flags &= ~PF_FORKNOEXEC;
-#ifdef __sparc__
-	if (N_MAGIC(ex) == NMAGIC) {
-		loff_t pos = fd_offset;
-		/* Fuck me plenty... */
-		/* <AOL></AOL> */
-		down_write(&current->mm->mmap_sem);	
-		error = do_brk(N_TXTADDR(ex), ex.a_text);
-		up_write(&current->mm->mmap_sem);
-		bprm->file->f_op->read(bprm->file, (char *) N_TXTADDR(ex),
-			  ex.a_text, &pos);
-		down_write(&current->mm->mmap_sem);
-		error = do_brk(N_DATADDR(ex), ex.a_data);
-		up_write(&current->mm->mmap_sem);
-		bprm->file->f_op->read(bprm->file, (char *) N_DATADDR(ex),
-			  ex.a_data, &pos);
-		goto beyond_if;
-	}
-#endif
 
 	if (N_MAGIC(ex) == OMAGIC) {
 		unsigned long text_addr, map_size;
@@ -347,7 +284,7 @@ static int load_aout_binary(struct linux_binprm * bprm, struct pt_regs * regs)
 
 		text_addr = N_TXTADDR(ex);
 
-#if defined(__alpha__) || defined(__sparc__)
+#ifdef __alpha__
 		pos = fd_offset;
 		map_size = ex.a_text+ex.a_data + PAGE_SIZE - 1;
 #else
-- 
1.5.6.5


