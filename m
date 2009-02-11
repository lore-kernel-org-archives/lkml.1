Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZBKAQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZBKAQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZBKAQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:16:12 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:15869 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbZBKAQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:16:11 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <499218C4.4080808@tremplin-utc.net>
Date: Wed, 11 Feb 2009 01:16:04 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lis3lv02d: support both one- and two-byte sensors
References: <1234310519-14230-1-git-send-email-giuseppe.bilotta@gmail.com>
In-Reply-To: <1234310519-14230-1-git-send-email-giuseppe.bilotta@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giuseppe Bilotta schreef:

> As pointed out by Eric, there's no need to jump through hoops to obtain
> a signed 16-bit number from a signed 8-bit number.
> 
> This patch is good for -mm
> 
> Note also that this patch is only about 8 vs 16 bit data, so the axis
> orientation for HP notebooks still has to be fixed in a separate patch,
> but at least now I should be able to check it out properly.
> 
Whoops, sorry for not catching it before, this part is not nice:

> @@ -121,6 +125,21 @@ void lis3lv02d_poweron(acpi_handle handle)
>  {
>  	adev.is_on = 1;
>  	adev.init(handle);
> +	adev.read(handle, WHO_AM_I, &adev.whoami);
> +	/* Tell apart LISxLV02Dy from LISx02Dy family by checking the LSB
> +	 * (0x3A vs 0x3B). TODO More sophisticated checks on other registers
> +	 * could be implemented, for example to see if we have 2 or 3 axes, and
> +	 * configure the joystick accordingly.
> +	 */
> +	if (adev.whoami & 1) {
> +		printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found\n");
> +		adev.lis3lv02d_read = lis3lv02d_read_8;
> +		adev.mdps_max_val = 128;
> +	} else {
> +		printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found\n");
> +		adev.lis3lv02d_read = lis3lv02d_read_16;
> +		adev.mdps_max_val = 2048;
> +	}
>  }
poweron() is called each time the joystick is opened, no need to check 
(and do a printk) so often! You need to move all this check to 
lis3lv02d_add() in hp_accel.c . Moreover, don't do tricky things like 
(adev.whoami & 1): just do a:
switch (adev.whoami) {
LIS302DL_ID:
	printk(KERN_INFO DRIVER_NAME ": 1-byte sensor found.\n");
	adev.lis3lv02d_read = lis3lv02d_read_8;
	adev.mdps_max_val = 128;
	break;
LIS3LV02DL_ID:
	printk(KERN_INFO DRIVER_NAME ": 2-byte sensor found.\n");
	adev.lis3lv02d_read = lis3lv02d_read_16;
	adev.mdps_max_val = 2048;
	break;
default:
	printk(KERN_ERR DRIVER_NAME ": unknown sensor found of type %d.\n", 
adev.whoami);
	return -EINVAL;
}


Eric
