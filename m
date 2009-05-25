Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZEYVEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZEYVEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZEYVDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:03:54 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55362 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751759AbZEYVDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:03:53 -0400
Date: Mon, 25 May 2009 17:03:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
cc: Robert Hancock <hancockrwd@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-storage: include USB drive in unusual_devs list
In-Reply-To: <20090525151313.GA2246@ime.usp.br>
Message-ID: <Pine.LNX.4.44L0.0905251657100.27717-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 May 2009, [utf-8] Rogério Brito wrote:

> 67b:2316:L
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 004: ID 067b:2316 Prolific Technology, Inc. Flash Disk Security Device
> Bus 004 Device 003: ID 067b:2317 Prolific Technology, Inc. Mass Storage Device
> Bus 004 Device 002: ID 067b:2315 Prolific Technology, Inc. Flash Disk Embedded Hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> chagas:~#
> - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> 
> > If that eliminates the errors, we can add a permanent quirk entry for 
> > this device.
> 
> I can test whatever you want me to, so that this can be fixed. The above
> lsusb log shows that, perhaps, the quirks option should be set for the
> device 067b:2317, instead of 067b:2316, as you told me to?

Yes, my fault, I mixed up the two device IDs.

> (I'm going to verify it right now).
> 
> Yes, that works. Using 67b:2317:L as a quirk eliminates the messages.
> And I do get the
> 
> [ 3454.054150] usb-storage 4-2.1:1.0: Quirks match for vid 067b pid 2317: 80
> 
> message. Therefore, a proposal:
> 
> This patch adds a quirk entry for the Leading Driver UD-11
> usb flash drive.
> 
> As Alan Stern told me, the device doesn't deal correctly with
> the locking media feature of the device, and this patch
> incorporates it.
> 
> Compiled, tested, working.
> 
> 
> Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
> 
> ---
> 
> The US_PR_DEVICE macro could be changed to US_PR_CBI, from what
> I saw in the udevadm info tree.
> 
> --- a/drivers/usb/storage/unusual_devs.h
> +++ b/drivers/usb/storage/unusual_devs.h
> @@ -838,6 +838,19 @@ UNUSUAL_DEV( 0x066f, 0x8000, 0x0001, 0x0
>  		US_SC_DEVICE, US_PR_DEVICE, NULL,
>  		US_FL_FIX_CAPACITY ),
>  
> +/* Reported by Rogério Brito <rbrito@ime.usp.br> */

I think you're not supposed to use non-ASCII characters in comments, 
although they're okay in the Changelog.

> +/* 'lsusb' tells:
> + *    "Prolific Technology, Inc. Mass Storage Device"
> + * but 'udevadm info' says:
> + *    ATTR{manufacturer}=="Leading Driver Co.,LTD."
> + *    ATTR{product}=="USB Mass Storage Device"

Don't worry about these attributes.  Leave just the Prolific name.

> + */
> +UNUSUAL_DEV( 0x067b, 0x2317, 0x0001, 0x001,
> +		"Prolific Technology, Inc.",
> +		"Mass Storage Device",
> +		US_SC_DEVICE, US_PR_DEVICE, NULL,
> +		US_FL_NOT_LOCKABLE ),
> +
>  /* Reported by Richard -=[]=- <micro_flyer@hotmail.com> */
>  /* Change to bcdDeviceMin (0x0100 to 0x0001) reported by
>   * Thomas Bartosik <tbartdev@gmx-topmail.de> */
> 
> 
> Actually, I just ventured myself and created a patch, attached (sorry, I
> know that people don't like attached patches, but I don't want to mix

This looks good.  Make those suggested changes and submit it to Phil 
Dibowitz <phil@ipom.com>; it might even get merged in time to appear 
in 2.6.30.

Alan Stern

