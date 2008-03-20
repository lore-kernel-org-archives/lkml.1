Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbYCTVKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbYCTVKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 17:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbYCTVKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 17:10:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39196 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756225AbYCTVKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 17:10:30 -0400
Date: Thu, 20 Mar 2008 14:10:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: dwmw2@infradead.org, greg@kroah.com, lethal@linux-sh.org,
       linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       linux-mtd@vger.kernel.org
Subject: Re: [PATCH] 2/2 mtd: Add support for the Dreamcast VMU flash
Message-Id: <20080320141018.34127f0d.akpm@linux-foundation.org>
In-Reply-To: <1205880982.6250.32.camel@localhost.localdomain>
References: <1205879413.6250.13.camel@localhost.localdomain>
	<1205880554.6250.25.camel@localhost.localdomain>
	<1205880982.6250.32.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 22:56:22 +0000
Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:

> This builds on (though I essentially rewrote most of it) a driver Paul
> Mundt and I wrote way back when to support the memory component of the
> SEGA Dreamcast's Visual Memory Unit.
> 
> The device is accessed via the Dreamcast's maple bus.
> 
> ...
>
> +static struct vmu_block *ofs_to_block(unsigned long src_ofs,
> +	struct mtd_info *mtd, int partition)
> +{
> +	struct vmu_block *vblock;
> +	struct maple_device *mdev;
> +	struct memcard *card;
> +	struct mdev_part *mpart;
> +
> +	mpart = mtd->priv;
> +	mdev = mpart->mdev;
> +	card = mdev->private_data;
> +	vblock = kmalloc(sizeof(struct vmu_block), GFP_KERNEL);
> +	if (!vblock)
> +		goto simple_failed;
> +
> +	if (src_ofs >= ((card->parts)[partition]).numblocks * card->blocklen)
> +		goto failed;

Do this check before the kmalloc().

> +	vblock->num = src_ofs / card->blocklen;
> +
> +	if (vblock->num > ((card->parts)[partition]).numblocks)
> +		goto failed;
> +
> +	vblock->ofs = src_ofs % card->blocklen;
> +	return vblock;
> +
> +failed:
> +	kfree(vblock);
> +simple_failed:
> +	return NULL;
> +}
> +
> +
> +/* Maple bus callback function for reads */
> +static void vmu_blockread(struct mapleq *mq)
> +{
> +	struct maple_device *mdev;
> +	struct memcard *card;
> +	struct mtd_info *mtd;
> +	struct vmu_cache *pcache;
> +	struct mdev_part *mpart;
> +	int partition;
> +
> +	mdev = mq->dev;
> +	card = mdev->private_data;
> +	card->blockread = kmalloc(card->blocklen, GFP_KERNEL);
> +	if (!card->blockread)
> +		return;
> +	memcpy(card->blockread, mq->recvbuf + 12, card->blocklen);
> +	block_read = 1;
> +	mtd = card->mtd;
> +	mpart = mtd->priv;
> +	partition = mpart->partition;
> +	pcache = (card->parts[partition]).pcache;
> +	if (!pcache->buffer)
> +		pcache->buffer = kmalloc(card->blocklen, GFP_KERNEL);
> +		if (!pcache->buffer)
> +			return;

How is this ENOMEM propagated back and suitably handled?

> +	memcpy(pcache->buffer, card->blockread, card->blocklen);
> +	pcache->block = ((unsigned char *)mq->recvbuf)[11] & 0xFF;

The &0xff isn't needed?

> +	pcache->jiffies_atc = jiffies;
> +	pcache->valid = 1;
> +	wake_up_interruptible(&vmu_read);
> +}
> +
> +/* Interface with maple bus to read bytes */
> +static int maple_vmu_read_block(unsigned int num, unsigned char *buf,
> +	struct mtd_info *mtd)
> +{
> +	struct memcard *card;
> +	struct mdev_part *mpart;
> +	struct maple_device *mdev;
> +	int partition, error, locking;
> +	void *sendbuf;
> +
> +	mpart = mtd->priv;
> +	mdev = mpart->mdev;
> +	partition = mpart->partition;
> +	card = mdev->private_data;
> +
> +	/* wait for the mutex to be available */
> +	locking = down_interruptible(&(mdev->mq->sem));

Unneeded parentheses here.

> +	if (locking) {
> +		printk(KERN_INFO "Maple: VMU at (%d, %d) is locked -"
> +			" aborting read\n", mdev->unit, mdev->port);
> +		goto fail_nosendbuf;

So this function will "fail" if the calling process is signalled.  Has this
been tested?


> +	}
> +	mdev->mq->command = MAPLE_COMMAND_BREAD;
> +	mdev->mq->length = 2;
> +
> +	sendbuf = kzalloc(mdev->mq->length * 4, GFP_KERNEL);
> +	if (!sendbuf) {
> +		error = -ENOMEM;
> +		goto fail_nosendbuf;
> +	}

If this error is taken, vmu_flash_write() (at least) will not call
maple_vmu_write_block() and hence mdev->mq->sem never gets up()ed.  As far
as I can tell.

Also, when this function is called from vmu_flash_read_char() I can't see
where mdev->mq->sem gets up()ed ever.  But I didn't look too hard.

> +	((unsigned long *)sendbuf)[0] = cpu_to_be32(MAPLE_FUNC_MEMCARD);
> +	((unsigned long *)sendbuf)[1] = cpu_to_be32(partition << 24 | num);
> +
> +	mdev->mq->sendbuf = sendbuf;
> +	block_read = 0;
> +
> +	maple_getcond_callback(mdev, vmu_blockread, 0, MAPLE_FUNC_MEMCARD);
> +	maple_add_packet(mdev->mq);
> +	wait_event_interruptible_timeout(vmu_read, block_read, HZ * 4);
> +	if (block_read == 0) {
> +		printk(KERN_INFO "Maple: VMU read failed on block 0x%X\n", num);
> +		goto fail_blockread;
> +	}
> +
> +	memcpy(buf, card->blockread, card->blocklen);
> +	kfree(card->blockread);
> +	kfree(sendbuf);
> +
> +	return 0;
> +
> +fail_blockread:
> +	kfree(sendbuf);
> +fail_nosendbuf:
> +	return -1;
> +}

We don't need any special handling here if
wait_event_interruptible_timeout() was interrupted by a signal?

> +/* communicate with maple bus for phased writing */
> +static int maple_vmu_write_block(unsigned int num, const unsigned char *buf,
> +	struct mtd_info *mtd)
> +{
> +	struct memcard *card;
> +	struct mdev_part *mpart;
> +	struct maple_device *mdev;
> +	int partition, error, locking, x, phaselen;
> +	void *sendbuf;
> +
> +	mpart = mtd->priv;
> +	mdev = mpart->mdev;
> +	partition = mpart->partition;
> +	card = mdev->private_data;
> +
> +	phaselen = card->blocklen/card->writecnt;
> +	mdev->mq->command = MAPLE_COMMAND_BWRITE;
> +	mdev->mq->length = phaselen / 4 + 2;
> +
> +	sendbuf = kmalloc(mdev->mq->length * 4, GFP_KERNEL);
> +	if (!sendbuf) {
> +		error = -ENOMEM;
> +		goto fail_nosendbuf;
> +	}
> +
> +	((unsigned long *)sendbuf)[0] = cpu_to_be32(MAPLE_FUNC_MEMCARD);
> +
> +	for (x = 0; x < card->writecnt; x++) {
> +		/* take the lock to protect the contents of sendbuf */
> +		locking = down_interruptible(&mdev->mq->sem);
> +		if (locking) {
> +			error = -EBUSY;
> +			goto fail_nolock;
> +		}

Confused.  Where within this loop does the up(&mdev->mq->sem) happen?

> +		((unsigned long *)sendbuf)[1] =
> +			cpu_to_be32(partition << 24 | x << 16 | num);
> +		memcpy(sendbuf + 8, buf + phaselen * x, phaselen);
> +		mdev->mq->sendbuf = sendbuf;
> +		/* wait for the mutex to be available */
> +		maple_add_packet(mdev->mq);

Within here, I guess, via a workqueue or timer function?

> +	}
> +	/* wait until command is processed */
> +	locking = down_interruptible(&mdev->mq->sem);
> +	if (locking) {
> +		error = -EBUSY;
> +		goto fail_nolock;
> +	}
> +	up(&mdev->mq->sem);
> +
> +	kfree(sendbuf);
> +
> +	return card->blocklen;
> +
> +fail_nolock:
> +	printk(KERN_INFO "Maple: VMU at (%d, %d) is locked -"
> +		" aborting write\n", mdev->unit, mdev->port);
> +	kfree(sendbuf);
> +fail_nosendbuf:
> +	printk("Maple: VMU (%d, %d): write failed\n", mdev->port, mdev->unit);
> +	return error;
> +}
> +

