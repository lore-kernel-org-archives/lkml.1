Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYJCMEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYJCMEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 08:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYJCME0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 08:04:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:36084 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbYJCMEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 08:04:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=mms0tgVnBNBA4gN7oQgx+EM6H5GCawLkxYh2xFS3Q4eN5EumzqJYSwSSQqt00hqKkk
         R+emvZ7/efCMHwCkdjfyuXT68T1ucfu1I1mz016AX80QFLykBRIhXg1YLAnEnQ4pmz/r
         uh8D6wKzfhrioBKSaPUWCKBaRK+6AOEsNqwpg=
Date: Fri, 3 Oct 2008 08:03:05 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [RFC/PATCH] Block device for the ISS simulator
Message-ID: <20081003120305.GA2229@yoda.jdub.homelinux.org>
References: <20081003000904.0A812DDEEE@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081003000904.0A812DDEEE@ozlabs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 10:08:42AM +1000, Benjamin Herrenschmidt wrote:
>+static void iss_blk_setup(struct iss_blk *ib)
>+{
>+	unsigned long flags;
>+	u32 stat;
>+
>+	pr_debug("iss_blk_setup %d\n", ib->devno);
>+
>+	spin_lock_irqsave(&iss_blk_reglock, flags);
>+	out_8(iss_blk_regs->data, 0);
>+	out_be32(&iss_blk_regs->devno, ib->devno);
>+	out_8(&iss_blk_regs->cmd, ISS_BD_CMD_OPEN);
>+	stat = in_be32(&iss_blk_regs->stat);

Should probably use the ioread/iowrite functions instead of raw out/in.
Same comment throughout.

<snip>

>+static void iss_blk_do_request(struct request_queue * q)
>+{
>+	struct iss_blk *ib = q->queuedata;
>+	struct request *req;
>+	int rc = 0;
>+
>+	pr_debug("iss_do_request dev %d\n", ib->devno);
>+
>+	while ((req = elv_next_request(q)) != NULL) {
>+		pr_debug(" -> req @ %p, changed: %d\n", req, ib->changed);
>+		if (ib->changed) {
>+			end_request(req, 0);	/* failure */
>+			continue;
>+		}
>+		switch (rq_data_dir(req)) {
>+		case READ:
>+			rc = __iss_blk_read(ib, req->buffer, req->sector,
>+					    req->current_nr_sectors);
>+			break;
>+		case WRITE:
>+			rc = __iss_blk_write(ib, req->buffer, req->sector,
>+					     req->current_nr_sectors);
>+		};
>+
>+		pr_debug(" -> ending request, rc = %d\n", rc);
>+		if (rc)
>+			end_request(req, 0);	/* failure */
>+		else
>+			end_request(req, 1);	/* success */

Could possibly just do:

end_request(req, (!rc));

<snip>

>+static int __init iss_blk_init(void)
>+{
>+	struct device_node *np;
>+	int i;
>+
>+	pr_debug("iss_regs offsets:\n");
>+	pr_debug("  cmd    : 0x%x\n", offsetof(struct iss_blk_regs, cmd));
>+	pr_debug("  stat   : 0x%x\n", offsetof(struct iss_blk_regs, stat));
>+	pr_debug("  sector : 0x%x\n", offsetof(struct iss_blk_regs, sector));
>+	pr_debug("  count  : 0x%x\n", offsetof(struct iss_blk_regs, count));
>+	pr_debug("  devno  : 0x%x\n", offsetof(struct iss_blk_regs, devno));
>+	pr_debug("  size   : 0x%x\n", offsetof(struct iss_blk_regs, size));
>+	pr_debug("  data   : 0x%x\n", offsetof(struct iss_blk_regs, data));
>+
>+	np = of_find_node_by_path("/iss-block");
>+	if (np == NULL)
>+		return -ENODEV;
>+	iss_blk_regs = of_iomap(np, 0);

of_find_node_by_path increments the refcount for that node.  Need to
do an of_node_put when you are done.

>+	if (iss_blk_regs == NULL) {
>+		pr_err("issblk: Failed to map registers\n");
>+		return -ENOMEM;
>+	}
>+
>+	if (register_blkdev(MAJOR_NR, "iss_blk"))
>+		return -EIO;
>+
>+	spin_lock_init(&iss_blk_qlock);
>+	spin_lock_init(&iss_blk_reglock);
>+
>+	printk(KERN_INFO "ISS Block driver initializing for %d minors\n",
>+	       NUM_ISS_BLK_MINOR);
>+
>+	for (i = 0; i < NUM_ISS_BLK_MINOR; i++) {
>+		struct gendisk *disk = alloc_disk(1);
>+		struct request_queue *q;
>+		struct iss_blk *ib = &iss_blks[i];
>+
>+		if (!disk) {
>+			pr_err("issblk%d: Failed to allocate disk\n", i);
>+			break;
>+		}
>+
>+		q = blk_init_queue(iss_blk_do_request, &iss_blk_qlock);
>+		if (q == NULL) {
>+			pr_err("issblk%d: Failed to init queue\n", i);
>+			put_disk(disk);
>+			break;
>+		}
>+		q->queuedata = ib;
>+
>+		ib->disk = disk;
>+		ib->devno = i;
>+		ib->present = 0;
>+		ib->changed = 0;
>+		ib->capacity = 0;
>+		ib->sectsize = 512;
>+
>+		disk->major = MAJOR_NR;
>+		disk->first_minor = i;
>+		disk->fops = &iss_blk_fops;
>+		disk->private_data = &iss_blks[i];
>+		disk->flags = GENHD_FL_REMOVABLE;
>+		disk->queue = q;
>+		sprintf(disk->disk_name, "issblk%d", i);
>+
>+		iss_blk_setup(ib);
>+
>+		add_disk(disk);
>+	}
>+
>+	return 0;
>+}
>+
>+static void __exit iss_blk_exit(void)
>+{
>+	int i;
>+
>+	unregister_blkdev(MAJOR_NR, "iss_blk");
>+
>+	for (i = 0; i < NUM_ISS_BLK_MINOR; i++) {
>+		struct iss_blk *ib = &iss_blks[i];
>+
>+		if (ib->present) {
>+			out_be32(&iss_blk_regs->devno, ib->devno);
>+			out_8(&iss_blk_regs->cmd, ISS_BD_CMD_CLOSE);
>+		}
>+	}

Shouldn't you unmap iss_blk_regs at this point?

<snip>

>Index: linux-work/drivers/block/Kconfig
>===================================================================
>--- linux-work.orig/drivers/block/Kconfig	2008-07-17 14:43:58.000000000 +1000
>+++ linux-work/drivers/block/Kconfig	2008-09-23 11:12:03.000000000 +1000
>@@ -357,6 +357,10 @@ config BLK_DEV_XIP
> 	  will prevent RAM block device backing store memory from being
> 	  allocated from highmem (only a problem for highmem systems).
> 
>+config BLK_DEV_ISS
>+       bool "Support ISS Simulator Block Device"
>+       default n
>+

Should probably have:

	depends on PPC



josh
