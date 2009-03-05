Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbZCENNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbZCENNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbZCENMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:12:54 -0500
Received: from h155.mvista.com ([63.81.120.155]:62581 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757278AbZCENMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:12:52 -0500
Message-ID: <49AFCFDB.9080203@ru.mvista.com>
Date: Thu, 05 Mar 2009 16:12:59 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ide: merge ->atapi_*put_bytes and ->ata_*put_data
 methods
References: <200803302141.03013.bzolnier@gmail.com>
In-Reply-To: <200803302141.03013.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Merge ->atapi_{in,out}put_bytes and ->ata_{in,out}put_data methods
>   into new ->{in,out}put_data methods which take number of bytes to
>   transfer as an argument and always do padding.

> While at it:

> * Use 'hwif' or 'drive->hwif' instead of 'HWIF(drive)'.

> There should be no functional changes caused by this patch (all users
> of ->ata_{in,out}put_data methods were using multiply-of-4 word counts).

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

    Congratulations -- you introduced a bug with this patch. ;-)

> Index: b/drivers/ide/ide-iops.c
> ===================================================================
> --- a/drivers/ide/ide-iops.c
> +++ b/drivers/ide/ide-iops.c
> @@ -191,34 +191,45 @@ static void ata_vlb_sync(ide_drive_t *dr
>  
>  /*
>   * This is used for most PIO data transfers *from* the IDE interface
> + *
> + * These routines will round up any request for an odd number of bytes,
> + * so if an odd len is specified, be sure that there's at least one
> + * extra byte allocated for the buffer.
>   */
> -static void ata_input_data(ide_drive_t *drive, void *buffer, u32 wcount)
> +static void ata_input_data(ide_drive_t *drive, void *buf, unsigned int len)
>  {
>  	ide_hwif_t *hwif = drive->hwif;
>  	struct ide_io_ports *io_ports = &hwif->io_ports;
> +	unsigned long data_addr = io_ports->data_addr;
>  	u8 io_32bit = drive->io_32bit;
>  
> +	len++;
> +

    Now where is the symmetric len++ in ata_output_data()?

>  	if (io_32bit) {
>  		if (io_32bit & 2) {
>  			unsigned long flags;
>  
>  			local_irq_save(flags);
>  			ata_vlb_sync(drive, io_ports->nsect_addr);
> -			hwif->INSL(io_ports->data_addr, buffer, wcount);
> +			hwif->INSL(data_addr, buf, len / 4);
>  			local_irq_restore(flags);
>  		} else
> -			hwif->INSL(io_ports->data_addr, buffer, wcount);
> +			hwif->INSL(data_addr, buf, len / 4);
> +
> +		if ((len & 3) >= 2)
> +			hwif->INSW(data_addr, (u8 *)buf + (len & ~3), 1);
>  	} else
> -		hwif->INSW(io_ports->data_addr, buffer, wcount << 1);
> +		hwif->INSW(data_addr, buf, len / 2);
>  }
>  
>  /*
>   * This is used for most PIO data transfers *to* the IDE interface
>   */
> -static void ata_output_data(ide_drive_t *drive, void *buffer, u32 wcount)
> +static void ata_output_data(ide_drive_t *drive, void *buf, unsigned int len)
>  {
>  	ide_hwif_t *hwif = drive->hwif;
>  	struct ide_io_ports *io_ports = &hwif->io_ports;
> +	unsigned long data_addr = io_ports->data_addr;
>  	u8 io_32bit = drive->io_32bit;
>  
>  	if (io_32bit) {

    Patch coming. It turned out to be really good thing that I decided to look 
into these methods...

MBR, Sergei
