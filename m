Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZGFRDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZGFRDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 13:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZGFRDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 13:03:25 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:26577
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751890AbZGFRDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 13:03:24 -0400
Message-ID: <4A522E57.7060101@panasas.com>
Date: Mon, 06 Jul 2009 20:03:19 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeff Garzik <jeff@garzik.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd mailing-list <osd-dev@open-osd.org>
Subject: Re: [osd-dev] [GIT PULL] exofs/osd tree for 2.6.31
References: <4A3F45D5.4020600@panasas.com> <4A41F458.2050409@panasas.com>
In-Reply-To: <4A41F458.2050409@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jul 2009 17:03:22.0285 (UTC) FILETIME=[AB19E5D0:01C9FE5B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for nagging.
Is this going to be merged in 2.6.31 or wait for 2.6.32?
Anything we can do to help it not fall between the cracks next time?

Benny

On Jun. 24, 2009, 12:39 +0300, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On 06/22/2009 11:50 AM, Boaz Harrosh wrote:
>> Linus
>>
>> Please pull the following exofs/OSD changes from the git repository at:
>>
>>   git://git.open-osd.org/linux-open-osd.git for-linus
>>
>> These are a few fixes/cleanups and mainly a new block-device driver
>> from Jeff Garzik, that can export an OSD object to block-based users
>> like filesystems.
>>
>> Boaz Harrosh (5):
>>       exofs: Fix bio leak in error handling path (sync read)
>>       exofs: Remove IBM copyrights
>>       exofs: Avoid using file_fsync()
>>       MAINTAINERS: Add osd maintained files (F:)
>>       osdblk: Adjust queue limits to lower device's limits
>>
>> Jeff Garzik (1):
>>       osdblk: a Linux block device for OSD objects
>>
>>  MAINTAINERS            |    5 +-
>>  drivers/block/Kconfig  |   16 ++
>>  drivers/block/Makefile |    1 +
>>  drivers/block/osdblk.c |  670 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/exofs/common.h      |    4 +-
>>  fs/exofs/dir.c         |    4 +-
>>  fs/exofs/exofs.h       |    7 +-
>>  fs/exofs/file.c        |   21 +-
>>  fs/exofs/inode.c       |    7 +-
>>  fs/exofs/namei.c       |    4 +-
>>  fs/exofs/osd.c         |    4 +-
>>  fs/exofs/super.c       |    6 +-
>>  fs/exofs/symlink.c     |    4 +-
>>  13 files changed, 719 insertions(+), 34 deletions(-)
>>  create mode 100644 drivers/block/osdblk.c
>>
>> [These patches can be viewed on the web here:
>>  http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=refs/heads/for-linus
>> ]
>>
>> Thanks
>> Boaz
> 
> Hi Linus, Jeff
> 
> while testing osdblk I have found some bugs and squashed below patch into
> the original osdblk driver.
> 
> Linus please see that you have bc47df0 it might take a few minutes to update 
> 
> Boaz
> ---
> Subject: [SQUASHME] osdblk: Assorted bug fixes 
> 
> I have squashed the below fixes to the original osdblk driver.
> It should run much better now
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
> 
> diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
> index b07e154..13c1aee 100644
> --- a/drivers/block/osdblk.c
> +++ b/drivers/block/osdblk.c
> @@ -71,6 +71,19 @@
>  #define DRV_NAME "osdblk"
>  #define PFX DRV_NAME ": "
>  
> +/* #define _OSDBLK_DEBUG */
> +#ifdef _OSDBLK_DEBUG
> +#define OSDBLK_DEBUG(fmt, a...) \
> +	printk(KERN_NOTICE "osdblk @%s:%d: " fmt, __func__, __LINE__, ##a)
> +#else
> +#define OSDBLK_DEBUG(fmt, a...) \
> +	do { if (0) printk(fmt, ##a); } while (0)
> +#endif
> +
> +MODULE_AUTHOR("Jeff Garzik <jeff@garzik.org>");
> +MODULE_DESCRIPTION("block device inside an OSD object osdblk.ko");
> +MODULE_LICENSE("GPL");
> +
>  struct osdblk_device;
>  
>  enum {
> @@ -109,7 +122,7 @@ struct osdblk_device {
>  };
>  
>  static struct class *class_osdblk;		/* /sys/class/osdblk */
> -static struct mutex ctl_mutex;	/* Serialize open/close/setup/teardown */
> +static DEFINE_MUTEX(ctl_mutex);	/* Serialize open/close/setup/teardown */
>  static LIST_HEAD(osdblkdev_list);
>  
>  static struct block_device_operations osdblk_bd_ops = {
> @@ -223,8 +236,10 @@ static void osdblk_osd_complete(struct osd_request *or, void *private)
>  	struct osd_sense_info osi;
>  	int ret = osd_req_decode_sense(or, &osi);
>  
> -	if (ret)
> +	if (ret) {
>  		ret = -EIO;
> +		OSDBLK_DEBUG("osdblk_osd_complete with err=%d\n", ret);
> +	}
>  
>  	/* complete OSD request */
>  	osd_end_request(or);
> @@ -250,13 +265,15 @@ static struct bio *bio_chain_clone(struct bio *old_chain, gfp_t gfpmask)
>  	struct bio *tmp, *new_chain = NULL, *tail = NULL;
>  
>  	while (old_chain) {
> -		tmp = bio_kmalloc(gfpmask, old_chain->bi_vcnt);
> +		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
>  		if (!tmp)
>  			goto err_out;
>  
>  		__bio_clone(tmp, old_chain);
> +		tmp->bi_bdev = NULL;
>  		gfpmask &= ~__GFP_WAIT;
>  		tmp->bi_next = NULL;
> +
>  		if (!new_chain)
>  			new_chain = tail = tmp;
>  		else {
> @@ -270,6 +287,7 @@ static struct bio *bio_chain_clone(struct bio *old_chain, gfp_t gfpmask)
>  	return new_chain;
>  
>  err_out:
> +	OSDBLK_DEBUG("bio_chain_clone with err\n");
>  	bio_chain_put(new_chain);
>  	return NULL;
>  }
> @@ -277,13 +295,14 @@ err_out:
>  static void osdblk_rq_fn(struct request_queue *q)
>  {
>  	struct osdblk_device *osdev = q->queuedata;
> -	struct request *rq;
> -	struct osdblk_request *orq;
> -	struct osd_request *or;
> -	struct bio *bio;
> -	int do_write, do_flush;
>  
>  	while (1) {
> +		struct request *rq;
> +		struct osdblk_request *orq;
> +		struct osd_request *or;
> +		struct bio *bio;
> +		bool do_write, do_flush;
> +
>  		/* peek at request from block layer */
>  		rq = blk_fetch_request(q);
>  		if (!rq)
> @@ -317,6 +336,7 @@ static void osdblk_rq_fn(struct request_queue *q)
>  		or = osd_start_request(osdev->osd, GFP_ATOMIC);
>  		if (!or) {
>  			bio_chain_put(bio);
> +			OSDBLK_DEBUG("osd_start_request with err\n");
>  			break;
>  		}
>  
> @@ -336,12 +356,19 @@ static void osdblk_rq_fn(struct request_queue *q)
>  			osd_req_read(or, &osdev->obj, blk_rq_pos(rq) * 512ULL,
>  				     bio, blk_rq_bytes(rq));
>  
> +		OSDBLK_DEBUG("%s 0x%x bytes at 0x%llx\n",
> +			do_flush ? "flush" : do_write ?
> +				"write" : "read", blk_rq_bytes(rq),
> +			blk_rq_pos(rq) * 512ULL);
> +
>  		/* begin OSD command execution */
>  		if (osd_async_op(or, osdblk_osd_complete, orq,
>  				 osdev->obj_cred)) {
>  			osd_end_request(or);
>  			blk_requeue_request(q, rq);
>  			bio_chain_put(bio);
> +			OSDBLK_DEBUG("osd_execute_request_async with err\n");
> +			break;
>  		}
>  
>  		/* remove the special 'flush' marker, now that the command
> @@ -390,7 +417,7 @@ static int osdblk_init_disk(struct osdblk_device *osdev)
>  	if (!disk)
>  		return -ENOMEM;
>  
> -	sprintf(disk->disk_name, DRV_NAME "/%d", osdev->id);
> +	sprintf(disk->disk_name, DRV_NAME "%d", osdev->id);
>  	disk->major = osdev->major;
>  	disk->first_minor = 0;
>  	disk->fops = &osdblk_bd_ops;
> @@ -428,9 +455,12 @@ static int osdblk_init_disk(struct osdblk_device *osdev)
>  	osdev->q = q;
>  
>  	/* finally, announce the disk to the world */
> -	set_capacity(disk, obj_size);
> +	set_capacity(disk, obj_size / 512ULL);
>  	add_disk(disk);
>  
> +	printk(KERN_INFO "%s: Added of size 0x%llx\n",
> +		disk->disk_name, (unsigned long long)obj_size);
> +
>  	return 0;
>  }
>  
> @@ -544,7 +574,7 @@ static ssize_t class_osdblk_add(struct class *c, const char *buf, size_t count)
>  	if (rc)
>  		goto err_out_blkdev;
>  
> -	return 0;
> +	return count;
>  
>  err_out_blkdev:
>  	unregister_blkdev(osdev->major, osdev->name);
> @@ -557,6 +587,7 @@ err_out_slot:
>  
>  	kfree(osdev);
>  err_out_mod:
> +	OSDBLK_DEBUG("Error adding device %s\n", buf);
>  	module_put(THIS_MODULE);
>  	return rc;
>  }
> @@ -604,7 +635,7 @@ static ssize_t class_osdblk_remove(struct class *c, const char *buf,
>  	/* release module ref */
>  	module_put(THIS_MODULE);
>  
> -	return 0;
> +	return count;
>  }
>  
>  static struct class_attribute class_osdblk_attrs[] = {
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 7a117c1..da0e35f 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -441,7 +441,7 @@ void osd_end_request(struct osd_request *or)
>  {
>  	struct request *rq = or->request;
>  	/* IMPORTANT: make sure this agrees with osd_execute_request_async */
> -	bool is_async = (or->request->end_io_data == or);
> +	bool is_async = (rq->end_io_data == or);
>  
>  	_osd_free_seg(or, &or->set_attr);
>  	_osd_free_seg(or, &or->enc_get_attr);
> 
> _______________________________________________
> osd-dev mailing list
> osd-dev@open-osd.org
> http://mailman.open-osd.org/mailman/listinfo/osd-dev
