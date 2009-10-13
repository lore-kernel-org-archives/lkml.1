Return-Path: <linux-kernel-owner+w=401wt.eu-S1759914AbZJMNYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914AbZJMNYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759878AbZJMNYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:24:36 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:35580 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759867AbZJMNYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:24:35 -0400
Date: Tue, 13 Oct 2009 15:22:46 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH/RFC v5 5/5]: mtdoops: refactor as a dump_device
Message-ID: <20091013152246.37903d23@marrow.netinsight.se>
In-Reply-To: <20091013151751.59e217a7@marrow.netinsight.se>
References: <20091012113758.GB11035@elte.hu>
	<20091012140149.6789efab@marrow.netinsight.se>
	<20091012120951.GA16799@elte.hu>
	<1255349748.10605.13.camel@macbook.infradead.org>
	<20091012122023.GA19365@elte.hu>
	<20091012150650.51a4b4dc@marrow.netinsight.se>
	<20091012131528.GC25464@elte.hu>
	<20091012153937.0dcd73e5@marrow.netinsight.se>
	<alpine.LFD.2.01.0910120828390.3438@localhost.localdomain>
	<20091012110954.67d7d8d8.akpm@linux-foundation.org>
	<20091012182346.GH17138@elte.hu>
	<alpine.LFD.2.01.0910121130190.3438@localhost.localdomain>
	<20091013151751.59e217a7@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last messages which happens before a crash might contain interesting
information about the crash. This patch reworks mtdoops using the
dump_device support instead of a console, which simplifies the code and
includes also messages before the oops started.

It registers handlers for both oopses and panics. On oopses, the write
is scheduled in a work queue (to be able to use the regular mtd->write
call), while panics call mtd->panic_write directly. Thus, if
panic_on_oops is set, the oops will be written out during the panic.

A parameter to specify which mtd device to use (number or name), as well
as a flag to toggle wheter to dump oopses or only panics (since oopses
can often be handled by regular syslog).

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
---
 drivers/mtd/mtdoops.c |  218 +++++++++++++++++++++----------------------------
 1 files changed, 92 insertions(+), 126 deletions(-)

diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
index c2a3b5c..920ce4f 100644
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -29,10 +29,10 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/delay.h>
-#include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/mtd/mtd.h>
 #include <linux/log2.h>
+#include <linux/dump_device.h>
 
 #define MTDOOPS_KERNMSG_MAGIC 0x5d005d00
 
@@ -41,7 +41,19 @@ module_param(record_size, ulong, 0);
 MODULE_PARM_DESC(record_size,
 		"record size for MTD OOPS pages in bytes (default 4096)");
 
+static char mtddev[80];
+module_param_string(mtddev, mtddev, 80, 0600);
+MODULE_PARM_DESC(mtddev,
+		"name or index number of the MTD device to use");
+
+static int dump_oops = 1;
+module_param(dump_oops, int, 0);
+MODULE_PARM_DESC(dump_oops,
+		"set to 1 to dump oopses, 0 to only dump panics (default 1)");
+
 static struct mtdoops_context {
+	struct dump_device dump;
+
 	int mtd_index;
 	struct work_struct work_erase;
 	struct work_struct work_write;
@@ -50,14 +62,9 @@ static struct mtdoops_context {
 	int nextpage;
 	int nextcount;
 	u32 *oops_page_used;
-	char *name;
+	const char *name;
 
 	void *oops_buf;
-
-	/* writecount and disabling ready are spin lock protected */
-	spinlock_t writecount_lock;
-	int ready;
-	int writecount;
 } oops_cxt;
 
 static void mark_page_used(struct mtdoops_context *cxt, int page)
@@ -148,7 +155,6 @@ static void mtdoops_inc_counter(struct mtdoops_context *cxt)
 
 	printk(KERN_DEBUG "mtdoops: ready %d, %d (no erase)\n",
 	       cxt->nextpage, cxt->nextcount);
-	cxt->ready = 1;
 }
 
 /* Scheduled work - when we can't proceed without erasing a block */
@@ -197,7 +203,6 @@ badblock:
 	if (ret >= 0) {
 		printk(KERN_DEBUG "mtdoops: ready %d, %d\n",
 		       cxt->nextpage, cxt->nextcount);
-		cxt->ready = 1;
 		return;
 	}
 
@@ -215,11 +220,13 @@ static void mtdoops_write(struct mtdoops_context *cxt, int panic)
 {
 	struct mtd_info *mtd = cxt->mtd;
 	size_t retlen;
+	u32 *stamp;
 	int ret;
 
-	if (cxt->writecount < record_size)
-		memset(cxt->oops_buf + cxt->writecount, 0xff,
-					record_size - cxt->writecount);
+	/* Add mtdoops header to the buffer */
+	stamp = cxt->oops_buf;
+	*stamp++ = cxt->nextcount;
+	*stamp = MTDOOPS_KERNMSG_MAGIC;
 
 	if (panic)
 		ret = mtd->panic_write(mtd, cxt->nextpage * record_size,
@@ -228,8 +235,6 @@ static void mtdoops_write(struct mtdoops_context *cxt, int panic)
 		ret = mtd->write(mtd, cxt->nextpage * record_size,
 					record_size, &retlen, cxt->oops_buf);
 
-	cxt->writecount = 0;
-
 	if (retlen != record_size || ret < 0)
 		printk(KERN_ERR "mtdoops: write failure at %ld (%td of %ld written), error %d\n",
 		       cxt->nextpage * record_size, retlen, record_size, ret);
@@ -238,7 +243,6 @@ static void mtdoops_write(struct mtdoops_context *cxt, int panic)
 	mtdoops_inc_counter(cxt);
 }
 
-
 static void mtdoops_workfunc_write(struct work_struct *work)
 {
 	struct mtdoops_context *cxt =
@@ -294,11 +298,9 @@ static void find_next_position(struct mtdoops_context *cxt)
 		if (unclean_pages != 0) {
 			printk(KERN_INFO "mtdoops: cleaning area\n");
 			schedule_work(&cxt->work_erase);
-		} else {
+		} else
 			printk(KERN_DEBUG "mtdoops: ready %d, %d (clean)\n",
 			       cxt->nextpage, cxt->nextcount);
-			cxt->ready = 1;
-		}
 		return;
 	}
 
@@ -308,13 +310,55 @@ static void find_next_position(struct mtdoops_context *cxt)
 	mtdoops_inc_counter(cxt);
 }
 
+static void mtdoops_copy_buffer(struct mtdoops_context *cxt,
+		const char *s1, unsigned long l1,
+		const char *s2, unsigned long l2)
+{
+	unsigned long l1_cpy = min(l1, record_size - 8);
+	unsigned long l2_cpy = min(l2 - l1_cpy, record_size - l1_cpy - 8);
+	char *dst = cxt->oops_buf + 8;	/* Skip the header */
+
+	memcpy(dst, s1, l1_cpy);
+	memcpy(dst + l1_cpy, s2, l2_cpy);
+}
+
+static void mtdoops_oops(struct dump_device *dump,
+		const char *s1, unsigned long l1,
+		const char *s2, unsigned long l2)
+{
+	struct mtdoops_context *cxt = dump->priv;
+
+	mtdoops_copy_buffer(cxt, s1, l1, s2, l2);
+
+	/* Write when done */
+	schedule_work(&cxt->work_write);
+}
+
+static void mtdoops_panic(struct dump_device *dump,
+		const char *s1, unsigned long l1,
+		const char *s2, unsigned long l2)
+{
+	struct mtdoops_context *cxt = dump->priv;
+
+	mtdoops_copy_buffer(cxt, s1, l1, s2, l2);
+	/* Must be written immediately */
+	if (cxt->mtd->panic_write)
+		mtdoops_write(cxt, 1);
+	else
+		printk(KERN_ERR "mtdoops: Cannot write from panic without panic_write\n");
+}
+
+static int mtdoops_setup(struct dump_device *dump)
+{
+	return 0;
+}
 
 static void mtdoops_notify_add(struct mtd_info *mtd)
 {
 	struct mtdoops_context *cxt = &oops_cxt;
-	u64 mtdoops_pages = mtd->size;
+	u64 mtdoops_records = mtd->size;
 
-	do_div(mtdoops_pages, record_size);
+	do_div(mtdoops_records, record_size);
 
 	if (cxt->name && !strcmp(mtd->name, cxt->name))
 		cxt->mtd_index = mtd->index;
@@ -335,7 +379,7 @@ static void mtdoops_notify_add(struct mtd_info *mtd)
 	}
 
 	/* oops_page_used is a bit field */
-	cxt->oops_page_used = vmalloc(DIV_ROUND_UP(mtdoops_pages,
+	cxt->oops_page_used = vmalloc(DIV_ROUND_UP(mtdoops_records,
 			8 * sizeof(u32)));
 	if (!cxt->oops_page_used) {
 		printk(KERN_ERR "Could not allocate page array\n");
@@ -349,6 +393,11 @@ static void mtdoops_notify_add(struct mtd_info *mtd)
 
 	find_next_position(cxt);
 
+	cxt->dump.setup = mtdoops_setup;
+	if (dump_oops)
+		cxt->dump.oops = mtdoops_oops;
+	cxt->dump.panic = mtdoops_panic;
+	register_dumpdevice(&cxt->dump, cxt);
 	printk(KERN_INFO "mtdoops: Attached to MTD device %d\n", mtd->index);
 }
 
@@ -359,116 +408,27 @@ static void mtdoops_notify_remove(struct mtd_info *mtd)
 	if (mtd->index != cxt->mtd_index || cxt->mtd_index < 0)
 		return;
 
+	unregister_dumpdevice(&cxt->dump);
 	cxt->mtd = NULL;
 	flush_scheduled_work();
 }
 
-static void mtdoops_console_sync(void)
-{
-	struct mtdoops_context *cxt = &oops_cxt;
-	struct mtd_info *mtd = cxt->mtd;
-	unsigned long flags;
-
-	if (!cxt->ready || !mtd || cxt->writecount == 0)
-		return;
-
-	/*
-	 *  Once ready is 0 and we've held the lock no further writes to the
-	 *  buffer will happen
-	 */
-	spin_lock_irqsave(&cxt->writecount_lock, flags);
-	if (!cxt->ready) {
-		spin_unlock_irqrestore(&cxt->writecount_lock, flags);
-		return;
-	}
-	cxt->ready = 0;
-	spin_unlock_irqrestore(&cxt->writecount_lock, flags);
-
-	if (mtd->panic_write && (in_interrupt() || panic_on_oops))
-		/* Interrupt context, we're going to panic so try and log */
-		mtdoops_write(cxt, 1);
-	else
-		schedule_work(&cxt->work_write);
-}
-
-static void
-mtdoops_console_write(struct console *co, const char *s, unsigned int count)
-{
-	struct mtdoops_context *cxt = co->data;
-	struct mtd_info *mtd = cxt->mtd;
-	unsigned long flags;
-
-	if (!oops_in_progress) {
-		mtdoops_console_sync();
-		return;
-	}
-
-	if (!cxt->ready || !mtd)
-		return;
-
-	/* Locking on writecount ensures sequential writes to the buffer */
-	spin_lock_irqsave(&cxt->writecount_lock, flags);
-
-	/* Check ready status didn't change whilst waiting for the lock */
-	if (!cxt->ready) {
-		spin_unlock_irqrestore(&cxt->writecount_lock, flags);
-		return;
-	}
-
-	if (cxt->writecount == 0) {
-		u32 *stamp = cxt->oops_buf;
-		*stamp++ = cxt->nextcount;
-		*stamp = MTDOOPS_KERNMSG_MAGIC;
-		cxt->writecount = 8;
-	}
-
-	if (count + cxt->writecount > record_size)
-		count = record_size - cxt->writecount;
-
-	memcpy(cxt->oops_buf + cxt->writecount, s, count);
-	cxt->writecount += count;
-
-	spin_unlock_irqrestore(&cxt->writecount_lock, flags);
-
-	if (cxt->writecount == record_size)
-		mtdoops_console_sync();
-}
-
-static int __init mtdoops_console_setup(struct console *co, char *options)
-{
-	struct mtdoops_context *cxt = co->data;
-
-	if (cxt->mtd_index != -1 || cxt->name)
-		return -EBUSY;
-	if (options) {
-		cxt->name = kstrdup(options, GFP_KERNEL);
-		return 0;
-	}
-	if (co->index == -1)
-		return -EINVAL;
-
-	cxt->mtd_index = co->index;
-	return 0;
-}
 
 static struct mtd_notifier mtdoops_notifier = {
 	.add	= mtdoops_notify_add,
 	.remove	= mtdoops_notify_remove,
 };
 
-static struct console mtdoops_console = {
-	.name		= "ttyMTD",
-	.write		= mtdoops_console_write,
-	.setup		= mtdoops_console_setup,
-	.unblank	= mtdoops_console_sync,
-	.index		= -1,
-	.data		= &oops_cxt,
-};
-
-static int __init mtdoops_console_init(void)
+static int __init mtdoops_init(void)
 {
 	struct mtdoops_context *cxt = &oops_cxt;
+	int mtd_index;
+	char *endp;
 
+	if (strlen(mtddev) == 0) {
+		printk(KERN_ERR "mtdoops: mtd device must be supplied\n");
+		return -EINVAL;
+	}
 	if (!is_power_of_2(record_size)) {
 		printk(KERN_ERR "mtdoops: record_size must be a power of two\n");
 		return -EINVAL;
@@ -477,37 +437,43 @@ static int __init mtdoops_console_init(void)
 		printk(KERN_ERR "mtdoops: record_size must be over 4096 bytes\n");
 		return -EINVAL;
 	}
+
+	/* Setup the MTD device to use */
+	cxt->name = mtddev;
 	cxt->mtd_index = -1;
+	mtd_index = simple_strtoul(mtddev, &endp, 0);
+	if (endp != mtddev)
+		cxt->mtd_index = mtd_index;
+
 	cxt->oops_buf = vmalloc(record_size);
 	if (!cxt->oops_buf) {
-		printk(KERN_ERR "mtdoops: failed to allocate buffer workspace\n");
+		printk(KERN_ERR "Failed to allocate mtdoops write buffer workspace\n");
+		vfree(cxt->oops_buf);
 		return -ENOMEM;
 	}
+	memset(cxt->oops_buf, 0xff, record_size);
 
-	spin_lock_init(&cxt->writecount_lock);
 	INIT_WORK(&cxt->work_erase, mtdoops_workfunc_erase);
 	INIT_WORK(&cxt->work_write, mtdoops_workfunc_write);
 
-	register_console(&mtdoops_console);
 	register_mtd_user(&mtdoops_notifier);
 	return 0;
 }
 
-static void __exit mtdoops_console_exit(void)
+static void __exit mtdoops_exit(void)
 {
 	struct mtdoops_context *cxt = &oops_cxt;
 
 	unregister_mtd_user(&mtdoops_notifier);
-	unregister_console(&mtdoops_console);
 	kfree(cxt->name);
-	vfree(cxt->oops_buf);
 	if (cxt->oops_page_used)
 		vfree(cxt->oops_page_used);
+	vfree(cxt->oops_buf);
 }
 
 
-subsys_initcall(mtdoops_console_init);
-module_exit(mtdoops_console_exit);
+module_init(mtdoops_init);
+module_exit(mtdoops_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Richard Purdie <rpurdie@openedhand.com>");
-- 
1.6.0.4

