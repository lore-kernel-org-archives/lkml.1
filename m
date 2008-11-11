Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbYKKVwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbYKKVwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYKKVw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:52:28 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:50694 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYKKVw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:52:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g2YK91FhnWrZmfR4+zADDNtys6abU6eKxt1kSSHklrt9zjAHFQObjM4K/mMbenNHNp
         2F5CY6oTAW+zugTOGUKwYAcs7MfMuFAkekdi/D9p8R/HnoY9ByJAiQ93Gmc8GxlNXCyQ
         lhQh7nvK/KWZtKzF2IAGbSTUvnVkbcDMA6j6A=
Date: Tue, 11 Nov 2008 16:52:19 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Nuno Lucas <ntlucas@gmail.com>, Daniel Ritz <daniel.ritz@gmx.ch>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] linux-input: TSC-10 DM USB touchscreen driver assume
	2-byte response from controller
Message-ID: <20081111164953.ZZRA012@mailhub.coreip.homeip.net>
References: <c4f20e170811060725v2ae331f9t7b1ba48059f93170@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4f20e170811060725v2ae331f9t7b1ba48059f93170@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 03:25:40PM +0000, Nuno Lucas wrote:
> The usbtouchscreen module implements a driver for the TSC-10 DM USB
> touchscreen controllers, but assumes a 2-byte response for the
> CMD_RESET and CMD_RATE commands, when they can be only a single byte
> when no EEPROM is connected.
> 
> The driver worked with an earlier controller revision, but new
> revisions of the controller fail.
> 
> It seems the problem is that the early controller had the
> SEL4/EEPROM-CS pin high, but the new controller has it down, making
> the response different.
> 
> Without the fix, the controller would answer the single byte 0x06
> (ACK), making the init fail with -ENODEV because buf[1] is 0xFF (as
> initialized before).
> 
> As the single byte is the only thing we need to check it was ok, there
> is no need to verify the second byte.
> 
> The [0x15 0x01] case is the NAK [0x15] response for when there is no
> data in the EEPROM [bit-0 of second byte set], so I let that be, as I
> don't have any controller with an EEPROM.
> 
> With this patch, both the earlier and latest controller work the same.
> 
> Note: This was previously submited as BUG #11961 [1] on the bugzilla
> tracker, but rebased to version 2.6.27.4 and with unnecessary comments
> and printk's removed.
> 
> 
> Signed-off-by: Nuno Lucas <ntlucas@gmail.com>
> 
> 
> [1] http://bugzilla.kernel.org/show_bug.cgi?id=11961

> diff -urNp linux-2.6.27.4/drivers/input/touchscreen/usbtouchscreen.c linux-2.6.27.4-patched/drivers/input/touchscreen/usbtouchscreen.c
> --- linux-2.6.27.4/drivers/input/touchscreen/usbtouchscreen.c	2008-10-25 23:05:07.000000000 +0100
> +++ linux-2.6.27.4-patched/drivers/input/touchscreen/usbtouchscreen.c	2008-11-06 15:07:49.000000000 +0000
> @@ -424,7 +424,7 @@ static int dmc_tsc10_init(struct usbtouc
>  	                      0, 0, buf, 2, USB_CTRL_SET_TIMEOUT);
>  	if (ret < 0)
>  		goto err_out;
> -	if (buf[0] != 0x06 || buf[1] != 0x00) {
> +	if (buf[0] != 0x06) {
>  		ret = -ENODEV;
>  		goto err_out;
>  	}
> @@ -437,8 +437,7 @@ static int dmc_tsc10_init(struct usbtouc
>  	                      TSC10_RATE_150, 0, buf, 2, USB_CTRL_SET_TIMEOUT);
>  	if (ret < 0)
>  		goto err_out;
> -	if ((buf[0] != 0x06 || buf[1] != 0x00) &&
> -	    (buf[0] != 0x15 || buf[1] != 0x01)) {
> +	if ((buf[0] != 0x06) && (buf[0] != 0x15 || buf[1] != 0x01)) {
>  		ret = -ENODEV;
>  		goto err_out;
>  	}

Daniel, have you seen this?

-- 
Dmitry
