Return-Path: <linux-kernel-owner+w=401wt.eu-S1752013AbZJKUxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbZJKUxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 16:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbZJKUxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 16:53:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:53145 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbZJKUxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 16:53:44 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 [PATCH]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ben Efros <ben@pc-doctor.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, fangxiaozhi <huananhu@huawei.com>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>,
       Josua Dietze <digidietze@draisberghof.de>
In-Reply-To: <27304843.564411255279105669.JavaMail.root@mail.pc-doctor.com>
References: <27304843.564411255279105669.JavaMail.root@mail.pc-doctor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 07:51:32 +1100
Message-Id: <1255294292.2192.40.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The more i think of it, I don't think removal of the SANE_SENSE flag is a good idea after we've made reasonable effort to detect it.  The problem is the buggy devices that trigger SANE_SENSE to be set by error in the first place because they lie about the additional sense length.
> 
> Since these Huawei devices are already listed in the unusual devices, we could add the INSANE_SENSE flag to them as I did below...  Ben Herrenschmidt, can you confirm that this works for the regression as well?
> 
> 
> Add support for INSANE_SENSE flag to disable SANE_SENSE
> detection on known buggy usb mass storage devices.

Don't those devices support SANE_SENSE fine on LUN 0 according to
Alan parsing of my traces ? Heh, they may even work if I actually
populate the SD-CARD slot, I'll try later.

I still think it's simpler and potentially more future-proof to just
have a back-off scenario.

Now, whether we ping pong the US_FL_SANE_SENSE flag or not is minor,
I tend to think that your approach that doesn't touch the flag might
indeed be better.

I'll test the patch later today.

Cheers,
Ben.

>  Signed-off-by: Ben Efros <ben@pc-doctor.com>
> 
> --- linux-2.6.31.3/drivers/usb/storage/transport.c	2009-09-24 08:45:25.000000000 -0700
> +++ linux-2.6.31.3/drivers/usb/storage/transport.c	2009-10-11 08:06:26.000000000 -0700
> @@ -668,7 +668,7 @@ void usb_stor_invoke_transport(struct sc
>  	 */
>  	if ((srb->cmnd[0] == ATA_16 || srb->cmnd[0] == ATA_12) &&
>  	    result == USB_STOR_TRANSPORT_GOOD &&
> -	    !(us->fflags & US_FL_SANE_SENSE) &&
> +	    !(us->fflags & (US_FL_SANE_SENSE|US_FL_INSANE_SENSE)) &&
>  	    !(srb->cmnd[2] & 0x20)) {
>  		US_DEBUGP("-- SAT supported, increasing auto-sense\n");
>  		us->fflags |= US_FL_SANE_SENSE;
> @@ -738,8 +744,9 @@ void usb_stor_invoke_transport(struct sc
>  		 * The response code must be 70h through 73h inclusive.
>  		 */
>  		if (srb->sense_buffer[7] > (US_SENSE_SIZE - 8) &&
> -		    !(us->fflags & US_FL_SANE_SENSE) &&
> +		    !(us->fflags & (US_FL_SANE_SENSE|US_FL_INSANE_SENSE)) &&
>  		    (srb->sense_buffer[0] & 0x7C) == 0x70) {
> +
>  			US_DEBUGP("-- SANE_SENSE support enabled\n");
>  			us->fflags |= US_FL_SANE_SENSE;
>  
> --- linux-2.6.31.3/drivers/usb/storage/scsiglue.c	2009-09-24 08:45:25.000000000 -0700
> +++ linux-2.6.31.3/drivers/usb/storage/scsiglue.c	2009-10-11 07:52:22.000000000 -0700
> @@ -209,8 +209,11 @@ static int slave_configure(struct scsi_d
>  		if (us->fflags & US_FL_CAPACITY_HEURISTICS)
>  			sdev->guess_capacity = 1;
>  
> -		/* assume SPC3 or latter devices support sense size > 18 */
> -		if (sdev->scsi_level > SCSI_SPC_2)
> +		/* assume SPC3 or latter devices support sense size > 18
> +		 * if they haven't been marked to have insane sense data
> +		 */
> +		if (sdev->scsi_level > SCSI_SPC_2 &&
> +		    !(us->fflags & US_FL_INSANE_SENSE))
>  			us->fflags |= US_FL_SANE_SENSE;
>  
>  		/* Some devices report a SCSI revision level above 2 but are
> --- linux-2.6.31.3/include/linux/usb_usual.h	2009-09-24 08:45:25.000000000 -0700
> +++ linux-2.6.31.3/include/linux/usb_usual.h	2009-10-11 07:54:06.000000000 -0700
> @@ -56,7 +56,9 @@
>  	US_FLAG(SANE_SENSE,     0x00008000)			\
>  		/* Sane Sense (> 18 bytes) */			\
>  	US_FLAG(CAPACITY_OK,	0x00010000)			\
> -		/* READ CAPACITY response is correct */
> +		/* READ CAPACITY response is correct */         \
> +	US_FLAG(INSANE_SENSE,   0x00020000)                     \
> +		/* Device does not support SANE_SENSE (> 18 bytes) */
>  
>  #define US_FLAG(name, value)	US_FL_##name = value ,
>  enum { US_DO_ALL_FLAGS };
> --- linux-2.6.31.3/drivers/usb/storage/unusual_devs.h	2009-10-11 08:57:08.000000000 -0700
> +++ linux-2.6.31.3/drivers/usb/storage/unusual_devs.h	2009-10-11 08:59:34.000000000 -0700
> @@ -1422,332 +1422,332 @@ UNUSUAL_DEV(  0x12d1, 0x1001, 0x0000, 0x
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1003, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1004, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1401, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1402, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1403, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1404, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1405, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1406, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1407, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1408, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1409, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x140A, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x140B, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x140C, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x140D, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x140E, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x140F, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1410, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1411, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1412, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1413, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1414, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1415, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1416, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1417, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1418, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1419, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x141A, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x141B, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x141C, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x141D, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x141E, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x141F, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1420, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1421, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1422, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1423, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1424, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1425, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1426, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1427, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1428, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1429, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x142A, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x142B, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x142C, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x142D, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x142E, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x142F, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1430, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1431, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1432, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1433, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1434, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1435, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1436, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1437, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1438, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x1439, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x143A, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x143B, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x143C, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x143D, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x143E, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  UNUSUAL_DEV(  0x12d1, 0x143F, 0x0000, 0x0000,
>  		"HUAWEI MOBILE",
>  		"Mass Storage",
>  		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
> -		0),
> +		US_FL_INSANE_SENSE),
>  
>  /* Reported by Vilius Bilinkevicius <vilisas AT xxx DOT lt) */
>  UNUSUAL_DEV(  0x132b, 0x000b, 0x0001, 0x0001,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


