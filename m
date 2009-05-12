Return-Path: <linux-kernel-owner+w=401wt.eu-S1759295AbZELIf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbZELIf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757141AbZELIfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:35:47 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:33442 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757050AbZELIfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:35:45 -0400
Date: Tue, 12 May 2009 10:35:42 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Roel Kluin <roel.kluin@gmail.com>
cc: Greg KH <gregkh@suse.de>, axboe@kernel.dk,
       lkml <linux-kernel@vger.kernel.org>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [PATCH] block/ps3: remove driver_data direct access of struct
 device
In-Reply-To: <49FFFBAF.4040808@gmail.com>
Message-ID: <alpine.LRH.2.00.0905121034380.24439@vixen.sonytel.be>
References: <49FFFBAF.4040808@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 May 2009, Roel Kluin wrote:
> In the near future, the driver core is going to not allow direct access
> to the driver_data pointer in struct device.  Instead, the functions
> dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
> have been around since the beginning, so are backwards compatible with
> all older kernel versions.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

As this involves ps3_system_bus_devices, they should use
ps3_system_bus_[gs]et_driver_data(), too?

> ---
> Changelog was from Greg. Please review. In particular, is this required?
> 
> -	dev->core.driver_data = NULL;
> +	dev_set_drvdata(&dev->core, NULL);
> 
> 
>  drivers/block/ps3disk.c |   18 +++++++++---------
>  drivers/block/ps3vram.c |   46 +++++++++++++++++++++++-----------------------
>  2 files changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
> index bccc42b..4f707d6 100644
> --- a/drivers/block/ps3disk.c
> +++ b/drivers/block/ps3disk.c
> @@ -120,7 +120,7 @@ static void ps3disk_scatter_gather(struct ps3_storage_device *dev,
>  static int ps3disk_submit_request_sg(struct ps3_storage_device *dev,
>  				     struct request *req)
>  {
> -	struct ps3disk_private *priv = dev->sbd.core.driver_data;
> +	struct ps3disk_private *priv = dev_get_drvdata(&dev->sbd.core);
>  	int write = rq_data_dir(req), res;
>  	const char *op = write ? "write" : "read";
>  	u64 start_sector, sectors;
> @@ -169,7 +169,7 @@ static int ps3disk_submit_request_sg(struct ps3_storage_device *dev,
>  static int ps3disk_submit_flush_request(struct ps3_storage_device *dev,
>  					struct request *req)
>  {
> -	struct ps3disk_private *priv = dev->sbd.core.driver_data;
> +	struct ps3disk_private *priv = dev_get_drvdata(&dev->sbd.core);
>  	u64 res;
>  
>  	dev_dbg(&dev->sbd.core, "%s:%u: flush request\n", __func__, __LINE__);
> @@ -214,7 +214,7 @@ static void ps3disk_do_request(struct ps3_storage_device *dev,
>  static void ps3disk_request(struct request_queue *q)
>  {
>  	struct ps3_storage_device *dev = q->queuedata;
> -	struct ps3disk_private *priv = dev->sbd.core.driver_data;
> +	struct ps3disk_private *priv = dev_get_drvdata(&dev->sbd.core);
>  
>  	if (priv->req) {
>  		dev_dbg(&dev->sbd.core, "%s:%u busy\n", __func__, __LINE__);
> @@ -247,7 +247,7 @@ static irqreturn_t ps3disk_interrupt(int irq, void *data)
>  		return IRQ_HANDLED;
>  	}
>  
> -	priv = dev->sbd.core.driver_data;
> +	priv = dev_get_drvdata(&dev->sbd.core);
>  	req = priv->req;
>  	if (!req) {
>  		dev_dbg(&dev->sbd.core,
> @@ -368,7 +368,7 @@ static void ata_id_c_string(const u16 *id, unsigned char *s, unsigned int ofs,
>  
>  static int ps3disk_identify(struct ps3_storage_device *dev)
>  {
> -	struct ps3disk_private *priv = dev->sbd.core.driver_data;
> +	struct ps3disk_private *priv = dev_get_drvdata(&dev->sbd.core);
>  	struct lv1_ata_cmnd_block ata_cmnd;
>  	u16 *id = dev->bounce_buf;
>  	u64 res;
> @@ -449,7 +449,7 @@ static int __devinit ps3disk_probe(struct ps3_system_bus_device *_dev)
>  		goto fail;
>  	}
>  
> -	dev->sbd.core.driver_data = priv;
> +	dev_set_drvdata(&dev->sbd.core, priv);
>  	spin_lock_init(&priv->lock);
>  
>  	dev->bounce_size = BOUNCE_SIZE;
> @@ -527,7 +527,7 @@ fail_free_bounce:
>  	kfree(dev->bounce_buf);
>  fail_free_priv:
>  	kfree(priv);
> -	dev->sbd.core.driver_data = NULL;
> +	dev_set_drvdata(&dev->sbd.core, NULL);
>  fail:
>  	mutex_lock(&ps3disk_mask_mutex);
>  	__clear_bit(devidx, &ps3disk_mask);
> @@ -538,7 +538,7 @@ fail:
>  static int ps3disk_remove(struct ps3_system_bus_device *_dev)
>  {
>  	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
> -	struct ps3disk_private *priv = dev->sbd.core.driver_data;
> +	struct ps3disk_private *priv = dev_get_drvdata(&dev->sbd.core);
>  
>  	mutex_lock(&ps3disk_mask_mutex);
>  	__clear_bit(MINOR(disk_devt(priv->gendisk)) / PS3DISK_MINORS,
> @@ -552,7 +552,7 @@ static int ps3disk_remove(struct ps3_system_bus_device *_dev)
>  	ps3stor_teardown(dev);
>  	kfree(dev->bounce_buf);
>  	kfree(priv);
> -	dev->sbd.core.driver_data = NULL;
> +	dev_set_drvdata(&dev->sbd.core, NULL);
>  	return 0;
>  }
>  
> diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
> index 8eddef3..8ecf1e0 100644
> --- a/drivers/block/ps3vram.c
> +++ b/drivers/block/ps3vram.c
> @@ -111,7 +111,7 @@ static u32 *ps3vram_get_notifier(u32 *reports, int notifier)
>  
>  static void ps3vram_notifier_reset(struct ps3_system_bus_device *dev)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  	u32 *notify = ps3vram_get_notifier(priv->reports, NOTIFIER);
>  	int i;
>  
> @@ -122,7 +122,7 @@ static void ps3vram_notifier_reset(struct ps3_system_bus_device *dev)
>  static int ps3vram_notifier_wait(struct ps3_system_bus_device *dev,
>  				 unsigned int timeout_ms)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  	u32 *notify = ps3vram_get_notifier(priv->reports, NOTIFIER);
>  	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
>  
> @@ -137,7 +137,7 @@ static int ps3vram_notifier_wait(struct ps3_system_bus_device *dev,
>  
>  static void ps3vram_init_ring(struct ps3_system_bus_device *dev)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  
>  	priv->ctrl[CTRL_PUT] = FIFO_BASE + FIFO_OFFSET;
>  	priv->ctrl[CTRL_GET] = FIFO_BASE + FIFO_OFFSET;
> @@ -146,7 +146,7 @@ static void ps3vram_init_ring(struct ps3_system_bus_device *dev)
>  static int ps3vram_wait_ring(struct ps3_system_bus_device *dev,
>  			     unsigned int timeout_ms)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
>  
>  	do {
> @@ -175,7 +175,7 @@ static void ps3vram_begin_ring(struct ps3vram_priv *priv, u32 chan, u32 tag,
>  
>  static void ps3vram_rewind_ring(struct ps3_system_bus_device *dev)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  	int status;
>  
>  	ps3vram_out_ring(priv, 0x20000000 | (FIFO_BASE + FIFO_OFFSET));
> @@ -196,7 +196,7 @@ static void ps3vram_rewind_ring(struct ps3_system_bus_device *dev)
>  
>  static void ps3vram_fire_ring(struct ps3_system_bus_device *dev)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  	int status;
>  
>  	mutex_lock(&ps3_gpu_mutex);
> @@ -225,7 +225,7 @@ static void ps3vram_fire_ring(struct ps3_system_bus_device *dev)
>  
>  static void ps3vram_bind(struct ps3_system_bus_device *dev)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  
>  	ps3vram_begin_ring(priv, UPLOAD_SUBCH, 0, 1);
>  	ps3vram_out_ring(priv, 0x31337303);
> @@ -248,7 +248,7 @@ static int ps3vram_upload(struct ps3_system_bus_device *dev,
>  			  unsigned int src_offset, unsigned int dst_offset,
>  			  int len, int count)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  
>  	ps3vram_begin_ring(priv, UPLOAD_SUBCH,
>  			   NV_MEMORY_TO_MEMORY_FORMAT_OFFSET_IN, 8);
> @@ -280,7 +280,7 @@ static int ps3vram_download(struct ps3_system_bus_device *dev,
>  			    unsigned int src_offset, unsigned int dst_offset,
>  			    int len, int count)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  
>  	ps3vram_begin_ring(priv, DOWNLOAD_SUBCH,
>  			   NV_MEMORY_TO_MEMORY_FORMAT_OFFSET_IN, 8);
> @@ -310,7 +310,7 @@ static int ps3vram_download(struct ps3_system_bus_device *dev,
>  
>  static void ps3vram_cache_evict(struct ps3_system_bus_device *dev, int entry)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  	struct ps3vram_cache *cache = &priv->cache;
>  
>  	if (!(cache->tags[entry].flags & CACHE_PAGE_DIRTY))
> @@ -332,7 +332,7 @@ static void ps3vram_cache_evict(struct ps3_system_bus_device *dev, int entry)
>  static void ps3vram_cache_load(struct ps3_system_bus_device *dev, int entry,
>  			       unsigned int address)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  	struct ps3vram_cache *cache = &priv->cache;
>  
>  	dev_dbg(&dev->core, "Fetching %d: 0x%08x\n", entry, address);
> @@ -352,7 +352,7 @@ static void ps3vram_cache_load(struct ps3_system_bus_device *dev, int entry,
>  
>  static void ps3vram_cache_flush(struct ps3_system_bus_device *dev)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  	struct ps3vram_cache *cache = &priv->cache;
>  	int i;
>  
> @@ -366,7 +366,7 @@ static void ps3vram_cache_flush(struct ps3_system_bus_device *dev)
>  static unsigned int ps3vram_cache_match(struct ps3_system_bus_device *dev,
>  					loff_t address)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  	struct ps3vram_cache *cache = &priv->cache;
>  	unsigned int base;
>  	unsigned int offset;
> @@ -400,7 +400,7 @@ static unsigned int ps3vram_cache_match(struct ps3_system_bus_device *dev,
>  
>  static int ps3vram_cache_init(struct ps3_system_bus_device *dev)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  
>  	priv->cache.page_count = CACHE_PAGE_COUNT;
>  	priv->cache.page_size = CACHE_PAGE_SIZE;
> @@ -419,7 +419,7 @@ static int ps3vram_cache_init(struct ps3_system_bus_device *dev)
>  
>  static void ps3vram_cache_cleanup(struct ps3_system_bus_device *dev)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  
>  	ps3vram_cache_flush(dev);
>  	kfree(priv->cache.tags);
> @@ -428,7 +428,7 @@ static void ps3vram_cache_cleanup(struct ps3_system_bus_device *dev)
>  static int ps3vram_read(struct ps3_system_bus_device *dev, loff_t from,
>  			size_t len, size_t *retlen, u_char *buf)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  	unsigned int cached, count;
>  
>  	dev_dbg(&dev->core, "%s: from=0x%08x len=0x%zx\n", __func__,
> @@ -476,7 +476,7 @@ static int ps3vram_read(struct ps3_system_bus_device *dev, loff_t from,
>  static int ps3vram_write(struct ps3_system_bus_device *dev, loff_t to,
>  			 size_t len, size_t *retlen, const u_char *buf)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  	unsigned int cached, count;
>  
>  	if (to >= priv->size)
> @@ -543,7 +543,7 @@ static const struct file_operations ps3vram_proc_fops = {
>  
>  static void __devinit ps3vram_proc_init(struct ps3_system_bus_device *dev)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  	struct proc_dir_entry *pde;
>  
>  	pde = proc_create(DEVICE_NAME, 0444, NULL, &ps3vram_proc_fops);
> @@ -615,9 +615,9 @@ static int __devinit ps3vram_probe(struct ps3_system_bus_device *dev)
>  	}
>  
>  	mutex_init(&priv->lock);
> -	dev->core.driver_data = priv;
> +	dev_set_drvdata(&dev->core, priv);
>  
> -	priv = dev->core.driver_data;
> +	priv = dev_get_drvdata(&dev->core);
>  
>  	/* Allocate XDR buffer (1MiB aligned) */
>  	priv->xdr_buf = (void *)__get_free_pages(GFP_KERNEL,
> @@ -787,14 +787,14 @@ out_free_xdr_buf:
>  	free_pages((unsigned long) priv->xdr_buf, get_order(XDR_BUF_SIZE));
>  fail_free_priv:
>  	kfree(priv);
> -	dev->core.driver_data = NULL;
> +	dev_set_drvdata(&dev->core, NULL);
>  fail:
>  	return error;
>  }
>  
>  static int ps3vram_remove(struct ps3_system_bus_device *dev)
>  {
> -	struct ps3vram_priv *priv = dev->core.driver_data;
> +	struct ps3vram_priv *priv = dev_get_drvdata(&dev->core);
>  
>  	del_gendisk(priv->gendisk);
>  	put_disk(priv->gendisk);
> @@ -809,7 +809,7 @@ static int ps3vram_remove(struct ps3_system_bus_device *dev)
>  	ps3_close_hv_device(dev);
>  	free_pages((unsigned long) priv->xdr_buf, get_order(XDR_BUF_SIZE));
>  	kfree(priv);
> -	dev->core.driver_data = NULL;
> +	dev_set_drvdata(&dev->core, NULL);
>  	return 0;
>  }

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village � Da Vincilaan 7-D1 � B-1935 Zaventem � Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 � RPR Brussels
Fortis � BIC GEBABEBB � IBAN BE41293037680010
