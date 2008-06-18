Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYFROEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYFROEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYFROEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:04:10 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:24683 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbYFROEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:04:08 -0400
Date: Wed, 18 Jun 2008 16:03:34 +0200
From: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Subject: Re: AZFS file system proposal
Message-ID: <20080618160334.780b6283@mercedes-benz.boeblingen.de.ibm.com>
In-Reply-To: <20080618112717.GA23081@infradead.org>
References: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com>
	<20080618112717.GA23081@infradead.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you very much Christoph for your comments. Some of them I have already found useful and fixed my code accordinly. Some other your comments I find interesting but would like to investigate them a little bit more.
I will send an updated version of my patch soon.

> truncate and seeking are done by the VFS, not need to do it.

I think VFS is doing it not exactly the same way which I need. But I will look at it once more again to make sure.

> Also no need to stuff the inode in file->private_data because
> it's always available through file->f_path.dentry->inode.

Fixed.

> You need to check for an NULL pointer from kmem_cache_alloc
> here.

Fixed.

> > +	if (!disk || !disk->queue) {
> 
> This won't ever be zero, no need to check.

Agree 50%. I have removed a printk from here but have left the following line;
	BUG_ON(!disk || !disk->queue);

> > +	if (!get_device(disk->driverfs_dev)) {
> > +		printk(KERN_ERR "%s cannot get reference to device driver\n",
> > +				AZFS_FILESYSTEM_NAME);
> > +		return -EFAULT;
> > +	}
> 
> You don't need another reference, the disk won't go away while the
> block device is open.

Not agree. I leave get_device here but remove the printk.

> > +	spin_lock(&super_list.lock);
> > +	list_for_each_entry(knoten, &super_list.head, list)
> > +		if (knoten->blkdev == sb->s_bdev) {
> > +			super = knoten;
> > +			break;
> > +		}
> > +	spin_unlock(&super_list.lock);
> 
> This can't happen.  get_sb_bdev already searches for the same superblock
> already existing and doesn't even call into fill_super in that case.

I will check it.

> > +static void
> > +azfs_kill_sb(struct super_block *sb)
> > +{
> > +	sb->s_root = NULL;
> 
> Very bad idea, if you set sb->s_root to zero before calling
> generic_shutdown_super it will miss a lot of the taerdown activity.

I need it because I want to keep all super blocks and inodes to make it possible to mount the same AZFS partition later and to let user see all his files again. Don't forget - AZFS keeps all the inode data in RAM.

> > +	spin_lock(&super_list.lock);
> > +	list_for_each_entry_safe(super, SUPER, &super_list.head, list) {
> > +		disk = super->blkdev->bd_disk;
> > +		list_del(&super->list);
> > +		iounmap((void*) super->io_addr);
> > +		write_lock(&super->lock);
> > +		for_each_block_safe(block, knoten, &super->block_list)
> > +			azfs_block_free(block);
> > +		write_unlock(&super->lock);
> > +		disk->driverfs_dev->driver_data = NULL;
> > +		disk->driverfs_dev->platform_data = NULL;
> > +		kfree(super);
> > +		put_device(disk->driverfs_dev);
> 
> All this teardown should happen in ->put_super, and with this and
> the above comment there should be need for a list of all superblocks.

Same thing - super blocks and inodes of unmounted file systems are still in RAM.

-- 
Mit freundlichen Grüßen / met vriendelijke groeten / avec regards

    Maxim V. Shchetynin
    Linux Kernel Entwicklung
    IBM Deutschland Entwicklung GmbH
    Linux für Cell, Abteilung 3250
    Schönaicher Straße 220
    71032 Böblingen

Vorsitzender des Aufsichtsrats: Johann Weihen
Geschäftsführung: Herbert Kircher
Sitz der Gesellschaft: Böblingen
Registriergericht: Amtsgericht Stuttgart, HRB 243294

Fahr nur so schnell wie dein Schutzengel fliegen kann!
