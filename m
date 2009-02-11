Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbZBKJrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbZBKJrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 04:47:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZBKJrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 04:47:42 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:6877 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbZBKJrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 04:47:41 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <49929EB8.4020802@tremplin-utc.net>
Date: Wed, 11 Feb 2009 10:47:36 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv6] lis3lv02d: support both one- and two-byte sensors
References: <1234314259-17922-1-git-send-email-giuseppe.bilotta@gmail.com>
In-Reply-To: <1234314259-17922-1-git-send-email-giuseppe.bilotta@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giuseppe Bilotta schreef:
:
> Same as v5, with a couple of renames to have simpler and more meaningful
> names. The #define's for the LISxxxxx families have been renamed
> according to the actual functional distinction, and the struct member
> holding the data read function has been renamed to read_data.
> 
Almost good... just a little thing more:
> @@ -254,10 +270,21 @@ static int lis3lv02d_add(struct acpi_device *device)
>  	strcpy(acpi_device_class(device), ACPI_MDPS_CLASS);
>  	device->driver_data = &adev;
>  
> -	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &val);
> -	if ((val != LIS3LV02DL_ID) && (val != LIS302DL_ID)) {
> -		printk(KERN_ERR DRIVER_NAME
> -				": Accelerometer chip not LIS3LV02D{L,Q}\n");
> +	lis3lv02d_acpi_read(device->handle, WHO_AM_I, &adev.whoami);
> +	switch (adev.whoami) {
> +		case LIS_DOUBLE_ID:
> +			printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found\n");
> +			adev.read_data = lis3lv02d_read_16;
> +			adev.mdps_max_val = 2048;
> +			break;
> +		case LIS_SINGLE_ID:
> +			printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found\n");
> +			adev.read_data = lis3lv02d_read_8;
> +			adev.mdps_max_val = 128;
> +			break;
> +		default:
> +			printk(KERN_ERR DRIVER_NAME
> +				": unknown sensor type 0x%X\n", adev.whoami);
>  	}

In the default case, add:
			return -EINVAL;
I don't want the driver to start messing with chips we have no idea what
they do!

Eric
