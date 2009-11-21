Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbZKUVoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbZKUVoG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 16:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756699AbZKUVoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 16:44:05 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:32954 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbZKUVoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 16:44:04 -0500
Date: Sat, 21 Nov 2009 22:44:08 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: maciej.sosnowski@intel.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org,
       Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Subject: Re: [PATCH 7/8] drivers/dma: introduce missing kfree
In-Reply-To: <e9c3a7c20911211321x4f87f616ya6bf7561ff5748f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0911212243420.28848@ask.diku.dk>
References: <Pine.LNX.4.64.0911211252180.23681@ask.diku.dk>
 <e9c3a7c20911211321x4f87f616ya6bf7561ff5748f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511516320-1799644698-1258839848=:28848"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-1799644698-1258839848=:28848
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 21 Nov 2009, Dan Williams wrote:

> On Sat, Nov 21, 2009 at 4:52 AM, Julia Lawall <julia@diku.dk> wrote:
> > From: Julia Lawall <julia@diku.dk>
> >
> > Error handling code following a kzalloc should free the allocated data.
> >
> 
> Yes, but there is another buglet here:
> 
> >        /* get platform data */
> >        if (!pdev->dev.platform_data)
> > -               goto shdev_err;
> > +               goto platform_err;
> 
> "err" is still zero at this point so the probe does not fail.
> 
> How about the following instead?

OK, that is indeed both better and simpler.

thanks,
julia


> diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
> index b3b065c..034ecf0 100644
> --- a/drivers/dma/shdma.c
> +++ b/drivers/dma/shdma.c
> @@ -640,17 +640,16 @@ static int __init sh_dmae_probe(struct
> platform_device *pdev)
>  #endif
>         struct sh_dmae_device *shdev;
> 
> +       /* get platform data */
> +       if (!pdev->dev.platform_data)
> +               return -ENODEV;
> +
>         shdev = kzalloc(sizeof(struct sh_dmae_device), GFP_KERNEL);
>         if (!shdev) {
>                 dev_err(&pdev->dev, "No enough memory\n");
> -               err = -ENOMEM;
> -               goto shdev_err;
> +               return -ENOMEM;
>         }
> 
> -       /* get platform data */
> -       if (!pdev->dev.platform_data)
> -               goto shdev_err;
> -
>         /* platform data */
>         memcpy(&shdev->pdata, pdev->dev.platform_data,
>                         sizeof(struct sh_dmae_pdata));
> @@ -722,7 +721,6 @@ eirq_err:
>  rst_err:
>         kfree(shdev);
> 
> -shdev_err:
>         return err;
>  }
> 
---511516320-1799644698-1258839848=:28848--
