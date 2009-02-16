Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZBPWBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZBPWBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZBPWBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:01:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48843 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbZBPWBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:01:39 -0500
Message-ID: <4999E229.3050507@redhat.com>
Date: Mon, 16 Feb 2009 16:01:13 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       t-sato@yk.jp.nec.com
Subject: [PATCH V5] Allow SysRq emergency thaw to thaw frozen filesystems
References: <496EB639.6090800@redhat.com>	<4970E087.8020308@redhat.com>	<4970E4FB.7040407@redhat.com>	<20090130134009.02d4a576.akpm@linux-foundation.org>	<498779D6.7010304@redhat.com> <20090203140135.fe8360f6.akpm@linux-foundation.org>
In-Reply-To: <20090203140135.fe8360f6.akpm@linux-foundation.org>
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

(this version fixes a couple small issues raised by Randy Dunlap)
(and adds sb_lock locking I forgot, as akpm pointed out)
(and includes Randy's CONFIG_BLOCK fix)
(and does proper locking, finally)

Thanks,
-Eric

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.28.x86_64/drivers/char/sysrq.c
===================================================================
--- linux-2.6.28.x86_64.orig/drivers/char/sysrq.c
+++ linux-2.6.28.x86_64/drivers/char/sysrq.c
@@ -348,6 +348,19 @@ static struct sysrq_key_op sysrq_moom_op
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
 
+#ifdef CONFIG_BLOCK
+static void sysrq_handle_thaw(int key, struct tty_struct *tty)
+{
+	emergency_thaw_all();
+}
+static struct sysrq_key_op sysrq_thaw_op = {
+	.handler	= sysrq_handle_thaw,
+	.help_msg	= "thaw-filesystems(J)",
+	.action_msg	= "Emergency Thaw of all frozen filesystems",
+	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
+};
+#endif
+
 static void sysrq_handle_kill(int key, struct tty_struct *tty)
 {
 	send_sig_all(SIGKILL);
@@ -398,9 +411,13 @@ static struct sysrq_key_op *sysrq_key_ta
 	&sysrq_moom_op,			/* f */
 	/* g: May be registered by ppc for kgdb */
 	NULL,				/* g */
-	NULL,				/* h */
+	NULL,				/* h - reserved for help */
 	&sysrq_kill_op,			/* i */
+#ifdef CONFIG_BLOCK
+	&sysrq_thaw_op,			/* j */
+#else
 	NULL,				/* j */
+#endif
 	&sysrq_SAK_op,			/* k */
 #ifdef CONFIG_SMP
 	&sysrq_showallcpus_op,		/* l */
Index: linux-2.6.28.x86_64/fs/buffer.c
===================================================================
--- linux-2.6.28.x86_64.orig/fs/buffer.c
+++ linux-2.6.28.x86_64/fs/buffer.c
@@ -258,6 +258,39 @@ struct super_block *freeze_bdev(struct b
 }
 EXPORT_SYMBOL(freeze_bdev);
 
+void do_thaw_all(unsigned long unused)
+{
+	struct super_block *sb;
+	char b[BDEVNAME_SIZE];
+
+	spin_lock(&sb_lock);
+restart:
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		sb->s_count++;
+		spin_unlock(&sb_lock);
+		down_read(&sb->s_umount);
+		while (sb->s_bdev && !thaw_bdev(sb->s_bdev, sb))
+			printk(KERN_WARNING "Emergency Thaw on %s\n",
+			       bdevname(sb->s_bdev, b));
+		up_read(&sb->s_umount);
+		spin_lock(&sb_lock);
+		if (__put_super_and_need_restart(sb))
+			goto restart;
+	}
+	spin_unlock(&sb_lock);
+	printk(KERN_WARNING "Emergency Thaw complete\n");
+}
+
+/**
+ * emergency_thaw_all -- forcibly thaw every frozen filesystem
+ *
+ * Used for emergency unfreeze of all filesystems via SysRq
+ */
+void emergency_thaw_all(void)
+{
+	pdflush_operation(do_thaw_all, 0);
+}
+
 /**
  * thaw_bdev  -- unlock filesystem
  * @bdev:	blockdevice to unlock
Index: linux-2.6.28.x86_64/include/linux/buffer_head.h
===================================================================
--- linux-2.6.28.x86_64.orig/include/linux/buffer_head.h
+++ linux-2.6.28.x86_64/include/linux/buffer_head.h
@@ -171,6 +171,7 @@ void __wait_on_buffer(struct buffer_head
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
 struct super_block *freeze_bdev(struct block_device *);
+void emergency_thaw_all(void);
 int thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
Index: linux-2.6.28.x86_64/Documentation/sysrq.txt
===================================================================
--- linux-2.6.28.x86_64.orig/Documentation/sysrq.txt
+++ linux-2.6.28.x86_64/Documentation/sysrq.txt
@@ -81,6 +81,8 @@ On all -  write a character to /proc/sys
 
 'i'     - Send a SIGKILL to all processes, except for init.
 
+'j'     - Forcibly "Just thaw it" - filesystems frozen by the FIFREEZE ioctl.
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

