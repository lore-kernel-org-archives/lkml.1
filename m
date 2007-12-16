Return-Path: <linux-kernel-owner+w=401wt.eu-S1765497AbXLPJup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765497AbXLPJup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 04:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbXLPJud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 04:50:33 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:22895 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755049AbXLPJua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 04:50:30 -0500
Date: Sun, 16 Dec 2007 18:50:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-sh@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 2/3] Add GD-Rom support to the SEGA Dreamcast
Message-ID: <20071216095019.GA12184@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-sh@vger.kernel.org, axboe@kernel.dk
References: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I don't know anything about the CD-ROM layer, so I've just commented
on the general and SH-specific stuff. Hopefully someone with a clue
in this area (ie, not me) can offer input on the rest of the bits.

On Sun, Dec 16, 2007 at 12:21:21AM +0000, Adrian McMenamin wrote:
> +/* GD Rom registers */
> +#define GDROM_BASE_REG 0xA05F7000
> +#define GDROM_ALTSTATUS_REG GDROM_BASE_REG + 0x18
> +#define GDROM_DATA_REG GDROM_BASE_REG + 0x80
> +#define GDROM_ERROR_REG GDROM_BASE_REG + 0x84
> +#define GDROM_INTSEC_REG GDROM_BASE_REG + 0x88
> +#define GDROM_SECNUM_REG GDROM_BASE_REG + 0x8C
> +#define GDROM_BCL_REG  GDROM_BASE_REG + 0x90
> +#define GDROM_BCH_REG GDROM_BASE_REG + 0x94
> +#define GDROM_DSEL_REG GDROM_BASE_REG + 0x98
> +#define GDROM_STATUSCOMMAND_REG GDROM_BASE_REG + 0x9C
> +#define GDROM_RESET_REG GDROM_BASE_REG + 0x4E4
> +
> +#define GDROM_DATA_REG_P0 0x005F7080
> +
> +#define GDROM_DMA_STARTADDR_REG GDROM_BASE_REG + 0x404
> +#define GDROM_DMA_LENGTH_REG GDROM_BASE_REG + 0x408
> +#define GDROM_DMA_DIRECTION_REG GDROM_BASE_REG + 0x40C
> +#define GDROM_DMA_ENABLE_REG GDROM_BASE_REG + 0x414
> +#define GDROM_DMA_STATUS_REG GDROM_BASE_REG + 0x418
> +#define GDROM_DMA_WAIT_REG GDROM_BASE_REG + 0x4A0
> +#define GDROM_DMA_ACCESS_CTRL_REG GDROM_BASE_REG + 0x4B8
> +
These should all be encapsulated by brackets.

> +static void wait_clrbusy(void)
> +{
> +	while (ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80)
> +		schedule();
> +}
> +	
> +static void gdrom_wait_busy_sleeps(void)
> +{
> +	/* Wait to get busy first */
> +	while ((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80) == 0)
> +		schedule();
> +	/* Now wait for busy to clear */
> +	wait_clrbusy();
> +}		
> +
Are you sure you can tolerate a schedule() in here, as opposed to a
cpu_relax()? If you're going to schedule away whilst polling a bit, you
may as well just use a wait queue and wait_on_bit() or so. This seems
like a lot of extra latency for this though.

> +static void gdrom_spicommand(void *spi_string, int buflen)
> +{
> +	short *cmd = spi_string;
[snip]

> +	wait_clrbusy();
> +	ctrl_outb(GDROM_COM_PACKET, GDROM_STATUSCOMMAND_REG);
> +	while ((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) != 8)
> +		; /* wait for DRQ to be set to 1 */
cpu_relax()

> +static char gdrom_execute_diagnostic(void)
> +{
> +	int count;
> +	/* Restart the GDROM */
> +	ctrl_outl(0x1fffff, GDROM_RESET_REG);
> +	for (count = 0xa0000000; count < 0xa0200000; count += 4)
> +		ctrl_inl(count);

Er? This ranged dummy reading of the P2 space needs some explanation. The
GD-ROM isn't even mapped in to this space, so this seems like a hack to
either work around a timing issue or a write ordering problem.

> +static int gdrom_get_last_session(struct cdrom_device_info *cd_info,
> struct cdrom_multisession *ms_info)
> +{
[snip]

> +		}	
> +	}
> +	else

Questionable placement of else.

> +		printk(KERN_DEBUG "Disk is GDROM\n");
> +	if (gd.toc)
> +		kfree(gd.toc);

Useless if.

> +	gd.toc = kzalloc(sizeof(struct gdromtoc), GFP_KERNEL);
> +	if (!gd.toc) {
> +		err = -ENOMEM;
> +		goto clean_tocB;
> +	}
> +		if (tocuse)

Broken indendation.

> +static int gdrom_open(struct cdrom_device_info *cd_info, int purpose)
> +{
> +	int err;
> +	/* spin up the disk */
> +	err = gdrom_preparedisk_cmd();
> +	if (err)
> +		return -EIO;
> +	
> +	return 0;

Perhaps gdrom_preparedisk_cmd() should just hand back -EIO in the error
case and you can just pass that on directly. If you have no other users
of it, then just move the work in to the gdrom_open() directly.

> +static void gdrom_release(struct cdrom_device_info *cd_info)
> +{
> +}
> +
Do you really need this? If this is some sort of driver model damage, a
comment to that extent would be helpful, otherwise just kill this off.

> +static int gdrom_mediachanged(struct cdrom_device_info *cd_info, int ignore)
> +{
> +	/* check the sense key */
> +	char sense = ctrl_inb(GDROM_ERROR_REG);
> +	if ((sense & 0xF0) == 0x60)
> +		return 1;
> +	return 0;
> +}
> +
Just return (ctrl_inb(GDROM_ERROR_REG) & 0xf0) == 0x60 ?

> +static int gdrom_hardreset(struct cdrom_device_info * cd_info)
> +{
> +	int count;
> +	ctrl_outl(0x1fffff, GDROM_RESET_REG);
> +	for (count = 0xa0000000; count < 0xa0200000; count += 4)
> +		ctrl_inl(count);
> +	return 0;
> +}
> +
More strange P2 abuse. If this is the officially recommended reset
method in the GD-ROM errat^H^H^H^Hspecification, it paints a pretty good
picture of its commercial success.

> +	if (bufstring){
> +		memcpy(bufstring, &sense[4], 2); /* return additional sense data */
> +	}
> +
Useless braces.

> +	if (sense_key < 2)
> +		return 0;
> +	return -EIO;
> +}
> +	
> +static struct cdrom_device_ops gdrom_ops = {
> +	.open			= gdrom_open,
> +	.release		= gdrom_release,
> +	.drive_status		= gdrom_drivestatus,
> +	.media_changed		= gdrom_mediachanged,
> +	.tray_move		= NULL,
> +	.lock_door		= NULL,
> +	.select_speed		= NULL,
> +	.get_last_session	= gdrom_get_last_session,
> +	.get_mcn		= NULL,
> +	.reset			= gdrom_hardreset,
> +	.audio_ioctl		= NULL,
> +	.capability		= CDC_MULTI_SESSION | CDC_MEDIA_CHANGED |
> +				  CDC_RESET | CDC_DRIVE_STATUS | CDC_CD_R,
> +	.generic_packet		= NULL,
> +	.n_minors		= 1,
> +};
> +
You can kill off the NULL entries. We stopped initializing every
structure element some time between 2.0 and 2.2, lets not bring it back.

> +int gdrom_bdops_open(struct inode *inode, struct file *file)
> +{
> +	return cdrom_open(gd.cd_info, inode, file);
> +}
> +
> +int gdrom_bdops_release(struct inode *inode, struct file *file)
> +{
> +	return cdrom_release(gd.cd_info, file);
> +}
> +
> +int gdrom_bdops_mediachanged(struct gendisk *disk)
> +{
> +	return cdrom_media_changed(gd.cd_info);
> +}
> +
These should be static?

> +static irqreturn_t gdrom_command_interrupt(int irq, void *dev_id)
> +{
> +	if (dev_id != &gd)
> +		return IRQ_NONE;

You aren't setting this up as a shared IRQ, so this shouldn't be
necessary.

> +static int gdrom_readdisk_dma(int block, int block_cnt, char *buffer)
> +{
> +	int err;
> +	struct packet_command *read_command;
> +	/* release the spin lock but check later
> + 	 * we're not in the middle of some dma */
> +	spin_unlock(&gdrom_lock);

The locking strategy here is a bit interesting, has spinlock debugging
tossed any profanities to your console?

> +static void gdrom_request_handler_dma(struct request *req)
> +{
[snip]

> +	}
> +	else
> +		end_request(req, 1);

Another magical else.

> +/* Print string identifying GD ROM device */
> +static void gdrom_outputversion(void)
> +{
> +	struct gdrom_id *id;
> +	char *model_name, *manuf_name, *firmw_ver;
> +	/* query device ID */
> +	id = kzalloc(sizeof(struct gdrom_id), GFP_KERNEL);
> +	gdrom_identifydevice(id);
> +	model_name = kmalloc(17, GFP_KERNEL);
> +	manuf_name = kmalloc(17, GFP_KERNEL);
> +	firmw_ver = kmalloc(17, GFP_KERNEL);
> +	snprintf(model_name, 16, id->modname);
> +	snprintf(manuf_name, 16, id->mname);
> +	snprintf(firmw_ver, 16, id->firmver);

kstrdup is your friend. Incidentally, error checking and kfree() in the
error paths could also be considered close acquaintances.

> +/* set the default mode for DMA transfer */
> +static void gdrom_init_dma_mode(void)
> +{
> +	ctrl_outb(0x13, GDROM_ERROR_REG);
> +	ctrl_outb(0x22, GDROM_INTSEC_REG);
> +	wait_clrbusy();
> +	ctrl_outb(0xEF, GDROM_STATUSCOMMAND_REG);
> +	gdrom_wait_busy_sleeps();

Also, why dos your wait_clrbusy() not have a gdrom_ prefix()? They seem
to be always used together.

> +static int __init probe_gdrom(struct platform_device *devptr)
> +{
[snip]

> +probe_fail_requestq:
> +	free_irq(HW_EVENT_GDROM_DMA, &gd);
> +probe_fail_dmairq_register:
> +	free_irq(HW_EVENT_GDROM_CMD, &gd);
> +probe_fail_cmdirq_register:
> +probe_fail_cdrom_register:
> +	del_gendisk(gd.disk);
> +probe_fail_no_disk:
> +	kfree(gd.cd_info);
> +	unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
> +	gdrom_major = 0;
> +probe_fail_no_mem:
> +	printk(KERN_WARNING "GDROM: Could not probe for device - error is
> 0x%X\n", err);
> +	return err;
> +}
> +
> +static int remove_gdrom(struct platform_device *devptr)
> +{
> +	return unregister_cdrom(gd.cd_info);

I can't help but notice that your probe error path and remove path have
absolutely nothing in common, and the amount of work done in one does not
match the other. If this is intentional, a comment would be useful.

Also, __devinit/__devexit annotations?

> +static struct platform_driver gdrom_driver = {
> +	.probe = probe_gdrom,
> +	.remove = remove_gdrom,

__devexit_p()?

> +static void __exit exit_gdrom(void)
> +{
> +	blk_cleanup_queue(gd.gdrom_rq);
> +	free_irq(HW_EVENT_GDROM_CMD, &gd);
> +	free_irq(HW_EVENT_GDROM_DMA, &gd);
> +	del_gendisk(gd.disk);
> +	if (gdrom_major)
> +		unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
> +	platform_device_unregister(pd);
> +	platform_driver_unregister(&gdrom_driver);
> +	if (gd.toc)
> +		kfree(gd.toc);
> +}
> +
Ah, here's where you do the rest of the cleanup. This is non-intuitive,
remove should balance the work done by probe and exit the work done by
init.
