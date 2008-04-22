Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbYDVQN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbYDVQN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbYDVQNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:13:19 -0400
Received: from h155.mvista.com ([63.81.120.155]:31632 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753841AbYDVQNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:13:18 -0400
Message-ID: <480E0E79.3060401@ru.mvista.com>
Date: Tue, 22 Apr 2008 20:12:41 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: Re: [PATCH 1/5] ide: add ide_pad_transfer() helper
References: <200804122103.15491.bzolnier@gmail.com>
In-Reply-To: <200804122103.15491.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Add ide_pad_transfer() helper (which uses ->{in,out}put_data methods
>   internally so the transfer is also padded to drive+host requirements)
>   and use it instead of ide_atapi_{write_zeros,discard_data}().

> * Remove no longer needed ide_atapi_{write_zeros,discard_data}().

> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/ide-tape.c
> ===================================================================
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -395,7 +395,7 @@ static void idetape_input_buffers(ide_dr
>  		if (bh == NULL) {
>  			printk(KERN_ERR "ide-tape: bh == NULL in "
>  				"idetape_input_buffers\n");
> -			ide_atapi_discard_data(drive, bcount);
> +			ide_pad_transfer(drive, 0, bcount);
>  			return;
>  		}
>  		count = min(
> @@ -871,7 +871,7 @@ static ide_startstop_t idetape_pc_intr(i
>  				printk(KERN_ERR "ide-tape: The tape wants to "
>  					"send us more data than expected "
>  					"- discarding data\n");
> -				ide_atapi_discard_data(drive, bcount);
> +				ide_pad_transfer(drive, 0, bcount);
>  				ide_set_handler(drive, &idetape_pc_intr,
>  						IDETAPE_WAIT_CMD, NULL);
>  				return ide_started;
> Index: b/drivers/scsi/ide-scsi.c
> ===================================================================
> --- a/drivers/scsi/ide-scsi.c
> +++ b/drivers/scsi/ide-scsi.c
> @@ -164,7 +164,7 @@ static void idescsi_input_buffers(ide_dr
>  
>  	if (bcount) {
>  		printk (KERN_ERR "ide-scsi: scatter gather table too small, discarding data\n");
> -		ide_atapi_discard_data(drive, bcount);
> +		ide_pad_transfer(drive, 0, bcount);
>  	}
>  }
>  
> @@ -201,7 +201,7 @@ static void idescsi_output_buffers(ide_d
>  
>  	if (bcount) {
>  		printk (KERN_ERR "ide-scsi: scatter gather table too small, padding with zeros\n");
> -		ide_atapi_write_zeros(drive, bcount);
> +		ide_pad_transfer(drive, 1, bcount);
>  	}
>  }
>  
> @@ -438,7 +438,7 @@ static ide_startstop_t idescsi_pc_intr (
>  				}
>  				pc->xferred += temp;
>  				pc->cur_pos += temp;
> -				ide_atapi_discard_data(drive, bcount - temp);
> +				ide_pad_transfer(drive, 0, bcount - temp);
>  				ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
>  				return ide_started;
>  			}
> Index: b/include/linux/ide.h
> ===================================================================
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -816,6 +816,8 @@ void ide_execute_command(ide_drive_t *, 
>  
>  void ide_execute_pkt_cmd(ide_drive_t *);
>  
> +void ide_pad_transfer(ide_drive_t *, int, int);
> +
>  ide_startstop_t __ide_error(ide_drive_t *, struct request *, u8, u8);
>  
>  ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, byte stat);
> @@ -1346,27 +1348,4 @@ static inline u8 ide_read_error(ide_driv
>  
>  	return hwif->INB(hwif->io_ports.error_addr);
>  }
> -
> -/*
> - * Too bad. The drive wants to send us data which we are not ready to accept.
> - * Just throw it away.
> - */
> -static inline void ide_atapi_discard_data(ide_drive_t *drive, unsigned bcount)
> -{
> -	ide_hwif_t *hwif = drive->hwif;
> -
> -	/* FIXME: use ->input_data */
> -	while (bcount--)
> -		(void)hwif->INB(hwif->io_ports.data_addr);
> -}
> -
> -static inline void ide_atapi_write_zeros(ide_drive_t *drive, unsigned bcount)
> -{
> -	ide_hwif_t *hwif = drive->hwif;
> -
> -	/* FIXME: use ->output_data */
> -	while (bcount--)
> -		hwif->OUTB(0, hwif->io_ports.data_addr);
> -}
> -
>  #endif /* _IDE_H */

    I doubt that these ever worked as expected since you can't hope that the 
IDE data transfers are 8-bit if you use 8-bit I/O -- they will be 16-bit 
anyway.  So, this patch is not just a cleanup, it's fixing a bug. :-)

MBR, Sergei
