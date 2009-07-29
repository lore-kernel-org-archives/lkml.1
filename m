Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbZG2AxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbZG2AxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbZG2AxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:53:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:8659 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbZG2AxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 20:53:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,285,1246863600"; 
   d="scan'208";a="434184958"
Subject: Re: [PATCH 9/9] drivers/acpi: correct error-handling code
From: Zhang Rui <rui.zhang@intel.com>
To: Julia Lawall <julia@diku.dk>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0907281756010.28189@ask.diku.dk>
References: <Pine.LNX.4.64.0907281756010.28189@ask.diku.dk>
Content-Type: text/plain; charset=utf-8
Date: Wed, 29 Jul 2009 08:53:29 +0800
Message-Id: <1248828809.2670.144.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-28 at 23:56 +0800, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> backlight_device_register may return an ERR_PTR value rather than a valid
> pointer.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)

> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/acpi/video.c                |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index 8851315..29788db 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -982,6 +982,8 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
>  		sprintf(name, "acpi_video%d", count++);
>  		device->backlight = backlight_device_register(name,
>  			NULL, device, &acpi_backlight_ops);
> +		if (IS_ERR(device->backlight))
> +			return;

we should kfree(name) here.

>  		device->backlight->props.max_brightness = device->brightness->count-3;
>  		kfree(name);

how about this one?

﻿backlight_device_register may return an ERR_PTR value rather than a valid
pointer.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/video.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/video.c
===================================================================
--- linux-2.6.orig/drivers/acpi/video.c
+++ linux-2.6/drivers/acpi/video.c
@@ -982,8 +982,10 @@ static void acpi_video_device_find_cap(s
 		sprintf(name, "acpi_video%d", count++);
 		device->backlight = backlight_device_register(name,
 			NULL, device, &acpi_backlight_ops);
-		device->backlight->props.max_brightness = device->brightness->count-3;
 		kfree(name);
+		if (IS_ERR(device->backlight))
+			return;
+		device->backlight->props.max_brightness = device->brightness->count-3;
 
 		result = sysfs_create_link(&device->backlight->dev.kobj,
 					   &device->dev->dev.kobj, "device");



 

