Return-Path: <linux-kernel-owner+w=401wt.eu-S1753617AbZAECe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617AbZAECe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZAECeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:34:44 -0500
Received: from zakalwe.fi ([80.83.5.154]:32784 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbZAECdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:33:49 -0500
Date: Mon, 5 Jan 2009 04:33:46 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: unsik Kim <donari75@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] mflash linux support
Message-ID: <20090105023346.GE6115@zakalwe.fi>
References: <57afda040901041718g1415e210hfd0991270dfdd72d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <57afda040901041718g1415e210hfd0991270dfdd72d@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few style issues:

On Mon, Jan 05, 2009 at 10:18:54AM +0900, unsik Kim wrote:
> +/* This function also called from IRQ context */
> +static void mg_request(struct request_queue *q)
> +{
> +	struct request *req;
> +	struct mg_host *host;
> +	u32 sect_num, sect_cnt, i;
> +	u16 *buff;
> +
> +repeat:
> +	req = elv_next_request(q);
> +	if (!req)
> +		return;
> +
> +	host = req->rq_disk->private_data;
> +
> +	/* check unwanted request call */
> +	if (host->mg_do_intr)
> +		return;
> +
> +	del_timer(&host->timer);
> +
> +	if (host->reset) {
> +		if (mg_disk_init(host)) {
> +			end_request(req, 0);
> +			return;
> +		}
> +		host->reset = 0;
> +	}
> +
> +	sect_num = req->sector;
> +	/* deal whole segments */
> +	sect_cnt = req->nr_sectors;
> +
> +	/* sanity check */
> +	if (sect_num >= get_capacity(req->rq_disk) ||
> +	    ((sect_num + sect_cnt) > get_capacity(req->rq_disk))) {
> +		printk(KERN_WARNING "%s: bad access: sector=%d, count=%d\n",
> +			 req->rq_disk->disk_name, sect_num, sect_cnt);
> +		end_request(req, 0);
> +		goto repeat;
> +	}
> +
> +	if (blk_fs_request(req)) {

Do this

	if (!blk_fs_request(req))
		return;

	switch (...) {

and you can drop the following code one intendation level down.

> +		switch (rq_data_dir(req)) {
> +		case READ:
> +			if (mg_out(host, sect_num, sect_cnt, MG_CMD_RD, &mg_read_intr) !=
> MG_ERR_NONE) {
> +				mg_bad_rw_intr(host);
> +				goto repeat;

Jumping backwards with goto does not look nice. Can you create a top 
level while statement starting from a beginning of a function, and put 
this switch case list into a separate function?

> +			}
> +			break;
> +		case WRITE:
> +			/* TODO : handler */
> +			outb(MG_REG_CTRL_INTR_DISABLE, host->dev_base + MG_REG_DRV_CTRL);
> +			if (mg_out(host, sect_num, sect_cnt, MG_CMD_WR, &mg_write_intr) !=
> MG_ERR_NONE) {
> +				mg_bad_rw_intr(host);
> +				goto repeat;
> +			}
> +			del_timer(&host->timer);
> +			mg_wait(host, MG_REG_STATUS_BIT_DATA_REQ, 3000);
> +			outb(MG_REG_CTRL_INTR_ENABLE, host->dev_base + MG_REG_DRV_CTRL);
> +			if (host->error) {
> +				mg_bad_rw_intr(host);
> +				goto repeat;
> +			}
> +			buff = (u16 *)req->buffer;
> +			for (i = 0; i < MG_SECTOR_SIZE >> 1; i++) {
> +				outw(*buff, host->dev_base + MG_BUFF_OFFSET + (i << 1));
> +				buff++;
> +			}
> +			mod_timer(&host->timer, jiffies + 3 * HZ);
> +			outb(MG_CMD_WR_CONF, host->dev_base + MG_REG_COMMAND);
> +			break;
> +		default:
> +			printk(KERN_WARNING "%s:%d unknown command\n", __func__, __LINE__);
> +			end_request(req, 0);
> +			break;
> +		}
> +	}
> +}
> +
> +static int mg_ioctl(struct block_device *bdev, fmode_t fmode,
> unsigned cmd, unsigned long arg)
> +{
> +	struct hd_geometry geo;
> +	struct mg_host *host = bdev->bd_disk->private_data;
> +
> +	switch (cmd) {
> +	case HDIO_GETGEO:

	if (cmd == HDIO_GETGEO) {
		...

> +		if (!access_ok(VERIFY_WRITE, arg, sizeof(geo))) {
> +			return -EFAULT;
> +		}
> +
> +		geo.cylinders = host->id_data.cyls;
> +		geo.heads = host->id_data.heads;
> +		geo.sectors = host->id_data.sectors;
> +		geo.start = get_start_sect(bdev);
> +
> +		if (copy_to_user((void *)arg, &geo, sizeof(geo)))
> +			return -EFAULT;
> +
> +		return 0;
> +	}
> +
> +	return -ENOTTY;
> +}

Heikki
