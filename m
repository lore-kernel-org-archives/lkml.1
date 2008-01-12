Return-Path: <linux-kernel-owner+w=401wt.eu-S1763458AbYALOOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763458AbYALOOk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 09:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756342AbYALOOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 09:14:31 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:24190 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751727AbYALOO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 09:14:29 -0500
X-Trace: 669393908/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.82.216
X-SBRS: None
X-RemoteIP: 81.1.82.216
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoXADNaiEdRAVLY/2dsb2JhbACBVoFLjjuWCw
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom CDROM drive on
	SEGA Dreamcast
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Paul Mundt <lethal@linux-sh.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080112053630.0ccb290e.akpm@linux-foundation.org>
References: <1200007549.6349.16.camel@localhost.localdomain>
	 <1200088609.6213.3.camel@localhost.localdomain>
	 <20080112053630.0ccb290e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 12 Jan 2008 14:14:01 +0000
Message-Id: <1200147241.6207.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-12 at 05:36 -0800, Andrew Morton wrote:
> On Fri, 11 Jan 2008 21:56:49 +0000 Adrian McMenamin <adrian@newgolddream.dyndns.info> wrote:
> 
> > 
> > On Thu, 2008-01-10 at 23:25 +0000, Adrian McMenamin wrote:
> > > From: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> > > 
> > > This patch adds support for the GD-Rom drive, SEGA's proprietary implementation of an IDE CD Rom for the SEGA Dreamcast. This driver implements Sega's Packet Interface (SPI) - at least partially. It will also read disks in SEGA's propreitary GD format.
> > > 
> > > Unlike previous drivers (which were never in mainline) this uses DMA and not PIO to read disks. It is a new driver, not a refactoring of old drivers. 
> > > 
> >
> > ...
> >
> > +
> > +static bool gdrom_is_busy(void)
> > +{
> > +	return (ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80) != 0;
> > +}
> > +
> > +static bool gdrom_data_request(void)
> > +{
> > + 	return (ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) == 8;
> > +}
> > +
> > +static void gdrom_wait_clrbusy(void)
> > +{
> > +	/* long timeouts - typical for a CD Rom */
> > +	unsigned long timeout = jiffies + HZ * 60;
> > +	while ((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80) && (time_before(jiffies, timeout)))
> > +		cpu_relax();
> > +}
> 
> That's a heck of a long busywait, and no indication is made to either the
> calling function or to the system operator that this funtction timed out.
> 

There is a 60 second timeout on one of the basic read fuctions in
cdrom.c, which I think is where I got this from. But the default timeout
there is 7 seconds, which I suppose I could use.


> > +static void gdrom_wait_busy_sleeps(void)
> > +{
> > +	unsigned long timeout;
> > +	/* Wait to get busy first */
> > +	timeout = jiffies + HZ * 60;
> > +	while (!gdrom_is_busy() && time_before(jiffies, timeout))
> > +		cpu_relax();
> > +	/* Now wait for busy to clear */
> > +	gdrom_wait_clrbusy();
> > +}
> 
> Ditto * 2.
> 
> > +static void gdrom_identifydevice(void *buf)
> > +{
> > +	int c;
> > +	short *data = buf;
> > +	gdrom_wait_clrbusy();
> > +	ctrl_outb(GDROM_COM_IDDEV, GDROM_STATUSCOMMAND_REG);
> > +	gdrom_wait_busy_sleeps();
> > +	/* now read in the data */
> > +	for (c = 0; c < 40; c++)
> > +		data[c] = ctrl_inw(GDROM_DATA_REG);
> > +}
> 
> Most kernel code puts a blank line after the definition of the locals and
> before start-of-code.  We don't make a big fuss over code which omits the
> blanks line but please consider.
> 
> > +static void gdrom_spicommand(void *spi_string, int buflen)
> > +{
> > +	short *cmd = spi_string;
> > +	/* ensure IRQ_WAIT is set */
> > +	ctrl_outb(0x08, GDROM_ALTSTATUS_REG);
> > +	/* specify how many bytes we expect back */
> > +	ctrl_outb(buflen & 0xFF, GDROM_BCL_REG);
> > +	ctrl_outb((buflen >> 8) & 0xFF, GDROM_BCH_REG);
> > +	/* other parameters */
> > +	ctrl_outb(0, GDROM_INTSEC_REG);
> > +	ctrl_outb(0, GDROM_SECNUM_REG);
> > +	ctrl_outb(0, GDROM_ERROR_REG);
> > +	/* Wait until we can go */
> > +	gdrom_wait_clrbusy();
> > +	ctrl_outb(GDROM_COM_PACKET, GDROM_STATUSCOMMAND_REG);
> > +	while (!gdrom_data_request())
> > +		cpu_relax();
> 
> No timeout at all here?


True enough. If the bits never cleared that would be broken hardware,
but not a reason not to catch it.

> 
> > +	outsw(PHYSADDR(GDROM_DATA_REG), cmd, 6);
> > +}
> > +

....


> > +static int gdrom_preparedisk_cmd(void)
> > +{
> > +	struct packet_command *spin_command;
> > +	spin_command = kzalloc(sizeof(struct packet_command), GFP_KERNEL);
> > +	if (!spin_command)
> > +		return -ENOMEM;
> > +	spin_command->cmd[0] = 0x70;
> > +	spin_command->cmd[2] = 0x1f;
> > +	spin_command->buflen = 0;
> > +	gd.pending = 1;
> > +	gdrom_packetcommand(gd.cd_info, spin_command);
> > +	/* 60 second timeout */
> > +	wait_event_interruptible_timeout(command_queue, gd.pending == 0, HZ * 60);
> > +	gd.pending = 0;
> > +	kfree(spin_command);
> > +	if (gd.status & 0x01) {
> > +		/* log an error */
> > +		gdrom_getsense(NULL);
> > +		return -EIO;
> > +	}
> > +	return 0;
> > +}
> 
> If the wait_event_interruptible_timeout() indeed times out, we go ahead and
> free spin_command.  But someone else could potentially be using it. 
> 
> Suppose gdrom_packetcommand() got stuck for a minute due to bad hardware,
> or some SCHED_FIFO task preempting us here and running for 61 seconds without
> yielding or something similarly weird.
> 


Maybe I am being stupid here, but I don't follow this. They'll get a
non-fatal error, that's all. Who else would be using spin_command? It's
just a series of bytes to plug into the GD Rom registers, that's all.




> > ...
> >
> > +/* keep the function looking like the universal CD Rom specification - returning int*/
> > +static int gdrom_packetcommand(struct cdrom_device_info *cd_info, struct packet_command *command)
> > +{
> > +	gdrom_spicommand(&command->cmd, command->buflen);
> > +	return 0;
> > +}
> 
> Please pass the diff through scripts/checkpatch.pl.  Some things, like the
> above, you may choose to fix.  Some you definitely will.


I did. I'll recheck it though, of course.

> 
> > +/* Get Sense SPI command
> > + * From Marcus Comstedt
> > + * cmd = 0x13
> > + * cmd + 4 = length of returned buffer
> > + * Returns 5 16 bit words
> > + */
> > +static int gdrom_getsense(short *bufstring)
> > +{
> > +	struct packet_command *sense_command;
> > +	short sense[5];
> > +	int sense_key;
> > +	if (gd.pending)
> > +		return -EIO;
> > +
> > +	/* allocate command and buffer */
> > +	sense_command = kzalloc(sizeof(struct packet_command), GFP_KERNEL);
> > +	if (!sense_command)
> > +		return -ENOMEM;
> > +
> > +	sense_command->cmd[0] = 0x13;
> > +	sense_command->cmd[4] = 10;
> > +	sense_command->buflen = 10;
> > +
> > +	gd.pending = 1;
> > +	gdrom_packetcommand(gd.cd_info, sense_command);
> > +	/* 60 second timeout */
> > +	wait_event_interruptible_timeout(command_queue, gd.pending == 0, HZ * 60);
> > +	gd.pending = 0;
> > +	kfree(sense_command);
> 
> The other thing about wait_event_interruptible_timeout() is that it is,
> err, interruptible.  If this task has signal_pending() then
> wait_event_interruptible_timeout() will return immediately.  Surely then
> there is a high risk that we'll free sense_command while someone else is
> playing with it?
> 

Again, maybe I am missing the point (quite possible), but I don't see
how this is an issue. What is mising is something to check there haven't
been timeouts earlier that mean we'll just be reading garbage out of the
registers, but I don't there is any problem about freeing this piece of
memory.


....

> > +
> > +static int __devinit gdrom_set_interrupt_handlers(void)
> > +{
> > +	int err;
> > +	init_waitqueue_head(&command_queue);
> > +	err = request_irq(HW_EVENT_GDROM_CMD, gdrom_command_interrupt, IRQF_DISABLED, "gdrom_command", &gd);
> > +	if (err)
> > +		return err;
> > +	init_waitqueue_head(&request_queue);
> 
> You can initialise command_queue and request_queue at compile-time with
> DECLARE_WAIT_QUEUE_HEAD().
> 

Are you saying that is better?

> > +	err = request_irq(HW_EVENT_GDROM_DMA, gdrom_dma_interrupt, IRQF_DISABLED, "gdrom_dma", &gd);
> > +	if (err)
> > +		free_irq(HW_EVENT_GDROM_CMD, &gd);
> > +	return err;
> > +}
> > +
> >
> > ...
> >
> > +	spin_lock(&gdrom_lock);
> > +	list_for_each_safe(elem, next, &gdrom_deferred) {
> > +		req = list_entry(elem, struct request, queuelist);
> > +		spin_unlock(&gdrom_lock);
> > +		block = req->sector/GD_TO_BLK + GD_SESSION_OFFSET;
> > +		block_cnt = req->nr_sectors/GD_TO_BLK;
> > +		ctrl_outl(PHYSADDR(req->buffer), GDROM_DMA_STARTADDR_REG);
> > +		ctrl_outl(block_cnt * GDROM_HARD_SECTOR, GDROM_DMA_LENGTH_REG);
> > +		ctrl_outl(1, GDROM_DMA_DIRECTION_REG);
> > +		ctrl_outl(1, GDROM_DMA_ENABLE_REG);
> > +		read_command->cmd[2] = (block >> 16) & 0xFF;
> > +		read_command->cmd[3] = (block >> 8) & 0xFF;
> > +		read_command->cmd[4] = block & 0xFF;
> > +		read_command->cmd[8] = (block_cnt >> 16) & 0xFF;
> > +		read_command->cmd[9] = (block_cnt >> 8) & 0xFF;
> > +		read_command->cmd[10] = block_cnt & 0xFF;
> > +		/* set for DMA */
> > +		ctrl_outb(1, GDROM_ERROR_REG);
> > +		/* other registers */
> > +		ctrl_outb(0, GDROM_SECNUM_REG);
> > +		ctrl_outb(0, GDROM_BCL_REG);
> > +		ctrl_outb(0, GDROM_BCH_REG);
> > +		ctrl_outb(0, GDROM_DSEL_REG);
> > +		ctrl_outb(0, GDROM_INTSEC_REG);
> > +		/* In multiple DMA transfers need to wait */
> > +		timeout = jiffies + HZ / 2;
> > +		while (gdrom_is_busy() && time_before(jiffies, timeout))
> > +			cpu_relax();
> > +		ctrl_outb(GDROM_COM_PACKET, GDROM_STATUSCOMMAND_REG);
> > +		timeout = jiffies + HZ / 2;
> > +		while (gdrom_is_busy() && time_before(jiffies, timeout))
> > +			cpu_relax();
> > +		gd.pending = 1;
> > +		gd.transfer = 1;
> > +		outsw(PHYSADDR(GDROM_DATA_REG), &read_command->cmd, 6);
> > +		timeout = jiffies + HZ / 2;
> > +		while (ctrl_inb(GDROM_DMA_STATUS_REG) &&
> > + 		       time_before(jiffies, timeout))
> > +			cpu_relax();
> 
> Are all these busy waits really unavoidable?


I'm afraid so.

...

> > +
> > +static void gdrom_request_handler_dma(struct request *req)
> > +{
> > +	/* dequeue, add to list of deferred work
> > + 	 * and then schedule workqueue */
> > +	blkdev_dequeue_request(req);
> > +	list_add_tail(&req->queuelist, &gdrom_deferred);
> > +	schedule_work(&work);
> > +}
> 
> Whenever a driver does schedule_work() we'd expect to see a
> flush_workqeue() somewhere in its cleanup code.  Are you sure that there is
> no possibility that this work item is still pending (or running) after
> device close, during suspend, after rmmod, etc?
> 

Good point.

