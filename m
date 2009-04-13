Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbZDMKvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbZDMKvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 06:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZDMKuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 06:50:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63447 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbZDMKuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 06:50:52 -0400
Message-ID: <49E31931.5000506@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 18:51:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>
CC: "Theodore Ts'o" <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] blktrace: move trace/ dir to /sys/block/sda/
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: allow ftrace-plugin blktrace to trace device-mapper devices

blktrace can't trace a single partition, so it makes no sense to
have one trace/ dir in each /sys/block/sda/sdaX. Move it to
/sys/block/sda/.

Thus we fix an issue reported by Ted, that ftrace-plugin blktrace
can't be used to trace device-mapper devices.

Now:

  # echo 1 > /sys/block/dm-0/trace/enable
  echo: write error: No such device or address
  # mount -t ext4 /dev/dm-0 /mnt
  # echo 1 > /sys/block/dm-0/trace/enable
  # echo blk > /debug/tracing/current_tracer

Reported-by: Theodore Tso <tytso@mit.edu>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 block/blk-sysfs.c            |    7 ++++++-
 fs/partitions/check.c        |    3 ---
 include/linux/blktrace_api.h |    7 ++++++-
 kernel/trace/blktrace.c      |    7 ++++++-
 4 files changed, 18 insertions(+), 6 deletions(-)

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
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 99e33ef..445fd2f 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -295,9 +295,6 @@ static struct attribute_group part_attr_group = {
 
 static struct attribute_group *part_attr_groups[] = {
 	&part_attr_group,
-#ifdef CONFIG_BLK_DEV_IO_TRACE
-	&blk_trace_attr_group,
-#endif
 	NULL
 };
 
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index d960889..518e32a 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -197,7 +197,7 @@ extern int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 extern int blk_trace_startstop(struct request_queue *q, int start);
 extern int blk_trace_remove(struct request_queue *q);
 
-extern struct attribute_group blk_trace_attr_group;
+extern int blk_trace_init_sysfs(struct device *dev);
 
 #else /* !CONFIG_BLK_DEV_IO_TRACE */
 #define blk_trace_ioctl(bdev, cmd, arg)		(-ENOTTY)
@@ -209,6 +209,11 @@ extern struct attribute_group blk_trace_attr_group;
 #define blk_trace_remove(q)			(-ENOTTY)
 #define blk_add_trace_msg(q, fmt, ...)		do { } while (0)
 
+static inline int blk_trace_init_sysfs(struct device *dev)
+{
+	return 0;
+}
+
 #endif /* CONFIG_BLK_DEV_IO_TRACE */
 #endif /* __KERNEL__ */
 #endif
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 2b98195..9bae35f 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1420,7 +1420,7 @@ static struct attribute *blk_trace_attrs[] = {
 	NULL
 };
 
-struct attribute_group blk_trace_attr_group = {
+static struct attribute_group blk_trace_attr_group = {
 	.name  = "trace",
 	.attrs = blk_trace_attrs,
 };
@@ -1620,3 +1620,8 @@ out:
 	return ret ? ret : count;
 }
 
+int blk_trace_init_sysfs(struct device *dev)
+{
+	return sysfs_create_group(&dev->kobj, &blk_trace_attr_group);
+}
+
-- 
1.5.4.rc3

