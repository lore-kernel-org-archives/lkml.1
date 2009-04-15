Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbZDOKO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbZDOKO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759319AbZDOKOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:14:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:55491 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759024AbZDOKOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:14:00 -0400
Date: Wed, 15 Apr 2009 10:13:14 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, tytso@mit.edu,
       jens.axboe@oracle.com, duyuyang@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, tytso@mit.edu,
       jens.axboe@oracle.com, duyuyang@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49E42665.6020506@cn.fujitsu.com>
References: <49E42665.6020506@cn.fujitsu.com>
Subject: [tip:tracing/core] blktrace: add trace/ to /sys/block/sda
Message-ID: <tip-fd22f2711aadb26ff56f7d3637430af098dfaeb1@git.kernel.org>
Git-Commit-ID: fd22f2711aadb26ff56f7d3637430af098dfaeb1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Apr 2009 10:13:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd22f2711aadb26ff56f7d3637430af098dfaeb1
Gitweb:     http://git.kernel.org/tip/fd22f2711aadb26ff56f7d3637430af098dfaeb1
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 14 Apr 2009 14:00:05 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Apr 2009 09:38:54 +0200

blktrace: add trace/ to /sys/block/sda

Impact: allow ftrace-plugin blktrace to trace device-mapper devices

To trace a single partition:
  # echo 1 > /sys/block/sda/sda1/enable

To trace the whole sda instead:
  # echo 1 > /sys/block/sda/enable

Thus we also fix an issue reported by Ted, that ftrace-plugin blktrace
can't be used to trace device-mapper devices.

Now:

  # echo 1 > /sys/block/dm-0/trace/enable
  echo: write error: No such device or address
  # mount -t ext4 /dev/dm-0 /mnt
  # echo 1 > /sys/block/dm-0/trace/enable
  # echo blk > /debug/tracing/current_tracer

Reported-by: Theodore Tso <tytso@mit.edu>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Shawn Du <duyuyang@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
LKML-Reference: <49E42665.6020506@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 block/blk-sysfs.c            |    7 ++++++-
 include/linux/blktrace_api.h |    6 ++++++
 kernel/trace/blktrace.c      |    5 +++++
 3 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 73f36be..8653d71 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -387,16 +387,21 @@ struct kobj_type blk_queue_ktype = {
 int blk_register_queue(struct gendisk *disk)
 {
 	int ret;
+	struct device *dev = disk_to_dev(disk);
 
 	struct request_queue *q = disk->queue;
 
 	if (WARN_ON(!q))
 		return -ENXIO;
 
+	ret = blk_trace_init_sysfs(dev);
+	if (ret)
+		return ret;
+
 	if (!q->request_fn)
 		return 0;
 
-	ret = kobject_add(&q->kobj, kobject_get(&disk_to_dev(disk)->kobj),
+	ret = kobject_add(&q->kobj, kobject_get(&dev->kobj),
 			  "%s", "queue");
 	if (ret < 0)
 		return ret;
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 267edc4..62763c9 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -198,6 +198,7 @@ extern int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 			   char __user *arg);
 extern int blk_trace_startstop(struct request_queue *q, int start);
 extern int blk_trace_remove(struct request_queue *q);
+extern int blk_trace_init_sysfs(struct device *dev);
 
 extern struct attribute_group blk_trace_attr_group;
 
@@ -210,6 +211,11 @@ extern struct attribute_group blk_trace_attr_group;
 # define blk_trace_startstop(q, start)			(-ENOTTY)
 # define blk_trace_remove(q)				(-ENOTTY)
 # define blk_add_trace_msg(q, fmt, ...)			do { } while (0)
+static inline int blk_trace_init_sysfs(struct device *dev)
+{
+	return 0;
+}
+
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
 
 #endif /* __KERNEL__ */
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index d109898..8e7c5da 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1644,3 +1644,8 @@ out:
 	return ret ? ret : count;
 }
 
+int blk_trace_init_sysfs(struct device *dev)
+{
+	return sysfs_create_group(&dev->kobj, &blk_trace_attr_group);
+}
+
