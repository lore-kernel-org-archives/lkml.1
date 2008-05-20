Return-Path: <linux-kernel-owner+w=401wt.eu-S935069AbYETW50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935069AbYETW50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762381AbYETW5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:57:09 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:38133 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758597AbYETW5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:57:07 -0400
Date: Wed, 21 May 2008 01:54:55 +0300
From: Adrian Bunk <bunk@kernel.org>
To: jdike@addtoit.com
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [2.6 patch] UML: remove the dead TTY_LOG code
Message-ID: <20080520225455.GB16264@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the dead CONFIG_TTY_LOG (no kconfig option).

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/um/kernel/exec.c      |   12 --
 arch/um/os-Linux/Makefile  |    3 
 arch/um/os-Linux/tty_log.c |  217 -------------------------------------
 3 files changed, 232 deletions(-)

531b7c113d8deed217fb800cdd3f610899fbc0d9 diff --git a/arch/um/kernel/exec.c b/arch/um/kernel/exec.c
index f5d7f45..598711c 100644
--- a/arch/um/kernel/exec.c
+++ b/arch/um/kernel/exec.c
@@ -42,23 +42,11 @@ void start_thread(struct pt_regs *regs, unsigned long eip, unsigned long esp)
 	PT_REGS_SP(regs) = esp;
 }
 
-#ifdef CONFIG_TTY_LOG
-extern void log_exec(char **argv, void *tty);
-#endif
-
 static long execve1(char *file, char __user * __user *argv,
 		    char __user *__user *env)
 {
 	long error;
-#ifdef CONFIG_TTY_LOG
-	struct tty_struct *tty;
 
-	mutex_lock(&tty_mutex);
-	tty = get_current_tty();
-	if (tty)
-		log_exec(argv, tty);
-	mutex_unlock(&tty_mutex);
-#endif
 	error = do_execve(file, argv, env, &current->thread.regs);
 	if (error == 0) {
 		task_lock(current);
diff --git a/arch/um/os-Linux/Makefile b/arch/um/os-Linux/Makefile
index 8a48d6a..d66f038 100644
--- a/arch/um/os-Linux/Makefile
+++ b/arch/um/os-Linux/Makefile
@@ -7,9 +7,6 @@ obj-y = aio.o elf_aux.o execvp.o file.o helper.o irq.o main.o mem.o process.o \
 	registers.o sigio.o signal.o start_up.o time.o tty.o uaccess.o \
 	umid.o tls.o user_syms.o util.o drivers/ sys-$(SUBARCH)/ skas/
 
-obj-$(CONFIG_TTY_LOG) += tty_log.o
-user-objs-$(CONFIG_TTY_LOG) += tty_log.o
-
 USER_OBJS := $(user-objs-y) aio.o elf_aux.o execvp.o file.o helper.o irq.o \
 	main.o mem.o process.o registers.o sigio.o signal.o start_up.o time.o \
 	tty.o tls.o uaccess.o umid.o util.o
diff --git a/arch/um/os-Linux/tty_log.c b/arch/um/os-Linux/tty_log.c
deleted file mode 100644
index cc648e6..0000000
--- a/arch/um/os-Linux/tty_log.c
+++ /dev/null
@@ -1,217 +0,0 @@
-/*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com) and
- * geoffrey hing <ghing@net.ohio-state.edu>
- * Licensed under the GPL
- */
-
-#include <errno.h>
-#include <string.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <sys/time.h>
-#include "init.h"
-#include "user.h"
-#include "os.h"
-
-#define TTY_LOG_DIR "./"
-
-/* Set early in boot and then unchanged */
-static char *tty_log_dir = TTY_LOG_DIR;
-static int tty_log_fd = -1;
-
-#define TTY_LOG_OPEN 1
-#define TTY_LOG_CLOSE 2
-#define TTY_LOG_WRITE 3
-#define TTY_LOG_EXEC 4
-
-#define TTY_READ 1
-#define TTY_WRITE 2
-
-struct tty_log_buf {
-	int what;
-	unsigned long tty;
-	int len;
-	int direction;
-	unsigned long sec;
-	unsigned long usec;
-};
-
-int open_tty_log(void *tty, void *current_tty)
-{
-	struct timeval tv;
-	struct tty_log_buf data;
-	char buf[strlen(tty_log_dir) + sizeof("01234567890-01234567\0")];
-	int fd;
-
-	gettimeofday(&tv, NULL);
-	if(tty_log_fd != -1){
-		data = ((struct tty_log_buf) { .what 	= TTY_LOG_OPEN,
-					       .tty  = (unsigned long) tty,
-					       .len  = sizeof(current_tty),
-					       .direction = 0,
-					       .sec = tv.tv_sec,
-					       .usec = tv.tv_usec } );
-		write(tty_log_fd, &data, sizeof(data));
-		write(tty_log_fd, &current_tty, data.len);
-		return tty_log_fd;
-	}
-
-	sprintf(buf, "%s/%0u-%0u", tty_log_dir, (unsigned int) tv.tv_sec,
- 		(unsigned int) tv.tv_usec);
-
-	fd = os_open_file(buf, of_append(of_create(of_rdwr(OPENFLAGS()))),
-			  0644);
-	if(fd < 0){
-		printk("open_tty_log : couldn't open '%s', errno = %d\n",
-		       buf, -fd);
-	}
-	return fd;
-}
-
-void close_tty_log(int fd, void *tty)
-{
-	struct tty_log_buf data;
-	struct timeval tv;
-
-	if(tty_log_fd != -1){
-		gettimeofday(&tv, NULL);
-		data = ((struct tty_log_buf) { .what 	= TTY_LOG_CLOSE,
-					       .tty  = (unsigned long) tty,
-					       .len  = 0,
-					       .direction = 0,
-					       .sec = tv.tv_sec,
-					       .usec = tv.tv_usec } );
-		write(tty_log_fd, &data, sizeof(data));
-		return;
-	}
-	os_close_file(fd);
-}
-
-static int log_chunk(int fd, const char *buf, int len)
-{
-	int total = 0, try, missed, n;
-	char chunk[64];
-
-	while(len > 0){
-		try = (len > sizeof(chunk)) ? sizeof(chunk) : len;
-		missed = copy_from_user_proc(chunk, (char *) buf, try);
-		try -= missed;
-		n = write(fd, chunk, try);
-		if(n != try) {
-			if(n < 0)
-				return -errno;
-			return -EIO;
-		}
-		if(missed != 0)
-			return -EFAULT;
-
-		len -= try;
-		total += try;
-		buf += try;
-	}
-
-	return total;
-}
-
-int write_tty_log(int fd, const char *buf, int len, void *tty, int is_read)
-{
-	struct timeval tv;
-	struct tty_log_buf data;
-	int direction;
-
-	if(fd == tty_log_fd){
-		gettimeofday(&tv, NULL);
-		direction = is_read ? TTY_READ : TTY_WRITE;
-		data = ((struct tty_log_buf) { .what 	= TTY_LOG_WRITE,
-					       .tty  = (unsigned long) tty,
-					       .len  = len,
-					       .direction = direction,
-					       .sec = tv.tv_sec,
-					       .usec = tv.tv_usec } );
-		write(tty_log_fd, &data, sizeof(data));
-	}
-
-	return log_chunk(fd, buf, len);
-}
-
-void log_exec(char **argv, void *tty)
-{
-	struct timeval tv;
-	struct tty_log_buf data;
-	char **ptr,*arg;
-	int len;
-
-	if(tty_log_fd == -1) return;
-
-	gettimeofday(&tv, NULL);
-
-	len = 0;
-	for(ptr = argv; ; ptr++){
-		if(copy_from_user_proc(&arg, ptr, sizeof(arg)))
-			return;
-		if(arg == NULL) break;
-		len += strlen_user_proc(arg);
-	}
-
-	data = ((struct tty_log_buf) { .what 	= TTY_LOG_EXEC,
-				       .tty  = (unsigned long) tty,
-				       .len  = len,
-				       .direction = 0,
-				       .sec = tv.tv_sec,
-				       .usec = tv.tv_usec } );
-	write(tty_log_fd, &data, sizeof(data));
-
-	for(ptr = argv; ; ptr++){
-		if(copy_from_user_proc(&arg, ptr, sizeof(arg)))
-			return;
-		if(arg == NULL) break;
-		log_chunk(tty_log_fd, arg, strlen_user_proc(arg));
-	}
-}
-
-extern void register_tty_logger(int (*opener)(void *, void *),
-				int (*writer)(int, const char *, int,
-					      void *, int),
-				void (*closer)(int, void *));
-
-static int register_logger(void)
-{
-	register_tty_logger(open_tty_log, write_tty_log, close_tty_log);
-	return 0;
-}
-
-__uml_initcall(register_logger);
-
-static int __init set_tty_log_dir(char *name, int *add)
-{
-	tty_log_dir = name;
-	return 0;
-}
-
-__uml_setup("tty_log_dir=", set_tty_log_dir,
-"tty_log_dir=<directory>\n"
-"    This is used to specify the directory where the logs of all pty\n"
-"    data from this UML machine will be written.\n\n"
-);
-
-static int __init set_tty_log_fd(char *name, int *add)
-{
-	char *end;
-
-	tty_log_fd = strtoul(name, &end, 0);
-	if((*end != '\0') || (end == name)){
-		printf("set_tty_log_fd - strtoul failed on '%s'\n", name);
-		tty_log_fd = -1;
-	}
-
-	*add = 0;
-	return 0;
-}
-
-__uml_setup("tty_log_fd=", set_tty_log_fd,
-"tty_log_fd=<fd>\n"
-"    This is used to specify a preconfigured file descriptor to which all\n"
-"    tty data will be written.  Preconfigure the descriptor with something\n"
-"    like '10>tty_log tty_log_fd=10'.\n\n"
-);

