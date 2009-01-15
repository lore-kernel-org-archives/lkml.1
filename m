Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbZAOEHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbZAOEHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 23:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754344AbZAOEG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 23:06:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49783 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbZAOEG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 23:06:57 -0500
Message-ID: <496EB639.6090800@redhat.com>
Date: Wed, 14 Jan 2009 22:06:17 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the filesystem freeze operation has been elevated
to the VFS, and is just an ioctl away, some sort of safety net
for unintentionally frozen root filesystems may be in order.

The timeout thaw originally proposed did not get merged, but
perhaps something like this would be useful in emergencies.

This doesn't have to piggyback on the existing emergency sync
sysrq, but it seems like a reasonable, simple addition to me.

I've tested this on a non-root fs with multiple (nested) freezers,
as well as on a system rendered unresponsive due to a frozen
root fs.

Thanks,
-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/drivers/char/sysrq.c
===================================================================
--- linux-2.6.orig/drivers/char/sysrq.c
+++ linux-2.6/drivers/char/sysrq.c
@@ -151,6 +151,7 @@ static struct sysrq_key_op sysrq_reboot_
 
 static void sysrq_handle_sync(int key, struct tty_struct *tty)
 {
+	emergency_thaw();
 	emergency_sync();
 }
 static struct sysrq_key_op sysrq_sync_op = {
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -258,6 +258,29 @@ struct super_block *freeze_bdev(struct b
 }
 EXPORT_SYMBOL(freeze_bdev);
 
+void do_thaw(unsigned long unused)
+{
+	struct super_block *sb;
+	char b[BDEVNAME_SIZE];
+
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
+			printk(KERN_WARNING "Emergency Thaw on %s\n",
+			       bdevname(sb->s_bdev, b));
+	}
+	printk(KERN_WARNING "Emergency Thaw complete\n");
+}
+
+/**
+ * emergency_thaw -- force thaw every filesystem
+ *
+ * Used for emergency unfreeze of all filesystems via SysRq
+ */
+void emergency_thaw(void)
+{
+	pdflush_operation(do_thaw, 0);
+}
+
 /**
  * thaw_bdev  -- unlock filesystem
  * @bdev:	blockdevice to unlock
Index: linux-2.6/include/linux/buffer_head.h
===================================================================
--- linux-2.6.orig/include/linux/buffer_head.h
+++ linux-2.6/include/linux/buffer_head.h
@@ -171,6 +171,7 @@ void __wait_on_buffer(struct buffer_head
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
 struct super_block *freeze_bdev(struct block_device *);
+void emergency_thaw(void);
 int thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
Index: linux-2.6/Documentation/sysrq.txt
===================================================================
--- linux-2.6.orig/Documentation/sysrq.txt
+++ linux-2.6/Documentation/sysrq.txt
@@ -101,7 +101,8 @@ On all -  write a character to /proc/sys
 
 'r'     - Turns off keyboard raw mode and sets it to XLATE.
 
-'s'     - Will attempt to sync all mounted filesystems.
+'s'     - Will attempt to sync all mounted filesystems, and unfreeze
+	  any frozen fileystems.
 
 't'     - Will dump a list of current tasks and their information to your
           console.


