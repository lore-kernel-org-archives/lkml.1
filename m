Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbYJGKGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbYJGKGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYJGKEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:04:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:58334 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbYJGKEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WxOP1iFCrLlnjAMVDVbueImE8YS8KGODb2DbQCZxlphe40GWgRhGEawaFa4nBFRL5B
         wgIast4NS3iqKPRhwEWCa1q6ULYrvnxMevHhE0tr7BYTznCFm8PtVvGDx2cacoLisEQK
         LAYbGOUJ3HhxlvvzUvKqaarOncDUMZST8asPQ=
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
Subject: [PATCH -mm 6/6] export per-task i/o throttling statistics to userspace
Date: Tue,  7 Oct 2008 12:03:38 +0200
Message-Id: <1223373818-13687-7-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the throttling statistics collected for each task through
/proc/PID/io-throttle-stat.

Example:
 $ cat /proc/$$/io-throttle-stat
 0 0 0 0
 ^ ^ ^ ^
  \ \ \ \_____global iops sleep (in clock ticks)
   \ \ \______global iops counter
    \ \_______global bandwidth sleep (in clock ticks)
     \________global bandwidth counter

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 fs/proc/base.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 63617ca..e8c4d5c 100644
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
@@ -2459,6 +2460,17 @@ static int proc_tgid_io_accounting(struct task_struct *task, char *buffer)
 }
 #endif /* CONFIG_TASK_IO_ACCOUNTING */
 
+#ifdef CONFIG_CGROUP_IO_THROTTLE
+static int proc_iothrottle_stat(struct task_struct *task, char *buffer)
+{
+	return sprintf(buffer, "%llu %llu %llu %llu\n",
+			get_io_throttle_cnt(task, IOTHROTTLE_BANDWIDTH),
+			get_io_throttle_sleep(task, IOTHROTTLE_BANDWIDTH),
+			get_io_throttle_cnt(task, IOTHROTTLE_IOPS),
+			get_io_throttle_sleep(task, IOTHROTTLE_IOPS));
+}
+#endif /* CONFIG_CGROUP_IO_THROTTLE */
+
 /*
  * Thread groups
  */
@@ -2534,6 +2546,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, tgid_io_accounting),
 #endif
+#ifdef CONFIG_CGROUP_IO_THROTTLE
+	INF("io-throttle-stat",	S_IRUGO, iothrottle_stat),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file * filp,
@@ -2865,6 +2880,9 @@ static const struct pid_entry tid_base_stuff[] = {
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

