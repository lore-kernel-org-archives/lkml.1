Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbZBKGgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbZBKGgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 01:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbZBKGg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 01:36:28 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:62720 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZBKGg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 01:36:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=xV63X4JX/lRCPQ5yEXtocUgAl0AIRh/APKPI63aUnNBlPEkZ+/ou071UtpUKUcR3B9
         hH4OcKBqHmGIjDoe0HL3bsy70US7qaq4ENlXZrHJ7yrqR0EWh7lnplep/rw9J1pRcDZW
         XxJQcaaOLYkj7dcB2rYYRgsnf0wu1HgH0sJJ4=
Date: Wed, 11 Feb 2009 07:36:23 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ide: pass command to ide_map_sg()
Message-ID: <20090211063623.GB937@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090209231945.32406.14874.sendpatchset@localhost.localdomain> <20090209231952.32406.58013.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090209231952.32406.58013.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 12:19:52AM +0100, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: pass command to ide_map_sg()
> 
> * Set IDE_TFLAG_WRITE flag and ->rq also for ATA_CMD_PACKET
>   commands.
> 
> * Pass command to ->dma_setup method and update all its
>   implementations accordingly.
> 
> * Pass command instead of request to ide_build_sglist(),
>   *_build_dmatable() and ide_map_sg().
> 
> While at it:
> 
> * Fix scc_dma_setup() documentation + use ATA_DMA_WR define.
> 
> * Rename sgiioc4_build_dma_table() to sgiioc4_build_dmatable(),
>   change return value type to 'int' and drop unused 'ddir'
>   argument.
> 
> * Do some minor cleanups in [tx4939]ide_dma_setup().
> 
> There should be no functional changes caused by this patch.
> 
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/alim15x3.c     |    7 ++++---
>  drivers/ide/au1xxx-ide.c   |   15 ++++++---------
>  drivers/ide/icside.c       |    7 +++----
>  drivers/ide/ide-atapi.c    |   16 ++++++++++++----
>  drivers/ide/ide-disk.c     |   10 +++++-----
>  drivers/ide/ide-dma-sff.c  |   18 +++++++++---------
>  drivers/ide/ide-dma.c      |   15 +++++++--------
>  drivers/ide/ide-floppy.c   |    6 +++++-
>  drivers/ide/ide-io.c       |    6 +++---
>  drivers/ide/ide-taskfile.c |    4 ++--
>  drivers/ide/ns87415.c      |    4 ++--
>  drivers/ide/pmac.c         |   19 ++++++++-----------
>  drivers/ide/scc_pata.c     |   19 +++++++------------
>  drivers/ide/sgiioc4.c      |   21 +++++++--------------
>  drivers/ide/trm290.c       |   10 +++++-----
>  drivers/ide/tx4939ide.c    |   26 ++++++++++----------------
>  include/linux/ide.h        |   12 ++++++------
>  17 files changed, 101 insertions(+), 114 deletions(-)
> 
> Index: b/drivers/ide/alim15x3.c
> ===================================================================
> --- a/drivers/ide/alim15x3.c
> +++ b/drivers/ide/alim15x3.c
> @@ -191,17 +191,18 @@ static void ali_set_dma_mode(ide_drive_t
>  /**
>   *	ali15x3_dma_setup	-	begin a DMA phase
>   *	@drive:	target device
> + *	@cmd: command
>   *
>   *	Returns 1 if the DMA cannot be performed, zero on success.
>   */
>  
> -static int ali15x3_dma_setup(ide_drive_t *drive)
> +static int ali15x3_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
>  {
>  	if (m5229_revision < 0xC2 && drive->media != ide_disk) {
> -		if (rq_data_dir(drive->hwif->rq))
> +		if (cmd->tf_flags & IDE_TFLAG_WRITE)
>  			return 1;	/* try PIO instead of DMA */
>  	}
> -	return ide_dma_setup(drive);
> +	return ide_dma_setup(drive, cmd);
>  }
>  
>  /**
> Index: b/drivers/ide/au1xxx-ide.c
> ===================================================================
> --- a/drivers/ide/au1xxx-ide.c
> +++ b/drivers/ide/au1xxx-ide.c
> @@ -209,15 +209,14 @@ static void auide_set_dma_mode(ide_drive
>   */
>  
>  #ifdef CONFIG_BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
> -static int auide_build_dmatable(ide_drive_t *drive)
> +static int auide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
>  {
>  	ide_hwif_t *hwif = drive->hwif;
> -	struct request *rq = hwif->rq;
>  	_auide_hwif *ahwif = &auide_hwif;
>  	struct scatterlist *sg;
> -	int i = hwif->cmd.sg_nents, iswrite, count = 0;
> +	int i = cmd->sg_nents, count = 0;
> +	int iswrite = !!(cmd->tf_flags & IDE_TFLAG_WRITE);
>  
> -	iswrite = (rq_data_dir(rq) == WRITE);
>  	/* Save for interrupt context */
>  	ahwif->drive = drive;
>  
> @@ -298,12 +297,10 @@ static void auide_dma_exec_cmd(ide_drive
>  			    (2*WAIT_CMD), NULL);
>  }
>  
> -static int auide_dma_setup(ide_drive_t *drive)
> +static int auide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
>  {
> -	struct request *rq = drive->hwif->rq;
> -
> -	if (!auide_build_dmatable(drive)) {
> -		ide_map_sg(drive, rq);
> +	if (auide_build_dmatable(drive, cmd) == 0) {
> +		ide_map_sg(drive, cmd);
>  		return 1;
>  	}
>  
> Index: b/drivers/ide/icside.c
> ===================================================================
> --- a/drivers/ide/icside.c
> +++ b/drivers/ide/icside.c
> @@ -307,15 +307,14 @@ static void icside_dma_start(ide_drive_t
>  	enable_dma(ec->dma);
>  }
>  
> -static int icside_dma_setup(ide_drive_t *drive)
> +static int icside_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
>  {
>  	ide_hwif_t *hwif = drive->hwif;
>  	struct expansion_card *ec = ECARD_DEV(hwif->dev);
>  	struct icside_state *state = ecard_get_drvdata(ec);
> -	struct request *rq = hwif->rq;
>  	unsigned int dma_mode;
>  
> -	if (rq_data_dir(rq))
> +	if (cmd->tf_flags & IDE_TFLAG_WRITE)
>  		dma_mode = DMA_MODE_WRITE;
>  	else
>  		dma_mode = DMA_MODE_READ;
> @@ -344,7 +343,7 @@ static int icside_dma_setup(ide_drive_t 
>  	 * Tell the DMA engine about the SG table and
>  	 * data direction.
>  	 */
> -	set_dma_sg(ec->dma, hwif->sg_table, hwif->cmd.sg_nents);
> +	set_dma_sg(ec->dma, hwif->sg_table, cmd->sg_nents);
>  	set_dma_mode(ec->dma, dma_mode);
>  
>  	drive->waiting_for_dma = 1;
> Index: b/drivers/ide/ide-atapi.c
> ===================================================================
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c
> @@ -626,12 +626,20 @@ ide_startstop_t ide_issue_pc(ide_drive_t
>  {
>  	struct ide_atapi_pc *pc;
>  	ide_hwif_t *hwif = drive->hwif;
> +	const struct ide_dma_ops *dma_ops = hwif->dma_ops;
> +	struct ide_cmd *cmd = &hwif->cmd;
>  	ide_expiry_t *expiry = NULL;
>  	struct request *rq = hwif->rq;
>  	unsigned int timeout;
>  	u32 tf_flags;
>  	u16 bcount;
>  
> +	if (drive->media != ide_floppy) {
> +		if (rq_data_dir(rq))
> +			cmd->tf_flags |= IDE_TFLAG_WRITE;
> +		cmd->rq = rq;
> +	}
> +
>  	if (dev_is_idecd(drive)) {
>  		tf_flags = IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL;
>  		bcount = ide_cd_get_xferlen(rq);
> @@ -639,8 +647,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t
>  		timeout = ATAPI_WAIT_PC;
>  
>  		if (drive->dma) {
> -			if (ide_build_sglist(drive, rq))
> -				drive->dma = !hwif->dma_ops->dma_setup(drive);
> +			if (ide_build_sglist(drive, cmd))
> +				drive->dma = !dma_ops->dma_setup(drive, cmd);
>  			else
>  				drive->dma = 0;
>  		}
> @@ -663,8 +671,8 @@ ide_startstop_t ide_issue_pc(ide_drive_t
>  
>  		if ((pc->flags & PC_FLAG_DMA_OK) &&
>  		     (drive->dev_flags & IDE_DFLAG_USING_DMA)) {
> -			if (ide_build_sglist(drive, rq))
> -				drive->dma = !hwif->dma_ops->dma_setup(drive);
> +			if (ide_build_sglist(drive, cmd))
> +				drive->dma = !dma_ops->dma_setup(drive, cmd);
>  			else
>  				drive->dma = 0;
>  		}
> Index: b/drivers/ide/ide-disk.c
> ===================================================================
> --- a/drivers/ide/ide-disk.c
> +++ b/drivers/ide/ide-disk.c
> @@ -99,11 +99,6 @@ static ide_startstop_t __ide_do_rw_disk(
>  	memset(&cmd, 0, sizeof(cmd));
>  	cmd.tf_flags = IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
>  
> -	if (dma == 0) {
> -		ide_init_sg_cmd(&cmd, nsectors);
> -		ide_map_sg(drive, rq);
> -	}
> -
>  	if (drive->dev_flags & IDE_DFLAG_LBA) {
>  		if (lba48) {
>  			pr_debug("%s: LBA=0x%012llx\n", drive->name,
> @@ -156,6 +151,11 @@ static ide_startstop_t __ide_do_rw_disk(
>  	ide_tf_set_cmd(drive, &cmd, dma);
>  	cmd.rq = rq;
>  
> +	if (dma == 0) {
> +		ide_init_sg_cmd(&cmd, nsectors);
> +		ide_map_sg(drive, &cmd);
> +	}
> +
>  	rc = do_rw_taskfile(drive, &cmd);
>  
>  	if (rc == ide_stopped && dma) {
> Index: b/drivers/ide/ide-dma-sff.c
> ===================================================================
> --- a/drivers/ide/ide-dma-sff.c
> +++ b/drivers/ide/ide-dma-sff.c
> @@ -111,7 +111,7 @@ EXPORT_SYMBOL_GPL(ide_dma_host_set);
>   *	May also be invoked from trm290.c
>   */
>  
> -int ide_build_dmatable(ide_drive_t *drive, struct request *rq)
> +int ide_build_dmatable(ide_drive_t *drive, struct ide_cmd *cmd)
>  {
>  	ide_hwif_t *hwif = drive->hwif;
>  	__le32 *table = (__le32 *)hwif->dmatable_cpu;
> @@ -120,7 +120,7 @@ int ide_build_dmatable(ide_drive_t *driv
>  	struct scatterlist *sg;
>  	u8 is_trm290 = !!(hwif->host_flags & IDE_HFLAG_TRM290);
>  
> -	for_each_sg(hwif->sg_table, sg, hwif->cmd.sg_nents, i) {
> +	for_each_sg(hwif->sg_table, sg, cmd->sg_nents, i) {
>  		u32 cur_addr, cur_len, xcount, bcount;
>  
>  		cur_addr = sg_dma_address(sg);
> @@ -175,6 +175,7 @@ EXPORT_SYMBOL_GPL(ide_build_dmatable);
>  /**
>   *	ide_dma_setup	-	begin a DMA phase
>   *	@drive: target device
> + *	@cmd: command
>   *
>   *	Build an IDE DMA PRD (IDE speak for scatter gather table)
>   *	and then set up the DMA transfer registers for a device
> @@ -185,17 +186,16 @@ EXPORT_SYMBOL_GPL(ide_build_dmatable);
>   *	is returned.
>   */
>  
> -int ide_dma_setup(ide_drive_t *drive)
> +int ide_dma_setup(ide_drive_t *drive, struct ide_cmd *cmd)
>  {
>  	ide_hwif_t *hwif = drive->hwif;
> -	struct request *rq = hwif->rq;
> -	unsigned int reading = rq_data_dir(rq) ? 0 : ATA_DMA_WR;
>  	u8 mmio = (hwif->host_flags & IDE_HFLAG_MMIO) ? 1 : 0;
> +	u8 rw = (cmd->tf_flags & IDE_TFLAG_WRITE) ? 0 : ATA_DMA_WR;
>  	u8 dma_stat;
>  
>  	/* fall back to pio! */
> -	if (!ide_build_dmatable(drive, rq)) {
> -		ide_map_sg(drive, rq);
> +	if (ide_build_dmatable(drive, cmd) == 0) {
> +		ide_map_sg(drive, cmd);
>  		return 1;
>  	}
>  
> @@ -208,9 +208,9 @@ int ide_dma_setup(ide_drive_t *drive)
>  
>  	/* specify r/w */
>  	if (mmio)
> -		writeb(reading, (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
> +		writeb(rw, (void __iomem *)(hwif->dma_base + ATA_DMA_CMD));
>  	else
> -		outb(reading, hwif->dma_base + ATA_DMA_CMD);
> +		outb(rw, hwif->dma_base + ATA_DMA_CMD);
>  
>  	/* read DMA status for INTR & ERROR flags */
>  	dma_stat = hwif->dma_ops->dma_sff_read_status(hwif);
> Index: b/drivers/ide/ide-dma.c
> ===================================================================
> --- a/drivers/ide/ide-dma.c
> +++ b/drivers/ide/ide-dma.c
> @@ -120,7 +120,7 @@ int ide_dma_good_drive(ide_drive_t *driv
>  /**
>   *	ide_build_sglist	-	map IDE scatter gather for DMA I/O
>   *	@drive: the drive to build the DMA table for
> - *	@rq: the request holding the sg list
> + *	@cmd: command
>   *
>   *	Perform the DMA mapping magic necessary to access the source or
>   *	target buffers of a request via DMA.  The lower layers of the
> @@ -128,23 +128,22 @@ int ide_dma_good_drive(ide_drive_t *driv
>   *	operate in a portable fashion.
>   */
>  
> -int ide_build_sglist(ide_drive_t *drive, struct request *rq)
> +int ide_build_sglist(ide_drive_t *drive, struct ide_cmd *cmd)
>  {
>  	ide_hwif_t *hwif = drive->hwif;
>  	struct scatterlist *sg = hwif->sg_table;
> -	struct ide_cmd *cmd = &hwif->cmd;
>  	int i;
>  
> -	ide_map_sg(drive, rq);
> +	ide_map_sg(drive, cmd);
>  
> -	if (rq_data_dir(rq) == READ)
> -		cmd->sg_dma_direction = DMA_FROM_DEVICE;
> -	else
> +	if (cmd->tf_flags & IDE_TFLAG_WRITE)
>  		cmd->sg_dma_direction = DMA_TO_DEVICE;
> +	else
> +		cmd->sg_dma_direction = DMA_FROM_DEVICE;
>  
>  	i = dma_map_sg(hwif->dev, sg, cmd->sg_nents, cmd->sg_dma_direction);
>  	if (i == 0)
> -		ide_map_sg(drive, rq);
> +		ide_map_sg(drive, cmd);
>  
>  	return i;
>  }
> Index: b/drivers/ide/ide-floppy.c
> ===================================================================
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -285,8 +285,12 @@ static ide_startstop_t ide_floppy_do_req
>  		goto out_end;
>  	}
>  
> +	if (rq_data_dir(rq))
> +		cmd->tf_flags |= IDE_TFLAG_WRITE;
> +	cmd->rq = rq;
> +
>  	ide_init_sg_cmd(cmd, rq->nr_sectors);
> -	ide_map_sg(drive, rq);
> +	ide_map_sg(drive, cmd);

How about we push those mappings in ide_issue_pc() in the else-branch
after we've tried setting up dma and we've failed? This way we don't
have to do that in the ->do_request of every device and do it for all at
one place instead. Only ide-cd will have to have ->ide_io_buffers for
PIO transfers (which I was working on before bugs :))

[..]

-- 
Regards/Gruss,
    Boris.
