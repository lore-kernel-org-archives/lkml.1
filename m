Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZCKB7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZCKB7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 21:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZCKB7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 21:59:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:58011 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZCKB7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 21:59:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aEqKgyXr6oJ8v6/015DyiYmv4lnriwSMUTAjYQP+nSV/5EdNAC/aggDh4Fx8/KjMCE
         kGKHttiM70UgiOwX7goZtfLibX8nuVLSHT6ShLZUEMXRHp+QsrOVCUGhupQZDaTMkVhl
         f/0BwHfuBs2dzWxOvxroqgyxVbQFzMMrgdG1Y=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0903102139150.20676@anakin>
References: <Pine.LNX.4.64.0903102139150.20676@anakin>
Date: Wed, 11 Mar 2009 09:59:09 +0800
Message-ID: <d82e647a0903101859p1cc2adf6s375b389907a31b82@mail.gmail.com>
Subject: Re: linux-next: NCR_700_detect warnings
From: Ming Lei <tom.leiming@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-next@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/11 Geert Uytterhoeven <geert@linux-m68k.org>:
> commit 76afea5b078d36ec080a75c29ff5a3fbc5774fee
> Author: Ming Lei <tom.leiming@gmail.com>
> Date:   Fri Feb 6 23:40:12 2009 +0800
>
>    platform driver: fix incorrect use of 'platform_bus_type' with 'struct devic
>
>    This patch fixes the bug reported in
>        http://bugzilla.kernel.org/show_bug.cgi?id=11681.
>
>    "Lots of device drivers register a 'struct device_driver' with
>    the '.bus' member set to '&platform_bus_type'. This is wrong,
>    since the platform_bus functions expect the 'struct device_driver'
>    to be wrapped up in a 'struct platform_driver' which provides
>    some additional callbacks (like suspend_late, resume_early).
>    The effect may be that platform_suspend_late() uses bogus data
>    outside the device_driver struct as a pointer pointer to the
>    device driver's suspend_late() function or other hard to
>    reproduce failures."(Lothar Wassmann)
>
>    Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>    Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
>    Acked-by: David Brownell <dbrownell@users.sourceforge.net>
>    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> This introduced the following warnings on m68k, as `dev' is now a
> `struct platform_device *' instead of a `struct device *':
>
> | drivers/scsi/a4000t.c:64: warning: passing argument 3 of 'NCR_700_detect' from incompatible pointer type
> | drivers/scsi/mvme16x_scsi.c:67: warning: passing argument 3 of 'NCR_700_detect' from incompatible pointer type
> | drivers/scsi/bvme6000_scsi.c:61: warning: passing argument 3 of 'NCR_700_detect' from incompatible pointer type
>
> I think the below is missing (untested on real hardware)?

Yes, you are correct. It is really missed.
Thanks!

>
> diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
> index 6d25aca..61af3d9 100644
> --- a/drivers/scsi/a4000t.c
> +++ b/drivers/scsi/a4000t.c
> @@ -61,7 +61,8 @@ static int __devinit a4000t_probe(struct platform_device *dev)
>        hostdata->dcntl_extra = EA_710;
>
>        /* and register the chip */
> -       host = NCR_700_detect(&a4000t_scsi_driver_template, hostdata, dev);
> +       host = NCR_700_detect(&a4000t_scsi_driver_template, hostdata,
> +                             &dev->dev);
>        if (!host) {
>                printk(KERN_ERR "a4000t-scsi: No host detected; "
>                                "board configuration problem?\n");
> diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scsi.c
> index 9e9a82b..5799cb5 100644
> --- a/drivers/scsi/bvme6000_scsi.c
> +++ b/drivers/scsi/bvme6000_scsi.c
> @@ -58,7 +58,8 @@ bvme6000_probe(struct platform_device *dev)
>        hostdata->ctest7_extra = CTEST7_TT1;
>
>        /* and register the chip */
> -       host = NCR_700_detect(&bvme6000_scsi_driver_template, hostdata, dev);
> +       host = NCR_700_detect(&bvme6000_scsi_driver_template, hostdata,
> +                             &dev->dev);
>        if (!host) {
>                printk(KERN_ERR "bvme6000-scsi: No host detected; "
>                                "board configuration problem?\n");
> diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.c
> index 7794fc1..b5fbfd6 100644
> --- a/drivers/scsi/mvme16x_scsi.c
> +++ b/drivers/scsi/mvme16x_scsi.c
> @@ -64,7 +64,8 @@ mvme16x_probe(struct platform_device *dev)
>        hostdata->ctest7_extra = CTEST7_TT1;
>
>        /* and register the chip */
> -       host = NCR_700_detect(&mvme16x_scsi_driver_template, hostdata, dev);
> +       host = NCR_700_detect(&mvme16x_scsi_driver_template, hostdata,
> +                             &dev->dev);
>        if (!host) {
>                printk(KERN_ERR "mvme16x-scsi: No host detected; "
>                                "board configuration problem?\n");
>
> Gr{oetje,eeting}s,
>
>                                                Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                                            -- Linus Torvalds
>



-- 
Lei Ming
