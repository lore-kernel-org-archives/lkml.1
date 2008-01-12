Return-Path: <linux-kernel-owner+w=401wt.eu-S1763230AbYALNgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763230AbYALNgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 08:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYALNgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 08:36:32 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbYALNgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 08:36:31 -0500
Date: Sat, 12 Jan 2008 05:36:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Jens Axboe <jens.axboe@oracle.com>, Paul Mundt <lethal@linux-sh.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom CDROM drive on
 SEGA Dreamcast
Message-Id: <20080112053630.0ccb290e.akpm@linux-foundation.org>
In-Reply-To: <1200088609.6213.3.camel@localhost.localdomain>
References: <1200007549.6349.16.camel@localhost.localdomain>
	<1200088609.6213.3.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 21:56:49 +0000 Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:

> 
> On Thu, 2008-01-10 at 23:25 +0000, Adrian McMenamin wrote:
> > From: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> > 
> > This patch adds support for the GD-Rom drive, SEGA's proprietary implementation of an IDE CD Rom for the SEGA Dreamcast. This driver implements Sega's Packet Interface (SPI) - at least partially. It will also read disks in SEGA's propreitary GD format.
> > 
> > Unlike previous drivers (which were never in mainline) this uses DMA and not PIO to read disks. It is a new driver, not a refactoring of old drivers. 
> > 
>
> ...
>
> +
> +static bool gdrom_is_busy(void)
> +{
> +	return (ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80) != 0;
> +}
> +
> +static bool gdrom_data_request(void)
> +{
> + 	return (ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) == 8;
> +}
> +
> +static void gdrom_wait_clrbusy(void)
> +{
> +	/* long timeouts - typical for a CD Rom */
> +	unsigned long timeout = jiffies + HZ * 60;
> +	while ((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80) && (time_before(jiffies, timeout)))
> +		cpu_relax();
> +}

That's a heck of a long busywait, and no indication is made to either the
calling function or to the system operator that this funtction timed out.

> +static void gdrom_wait_busy_sleeps(void)
> +{
> +	unsigned long timeout;
> +	/* Wait to get busy first */
> +	timeout = jiffies + HZ * 60;
> +	while (!gdrom_is_busy() && time_before(jiffies, timeout))
> +		cpu_relax();
> +	/* Now wait for busy to clear */
> +	gdrom_wait_clrbusy();
> +}

Ditto * 2.

> +static void gdrom_identifydevice(void *buf)
> +{
> +	int c;
> +	short *data = buf;
> +	gdrom_wait_clrbusy();
> +	ctrl_outb(GDROM_COM_IDDEV, GDROM_STATUSCOMMAND_REG);
> +	gdrom_wait_busy_sleeps();
> +	/* now read in the data */
> +	for (c = 0; c < 40; c++)
> +		data[c] = ctrl_inw(GDROM_DATA_REG);
> +}

Most kernel code puts a blank line after the definition of the locals and
before start-of-code.  We don't make a big fuss over code which omits the
blanks line but please consider.

> +static void gdrom_spicommand(void *spi_string, int buflen)
> +{
> +	short *cmd = spi_string;
> +	/* ensure IRQ_WAIT is set */
> +	ctrl_outb(0x08, GDROM_ALTSTATUS_REG);
> +	/* specify how many bytes we expect back */
> +	ctrl_outb(buflen & 0xFF, GDROM_BCL_REG);
> +	ctrl_outb((buflen >> 8) & 0xFF, GDROM_BCH_REG);
> +	/* other parameters */
> +	ctrl_outb(0, GDROM_INTSEC_REG);
> +	ctrl_outb(0, GDROM_SECNUM_REG);
> +	ctrl_outb(0, GDROM_ERROR_REG);
> +	/* Wait until we can go */
> +	gdrom_wait_clrbusy();
> +	ctrl_outb(GDROM_COM_PACKET, GDROM_STATUSCOMMAND_REG);
> +	while (!gdrom_data_request())
> +		cpu_relax();

No timeout at all here?

> +	outsw(PHYSADDR(GDROM_DATA_REG), cmd, 6);
> +}
> +
> +/* gdrom_command_executediagnostic:
> + * Used to probe for presence of working GDROM
> + * Restarts GDROM device and then applies standard ATA 3
> + * Execute Diagnostic Command: a return of '1' indicates device 0
> + * present and device 1 absent
> + */
> +static char gdrom_execute_diagnostic(void)
> +{
> +	gdrom_hardreset(gd.cd_info);
> +	gdrom_wait_clrbusy();
> +	ctrl_outb(GDROM_COM_EXECDIAG, GDROM_STATUSCOMMAND_REG);
> +	gdrom_wait_busy_sleeps();
> +	return ctrl_inb(GDROM_ERROR_REG);
> +}

So this function can busywait for three minutes.

> +/*
> + * Prepare disk command
> + * byte 0 = 0x70
> + * byte 1 = 0x1f
> + */
> +static int gdrom_preparedisk_cmd(void)
> +{
> +	struct packet_command *spin_command;
> +	spin_command = kzalloc(sizeof(struct packet_command), GFP_KERNEL);
> +	if (!spin_command)
> +		return -ENOMEM;
> +	spin_command->cmd[0] = 0x70;
> +	spin_command->cmd[2] = 0x1f;
> +	spin_command->buflen = 0;
> +	gd.pending = 1;
> +	gdrom_packetcommand(gd.cd_info, spin_command);
> +	/* 60 second timeout */
> +	wait_event_interruptible_timeout(command_queue, gd.pending == 0, HZ * 60);
> +	gd.pending = 0;
> +	kfree(spin_command);
> +	if (gd.status & 0x01) {
> +		/* log an error */
> +		gdrom_getsense(NULL);
> +		return -EIO;
> +	}
> +	return 0;
> +}

If the wait_event_interruptible_timeout() indeed times out, we go ahead and
free spin_command.  But someone else could potentially be using it. 

Suppose gdrom_packetcommand() got stuck for a minute due to bad hardware,
or some SCHED_FIFO task preempting us here and running for 61 seconds without
yielding or something similarly weird.

> +/*
> + * Read TOC command
> + * byte 0 = 0x14
> + * byte 1 = session
> + * byte 3 = sizeof TOC >> 8  ie upper byte
> + * byte 4 = sizeof TOC & 0xff ie lower byte
> + */
> +static int gdrom_readtoc_cmd(struct gdromtoc *toc, int session)
> +{
> +	int tocsize;
> +	struct packet_command *toc_command;
> +	toc_command = kzalloc(sizeof(struct packet_command), GFP_KERNEL);
> +	if (!toc_command)
> +		return -ENOMEM;
> +	tocsize = sizeof(struct gdromtoc);
> +	toc_command->cmd[0] = 0x14;
> +	toc_command->cmd[1] = session;
> +	toc_command->cmd[3] = tocsize >> 8;
> +	toc_command->cmd[4] = tocsize & 0xff;
> +	toc_command->buflen = tocsize;
> +	gd.pending = 1;
> +	gdrom_packetcommand(gd.cd_info, toc_command);
> +	wait_event_interruptible_timeout(command_queue, gd.pending == 0, HZ * 60);
> +	gd.pending = 0;
> +	insw(PHYSADDR(GDROM_DATA_REG), toc, tocsize/2);
> +	kfree(toc_command);
> +	if (gd.status & 0x01)
> +		return -EINVAL;
> +	return 0;
> +}

Ditto.

>
> ...
>
> +/* keep the function looking like the universal CD Rom specification - returning int*/
> +static int gdrom_packetcommand(struct cdrom_device_info *cd_info, struct packet_command *command)
> +{
> +	gdrom_spicommand(&command->cmd, command->buflen);
> +	return 0;
> +}

Please pass the diff through scripts/checkpatch.pl.  Some things, like the
above, you may choose to fix.  Some you definitely will.

> +/* Get Sense SPI command
> + * From Marcus Comstedt
> + * cmd = 0x13
> + * cmd + 4 = length of returned buffer
> + * Returns 5 16 bit words
> + */
> +static int gdrom_getsense(short *bufstring)
> +{
> +	struct packet_command *sense_command;
> +	short sense[5];
> +	int sense_key;
> +	if (gd.pending)
> +		return -EIO;
> +
> +	/* allocate command and buffer */
> +	sense_command = kzalloc(sizeof(struct packet_command), GFP_KERNEL);
> +	if (!sense_command)
> +		return -ENOMEM;
> +
> +	sense_command->cmd[0] = 0x13;
> +	sense_command->cmd[4] = 10;
> +	sense_command->buflen = 10;
> +
> +	gd.pending = 1;
> +	gdrom_packetcommand(gd.cd_info, sense_command);
> +	/* 60 second timeout */
> +	wait_event_interruptible_timeout(command_queue, gd.pending == 0, HZ * 60);
> +	gd.pending = 0;
> +	kfree(sense_command);

The other thing about wait_event_interruptible_timeout() is that it is,
err, interruptible.  If this task has signal_pending() then
wait_event_interruptible_timeout() will return immediately.  Surely then
there is a high risk that we'll free sense_command while someone else is
playing with it?

> +	insw(PHYSADDR(GDROM_DATA_REG), &sense, 5);
> +	if (sense[1] & 40) {
> +		printk(KERN_INFO "GDROM: Drive not ready - command aborted\n");
> +		return -EIO;
> +	}
> +	sense_key = sense[1] & 0x0F;
> +	if (sense_key < ARRAY_SIZE(sense_texts))
> + 		printk(KERN_INFO "GDROM: %s\n", sense_texts[sense_key].text);
> + 	else
> + 		printk(KERN_ERR "GDROM: Unknown sense key: %d\n", sense_key);
> +  
> + 	if (bufstring)			/* return additional sense data */
> +		memcpy(bufstring, &sense[4], 2); /* return additional sense data */
> +
> +	if (sense_key < 2)
> +		return 0;
> +	return -EIO;
> +}
> +
>
> ...
>
> +
> +static int __devinit gdrom_set_interrupt_handlers(void)
> +{
> +	int err;
> +	init_waitqueue_head(&command_queue);
> +	err = request_irq(HW_EVENT_GDROM_CMD, gdrom_command_interrupt, IRQF_DISABLED, "gdrom_command", &gd);
> +	if (err)
> +		return err;
> +	init_waitqueue_head(&request_queue);

You can initialise command_queue and request_queue at compile-time with
DECLARE_WAIT_QUEUE_HEAD().

> +	err = request_irq(HW_EVENT_GDROM_DMA, gdrom_dma_interrupt, IRQF_DISABLED, "gdrom_dma", &gd);
> +	if (err)
> +		free_irq(HW_EVENT_GDROM_CMD, &gd);
> +	return err;
> +}
> +
>
> ...
>
> +	spin_lock(&gdrom_lock);
> +	list_for_each_safe(elem, next, &gdrom_deferred) {
> +		req = list_entry(elem, struct request, queuelist);
> +		spin_unlock(&gdrom_lock);
> +		block = req->sector/GD_TO_BLK + GD_SESSION_OFFSET;
> +		block_cnt = req->nr_sectors/GD_TO_BLK;
> +		ctrl_outl(PHYSADDR(req->buffer), GDROM_DMA_STARTADDR_REG);
> +		ctrl_outl(block_cnt * GDROM_HARD_SECTOR, GDROM_DMA_LENGTH_REG);
> +		ctrl_outl(1, GDROM_DMA_DIRECTION_REG);
> +		ctrl_outl(1, GDROM_DMA_ENABLE_REG);
> +		read_command->cmd[2] = (block >> 16) & 0xFF;
> +		read_command->cmd[3] = (block >> 8) & 0xFF;
> +		read_command->cmd[4] = block & 0xFF;
> +		read_command->cmd[8] = (block_cnt >> 16) & 0xFF;
> +		read_command->cmd[9] = (block_cnt >> 8) & 0xFF;
> +		read_command->cmd[10] = block_cnt & 0xFF;
> +		/* set for DMA */
> +		ctrl_outb(1, GDROM_ERROR_REG);
> +		/* other registers */
> +		ctrl_outb(0, GDROM_SECNUM_REG);
> +		ctrl_outb(0, GDROM_BCL_REG);
> +		ctrl_outb(0, GDROM_BCH_REG);
> +		ctrl_outb(0, GDROM_DSEL_REG);
> +		ctrl_outb(0, GDROM_INTSEC_REG);
> +		/* In multiple DMA transfers need to wait */
> +		timeout = jiffies + HZ / 2;
> +		while (gdrom_is_busy() && time_before(jiffies, timeout))
> +			cpu_relax();
> +		ctrl_outb(GDROM_COM_PACKET, GDROM_STATUSCOMMAND_REG);
> +		timeout = jiffies + HZ / 2;
> +		while (gdrom_is_busy() && time_before(jiffies, timeout))
> +			cpu_relax();
> +		gd.pending = 1;
> +		gd.transfer = 1;
> +		outsw(PHYSADDR(GDROM_DATA_REG), &read_command->cmd, 6);
> +		timeout = jiffies + HZ / 2;
> +		while (ctrl_inb(GDROM_DMA_STATUS_REG) &&
> + 		       time_before(jiffies, timeout))
> +			cpu_relax();

Are all these busy waits really unavoidable?

> +		ctrl_outb(1, GDROM_DMA_STATUS_REG);
> +		/* 5 second error margin here seems more reasonable */
> +		wait_event_interruptible_timeout(request_queue, gd.transfer == 0, HZ * 5);
> +		err = gd.transfer;
> +		gd.transfer = 0;
> +		gd.pending = 0;
> +		/* now seek to take the request spinlock
> + 		 * before handling ending the request */
> +		spin_lock(&gdrom_lock);
> +		list_del_init(&req->queuelist);
> +		end_dequeued_request(req, 1 - err);
> +	}
> +	spin_unlock(&gdrom_lock);
> +	kfree(read_command);
> +}
> +
> +static void gdrom_request_handler_dma(struct request *req)
> +{
> +	/* dequeue, add to list of deferred work
> + 	 * and then schedule workqueue */
> +	blkdev_dequeue_request(req);
> +	list_add_tail(&req->queuelist, &gdrom_deferred);
> +	schedule_work(&work);
> +}

Whenever a driver does schedule_work() we'd expect to see a
flush_workqeue() somewhere in its cleanup code.  Are you sure that there is
no possibility that this work item is still pending (or running) after
device close, during suspend, after rmmod, etc?


