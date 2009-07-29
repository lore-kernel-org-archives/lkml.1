Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbZG2CWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbZG2CWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 22:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZG2CWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 22:22:11 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:46977 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbZG2CWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 22:22:10 -0400
Date: Wed, 29 Jul 2009 04:20:32 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 9/9] drivers/acpi: correct error-handling code
In-Reply-To: <1248828809.2670.144.camel@rzhang-dt>
Message-ID: <Pine.LNX.4.64.0907290420120.16543@ask.diku.dk>
References: <Pine.LNX.4.64.0907281756010.28189@ask.diku.dk>
 <1248828809.2670.144.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511516320-1931889447-1248834032=:16543"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-1931889447-1248834032=:16543
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 29 Jul 2009, Zhang Rui wrote:

> On Tue, 2009-07-28 at 23:56 +0800, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > backlight_device_register may return an ERR_PTR value rather than a valid
> > pointer.
> > 
> > A simplified version of the semantic match that finds this problem is as
> > follows: (http://coccinelle.lip6.fr/)
> 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> >  drivers/acpi/video.c                |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> > index 8851315..29788db 100644
> > --- a/drivers/acpi/video.c
> > +++ b/drivers/acpi/video.c
> > @@ -982,6 +982,8 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
> >  		sprintf(name, "acpi_video%d", count++);
> >  		device->backlight = backlight_device_register(name,
> >  			NULL, device, &acpi_backlight_ops);
> > +		if (IS_ERR(device->backlight))
> > +			return;
> 
> we should kfree(name) here.

Yes, good point.

thanks,
julia

> >  		device->backlight->props.max_brightness = device->brightness->count-3;
> >  		kfree(name);
> 
> how about this one?
> 
> ÿÿbacklight_device_register may return an ERR_PTR value rather than a valid
> pointer.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/acpi/video.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/acpi/video.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/video.c
> +++ linux-2.6/drivers/acpi/video.c
> @@ -982,8 +982,10 @@ static void acpi_video_device_find_cap(s
>  		sprintf(name, "acpi_video%d", count++);
>  		device->backlight = backlight_device_register(name,
>  			NULL, device, &acpi_backlight_ops);
> -		device->backlight->props.max_brightness = device->brightness->count-3;
>  		kfree(name);
> +		if (IS_ERR(device->backlight))
> +			return;
> +		device->backlight->props.max_brightness = device->brightness->count-3;
>  
>  		result = sysfs_create_link(&device->backlight->dev.kobj,
>  					   &device->dev->dev.kobj, "device");
> 
> 
> 
>  
> 
> 
---511516320-1931889447-1248834032=:16543--
