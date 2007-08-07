Return-Path: <linux-kernel-owner+w=401wt.eu-S934061AbXHGLYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061AbXHGLYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 07:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759862AbXHGLYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 07:24:10 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:58141 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbXHGLYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 07:24:07 -0400
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 07 Aug 2007 13:27:42 +0200
Message-Id: <1186486062.19539.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 arch/s390/Kconfig             |    4 -
 arch/s390/hypfs/inode.c       |   12 +++
 drivers/s390/char/monwriter.c |    6 ++
 drivers/s390/char/vmur.c      |  176 +++++++++++++++++++++++++----------------
 drivers/s390/char/vmur.h      |    5 +-
 drivers/s390/cio/css.c        |    1 +
 drivers/s390/cio/qdio.c       |   92 +++++++++++-----------
 7 files changed, 178 insertions(+), 118 deletions(-)

Cornelia Huck (1):
      [S390] cio: avoid memory leak on error in css_alloc_subchannel().

Heiko Carstens (3):
      [S390] qdio: make sure data structures are correctly aligned.
      [S390] remove DEFAULT_MIGRATION_COST
      [S390] vmur: use DECLARE_COMPLETION_ONSTACK to keep lockdep happy

Melissa Howland (1):
      [S390] monwriter: Serialization bug for multithreaded applications.

Michael Holzheu (5):
      [S390] hypfs: implement show_options
      [S390] vmur: allocate single record buffers instead of one big data buffer
      [S390] vmur: reject open on z/VM reader files with status HOLD
      [S390] vmur: add "top of queue" sanity check for reader open
      [S390] vmur: diag14 only works with buffers below 2GB

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 098c62c..b711321 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -109,10 +109,6 @@ config HOTPLUG_CPU
 	  can be controlled through /sys/devices/system/cpu/cpu#.
 	  Say N if you want to disable CPU hotplug.
 
-config DEFAULT_MIGRATION_COST
-	int
-	default "1000000"
-
 config MATHEMU
 	bool "IEEE FPU emulation"
 	depends on MARCH_G5
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 8e1ea1c..ad4ca75 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -17,6 +17,8 @@
 #include <linux/parser.h>
 #include <linux/sysfs.h>
 #include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/mount.h>
 #include <asm/ebcdic.h>
 #include "hypfs.h"
 
@@ -256,6 +258,15 @@ static int hypfs_parse_options(char *options, struct super_block *sb)
 	return 0;
 }
 
+static int hypfs_show_options(struct seq_file *s, struct vfsmount *mnt)
+{
+	struct hypfs_sb_info *hypfs_info = mnt->mnt_sb->s_fs_info;
+
+	seq_printf(s, ",uid=%u", hypfs_info->uid);
+	seq_printf(s, ",gid=%u", hypfs_info->gid);
+	return 0;
+}
+
 static int hypfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *root_inode;
@@ -459,6 +470,7 @@ static struct file_system_type hypfs_type = {
 static struct super_operations hypfs_s_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= hypfs_drop_inode,
+	.show_options	= hypfs_show_options,
 };
 
 static decl_subsys(s390, NULL, NULL);
diff --git a/drivers/s390/char/monwriter.c b/drivers/s390/char/monwriter.c
index 268598e..20442fb 100644
--- a/drivers/s390/char/monwriter.c
+++ b/drivers/s390/char/monwriter.c
@@ -17,6 +17,7 @@
 #include <linux/miscdevice.h>
 #include <linux/ctype.h>
 #include <linux/poll.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <asm/ebcdic.h>
 #include <asm/io.h>
@@ -41,6 +42,7 @@ struct mon_private {
 	size_t hdr_to_read;
 	size_t data_to_read;
 	struct mon_buf *current_buf;
+	struct mutex thread_mutex;
 };
 
 /*
@@ -179,6 +181,7 @@ static int monwrite_open(struct inode *inode, struct file *filp)
 		return -ENOMEM;
 	INIT_LIST_HEAD(&monpriv->list);
 	monpriv->hdr_to_read = sizeof(monpriv->hdr);
+	mutex_init(&monpriv->thread_mutex);
 	filp->private_data = monpriv;
 	return nonseekable_open(inode, filp);
 }
@@ -209,6 +212,7 @@ static ssize_t monwrite_write(struct file *filp, const char __user *data,
 	void *to;
 	int rc;
 
+	mutex_lock(&monpriv->thread_mutex);
 	for (written = 0; written < count; ) {
 		if (monpriv->hdr_to_read) {
 			len = min(count - written, monpriv->hdr_to_read);
@@ -247,11 +251,13 @@ static ssize_t monwrite_write(struct file *filp, const char __user *data,
 		}
 		monpriv->hdr_to_read = sizeof(monpriv->hdr);
 	}
+	mutex_unlock(&monpriv->thread_mutex);
 	return written;
 
 out_error:
 	monpriv->data_to_read = 0;
 	monpriv->hdr_to_read = sizeof(struct monwrite_hdr);
+	mutex_unlock(&monpriv->thread_mutex);
 	return rc;
 }
 
diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index 161867c..04b19bd 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -119,10 +119,12 @@ static void urdev_put(struct urdev *urd)
 /*
  * Low-level functions to do I/O to a ur device.
  *     alloc_chan_prog
+ *     free_chan_prog
  *     do_ur_io
  *     ur_int_handler
  *
  * alloc_chan_prog allocates and builds the channel program
+ * free_chan_prog frees memory of the channel program
  *
  * do_ur_io issues the channel program to the device and blocks waiting
  * on a completion event it publishes at urd->io_done. The function
@@ -137,6 +139,16 @@ static void urdev_put(struct urdev *urd)
  * address pointer that alloc_chan_prog returned.
  */
 
+static void free_chan_prog(struct ccw1 *cpa)
+{
+	struct ccw1 *ptr = cpa;
+
+	while (ptr->cda) {
+		kfree((void *)(addr_t) ptr->cda);
+		ptr++;
+	}
+	kfree(cpa);
+}
 
 /*
  * alloc_chan_prog
@@ -144,44 +156,45 @@ static void urdev_put(struct urdev *urd)
  * with a final NOP CCW command-chained on (which ensures that CE and DE
  * are presented together in a single interrupt instead of as separate
  * interrupts unless an incorrect length indication kicks in first). The
- * data length in each CCW is reclen. The caller must ensure that count
- * is an integral multiple of reclen.
- * The channel program pointer returned by this function must be freed
- * with kfree. The caller is responsible for checking that
- * count/reclen is not ridiculously large.
+ * data length in each CCW is reclen.
  */
-static struct ccw1 *alloc_chan_prog(char *buf, size_t count, size_t reclen)
+static struct ccw1 *alloc_chan_prog(const char __user *ubuf, int rec_count,
+				    int reclen)
 {
-	size_t num_ccws;
 	struct ccw1 *cpa;
+	void *kbuf;
 	int i;
 
-	TRACE("alloc_chan_prog(%p, %zu, %zu)\n", buf, count, reclen);
+	TRACE("alloc_chan_prog(%p, %i, %i)\n", ubuf, rec_count, reclen);
 
 	/*
 	 * We chain a NOP onto the writes to force CE+DE together.
 	 * That means we allocate room for CCWs to cover count/reclen
 	 * records plus a NOP.
 	 */
-	num_ccws = count / reclen + 1;
-	cpa = kmalloc(num_ccws * sizeof(struct ccw1), GFP_KERNEL | GFP_DMA);
+	cpa = kzalloc((rec_count + 1) * sizeof(struct ccw1),
+		      GFP_KERNEL | GFP_DMA);
 	if (!cpa)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
-	for (i = 0; count; i++) {
+	for (i = 0; i < rec_count; i++) {
 		cpa[i].cmd_code = WRITE_CCW_CMD;
 		cpa[i].flags = CCW_FLAG_CC | CCW_FLAG_SLI;
 		cpa[i].count = reclen;
-		cpa[i].cda = __pa(buf);
-		buf += reclen;
-		count -= reclen;
+		kbuf = kmalloc(reclen, GFP_KERNEL | GFP_DMA);
+		if (!kbuf) {
+			free_chan_prog(cpa);
+			return ERR_PTR(-ENOMEM);
+		}
+		cpa[i].cda = (u32)(addr_t) kbuf;
+		if (copy_from_user(kbuf, ubuf, reclen)) {
+			free_chan_prog(cpa);
+			return ERR_PTR(-EFAULT);
+		}
+		ubuf += reclen;
 	}
 	/* The following NOP CCW forces CE+DE to be presented together */
 	cpa[i].cmd_code = CCW_CMD_NOOP;
-	cpa[i].flags = 0;
-	cpa[i].count = 0;
-	cpa[i].cda = 0;
-
 	return cpa;
 }
 
@@ -189,7 +202,7 @@ static int do_ur_io(struct urdev *urd, struct ccw1 *cpa)
 {
 	int rc;
 	struct ccw_device *cdev = urd->cdev;
-	DECLARE_COMPLETION(event);
+	DECLARE_COMPLETION_ONSTACK(event);
 
 	TRACE("do_ur_io: cpa=%p\n", cpa);
 
@@ -325,24 +338,11 @@ static ssize_t do_write(struct urdev *urd, const char __user *udata,
 			size_t count, size_t reclen, loff_t *ppos)
 {
 	struct ccw1 *cpa;
-	char *buf;
 	int rc;
 
-	/* Data buffer must be under 2GB line for fmt1 CCWs: hence GFP_DMA */
-	buf = kmalloc(count, GFP_KERNEL | GFP_DMA);
-	if (!buf)
-		return -ENOMEM;
-
-	if (copy_from_user(buf, udata, count)) {
-		rc = -EFAULT;
-		goto fail_kfree_buf;
-	}
-
-	cpa = alloc_chan_prog(buf, count, reclen);
-	if (!cpa) {
-		rc = -ENOMEM;
-		goto fail_kfree_buf;
-	}
+	cpa = alloc_chan_prog(udata, count / reclen, reclen);
+	if (IS_ERR(cpa))
+		return PTR_ERR(cpa);
 
 	rc = do_ur_io(urd, cpa);
 	if (rc)
@@ -354,10 +354,9 @@ static ssize_t do_write(struct urdev *urd, const char __user *udata,
 	}
 	*ppos += count;
 	rc = count;
+
 fail_kfree_cpa:
-	kfree(cpa);
-fail_kfree_buf:
-	kfree(buf);
+	free_chan_prog(cpa);
 	return rc;
 }
 
@@ -473,7 +472,7 @@ static ssize_t diag14_read(struct file *file, char __user *ubuf, size_t count,
 		return rc;
 
 	len = min((size_t) PAGE_SIZE, count);
-	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	buf = (char *) __get_free_page(GFP_KERNEL | GFP_DMA);
 	if (!buf)
 		return -ENOMEM;
 
@@ -500,7 +499,7 @@ static ssize_t diag14_read(struct file *file, char __user *ubuf, size_t count,
 	*offs += copied;
 	rc = copied;
 fail:
-	kfree(buf);
+	free_page((unsigned long) buf);
 	return rc;
 }
 
@@ -543,56 +542,97 @@ static int diag_read_next_file_info(struct file_control_block *buf, int spid)
 	}
 }
 
-static int verify_device(struct urdev *urd)
+static int verify_uri_device(struct urdev *urd)
 {
-	struct file_control_block fcb;
+	struct file_control_block *fcb;
 	char *buf;
 	int rc;
 
+	fcb = kmalloc(sizeof(*fcb), GFP_KERNEL | GFP_DMA);
+	if (!fcb)
+		return -ENOMEM;
+
+	/* check for empty reader device (beginning of chain) */
+	rc = diag_read_next_file_info(fcb, 0);
+	if (rc)
+		goto fail_free_fcb;
+
+	/* if file is in hold status, we do not read it */
+	if (fcb->file_stat & (FLG_SYSTEM_HOLD | FLG_USER_HOLD)) {
+		rc = -EPERM;
+		goto fail_free_fcb;
+	}
+
+	/* open file on virtual reader	*/
+	buf = (char *) __get_free_page(GFP_KERNEL | GFP_DMA);
+	if (!buf) {
+		rc = -ENOMEM;
+		goto fail_free_fcb;
+	}
+	rc = diag_read_file(urd->dev_id.devno, buf);
+	if ((rc != 0) && (rc != -ENODATA)) /* EOF does not hurt */
+		goto fail_free_buf;
+
+	/* check if the file on top of the queue is open now */
+	rc = diag_read_next_file_info(fcb, 0);
+	if (rc)
+		goto fail_free_buf;
+	if (!(fcb->file_stat & FLG_IN_USE)) {
+		rc = -EMFILE;
+		goto fail_free_buf;
+	}
+	rc = 0;
+
+fail_free_buf:
+	free_page((unsigned long) buf);
+fail_free_fcb:
+	kfree(fcb);
+	return rc;
+}
+
+static int verify_device(struct urdev *urd)
+{
 	switch (urd->class) {
 	case DEV_CLASS_UR_O:
 		return 0; /* no check needed here */
 	case DEV_CLASS_UR_I:
-		/* check for empty reader device (beginning of chain) */
-		rc = diag_read_next_file_info(&fcb, 0);
-		if (rc)
-			return rc;
-
-		/* open file on virtual reader	*/
-		buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-		if (!buf)
-			return -ENOMEM;
-		rc = diag_read_file(urd->dev_id.devno, buf);
-		kfree(buf);
-
-		if ((rc != 0) && (rc != -ENODATA)) /* EOF does not hurt */
-			return rc;
-		return 0;
+		return verify_uri_device(urd);
 	default:
 		return -ENOTSUPP;
 	}
 }
 
-static int get_file_reclen(struct urdev *urd)
+static int get_uri_file_reclen(struct urdev *urd)
 {
-	struct file_control_block fcb;
+	struct file_control_block *fcb;
 	int rc;
 
+	fcb = kmalloc(sizeof(*fcb), GFP_KERNEL | GFP_DMA);
+	if (!fcb)
+		return -ENOMEM;
+	rc = diag_read_next_file_info(fcb, 0);
+	if (rc)
+		goto fail_free;
+	if (fcb->file_stat & FLG_CP_DUMP)
+		rc = 0;
+	else
+		rc = fcb->rec_len;
+
+fail_free:
+	kfree(fcb);
+	return rc;
+}
+
+static int get_file_reclen(struct urdev *urd)
+{
 	switch (urd->class) {
 	case DEV_CLASS_UR_O:
 		return 0;
 	case DEV_CLASS_UR_I:
-		rc = diag_read_next_file_info(&fcb, 0);
-		if (rc)
-			return rc;
-		break;
+		return get_uri_file_reclen(urd);
 	default:
 		return -ENOTSUPP;
 	}
-	if (fcb.file_stat & FLG_CP_DUMP)
-		return 0;
-
-	return fcb.rec_len;
 }
 
 static int ur_open(struct inode *inode, struct file *file)
diff --git a/drivers/s390/char/vmur.h b/drivers/s390/char/vmur.h
index 16d0a4e..2b3c564 100644
--- a/drivers/s390/char/vmur.h
+++ b/drivers/s390/char/vmur.h
@@ -50,7 +50,10 @@ struct file_control_block {
 	char  rest[200];
 } __attribute__ ((packed));
 
-#define FLG_CP_DUMP 0x10
+#define FLG_SYSTEM_HOLD	0x04
+#define FLG_CP_DUMP	0x10
+#define FLG_USER_HOLD	0x20
+#define FLG_IN_USE	0x80
 
 /*
  * A struct urdev is created for each ur device that is made available
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 1c27a5a..5635e65 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -79,6 +79,7 @@ css_alloc_subchannel(struct subchannel_id schid)
 	sch->schib.pmcw.intparm = (__u32)(unsigned long)sch;
 	ret = cio_modify(sch);
 	if (ret) {
+		kfree(sch->lock);
 		kfree(sch);
 		return ERR_PTR(ret);
 	}
diff --git a/drivers/s390/cio/qdio.c b/drivers/s390/cio/qdio.c
index ed026a1..03347ae 100644
--- a/drivers/s390/cio/qdio.c
+++ b/drivers/s390/cio/qdio.c
@@ -81,6 +81,7 @@ static __u32 volatile spare_indicator;
 static atomic_t spare_indicator_usecount;
 #define QDIO_MEMPOOL_SCSSC_ELEMENTS 2
 static mempool_t *qdio_mempool_scssc;
+static struct kmem_cache *qdio_q_cache;
 
 static debug_info_t *qdio_dbf_setup;
 static debug_info_t *qdio_dbf_sbal;
@@ -1617,23 +1618,21 @@ static void
 qdio_release_irq_memory(struct qdio_irq *irq_ptr)
 {
 	int i;
+	struct qdio_q *q;
 
-	for (i=0;i<QDIO_MAX_QUEUES_PER_IRQ;i++) {
-		if (!irq_ptr->input_qs[i])
-			goto next;
-
-		kfree(irq_ptr->input_qs[i]->slib);
-		kfree(irq_ptr->input_qs[i]);
-
-next:
-		if (!irq_ptr->output_qs[i])
-			continue;
-
-		kfree(irq_ptr->output_qs[i]->slib);
-		kfree(irq_ptr->output_qs[i]);
-
+	for (i = 0; i < QDIO_MAX_QUEUES_PER_IRQ; i++) {
+		q = irq_ptr->input_qs[i];
+		if (q) {
+			free_page((unsigned long) q->slib);
+			kmem_cache_free(qdio_q_cache, q);
+		}
+		q = irq_ptr->output_qs[i];
+		if (q) {
+			free_page((unsigned long) q->slib);
+			kmem_cache_free(qdio_q_cache, q);
+		}
 	}
-	kfree(irq_ptr->qdr);
+	free_page((unsigned long) irq_ptr->qdr);
 	free_page((unsigned long) irq_ptr);
 }
 
@@ -1680,44 +1679,35 @@ qdio_alloc_qs(struct qdio_irq *irq_ptr,
 {
 	int i;
 	struct qdio_q *q;
-	int result=-ENOMEM;
-
-	for (i=0;i<no_input_qs;i++) {
-		q = kzalloc(sizeof(struct qdio_q), GFP_KERNEL);
 
-		if (!q) {
-			QDIO_PRINT_ERR("kmalloc of q failed!\n");
-			goto out;
-		}
+	for (i = 0; i < no_input_qs; i++) {
+		q = kmem_cache_alloc(qdio_q_cache, GFP_KERNEL);
+		if (!q)
+			return -ENOMEM;
+		memset(q, 0, sizeof(*q));
 
-		q->slib = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		q->slib = (struct slib *) __get_free_page(GFP_KERNEL);
 		if (!q->slib) {
-			QDIO_PRINT_ERR("kmalloc of slib failed!\n");
-			goto out;
+			kmem_cache_free(qdio_q_cache, q);
+			return -ENOMEM;
 		}
-
 		irq_ptr->input_qs[i]=q;
 	}
 
-	for (i=0;i<no_output_qs;i++) {
-		q = kzalloc(sizeof(struct qdio_q), GFP_KERNEL);
-
-		if (!q) {
-			goto out;
-		}
+	for (i = 0; i < no_output_qs; i++) {
+		q = kmem_cache_alloc(qdio_q_cache, GFP_KERNEL);
+		if (!q)
+			return -ENOMEM;
+		memset(q, 0, sizeof(*q));
 
-		q->slib=kmalloc(PAGE_SIZE,GFP_KERNEL);
+		q->slib = (struct slib *) __get_free_page(GFP_KERNEL);
 		if (!q->slib) {
-			QDIO_PRINT_ERR("kmalloc of slib failed!\n");
-			goto out;
+			kmem_cache_free(qdio_q_cache, q);
+			return -ENOMEM;
 		}
-
 		irq_ptr->output_qs[i]=q;
 	}
-
-	result=0;
-out:
-	return result;
+	return 0;
 }
 
 static void
@@ -2985,17 +2975,17 @@ qdio_allocate(struct qdio_initialize *init_data)
 	QDIO_DBF_HEX0(0,setup,&irq_ptr,sizeof(void*));
 
 	if (!irq_ptr) {
-		QDIO_PRINT_ERR("kmalloc of irq_ptr failed!\n");
+		QDIO_PRINT_ERR("allocation of irq_ptr failed!\n");
 		return -ENOMEM;
 	}
 
 	init_MUTEX(&irq_ptr->setting_up_sema);
 
 	/* QDR must be in DMA area since CCW data address is only 32 bit */
-	irq_ptr->qdr=kmalloc(sizeof(struct qdr), GFP_KERNEL | GFP_DMA);
+	irq_ptr->qdr = (struct qdr *) __get_free_page(GFP_KERNEL | GFP_DMA);
   	if (!(irq_ptr->qdr)) {
    		free_page((unsigned long) irq_ptr);
-    		QDIO_PRINT_ERR("kmalloc of irq_ptr->qdr failed!\n");
+		QDIO_PRINT_ERR("allocation of irq_ptr->qdr failed!\n");
 		return -ENOMEM;
        	}
 	QDIO_DBF_TEXT0(0,setup,"qdr:");
@@ -3004,6 +2994,7 @@ qdio_allocate(struct qdio_initialize *init_data)
 	if (qdio_alloc_qs(irq_ptr,
        			  init_data->no_input_qs,
 			  init_data->no_output_qs)) {
+		QDIO_PRINT_ERR("queue allocation failed!\n");
 		qdio_release_irq_memory(irq_ptr);
 		return -ENOMEM;
 	}
@@ -3895,9 +3886,19 @@ init_QDIO(void)
 	if (res)
 		return res;
 
+	qdio_q_cache = kmem_cache_create("qdio_q", sizeof(struct qdio_q),
+					 256, 0, NULL);
+	if (!qdio_q_cache) {
+		qdio_release_qdio_memory();
+		return -ENOMEM;
+	}
+
 	res = qdio_register_dbf_views();
-	if (res)
+	if (res) {
+		kmem_cache_destroy(qdio_q_cache);
+		qdio_release_qdio_memory();
 		return res;
+	}
 
 	QDIO_DBF_TEXT0(0,setup,"initQDIO");
 	res = bus_create_file(&ccw_bus_type, &bus_attr_qdio_performance_stats);
@@ -3929,6 +3930,7 @@ cleanup_QDIO(void)
 	qdio_release_qdio_memory();
 	qdio_unregister_dbf_views();
 	mempool_destroy(qdio_mempool_scssc);
+	kmem_cache_destroy(qdio_q_cache);
 	bus_remove_file(&ccw_bus_type, &bus_attr_qdio_performance_stats);
   	printk("qdio: %s: module removed\n",version);
 }


