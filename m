Return-Path: <linux-kernel-owner+w=401wt.eu-S933646AbYB2UaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbYB2UaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYB2UaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:30:05 -0500
Received: from homer.mvista.com ([63.81.120.155]:38288 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752431AbYB2UaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:30:02 -0500
Message-ID: <47C86B8B.8000100@ru.mvista.com>
Date: Fri, 29 Feb 2008 23:31:07 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 3/3] ide: remove IDE_*_REG macros
References: <200802091624.34064.bzolnier@gmail.com>
In-Reply-To: <200802091624.34064.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Add IDE_{ALTSTATUS,IREASON,BCOUNTL,BCOUNTH}_OFFSET defines.

> * Remove IDE_*_REG macros - this results in more readable
>   and slightly smaller code.

> There should be no functional changes caused by this patch.

> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/cris/ide-cris.c
> ===================================================================
> --- a/drivers/ide/cris/ide-cris.c
> +++ b/drivers/ide/cris/ide-cris.c
> @@ -228,7 +228,10 @@ cris_ide_fill_descriptor(cris_dma_descr_
>  static void
>  cris_ide_start_dma(ide_drive_t *drive, cris_dma_descr_type *d, int dir,int type,int len)
>  {
> -	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int, IDE_DATA_REG);
> +	ide_hwif_t *hwif = drive->hwif;
> +

    Why insert new line in the declaration block?

> +	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
> +					       hwif->io_ports[IDE_DATA_OFFSET]);
>  	reg_ata_rw_trf_cnt trf_cnt = {0};
>  
>  	mycontext.saved_data = (dma_descr_data*)virt_to_phys(d);
> @@ -264,8 +267,12 @@ cris_ide_wait_dma(int dir)
>  
>  static int cris_dma_test_irq(ide_drive_t *drive)
>  {
> +	ide_hwif_t *hwif = drive->hwif;
>  	int intr = REG_RD_INT(ata, regi_ata, r_intr);
> -	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int, IDE_DATA_REG);
> +

    Same here...

> +	reg_ata_rw_ctrl2 ctrl2 = REG_TYPE_CONV(reg_ata_rw_ctrl2, int,
> +					       hwif->io_ports[IDE_DATA_OFFSET]);
> +
>  	return intr & (1 << ctrl2.sel) ? 1 : 0;
>  }

[...]

> Index: b/drivers/ide/legacy/ht6560b.c
> ===================================================================
> --- a/drivers/ide/legacy/ht6560b.c
> +++ b/drivers/ide/legacy/ht6560b.c
> @@ -79,7 +79,7 @@
>   * out how they setup those cycle time interfacing values, as they at Holtek
>   * call them. IDESETUP.COM that is supplied with the drivers figures out
>   * optimal values and fetches those values to drivers. I found out that
> - * they use IDE_SELECT_REG to fetch timings to the ide board right after
> + * they use Select register to fetch timings to the ide board right after

    The register is called device/head officially. :-)

> Index: b/drivers/scsi/ide-scsi.c
> ===================================================================
> --- a/drivers/scsi/ide-scsi.c
> +++ b/drivers/scsi/ide-scsi.c
> @@ -275,9 +275,12 @@ static int idescsi_end_request(ide_drive
>  static ide_startstop_t
>  idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
>  {
> +	ide_hwif_t *hwif = drive->hwif;
> +
>  	if (ide_read_status(drive) & (BUSY_STAT | DRQ_STAT))
>  		/* force an abort */
> -		HWIF(drive)->OUTB(WIN_IDLEIMMEDIATE,IDE_COMMAND_REG);
> +		hwif->OUTB(WIN_IDLEIMMEDIATE,
> +			   hwif->io_ports[IDE_COMMAND_OFFSET]);

    Hum hm, why not WIN_DEVICE_RESET? :-O

[...]
> Index: b/include/linux/ide.h
> ===================================================================
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
[...]
> @@ -369,7 +355,7 @@ typedef struct ide_drive_s {
>          u8	wcache;		/* status of write cache */

    Spaces again...

>  	u8	acoustic;	/* acoustic management */
>  	u8	media;		/* disk, cdrom, tape, floppy, ... */
> -	u8	ctl;		/* "normal" value for IDE_CONTROL_REG */
> +	u8	ctl;		/* "normal" value for Control register */
>  	u8	ready_stat;	/* min status value for drive ready */
>  	u8	mult_count;	/* current multiple sector setting */
>  	u8	mult_req;	/* requested multiple sector setting */

MBR, Sergei

