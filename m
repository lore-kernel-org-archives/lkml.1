Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871AbYJQMhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbYJQMhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbYJQMhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:37:15 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:30437 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbYJQMhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:37:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=O8bsDVb+DBhtrGrpPF+2a8rApa7PlEw7ggePnvGvEeUKvtoy6OZLsEkU4TJnYXPV+X
         XBVguLs9N2lvat/gHK5jNiu0cQ8J60uXI9L+lE3O2w03giIsTVtCTuNuInI8hB0guEP2
         Ar3KnrQDTCaFcbUUZv1jS+jN5r+coS9UOlD34=
Date: Fri, 17 Oct 2008 16:40:15 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 02/31] proc: switch /proc/uptime to seq_file
Message-ID: <20081017124015.GC22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From ca4e424af8016656de18ac7c39f65cbc081d7643 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Fri, 3 Oct 2008 02:38:18 +0400
Subject: [PATCH 02/31] proc: switch /proc/uptime to seq_file

and move it to fs/proc/uptime.c while I'm at it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/Makefile    |    1 +
 fs/proc/proc_misc.c |   21 ---------------------
 fs/proc/uptime.c    |   43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 21 deletions(-)
 create mode 100644 fs/proc/uptime.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index bf2ab4d..27efa14 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -10,6 +10,7 @@ proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 proc-y       += inode.o root.o base.o generic.o array.o \
 		proc_tty.o proc_misc.o
 proc-y	+= loadavg.o
+proc-y	+= uptime.o
 proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 67bbab8..6c520f4 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -77,26 +77,6 @@ static int proc_calc_metrics(char *page, char **start, off_t off,
 	return len;
 }
 
-static int uptime_read_proc(char *page, char **start, off_t off,
-				 int count, int *eof, void *data)
-{
-	struct timespec uptime;
-	struct timespec idle;
-	int len;
-	cputime_t idletime = cputime_add(init_task.utime, init_task.stime);
-
-	do_posix_clock_monotonic_gettime(&uptime);
-	monotonic_to_bootbased(&uptime);
-	cputime_to_timespec(idletime, &idle);
-	len = sprintf(page,"%lu.%02lu %lu.%02lu\n",
-			(unsigned long) uptime.tv_sec,
-			(uptime.tv_nsec / (NSEC_PER_SEC / 100)),
-			(unsigned long) idle.tv_sec,
-			(idle.tv_nsec / (NSEC_PER_SEC / 100)));
-
-	return proc_calc_metrics(page, start, off, count, eof, len);
-}
-
 int __attribute__((weak)) arch_report_meminfo(char *page)
 {
 	return 0;
@@ -817,7 +797,6 @@ void __init proc_misc_init(void)
 		char *name;
 		int (*read_proc)(char*,char**,off_t,int,int*,void*);
 	} *p, simple_ones[] = {
-		{"uptime",	uptime_read_proc},
 		{"meminfo",	meminfo_read_proc},
 		{"version",	version_read_proc},
 #ifdef CONFIG_PROC_HARDWARE
diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
new file mode 100644
index 0000000..0c10a0b
--- /dev/null
+++ b/fs/proc/uptime.c
@@ -0,0 +1,43 @@
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/proc_fs.h>
+#include <linux/sched.h>
+#include <linux/seq_file.h>
+#include <linux/time.h>
+#include <asm/cputime.h>
+
+static int uptime_proc_show(struct seq_file *m, void *v)
+{
+	struct timespec uptime;
+	struct timespec idle;
+	cputime_t idletime = cputime_add(init_task.utime, init_task.stime);
+
+	do_posix_clock_monotonic_gettime(&uptime);
+	monotonic_to_bootbased(&uptime);
+	cputime_to_timespec(idletime, &idle);
+	seq_printf(m, "%lu.%02lu %lu.%02lu\n",
+			(unsigned long) uptime.tv_sec,
+			(uptime.tv_nsec / (NSEC_PER_SEC / 100)),
+			(unsigned long) idle.tv_sec,
+			(idle.tv_nsec / (NSEC_PER_SEC / 100)));
+	return 0;
+}
+
+static int uptime_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, uptime_proc_show, NULL);
+}
+
+static const struct file_operations uptime_proc_fops = {
+	.open		= uptime_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init proc_uptime_init(void)
+{
+	proc_create("uptime", 0, NULL, &uptime_proc_fops);
+	return 0;
+}
+module_init(proc_uptime_init);
-- 
1.5.6.5

