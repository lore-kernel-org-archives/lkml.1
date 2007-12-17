Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbXLQOKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbXLQOKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 09:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbXLQOKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 09:10:36 -0500
Received: from brick.kernel.dk ([87.55.233.238]:9212 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbXLQOKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 09:10:35 -0500
Date: Mon, 17 Dec 2007 15:06:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/3] Add GD-Rom support to the SEGA Dreamcast
Message-ID: <20071217140621.GA17168@kernel.dk>
References: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16 2007, Adrian McMenamin wrote:
> +static int gdrom_readdisk_dma(int block, int block_cnt, char *buffer)
> +{
> +	int err;
> +	struct packet_command *read_command;
> +	/* release the spin lock but check later
> + 	 * we're not in the middle of some dma */
> +	spin_unlock(&gdrom_lock);
> +	ctrl_outl(0x8843407F, GDROM_DMA_ACCESS_CTRL_REG); /* memory setting */
> +	ctrl_outl(9, GDROM_DMA_WAIT_REG); /* DMA word setting */
> +	ctrl_outl(PHYSADDR(buffer), GDROM_DMA_STARTADDR_REG);
> +	ctrl_outl(block_cnt * GDROM_HARD_SECTOR, GDROM_DMA_LENGTH_REG);
> +	ctrl_outl(1, GDROM_DMA_DIRECTION_REG);
> +	ctrl_outl(1, GDROM_DMA_ENABLE_REG);
> +	/* send command */
> +	read_command = kzalloc(sizeof(struct packet_command), GFP_KERNEL);
> +	if (!read_command)
> +		return -ENOMEM;
> +	read_command->cmd[0] = 0x30;
> +	read_command->cmd[1] = 0x20;
> +	read_command->cmd[2] = (block >> 16) & 0xFF;
> +	read_command->cmd[3] = (block >> 8) & 0xFF;
> +	read_command->cmd[4] = block & 0xFF;
> +	read_command->cmd[8] = (block_cnt >> 16) & 0xFF;
> +	read_command->cmd[9] = (block_cnt >> 8) & 0xFF;
> +	read_command->cmd[10] = block_cnt & 0xFF;
> +	/* set for DMA */
> +	ctrl_outb(1, GDROM_ERROR_REG);
> +	/* other parameters */
> +	ctrl_outb(0, GDROM_SECNUM_REG);
> +	ctrl_outb(0, GDROM_BCL_REG);
> +	ctrl_outb(0, GDROM_BCH_REG);
> +	ctrl_outb(0, GDROM_DSEL_REG);
> +	ctrl_outb(0, GDROM_INTSEC_REG);
> +	/* In multiple DMA transfers need to wait */
> +	while (ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80)
> +		cpu_relax();
> +	ctrl_outb(GDROM_COM_PACKET, GDROM_STATUSCOMMAND_REG);
> +	while ((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) != 8)
> +		cpu_relax(); /* wait for DRQ to be set to 1 */
> +	gd.pending = 1;
> +	gd.transfer = 1;
> +	outsw(PHYSADDR(GDROM_DATA_REG), &read_command->cmd, 6);
> +	while (ctrl_inb(GDROM_DMA_STATUS_REG))
> +		cpu_relax();
> +	ctrl_outb(1, GDROM_DMA_STATUS_REG);
> +	/* 5 second error margin here seems more reasonable */
> +	wait_event_interruptible_timeout(request_queue, gd.transfer == 0, HZ * 5);
> +	err = ctrl_inb(GDROM_DMA_STATUS_REG);
> +	err = gd.transfer;
> +	gd.transfer = 0;
> +	gd.pending = 0;
> +	kfree(read_command);
> +	spin_lock(&gdrom_lock);
> +	return err;
> +}	
> +
> +static void gdrom_request_handler_dma(struct request *req)
> +{
> +	int err, block, block_cnt;
> +	err = 0;
> +	block = req->sector/GD_TO_BLK + GD_SESSION_OFFSET;
> +	block_cnt = req->nr_sectors/GD_TO_BLK;
> +	err = gdrom_readdisk_dma(block, block_cnt, req->buffer);	
> +	if (unlikely(err)) {
> +		end_request(req, 0);
> +		spin_unlock(&gdrom_lock);
> +		gdrom_getsense(NULL);
> +		spin_lock(&gdrom_lock);
> +	}
> +	else
> +		end_request(req, 1);
> +}
> +
> +static void gdrom_request(struct request_queue *rq)
> +{
> +	struct request *req;
> +	unsigned long pages;
> +	pages = rq->backing_dev_info.ra_pages;
> +	while ((req = elv_next_request(rq)) != NULL) {
> +		if (! blk_fs_request(req)) {
> +			printk(KERN_DEBUG "GDROM: Non-fs request ignored\n");
> +			end_request(req, 0);
> +		}
> +		if (rq_data_dir(req)) {
> +			printk(KERN_NOTICE "GDROM: Read only device - write request ignored\n");
> +			end_request(req, 0);
> +		}
> +		if (req->nr_sectors) {
> +			gdrom_request_handler_dma(req);
> +		}
> +	}
> +}
> +

Few notes:

- Compare rq_data_dir() with WRITE, don't just assume that any non-zero
  will be a write.

- You need to offload this request handling to a workqueue of some sort,
  your current request handling is very broken for two reasons: One is
  that interrupts are still disabled when you drop your queue lock, so
  you cannot use sleeping functions like GFP_KERNEL allocations or
  wait_event(). The other is that it's illegal to sleep from your
  request_fn context in the first place, since you could be stalling
  others.

- You also seem to be busy waiting for other transactions to finish. Any
  idea how long those might take? Perhaps put an upper bound on this
  waiting, and/or do blocking waits?

- I'm assuming this hardware can't do sg transfers?

-- 
Jens Axboe

