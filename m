Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbYH0QKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbYH0QKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757345AbYH0QIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:08:17 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:24012 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbYH0QIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:08:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u78vmNkYuphSHcEXNCXQHnfqGSRiaZM6hKL1jPeuF36T9nCgCXnl3D28NnruXYRXf8
         sNfmEaciAi5GeoKuIXKILDfyHspwzpKXA0og2uV7M/DB80oSTUyuvp3Dw0+WvYAprgs4
         E3S0ddrUwfIRc/NhaYwuSOcjLyIjIPcZv+uGw=
From: Andrea Righi <righi.andrea@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>
Cc: agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       dave@linux.vnet.ibm.com, Divyesh Shah <dpshah@google.com>,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       Hirokazu Takahashi <taka@valinux.co.jp>, Li Zefan <lizf@cn.fujitsu.com>,
       Marco Innocenti <m.innocenti@cineca.it>, matt@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>
Subject: [RFC][PATCH -mm 5/5] export per-task i/o throttling statistics to userspace
Date: Wed, 27 Aug 2008 18:07:37 +0200
Message-Id: <1219853257-11052-6-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the throttling statistics collected for each task through
/proc/PID/io-throttle-stat:
 - total number of delayed I/O request
 - total amount of time in jiffies spent to wait for the delayed requests

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 fs/proc/base.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 01ed610..9983730 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -54,6 +54,7 @@
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/blk-io-throttle.h>
 #include <linux/init.h>
 #include <linux/capability.h>
 #include <linux/file.h>
@@ -2440,6 +2441,14 @@ static int proc_tgid_io_accounting(struct task_struct *task, char *buffer)
 }
 #endif /* CONFIG_TASK_IO_ACCOUNTING */
 
+#ifdef CONFIG_CGROUP_IO_THROTTLE
+static int proc_iothrottle_stat(struct task_struct *task, char *buffer)
+{
+	return sprintf(buffer, "%llu %llu\n",
+		get_io_throttle_cnt(task), get_io_throttle_sleep(task));
+}
+#endif /* CONFIG_CGROUP_IO_THROTTLE */
+
 /*
  * Thread groups
  */
@@ -2515,6 +2524,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, tgid_io_accounting),
 #endif
+#ifdef CONFIG_CGROUP_IO_THROTTLE
+	INF("io-throttle-stat",	S_IRUGO, iothrottle_stat),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file * filp,
@@ -2846,6 +2858,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, tid_io_accounting),
 #endif
+#ifdef CONFIG_CGROUP_IO_THROTTLE
+	INF("io-throttle-stat",	S_IRUGO, iothrottle_stat),
+#endif
 };
 
 static int proc_tid_base_readdir(struct file * filp,
-- 
1.5.4.3

