Return-Path: <linux-kernel-owner+w=401wt.eu-S1752056AbYIUEQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbYIUEQB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 00:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbYIUEPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 00:15:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYIUEPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 00:15:52 -0400
Date: Sat, 20 Sep 2008 21:14:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jens.axboe@oracle.com, agk@sourceware.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: [PATCH] dm: Add support for data integrity to DM
Message-Id: <20080920211433.9e1a6872.akpm@linux-foundation.org>
In-Reply-To: <yq13ajunyju.fsf@sermon.lab.mkp.net>
References: <yq13ajunyju.fsf@sermon.lab.mkp.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Sep 2008 20:16:21 -0400 "Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> 
> If all subdevices support the same protection format the DM device is
> flagged as capable.
> 
> ..
..
> +	/* Register dm device as being integrity capable */
> +	if (prev && bdev_get_integrity(prev->bdev)) {
> +		struct gendisk *disk = dm_disk(md);
> +
> +		if (blk_integrity_register(dm_disk(md), 

Please use checkpatch.  Always.  There's just no reason not to.  Sure,
you can make a decision to ignore some of its reports, but at least
this avoids the accidental introduction of layout problems.

> +					   bdev_get_integrity(prev->bdev)))
> +			printk(KERN_ERR "%s: %s Could not register integrity!\n",
> +			       __func__, disk->disk_name);
> +		else
> +			printk(KERN_INFO "Enabling data integrity on %s\n",
> +			       disk->disk_name);
> +	}
>  }
>
> ...
>
> +	if (bio_integrity(bio)) {
> +		bio_integrity_clone(clone, bio, bs);
> +
> +		if (idx != bio->bi_idx || clone->bi_size < bio->bi_size)
> +			bio_integrity_trim(clone, bio_sector_offset(bio, idx, 0), len);

For better or for worse, the developers of dm.c have chosen to keep the
whole file presentable in an 80-col display.  This patch breaks that,
and they might not like this.

> +	}
> +
>  	return clone;
>  }
>  
> @@ -1108,6 +1121,7 @@ static struct mapped_device *alloc_dev(int minor)
>  	md->disk->queue = md->queue;
>  	md->disk->private_data = md;
>  	sprintf(md->disk->disk_name, "dm-%d", minor);
> +	printk(KERN_ERR "DM: Created %s\n", md->disk->disk_name);
>  	add_disk(md->disk);
>  	format_dev_t(md->name, MKDEV(_major, minor));
>  
> @@ -1157,6 +1171,7 @@ static void free_dev(struct mapped_device *md)
>  	mempool_destroy(md->tio_pool);
>  	mempool_destroy(md->io_pool);
>  	bioset_free(md->bs);
> +	blk_integrity_unregister(md->disk);
>  	del_gendisk(md->disk);
>  	free_minor(minor);
>  
> @@ -1200,7 +1215,6 @@ static void __set_size(struct mapped_device *md, sector_t size)
>  
>  static int __bind(struct mapped_device *md, struct dm_table *t)
>  {
> -	struct request_queue *q = md->queue;
>  	sector_t size;
>  
>  	size = dm_table_get_size(t);
> @@ -1221,7 +1235,7 @@ static int __bind(struct mapped_device *md, struct dm_table *t)
>  
>  	write_lock(&md->map_lock);
>  	md->map = t;
> -	dm_table_set_restrictions(t, q);
> +	dm_table_set_restrictions(t, md);
>  	write_unlock(&md->map_lock);
>  
>  	return 0;
> @@ -1674,9 +1688,17 @@ void dm_uevent_add(struct mapped_device *md, struct list_head *elist)
>   */
>  struct gendisk *dm_disk(struct mapped_device *md)
>  {
> +	BUG_ON(md == NULL);

This will provide no more information than the oops which will happen
two lines later.

> +	BUG_ON(md->disk == NULL);

well, that will provide a little bit of information I guess.

>  	return md->disk;
>  }
>  
> +struct request_queue *dm_queue(struct mapped_device *md)
> +{
> +	return md->queue;
> +}

This (unused, undocumented) function should be inlined.


