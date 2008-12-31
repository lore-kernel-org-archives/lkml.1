Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbYLaTZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbYLaTZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 14:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbYLaTZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 14:25:39 -0500
Received: from ppp-110-52.adsl.restena.lu ([158.64.110.52]:42929 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751882AbYLaTZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 14:25:38 -0500
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Dec 2008 14:25:37 EST
Date: Wed, 31 Dec 2008 20:15:35 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: S3 with pata_via fails to resume, ide_via82Cxxx works
Message-ID: <20081231201535.4d86c159@neptune.home>
In-Reply-To: <200812311919.14579.bzolnier@gmail.com>
References: <20081230185037.7ec94e94@neptune.home>
	<20081230215953.235ce1b4@neptune.home>
	<200812311919.14579.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patch, it fixes the oops for me too.

Unfortunately the re-discovery of the drive causes at least XFS to
error and shutdown its mounts :(

Is it possible to block any access to the devices on the scanned port
until the scan has completed? Otherwise this renders rescanning
on port with mounted (e.g. /) partition to suicide...

I also wonder why it took so long and there is that complaint about
lost interrupt + failure. Was there some operation in progress that
got "killed" by the scan?

Bruno



Dec 31 19:58:26 venus [   83.716209] Probing IDE interface ide0...
Dec 31 19:58:27 venus [   84.030107] hda: FUJITSU MHY2250BH, ATA DISK drive
Dec 31 19:58:27 venus [   84.390048] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
Dec 31 19:58:27 venus [   84.390205] hda: UDMA/100 mode selected
Dec 31 19:58:39 venus [   96.640225] I/O error in filesystem ("hda3") meta-data dev hda3 block 0x202f14       ("xlog_iodone") error 5 buf count 1024
Dec 31 19:58:39 venus [   96.640274] xfs_force_shutdown(hda3,0x2) called from line 1062 of file /usr/src/linux-2.6.28/fs/xfs/xfs_log.c.  Return address = 0xc021418a
Dec 31 19:58:39 venus [   96.640331] Filesystem "hda3": Log I/O Error Detected.  Shutting down filesystem: hda3
Dec 31 19:58:39 venus [   96.640359] Please umount the filesystem, and rectify the problem(s)
Dec 31 18:58:46 venus [  103.710105] hda: dma_timer_expiry: DMA status (0x20)
Dec 31 18:58:46 venus [  103.710128] hda: lost interrupt
Dec 31 18:58:46 venus [  103.710148] hda: ide_dma_intr: bad DMA status (0x30)
Dec 31 18:58:46 venus [  103.710168] hda: dma_intr: status=0x50 { DriveReady SeekComplete }
Dec 31 18:58:46 venus [  103.710192] ide: failed opcode was: unknown
Dec 31 18:58:47 venus [  104.063206] hda: max request size: 512KiB
Dec 31 18:58:47 venus [  104.063230] hda: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63
Dec 31 18:58:47 venus [  104.063450] hda: cache flushes supported
Dec 31 18:59:09 venus [  126.640091] Filesystem "hda3": xfs_log_force: error 5 returned.
Dec 31 18:59:39 venus [  156.640109] Filesystem "hda3": xfs_log_force: error 5 returned.
Dec 31 19:00:09 venus [  186.640093] Filesystem "hda3": xfs_log_force: error 5 returned.



On Wed, 31 December 2008 Bartlomiej Zolnierkiewicz wrote:
> Thanks for the report, the following patch fixes the OOPS for me:
> 
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: fix ide_port_scan() to do ACPI setup after
> initializing request queues
> 
> This makes ide_port_scan()'s behavior match ide_host_register()'s
> one and fixes OOPS in elv_may_queue() during port re-scan.
> 
> Reported-by: Bruno Prémont <bonbons@linux-vserver.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-probe.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/drivers/ide/ide-probe.c
> ===================================================================
> --- a/drivers/ide/ide-probe.c
> +++ b/drivers/ide/ide-probe.c
> @@ -1694,8 +1694,8 @@ void ide_port_scan(ide_hwif_t *hwif)
>  	hwif->present = 1;
>  
>  	ide_port_tune_devices(hwif);
> -	ide_acpi_port_init_devices(hwif);
>  	ide_port_setup_devices(hwif);
> +	ide_acpi_port_init_devices(hwif);
>  	hwif_register_devices(hwif);
>  	ide_proc_port_register_devices(hwif);
>  }
> 
