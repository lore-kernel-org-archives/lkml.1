Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbXEFHBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbXEFHBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 03:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbXEFHBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 03:01:31 -0400
Received: from ozlabs.org ([203.10.76.45]:44209 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbXEFHBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 03:01:30 -0400
Subject: get_user_pages vs mmap MAP_FIXED bug
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 06 May 2007 17:01:16 +1000
Message-Id: <1178434876.12284.175.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This bug is in 2.6.21-rc7-mm2, but not 2.6.21.  Haven't tested
2.6.21-mm1 yet.

The following kernel module uses get_user_pages() to look at user
memory, and gets zeroed pages if they're not touched by userspace first.
The test case seems a little sensitive to change (eg. mapping at a
non-fixed address seems to work).

Usage:
	(build kernel)
	gcc -o examine_mmap examine_mmap.c
	sudo insmod kernel/examiner.ko
	sudo ./examine_mmap
		examine_mmap: For 0x1000: kernel sees 0, I see 1179403647
	sudo ./examine_mmap --touch
		OK: Both saw 1179403647

Anyone?
Rusty.

diff -r 142e4ca8c069 examine_mmap.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/examine_mmap.c	Sun May 06 16:21:19 2007 +1000
@@ -0,0 +1,38 @@
+/* Make with gcc -o examine_mmap examine_mmap.c */
+#include <unistd.h>
+#include <string.h>
+#include <stdio.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+int main(int argc, char *argv[])
+{
+	int *p;
+	char addrstr[80];
+	int res, fd;
+
+	/* Grab some file to mmap. */
+	fd = open("./vmlinux", O_RDONLY);
+	if (fd < 0)
+		err(1, "open");
+
+	/* Map one page of it at 4096 */
+	p = (void *)4096;
+	if (mmap(p, 4096, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED, fd, 0) != p)
+		err(1, "mmap");
+
+	/* This makes it work. */
+	if (argc > 1 && strcmp(argv[1], "--touch") == 0)
+		printf("Before: %p == %i\n", p, *p);
+
+	/* Find out what the kernel thinks it is with get_user_pages() */
+	fd = open("/proc/examiner", O_RDWR);
+	sprintf(addrstr, "%p", p);
+	res = write(fd, addrstr, strlen(addrstr));
+	if (res != *p)
+		errx(1, "For %p: kernel sees %i, I see %i\n", p, res, *p);
+	printf("OK: Both saw %i\n", res);
+	return 0;
+}
diff -r 142e4ca8c069 kernel/Makefile
--- a/kernel/Makefile	Sat May 05 22:01:39 2007 +1000
+++ b/kernel/Makefile	Sun May 06 10:38:27 2007 +1000
@@ -53,6 +53,7 @@ obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
+obj-m += examiner.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
diff -r 142e4ca8c069 kernel/examiner.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/kernel/examiner.c	Sun May 06 16:15:24 2007 +1000
@@ -0,0 +1,45 @@
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/highmem.h>
+#include <asm/uaccess.h>
+
+ssize_t examiner_write(struct file *f, const char __user *u, size_t s, loff_t *o)
+{
+	char addrstr[20];
+	unsigned long addr, res = 0xBADFEED;
+	struct page *page;
+
+	copy_from_user(addrstr, u, sizeof(addrstr));
+	addr = simple_strtoul(addrstr, NULL, 0);
+
+	down_read(&current->mm->mmap_sem);
+	if (get_user_pages(current, current->mm, addr,
+			   1, 0, 1, &page, NULL) == 1) {
+		int *p = kmap(page);
+		res = *p;
+		kunmap(page);
+	}
+	up_read(&current->mm->mmap_sem);
+	return res;
+}
+
+static const struct file_operations examiner_fops = {
+	.write		= examiner_write,
+};
+
+
+static int examiner(void)
+{
+	struct proc_dir_entry *p;
+
+	p = create_proc_entry("examiner", 0600, NULL);
+	p->proc_fops = &examiner_fops;
+	return 0;
+}
+
+static void unexaminer(void)
+{
+	remove_proc_entry("examiner", NULL);
+}
+module_init(examiner);
+module_exit(unexaminer);


