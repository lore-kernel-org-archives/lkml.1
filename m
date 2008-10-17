Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYJQMhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYJQMhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbYJQMg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:36:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:3625 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbYJQMg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:36:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=FGCS8gpFXXE5b2ZPUD49+1eBVAEQ4XX8ZhCRlNsEEIDoe4oerRQXLWtv1rgul143Au
         XM1+tigBwplU+y809kjIqZGNVqyETv3YQA+2eGuqatBU4urSD40MqX5XIGvRCnoqQBKd
         XcMyzPBA5rpPlnVJ7M4BBrko1FqpEi+eX2fgk=
Date: Fri, 17 Oct 2008 16:39:58 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 01/31] proc: switch /proc/loadavg to seq_file
Message-ID: <20081017123958.GB22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From bbcdd0fc20fa0d13983f3d4ffb7e5e98c12d2791 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Fri, 3 Oct 2008 02:21:47 +0400
Subject: [PATCH 01/31] proc: switch /proc/loadavg to seq_file

and move it to fs/proc/loadavg.c while I'm at it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/Makefile    |    2 +-
 fs/proc/loadavg.c   |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/proc_misc.c |   26 --------------------------
 3 files changed, 52 insertions(+), 27 deletions(-)
 create mode 100644 fs/proc/loadavg.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index ebaba02..bf2ab4d 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -9,7 +9,7 @@ proc-$(CONFIG_MMU)	:= mmu.o task_mmu.o
 
 proc-y       += inode.o root.o base.o generic.o array.o \
 		proc_tty.o proc_misc.o
-
+proc-y	+= loadavg.o
 proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
diff --git a/fs/proc/loadavg.c b/fs/proc/loadavg.c
new file mode 100644
index 0000000..9bca39c
--- /dev/null
+++ b/fs/proc/loadavg.c
@@ -0,0 +1,51 @@
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/pid_namespace.h>
+#include <linux/proc_fs.h>
+#include <linux/sched.h>
+#include <linux/seq_file.h>
+#include <linux/seqlock.h>
+#include <linux/time.h>
+
+#define LOAD_INT(x) ((x) >> FSHIFT)
+#define LOAD_FRAC(x) LOAD_INT(((x) & (FIXED_1-1)) * 100)
+
+static int loadavg_proc_show(struct seq_file *m, void *v)
+{
+	int a, b, c;
+	unsigned long seq;
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		a = avenrun[0] + (FIXED_1/200);
+		b = avenrun[1] + (FIXED_1/200);
+		c = avenrun[2] + (FIXED_1/200);
+	} while (read_seqretry(&xtime_lock, seq));
+
+	seq_printf(m, "%d.%02d %d.%02d %d.%02d %ld/%d %d\n",
+		LOAD_INT(a), LOAD_FRAC(a),
+		LOAD_INT(b), LOAD_FRAC(b),
+		LOAD_INT(c), LOAD_FRAC(c),
+		nr_running(), nr_threads,
+		task_active_pid_ns(current)->last_pid);
+	return 0;
+}
+
+static int loadavg_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, loadavg_proc_show, NULL);
+}
+
+static const struct file_operations loadavg_proc_fops = {
+	.open		= loadavg_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init proc_loadavg_init(void)
+{
+	proc_create("loadavg", 0, NULL, &loadavg_proc_fops);
+	return 0;
+}
+module_init(proc_loadavg_init);
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 59ea42e..67bbab8 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -56,8 +56,6 @@
 #include <asm/div64.h>
 #include "internal.h"
 
-#define LOAD_INT(x) ((x) >> FSHIFT)
-#define LOAD_FRAC(x) LOAD_INT(((x) & (FIXED_1-1)) * 100)
 /*
  * Warning: stuff below (imported functions) assumes that its output will fit
  * into one page. For some of those functions it may be wrong. Moreover, we
@@ -79,29 +77,6 @@ static int proc_calc_metrics(char *page, char **start, off_t off,
 	return len;
 }
 
-static int loadavg_read_proc(char *page, char **start, off_t off,
-				 int count, int *eof, void *data)
-{
-	int a, b, c;
-	int len;
-	unsigned long seq;
-
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		a = avenrun[0] + (FIXED_1/200);
-		b = avenrun[1] + (FIXED_1/200);
-		c = avenrun[2] + (FIXED_1/200);
-	} while (read_seqretry(&xtime_lock, seq));
-
-	len = sprintf(page,"%d.%02d %d.%02d %d.%02d %ld/%d %d\n",
-		LOAD_INT(a), LOAD_FRAC(a),
-		LOAD_INT(b), LOAD_FRAC(b),
-		LOAD_INT(c), LOAD_FRAC(c),
-		nr_running(), nr_threads,
-		task_active_pid_ns(current)->last_pid);
-	return proc_calc_metrics(page, start, off, count, eof, len);
-}
-
 static int uptime_read_proc(char *page, char **start, off_t off,
 				 int count, int *eof, void *data)
 {
@@ -842,7 +817,6 @@ void __init proc_misc_init(void)
 		char *name;
 		int (*read_proc)(char*,char**,off_t,int,int*,void*);
 	} *p, simple_ones[] = {
-		{"loadavg",     loadavg_read_proc},
 		{"uptime",	uptime_read_proc},
 		{"meminfo",	meminfo_read_proc},
 		{"version",	version_read_proc},
-- 
1.5.6.5

