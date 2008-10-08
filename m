Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbYJHUfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbYJHUfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYJHUfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:35:03 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:41134 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYJHUfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:35:00 -0400
Date: Wed, 08 Oct 2008 16:34:37 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] drivers/acpi: dereference without an error test
In-reply-to: <200809261551.58262.brunel@diku.dk>
X-X-Sender: lenb@localhost.localdomain
To: Julien Brunel <brunel@diku.dk>
Cc: rui.zhang@intel.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-id: <alpine.LFD.1.10.0810081634300.3041@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200809261551.58262.brunel@diku.dk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied.

thanks,
-len

On Fri, 26 Sep 2008, Julien Brunel wrote:

> After a variable is assigned the result of backlight_device_register, an error
> test should be performed before a dereference. 
> 
> A simplified version of the semantic match that finds this problem is
> as follows: 
> (http://www.emn.fr/x-info/coccinelle/)
> // <smpl>
> @def0@
> expression x;
> position p0;
> @@
> 
> x@p0 = backlight_device_register(...)
> 
> @protected@
> expression def0.x,E;
> position def0.p0;
> position p;
> statement S;
> @@
> x@p0
> ... when != x = E
> if (!IS_ERR(x) && ...) {<... x@p ...>} else S
> 
> @unprotected@
> expression def0.x,E;
> identifier fld;
> position def0.p0;
> position p != protected.p;
> @@
> x@p0
> ... when != x = E
> * x@p->fld
> // </smpl>
> 
> Signed-off-by: Julien Brunel <brunel@diku.dk>
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/acpi/video.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff -u -p a/drivers/acpi/video.c b/drivers/acpi/video.c
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -752,6 +752,8 @@ static void acpi_video_device_find_cap(s
>  		sprintf(name, "acpi_video%d", count++);
>  		device->backlight = backlight_device_register(name,
>  			NULL, device, &acpi_backlight_ops);
> +		if (IS_ERR(device->backlight))
> +			return;
>  		device->backlight->props.max_brightness = device->brightness->count-3;
>  		/*
>  		 * If there exists the _BQC object, the _BQC object will be
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
