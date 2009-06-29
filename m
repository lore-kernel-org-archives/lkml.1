Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbZF2WAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbZF2WAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 18:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbZF2V75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 17:59:57 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:48103 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZF2V74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 17:59:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :message-id;
        b=asV3YjFmMYO3ANaxggMeRPlvrqegkXwuLaZ4te0Q2fOkQ90g7dFvRf7J08QJRKiI+Z
         wfrHapatGjO52T2TQE/hMISkeq8/7JZHDRu+mU7zXDUE7j8XPAM8ZurLxN+IHupMBRai
         tN27zkiW/IpXiw8f/QXDzNUvOzl491tW+MKII=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] make execve(NULL) re-execute current binary
Date: Tue, 30 Jun 2009 00:03:39 +0200
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_7oTSKFyibGViFXW"
Message-Id: <200906300003.39440.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_7oTSKFyibGViFXW
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Al, Andrew, folks,

This is a version 2 of re-execution patch.

I replaced hardcoded "/proc/self/exe" with execve(NULL)
extension in the hopes that this is considered less ugly.
Also I tried to format code according to Andrew's wishes.

Handling execve(NULL) requires adding a bit of code
to per-architecture sys_execve().
In the attached patch, it is done only on x86.
If this patch will be ACKed in principle,
the final version will do it for all architectures.

Description follows.

=========================================================

In some circumstances running process needs to re-execute
its image.

Among other useful cases, it is _crucial_ for NOMMU arches.

They need it to perform daemonization. Classic sequence
of "fork, parent dies, child continues" can't be used
due to lack of fork on NOMMU, and instead we have to do
"vfork, child re-exec itself (with a flag to not daemonize)
and therefore unblocks parent, parent dies".

Another crucial use case on NOMMU is POSIX shell support.
Imagine a shell command of the form "func1 | func2 | func3".
This can be implemented on NOMMU by vforking thrice,
re-executing the shell in every child in the form
"<shell> -c 'body of funcN'", and letting parent wait and collect
exitcodes and such. As far as I can see, it's the only way
to implement it correctly on NOMMU.

The program may re-execute itself by name if it knows the name,
but we generally may be unsure about it. Binary may be renamed,
or even deleted while it is being run.

More elegant way is to execute /proc/self/exe.
This works just fine as long as /proc is mounted.

But it breaks if /proc isn't mounted, and this can happen in real-world
usage. For example, when shell invoked very early in initrd/initramfs.
Or when the program is in a chroot jail. Etc.

With this patch, it is possible to re-execute current binary
even if /proc is not mounted. It is done with execve()
call with NULL pointer as a 1st parameter instead of filename to exec.

Please comment.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_7oTSKFyibGViFXW
Content-Type: text/x-diff;
  charset="us-ascii";
  name="linux-2.6.30_proc_self_exe_v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.30_proc_self_exe_v2.patch"

diff -urp ../linux-2.6.30.org/arch/x86/kernel/process_32.c linux-2.6.30-1/arch/x86/kernel/process_32.c
--- ../linux-2.6.30.org/arch/x86/kernel/process_32.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30-1/arch/x86/kernel/process_32.c	2009-06-29 22:28:38.000000000 +0200
@@ -453,6 +453,15 @@ int sys_execve(struct pt_regs *regs)
 	int error;
 	char *filename;
 
+	if (regs->bx == 0) {
+		/* execme */
+		error = do_execve(NULL,
+			(char __user * __user *) regs->cx,
+			(char __user * __user *) regs->dx,
+			regs);
+		goto out;
+	}
+
 	filename = getname((char __user *) regs->bx);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
@@ -461,12 +470,12 @@ int sys_execve(struct pt_regs *regs)
 			(char __user * __user *) regs->cx,
 			(char __user * __user *) regs->dx,
 			regs);
+	putname(filename);
+out:
 	if (error == 0) {
 		/* Make sure we don't return using sysenter.. */
 		set_thread_flag(TIF_IRET);
 	}
-	putname(filename);
-out:
 	return error;
 }
 
diff -urp ../linux-2.6.30.org/arch/x86/kernel/process_64.c linux-2.6.30-1/arch/x86/kernel/process_64.c
--- ../linux-2.6.30.org/arch/x86/kernel/process_64.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30-1/arch/x86/kernel/process_64.c	2009-06-29 22:28:56.000000000 +0200
@@ -504,6 +504,9 @@ long sys_execve(char __user *name, char 
 	long error;
 	char *filename;
 
+	if (name == NULL)
+		return do_execve(NULL, argv, envp, regs);
+
 	filename = getname(name);
 	error = PTR_ERR(filename);
 	if (IS_ERR(filename))
diff -urp ../linux-2.6.30.org/fs/exec.c linux-2.6.30-1/fs/exec.c
--- ../linux-2.6.30.org/fs/exec.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-2.6.30-1/fs/exec.c	2009-06-29 22:29:44.000000000 +0200
@@ -644,14 +644,39 @@ EXPORT_SYMBOL(setup_arg_pages);
 
 #endif /* CONFIG_MMU */
 
+static struct file *open_self(void)
+{
+	struct file *file;
+	struct mm_struct *mm;
+
+	mm = get_task_mm(current);
+	file = NULL;
+	if (mm) {
+		file = get_mm_exe_file(mm);
+		mmput(mm);
+	}
+	if (!file)
+		file = ERR_PTR(-ENOENT);
+	return file;
+}
+
 struct file *open_exec(const char *name)
 {
 	struct file *file;
 	int err;
 
-	file = do_filp_open(AT_FDCWD, name,
+	if (name == NULL) {
+		/*
+		 * execve(NULL) execs the binary of the current process.
+		 * Unlike execve("/proc/self/exe"), it does not require
+		 * mounted /proc.
+		 */
+		file = open_self();
+	} else {
+		file = do_filp_open(AT_FDCWD, name,
 				O_LARGEFILE | O_RDONLY | FMODE_EXEC, 0,
 				MAY_EXEC | MAY_OPEN);
+	}
 	if (IS_ERR(file))
 		goto out;
 
@@ -1291,8 +1316,8 @@ int do_execve(char * filename,
 	sched_exec();
 
 	bprm->file = file;
-	bprm->filename = filename;
-	bprm->interp = filename;
+	bprm->filename = filename ? filename : current->comm;
+	bprm->interp = bprm->filename;
 
 	retval = bprm_mm_init(bprm);
 	if (retval)

--Boundary-00=_7oTSKFyibGViFXW--
