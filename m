Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbZDRVlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbZDRVlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 17:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759898AbZDRVjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 17:39:00 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63655 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759790AbZDRVi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 17:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dQULdBkMN+EYQ+Ugym85RWctnSVIkMhOq/pS5e+nk+hkUgFdb2PsQpTH95Aucwtmuk
         mBnPz3lpj9Lu7wDgrGoXG/VyRfjpHkqt/cAUT401r9Yjmvthm4Ts9fUZIunZasYl6HMR
         XE1ssY1guRtW64QxDqGcCBv/uw2oe5icQqFJA=
From: Andrea Righi <righi.andrea@gmail.com>
To: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, Nauman Rafique <nauman@google.com>,
       fchecconi@gmail.com, paolo.valente@unimore.it,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH 7/7] export per-task io-throttle statistics to userspace
Date: Sat, 18 Apr 2009 23:38:32 +0200
Message-Id: <1240090712-1058-8-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1240090712-1058-1-git-send-email-righi.andrea@gmail.com>
References: <1240090712-1058-1-git-send-email-righi.andrea@gmail.com>
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
index aa763ab..94061bf 100644
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
@@ -2453,6 +2454,17 @@ static int proc_tgid_io_accounting(struct task_struct *task, char *buffer)
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
 static int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *task)
 {
@@ -2539,6 +2551,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, proc_tgid_io_accounting),
 #endif
+#ifdef CONFIG_CGROUP_IO_THROTTLE
+	INF("io-throttle-stat",	S_IRUGO, proc_iothrottle_stat),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file * filp,
@@ -2874,6 +2889,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_TASK_IO_ACCOUNTING
 	INF("io",	S_IRUGO, proc_tid_io_accounting),
 #endif
+#ifdef CONFIG_CGROUP_IO_THROTTLE
+	INF("io-throttle-stat",	S_IRUGO, proc_iothrottle_stat),
+#endif
 };
 
 static int proc_tid_base_readdir(struct file * filp,
-- 
1.5.6.3

