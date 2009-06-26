Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZFZDSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZFZDSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 23:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZFZDSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 23:18:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:36683 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbZFZDSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 23:18:24 -0400
Subject: Re: [PATCH] IDE: ide-taskfile.c fix compilation warning and cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200906221250.36318.bzolnier@gmail.com>
References: <1245650973.30547.3.camel@ht.satnam>
	 <200906221250.36318.bzolnier@gmail.com>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 08:48:10 +0530
Message-Id: <1245986290.3568.1.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 12:50 +0200, Bartlomiej Zolnierkiewicz wrote:
> On Monday 22 June 2009 08:09:33 Jaswinder Singh Rajput wrote:
> 
> > @@ -248,8 +250,9 @@ void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
> >  		page = nth_page(page, (offset >> PAGE_SHIFT));
> >  		offset %= PAGE_SIZE;
> >  
> > -		if (PageHighMem(page))
> > -			local_irq_save(flags);
> > +#ifdef CONFIG_HIGHMEM
> > +		local_irq_save(flags);
> > +#endif
> >  
> >  		buf = kmap_atomic(page, KM_BIO_SRC_IRQ) + offset;
> >  
> > @@ -269,8 +272,9 @@ void ide_pio_bytes(ide_drive_t *drive, struct ide_cmd *cmd,
> >  
> >  		kunmap_atomic(buf, KM_BIO_SRC_IRQ);
> >  
> > -		if (PageHighMem(page))
> > -			local_irq_restore(flags);
> > +#ifdef CONFIG_HIGHMEM
> > +		local_irq_restore(flags);
> > +#endif
> 
> This part is incorrect (adds a performance regression for low-mem pages
> w/ HIGHMEM=y) and seems to be accidental (nothing about it in the patch
> description).
> 
> Besides I would suggest splitting the patch on fix and cleanup parts.

Here is the cleanup part:

[PATCH] IDE: ide-taskfile.c fix style problems

Fix trivial style problems:

WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
WARNING: space prohibited between function name and open parenthesis '('
WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
ERROR: do not use C99 // comments X 2
ERROR: trailing statements should be on next line
ERROR: trailing whitespace
ERROR: switch and case should be at the same indent
WARNING: line over 80 characters

total: 5 errors, 4 warnings

Also removed dead code

Also used pr_err() to avoid line breaks

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/ide/ide-taskfile.c |  109 ++++++++++++++++++++-----------------------
 1 files changed, 51 insertions(+), 58 deletions(-)

diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 75b85a8..ed512a8 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -19,8 +19,8 @@
 #include <linux/hdreg.h>
 #include <linux/ide.h>
 #include <linux/scatterlist.h>
+#include <linux/uaccess.h>
 
-#include <asm/uaccess.h>
 #include <asm/io.h>
 
 void ide_tf_readback(ide_drive_t *drive, struct ide_cmd *cmd)
@@ -53,7 +53,7 @@ void ide_tf_dump(const char *s, struct ide_cmd *cmd)
 #endif
 }
 
-int taskfile_lib_get_identify (ide_drive_t *drive, u8 *buf)
+int taskfile_lib_get_identify(ide_drive_t *drive, u8 *buf)
 {
 	struct ide_cmd cmd;
 
@@ -86,7 +86,7 @@ ide_startstop_t do_rw_taskfile(ide_drive_t *drive, struct ide_cmd *orig_cmd)
 	if (orig_cmd->protocol == ATA_PROT_PIO &&
 	    (orig_cmd->tf_flags & IDE_TFLAG_MULTI_PIO) &&
 	    drive->mult_count == 0) {
-		printk(KERN_ERR "%s: multimode not set!\n", drive->name);
+		pr_err("%s: multimode not set!\n", drive->name);
 		return ide_stopped;
 	}
 
@@ -214,7 +214,7 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
 	}
 
 	if (stat & ATA_BUSY)
-		printk(KERN_ERR "%s: drive still BUSY!\n", drive->name);
+		pr_err("%s: drive still BUSY!\n", drive->name);
 
 	return stat;
 }
@@ -398,8 +398,7 @@ static ide_startstop_t pre_task_out_intr(ide_drive_t *drive,
 
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ,
 			  drive->bad_wstat, WAIT_DRQ)) {
-		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
-			drive->name,
+		pr_err("%s: no DRQ after issuing %sWRITE%s\n", drive->name,
 			(cmd->tf_flags & IDE_TFLAG_MULTI_PIO) ? "MULT" : "",
 			(drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
 		return startstop;
@@ -449,7 +448,6 @@ put_req:
 	blk_put_request(rq);
 	return error;
 }
-
 EXPORT_SYMBOL(ide_raw_taskfile);
 
 int ide_no_data_taskfile(ide_drive_t *drive, struct ide_cmd *cmd)
@@ -475,10 +473,9 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 	u16 nsect		= 0;
 	char __user *buf = (char __user *)arg;
 
-//	printk("IDE Taskfile ...\n");
-
 	req_task = kzalloc(tasksize, GFP_KERNEL);
-	if (req_task == NULL) return -ENOMEM;
+	if (req_task == NULL)
+		return -ENOMEM;
 	if (copy_from_user(req_task, buf, tasksize)) {
 		kfree(req_task);
 		return -EFAULT;
@@ -486,7 +483,7 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 
 	taskout = req_task->out_size;
 	taskin  = req_task->in_size;
-	
+
 	if (taskin > 65536 || taskout > 65536) {
 		err = -EINVAL;
 		goto abort;
@@ -576,51 +573,49 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 	cmd.protocol = ATA_PROT_DMA;
 
 	switch (req_task->data_phase) {
-		case TASKFILE_MULTI_OUT:
-			if (!drive->mult_count) {
-				/* (hs): give up if multcount is not set */
-				printk(KERN_ERR "%s: %s Multimode Write " \
-					"multcount is not set\n",
-					drive->name, __func__);
-				err = -EPERM;
-				goto abort;
-			}
-			cmd.tf_flags |= IDE_TFLAG_MULTI_PIO;
-			/* fall through */
-		case TASKFILE_OUT:
-			cmd.protocol = ATA_PROT_PIO;
-			/* fall through */
-		case TASKFILE_OUT_DMAQ:
-		case TASKFILE_OUT_DMA:
-			cmd.tf_flags |= IDE_TFLAG_WRITE;
-			nsect = taskout / SECTOR_SIZE;
-			data_buf = outbuf;
-			break;
-		case TASKFILE_MULTI_IN:
-			if (!drive->mult_count) {
-				/* (hs): give up if multcount is not set */
-				printk(KERN_ERR "%s: %s Multimode Read failure " \
-					"multcount is not set\n",
-					drive->name, __func__);
-				err = -EPERM;
-				goto abort;
-			}
-			cmd.tf_flags |= IDE_TFLAG_MULTI_PIO;
-			/* fall through */
-		case TASKFILE_IN:
-			cmd.protocol = ATA_PROT_PIO;
-			/* fall through */
-		case TASKFILE_IN_DMAQ:
-		case TASKFILE_IN_DMA:
-			nsect = taskin / SECTOR_SIZE;
-			data_buf = inbuf;
-			break;
-		case TASKFILE_NO_DATA:
-			cmd.protocol = ATA_PROT_NODATA;
-			break;
-		default:
-			err = -EFAULT;
+	case TASKFILE_MULTI_OUT:
+		if (!drive->mult_count) {
+			/* (hs): give up if multcount is not set */
+			pr_err("%s: %s Multimode Write multcount is not set\n",
+				drive->name, __func__);
+			err = -EPERM;
+			goto abort;
+		}
+		cmd.tf_flags |= IDE_TFLAG_MULTI_PIO;
+		/* fall through */
+	case TASKFILE_OUT:
+		cmd.protocol = ATA_PROT_PIO;
+		/* fall through */
+	case TASKFILE_OUT_DMAQ:
+	case TASKFILE_OUT_DMA:
+		cmd.tf_flags |= IDE_TFLAG_WRITE;
+		nsect = taskout / SECTOR_SIZE;
+		data_buf = outbuf;
+		break;
+	case TASKFILE_MULTI_IN:
+		if (!drive->mult_count) {
+			/* (hs): give up if multcount is not set */
+			pr_err("%s: %s Multimode Read multcount is not set\n",
+				drive->name, __func__);
+			err = -EPERM;
 			goto abort;
+		}
+		cmd.tf_flags |= IDE_TFLAG_MULTI_PIO;
+		/* fall through */
+	case TASKFILE_IN:
+		cmd.protocol = ATA_PROT_PIO;
+		/* fall through */
+	case TASKFILE_IN_DMAQ:
+	case TASKFILE_IN_DMA:
+		nsect = taskin / SECTOR_SIZE;
+		data_buf = inbuf;
+		break;
+	case TASKFILE_NO_DATA:
+		cmd.protocol = ATA_PROT_NODATA;
+		break;
+	default:
+		err = -EFAULT;
+		goto abort;
 	}
 
 	if (req_task->req_cmd == IDE_DRIVE_TASK_NO_DATA)
@@ -629,7 +624,7 @@ int ide_taskfile_ioctl(ide_drive_t *drive, unsigned long arg)
 		nsect = (cmd.hob.nsect << 8) | cmd.tf.nsect;
 
 		if (!nsect) {
-			printk(KERN_ERR "%s: in/out command without data\n",
+			pr_err("%s: in/out command without data\n",
 					drive->name);
 			err = -EFAULT;
 			goto abort;
@@ -671,8 +666,6 @@ abort:
 	kfree(outbuf);
 	kfree(inbuf);
 
-//	printk("IDE Taskfile ioctl ended. rc = %i\n", err);
-
 	return err;
 }
 #endif
-- 
1.6.0.6



