Return-Path: <linux-kernel-owner+w=401wt.eu-S1759566AbXFJPvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566AbXFJPvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 11:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758866AbXFJPvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 11:51:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51865 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758245AbXFJPvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 11:51:20 -0400
Date: Sun, 10 Jun 2007 16:56:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_it821x: sync with IDE it821x driver
Message-ID: <20070610165638.2db56f04@the-village.bc.nu>
In-Reply-To: <200706090223.20933.bzolnier@gmail.com>
References: <200706090223.20933.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -258,8 +259,14 @@ static void it821x_passthru_set_piomode(
>  	static const u8 pio_want[]    = { ATA_66, ATA_66, ATA_66, ATA_66, ATA_ANY };
>  
>  	struct it821x_dev *itdev = ap->private_data;
> +	struct ata_device *pair = ata_dev_pair(adev);
>  	int unit = adev->devno;
> -	int mode_wanted = adev->pio_mode - XFER_PIO_0;
> +	int mode_wanted = adev->pio_mode;
> +
> +	if (pair && adev->pio_mode > pair->pio_mode)
> +		mode_wanted = pair->pio_mode;
> +
> +	mode_wanted -= XFER_PIO_0;

NAK this too

Please see it821x_program.

it821x_passthru_set_piomode computes the required mode and the preferred
clock for the mode
it821x_clock_strategy the computes the best clock to use
it821x_program the programs the device

Whenever we issue a command it821x_passthru_dev_select then does a timing
mode switch and loads the PIO timing before doing the dev_select. The
same is also done when doing a qc_issue_prot so each qc_issue will have
the right timings loaded for the device.

So if you've got a problem case your diagnosis isn't one that makes a lot
of sense, and the fix is clearly wrong but I've not seen most of the
discussion between you and whoever you worked with to judge why.

One obvious possibility is that we are not currently doing timing
clipping for the address setup and merge for the 8bit timings. However
the docs I have strongly imply that the IT821x PIO/MWDMA timing register
is for data cycles only.

The other would be that there is some kind of pattern of interaction
between the ATA midlayer and the driver causing the wrong timings to get
loaded at some point.

Your "fix" would happen to work for both of these cases, but is wrong for
both of them.

If the register is switching all the timings then the fix is to switch
the PIO timing loaded to the lowest of the two initially (in _program)
and flip it back to the correct value at the start of the data transfer
sequence. We can then flip it back next qc_issue or indeed at the end of
the data xfer

If we've got an interaction problem then we need proper traces with
LIBATA debug turned right up so we can fix the actual case where the
switching occurs wrongly.

Alan
