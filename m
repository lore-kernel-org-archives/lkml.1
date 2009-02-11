Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbZBKMdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbZBKMdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZBKMdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:33:08 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:27466 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbZBKMdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:33:07 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4992C57E.9050109@tremplin-utc.net>
Date: Wed, 11 Feb 2009 13:33:02 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: pavel@suse.cz
Cc: akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       trenn@suse.de
Subject: Re: hp accelerometer: add freefall detection
References: <200901162234.n0GMYB8Z022317@imap1.linux-foundation.org>
In-Reply-To: <200901162234.n0GMYB8Z022317@imap1.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Machek <pavel@suse.cz>
> 
> This adds freefall handling to hp_accel driver.  According to HP, it
> should just work, without us having to set the chip up by hand.
> 
> hpfall.c is example .c program that parks the disk when accelerometer
> detects free fall.  It should work; for now, it uses fixed 20seconds
> protection period.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> Cc: Thomas Renninger <trenn@suse.de>
> Cc: �ric Piel <eric.piel@tremplin-utc.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Hi Pavel,
Sorry for being amazingly late, reading the latest patches from
Giuseppe, I noticed some parts in this patch which are strange.
Basically you scrap all the init and all the poweroff. Some of the
things there were put for some purpose, and I wonder if you've verified
everything keeps working correctly.


> @@ -110,26 +114,13 @@ static void lis3lv02d_get_xyz(acpi_handl
>  void lis3lv02d_poweroff(acpi_handle handle)
>  {
>  	adev.is_on = 0;
> -	/* disable X,Y,Z axis and power down */
> -	adev.write(handle, CTRL_REG1, 0x00);
So we are not turning off the device on poweroff()?! Why? Did you notice
problems when we were doing it?

Actually I've always wondered if it was worthy to turn it off because
I've never been able to measure a difference in power consumption. Have
you done the measurement and noticed there is no effect? I'd be glad we
can get rid of this power management thing, but then we can scratch much
more than just this line!


> -	/*
> -	 * BDU: LSB and MSB values are not updated until both have been read.
> -	 *      So the value read will always be correct.
> -	 * IEN: Interrupt for free-fall and DD, not for data-ready.
> -	 */
> -	adev.read(handle, CTRL_REG2, &val);
> -	val |= CTRL2_BDU | CTRL2_IEN;
> -	adev.write(handle, CTRL_REG2, val);
This part is rather scary. Did you read the comment? If you don't
activate BDU you cannot be sure that the data you read is valid. I see
no reason why this would interfere with the free-fall detection so
unless you have a really good case, let's keep it. On the other hand, I
don't mind removing IEN if you've noticed that it's not useful or
interfering.

Eric
