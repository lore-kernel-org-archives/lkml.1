Return-Path: <linux-kernel-owner+w=401wt.eu-S936696AbZAPTcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936696AbZAPTcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbZAPTb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:31:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50320 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756092AbZAPTb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:31:56 -0500
Message-ID: <4970E087.8020308@redhat.com>
Date: Fri, 16 Jan 2009 13:31:19 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
CC: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH V2] Allow SysRq emergency thaw to thaw frozen filesystems
References: <496EB639.6090800@redhat.com>
In-Reply-To: <496EB639.6090800@redhat.com>
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

For example, freeze /path/to/mountpoint may freeze your
root filesystem if you forgot that you had that unmounted.

I chose 'j' as the last remaining character other than 'h'
which is sort of reserved for help (because help is generated
on any unknown character).

I've tested this on a non-root fs with multiple (nested) freezers,
as well as on a system rendered unresponsive due to a frozen
root fs.

Thanks,
-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6/drivers/char/sysrq.c
===================================================================
--- linux-2.6.orig/drivers/char/sysrq.c	2009-01-16 13:24:14.688575212 -0600
+++ linux-2.6/drivers/char/sysrq.c	2009-01-16 13:26:35.232575643 -0600
@@ -346,6 +346,17 @@ static struct sysrq_key_op sysrq_moom_op
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
 
+static void sysrq_handle_thaw(int key, struct tty_struct *tty)
+{
+	emergency_thaw_all();
+}
+static struct sysrq_key_op sysrq_thaw_op = {
+	.handler	= sysrq_handle_thaw,
+	.help_msg	= "Thaw(J)",
+	.action_msg	= "Emergency Thaw of all frozen filesystems",
+	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
+};
+
 static void sysrq_handle_kill(int key, struct tty_struct *tty)
 {
 	send_sig_all(SIGKILL);
@@ -396,9 +407,9 @@ static struct sysrq_key_op *sysrq_key_ta
 	&sysrq_moom_op,			/* f */
 	/* g: May be registered by ppc for kgdb */
 	NULL,				/* g */
-	NULL,				/* h */
+	NULL,				/* h - reserved for help */
 	&sysrq_kill_op,			/* i */
-	NULL,				/* j */
+	&sysrq_thaw_op,			/* j */
 	&sysrq_SAK_op,			/* k */
 #ifdef CONFIG_SMP
 	&sysrq_showallcpus_op,		/* l */
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c	2009-01-16 13:24:15.564575078 -0600
+++ linux-2.6/fs/buffer.c	2009-01-16 13:26:35.257575540 -0600
@@ -258,6 +258,29 @@ struct super_block *freeze_bdev(struct b
 }
 EXPORT_SYMBOL(freeze_bdev);
 
+void do_thaw_all(unsigned long unused)
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
+ * emergency_thaw_all -- forcibly thaw every frozen filesystem
+ *
+ * Used for emergency unfreeze of all filesystems via SysRq-z
+ */
+void emergency_thaw_all(void)
+{
+	pdflush_operation(do_thaw_all, 0);
+}
+
 /**
  * thaw_bdev  -- unlock filesystem
  * @bdev:	blockdevice to unlock
Index: linux-2.6/include/linux/buffer_head.h
===================================================================
--- linux-2.6.orig/include/linux/buffer_head.h	2009-01-14 15:15:53.320575384 -0600
+++ linux-2.6/include/linux/buffer_head.h	2009-01-16 13:26:35.394575234 -0600
@@ -171,6 +171,7 @@ void __wait_on_buffer(struct buffer_head
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
 struct super_block *freeze_bdev(struct block_device *);
+void emergency_thaw_all(void);
 int thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
Index: linux-2.6/Documentation/sysrq.txt
===================================================================
--- linux-2.6.orig/Documentation/sysrq.txt	2009-01-16 13:24:12.943637511 -0600
+++ linux-2.6/Documentation/sysrq.txt	2009-01-16 13:26:35.436575321 -0600
@@ -81,6 +81,8 @@ On all -  write a character to /proc/sys
 
 'i'     - Send a SIGKILL to all processes, except for init.
 
+'j'	- Forcibly "Just thaw it" - filesystems frozen by the FIFREEZE ioctl.
+
 'k'     - Secure Access Key (SAK) Kills all programs on the current virtual
           console. NOTE: See important comments below in SAK section.
 
@@ -160,6 +162,9 @@ t'E'rm and k'I'll are useful if you have
 are unable to kill any other way, especially if it's spawning other
 processes.
 
+"'J'ust thaw it" is useful if your system becomes unresponsive due to a frozen
+(probably root) filesystem via the FIFREEZE ioctl.
+
 *  Sometimes SysRq seems to get 'stuck' after using it, what can I do?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 That happens to me, also. I've found that tapping shift, alt, and control

