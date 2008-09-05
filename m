Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYIEQsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYIEQsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYIEQse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:48:34 -0400
Received: from nebensachen.de ([195.34.83.29]:47203 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651AbYIEQsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:48:30 -0400
X-Hashcash: 1:20:080905:jens.axboe@oracle.com::wSOiEwUgo+tuy4aU:00000000000000000000000000000000000000003QXJ
X-Hashcash: 1:20:080905:fujita.tomonori@lab.ntt.co.jp::+ppys9de9U6kzOYn:000000000000000000000000000000000Y5T
X-Hashcash: 1:20:080905:greg@kroah.com::i4dRrEGk8C6bHuNd:00002oo
X-Hashcash: 1:20:080905:linux-kernel@vger.kernel.org::tGMQFnCnnVR6jCqd:0000000000000000000000000000000001hiT
From: Elias Oltmanns <eo@nebensachen.de>
To: Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Block: Trouble with kobject initialisation for blk_cmd_filter
Date: Fri, 05 Sep 2008 18:48:07 +0200
Message-ID: <87od3235fc.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

current usage of the kobject in struct blk_cmd_filter is flawed. Doing
# modprobe -r sd-mod && modprobe sd-mod
while, for instance, a usb-stick is plugged in currently results in
nasty warnings and a dump_stack(). Since blk_cmd_filter is embedded in
struct request_queue, I don't see the need for a kobject anyway. What
about the much simpler option of a struct attribute_group in this
particular case?

This would imply that the cmd_filter subdirectory would appear under
sda/queue/ rather than sda/ (which is probably the right place) but,
alas, we have to keep compatibility in mind. So I've made some changes
to sysfs along the way in order to provide a legacy symlink. I'd have to
seperate these two changes for submission but I wanted to know your
opinion about it all first.

Thinking about it now makes me wonder whether this is too much for a rc
patch and whether we should just allocate the struct blk_cmd_filter
dynamically and have done with it. Anyway, tell me what you think.

Regards,

Elias

---
Applies to 2.6.27-rc5-git7.

 block/blk-sysfs.c      |    6 --
 block/blk.h            |    6 ++
 block/cmd-filter.c     |  113 +++++++++++++++----------------------------------
 fs/sysfs/symlink.c     |   48 ++++++++++++++++----
 include/linux/blkdev.h |    1 
 include/linux/sysfs.h  |    2 
 6 files changed, 81 insertions(+), 95 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 304ec73..0120c8e 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -9,12 +9,6 @@
 
 #include "blk.h"
 
-struct queue_sysfs_entry {
-	struct attribute attr;
-	ssize_t (*show)(struct request_queue *, char *);
-	ssize_t (*store)(struct request_queue *, const char *, size_t);
-};
-
 static ssize_t
 queue_var_show(unsigned int var, char *page)
 {
diff --git a/block/blk.h b/block/blk.h
index c79f30e..9ab0d6a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -10,6 +10,12 @@
 extern struct kmem_cache *blk_requestq_cachep;
 extern struct kobj_type blk_queue_ktype;
 
+struct queue_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct request_queue *, char *);
+	ssize_t (*store)(struct request_queue *, const char *, size_t);
+};
+
 void init_request_from_bio(struct request *req, struct bio *bio);
 void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			struct bio *bio);
diff --git a/block/cmd-filter.c b/block/cmd-filter.c
index 228b644..fc0f0b2 100644
--- a/block/cmd-filter.c
+++ b/block/cmd-filter.c
@@ -26,6 +26,8 @@
 #include <scsi/scsi.h>
 #include <linux/cdrom.h>
 
+#include "blk.h"
+
 int blk_verify_command(struct blk_cmd_filter *filter,
 		       unsigned char *cmd, int has_write_perm)
 {
@@ -50,9 +52,9 @@ int blk_verify_command(struct blk_cmd_filter *filter,
 EXPORT_SYMBOL(blk_verify_command);
 
 /* and now, the sysfs stuff */
-static ssize_t rcf_cmds_show(struct blk_cmd_filter *filter, char *page,
-			     int rw)
+static ssize_t rcf_cmds_show(struct request_queue *q, char *page, int rw)
 {
+	struct blk_cmd_filter *filter = &q->cmd_filter;
 	char *npage = page;
 	unsigned long *okbits;
 	int i;
@@ -76,24 +78,27 @@ static ssize_t rcf_cmds_show(struct blk_cmd_filter *filter, char *page,
 	return npage - page;
 }
 
-static ssize_t rcf_readcmds_show(struct blk_cmd_filter *filter, char *page)
+static ssize_t rcf_readcmds_show(struct request_queue *q, char *page)
 {
-	return rcf_cmds_show(filter, page, READ);
+	return rcf_cmds_show(q, page, READ);
 }
 
-static ssize_t rcf_writecmds_show(struct blk_cmd_filter *filter,
-				 char *page)
+static ssize_t rcf_writecmds_show(struct request_queue *q, char *page)
 {
-	return rcf_cmds_show(filter, page, WRITE);
+	return rcf_cmds_show(q, page, WRITE);
 }
 
-static ssize_t rcf_cmds_store(struct blk_cmd_filter *filter,
-			      const char *page, size_t count, int rw)
+static ssize_t rcf_cmds_store(struct request_queue *q, const char *page,
+			      size_t count, int rw)
 {
+	struct blk_cmd_filter *filter = &q->cmd_filter;
 	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
 	int cmd, set;
 	char *p, *status;
 
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
 	if (rw == READ) {
 		memcpy(&okbits, filter->read_ok, sizeof(okbits));
 		target_okbits = filter->read_ok;
@@ -128,31 +133,25 @@ static ssize_t rcf_cmds_store(struct blk_cmd_filter *filter,
 	return count;
 }
 
-static ssize_t rcf_readcmds_store(struct blk_cmd_filter *filter,
-				  const char *page, size_t count)
+static ssize_t rcf_readcmds_store(struct request_queue *q, const char *page,
+				  size_t count)
 {
-	return rcf_cmds_store(filter, page, count, READ);
+	return rcf_cmds_store(q, page, count, READ);
 }
 
-static ssize_t rcf_writecmds_store(struct blk_cmd_filter *filter,
-				   const char *page, size_t count)
+static ssize_t rcf_writecmds_store(struct request_queue *q, const char *page,
+				   size_t count)
 {
-	return rcf_cmds_store(filter, page, count, WRITE);
+	return rcf_cmds_store(q, page, count, WRITE);
 }
 
-struct rcf_sysfs_entry {
-	struct attribute attr;
-	ssize_t (*show)(struct blk_cmd_filter *, char *);
-	ssize_t (*store)(struct blk_cmd_filter *, const char *, size_t);
-};
-
-static struct rcf_sysfs_entry rcf_readcmds_entry = {
+static struct queue_sysfs_entry rcf_readcmds_entry = {
 	.attr = { .name = "read_table", .mode = S_IRUGO | S_IWUSR },
 	.show = rcf_readcmds_show,
 	.store = rcf_readcmds_store,
 };
 
-static struct rcf_sysfs_entry rcf_writecmds_entry = {
+static struct queue_sysfs_entry rcf_writecmds_entry = {
 	.attr = {.name = "write_table", .mode = S_IRUGO | S_IWUSR },
 	.show = rcf_writecmds_show,
 	.store = rcf_writecmds_store,
@@ -164,72 +163,30 @@ static struct attribute *default_attrs[] = {
 	NULL,
 };
 
-#define to_rcf(atr) container_of((atr), struct rcf_sysfs_entry, attr)
-
-static ssize_t
-rcf_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
-{
-	struct rcf_sysfs_entry *entry = to_rcf(attr);
-	struct blk_cmd_filter *filter;
-
-	filter = container_of(kobj, struct blk_cmd_filter, kobj);
-	if (entry->show)
-		return entry->show(filter, page);
-
-	return 0;
-}
-
-static ssize_t
-rcf_attr_store(struct kobject *kobj, struct attribute *attr,
-			const char *page, size_t length)
-{
-	struct rcf_sysfs_entry *entry = to_rcf(attr);
-	struct blk_cmd_filter *filter;
-
-	if (!capable(CAP_SYS_RAWIO))
-		return -EPERM;
-
-	if (!entry->store)
-		return -EINVAL;
-
-	filter = container_of(kobj, struct blk_cmd_filter, kobj);
-	return entry->store(filter, page, length);
-}
-
-static struct sysfs_ops rcf_sysfs_ops = {
-	.show = rcf_attr_show,
-	.store = rcf_attr_store,
-};
-
-static struct kobj_type rcf_ktype = {
-	.sysfs_ops = &rcf_sysfs_ops,
-	.default_attrs = default_attrs,
+static struct attribute_group rcf_attr_group = {
+	.name = "cmd_filter",
+	.attrs = default_attrs,
 };
 
 int blk_register_filter(struct gendisk *disk)
 {
+	struct kobject *kobj = &disk->queue->kobj;
 	int ret;
-	struct blk_cmd_filter *filter = &disk->queue->cmd_filter;
-	struct kobject *parent = kobject_get(disk->holder_dir->parent);
 
-	if (!parent)
-		return -ENODEV;
+	ret = sysfs_create_group(kobj, &rcf_attr_group);
+	if (!ret)
+		ret = sysfs_create_link_to_group(disk->holder_dir->parent,
+						 kobj, rcf_attr_group.name,
+						 rcf_attr_group.name);
+	WARN_ON(ret);
 
-	ret = kobject_init_and_add(&filter->kobj, &rcf_ktype, parent,
-				   "%s", "cmd_filter");
-
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(blk_register_filter);
 
 void blk_unregister_filter(struct gendisk *disk)
 {
-	struct blk_cmd_filter *filter = &disk->queue->cmd_filter;
-
-	kobject_put(&filter->kobj);
-	kobject_put(disk->holder_dir->parent);
+	sysfs_remove_link(disk->holder_dir->parent, rcf_attr_group.name);
+	sysfs_remove_group(&disk->queue->kobj, &rcf_attr_group);
 }
 EXPORT_SYMBOL(blk_unregister_filter);
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index a3ba217..d2813a1 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -19,22 +19,16 @@
 
 #include "sysfs.h"
 
-static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
+static int sysfs_sd_create_link(struct sysfs_dirent *parent_sd,
+				struct sysfs_dirent *target_sd,
 				const char *name, int warn)
 {
-	struct sysfs_dirent *parent_sd = NULL;
-	struct sysfs_dirent *target_sd = NULL;
 	struct sysfs_dirent *sd = NULL;
 	struct sysfs_addrm_cxt acxt;
 	int error;
 
 	BUG_ON(!name);
 
-	if (!kobj)
-		parent_sd = &sysfs_root;
-	else
-		parent_sd = kobj->sd;
-
 	error = -EFAULT;
 	if (!parent_sd)
 		goto out_put;
@@ -43,8 +37,8 @@ static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
 	 * sysfs_assoc_lock.  Fetch target_sd from it.
 	 */
 	spin_lock(&sysfs_assoc_lock);
-	if (target->sd)
-		target_sd = sysfs_get(target->sd);
+	if (target_sd)
+		target_sd = sysfs_get(target_sd);
 	spin_unlock(&sysfs_assoc_lock);
 
 	error = -ENOENT;
@@ -77,6 +71,19 @@ static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
 	return error;
 }
 
+static int sysfs_do_create_link(struct kobject *kobj, struct kobject *target,
+				const char *name, int warn)
+{
+	struct sysfs_dirent *parent_sd;
+
+	if (!kobj)
+		parent_sd = &sysfs_root;
+	else
+		parent_sd = kobj->sd;
+
+	return sysfs_sd_create_link(parent_sd, target->sd, name, warn);
+}
+
 /**
  *	sysfs_create_link - create symlink between two objects.
  *	@kobj:	object whose directory we're creating the link in.
@@ -104,6 +111,26 @@ int sysfs_create_link_nowarn(struct kobject *kobj, struct kobject *target,
 	return sysfs_do_create_link(kobj, target, name, 0);
 }
 
+int sysfs_create_link_to_group(struct kobject *kobj, struct kobject *target,
+			       const char *group, const char *linkname)
+{
+	struct sysfs_dirent *sd;
+	int ret;
+
+	BUG_ON(!kobj || !target);
+
+	sd = sysfs_get_dirent(target->sd, group);
+	if (!sd) {
+		WARN(!sd, KERN_WARNING "sysfs group %p not found for "
+		     "kobject '%s'\n", group, kobject_name(target));
+		return -ENOENT;
+	}
+
+	ret = sysfs_sd_create_link(kobj->sd, sd, linkname, 1);
+	sysfs_put(sd);
+	return ret;
+}
+
 /**
  *	sysfs_remove_link - remove symlink in object's directory.
  *	@kobj:	object we're acting for.
@@ -213,4 +240,5 @@ const struct inode_operations sysfs_symlink_inode_operations = {
 
 
 EXPORT_SYMBOL_GPL(sysfs_create_link);
+EXPORT_SYMBOL_GPL(sysfs_create_link_to_group);
 EXPORT_SYMBOL_GPL(sysfs_remove_link);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 44710d7..ca616b7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -286,7 +286,6 @@ struct blk_queue_tag {
 struct blk_cmd_filter {
 	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
 	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
-	struct kobject kobj;
 };
 
 struct request_queue
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 37fa241..e9e0971 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -116,6 +116,8 @@ int sysfs_add_file_to_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
 void sysfs_remove_file_from_group(struct kobject *kobj,
 			const struct attribute *attr, const char *group);
+int sysfs_create_link_to_group(struct kobject *kobj, struct kobject *target,
+			       const char *grpname, const char *linkname);
 
 void sysfs_notify(struct kobject *kobj, char *dir, char *attr);
 
