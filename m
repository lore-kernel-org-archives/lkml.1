Return-Path: <linux-kernel-owner+w=401wt.eu-S1756462AbZKUVVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462AbZKUVVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 16:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbZKUVVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 16:21:08 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:54607 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbZKUVVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 16:21:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LxezbRNyOyG4gQ9ZKWRLSX9XrpJcdR8jI39L6EKoPM9Lutk8R/dthuHxR5ed7RMw7J
         YRHgQzkuf+IzlUtexVlvwmVMFjloy+N85GmKD32sQJCYZUPi8VsWpMwQ3iqXAZ4gu5Y+
         mMUQE3v8WP4RW7UavO7lGLpn216U3BR69QB4Y=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0911211252180.23681@ask.diku.dk>
References: <Pine.LNX.4.64.0911211252180.23681@ask.diku.dk>
Date: Sat, 21 Nov 2009 14:21:12 -0700
X-Google-Sender-Auth: 541fe61987796e84
Message-ID: <e9c3a7c20911211321x4f87f616ya6bf7561ff5748f@mail.gmail.com>
Subject: Re: [PATCH 7/8] drivers/dma: introduce missing kfree
From: Dan Williams <dan.j.williams@intel.com>
To: Julia Lawall <julia@diku.dk>
Cc: maciej.sosnowski@intel.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org,
       Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 21, 2009 at 4:52 AM, Julia Lawall <julia@diku.dk> wrote:
> From: Julia Lawall <julia@diku.dk>
>
> Error handling code following a kzalloc should free the allocated data.
>

Yes, but there is another buglet here:

>        /* get platform data */
>        if (!pdev->dev.platform_data)
> -               goto shdev_err;
> +               goto platform_err;

"err" is still zero at this point so the probe does not fail.

How about the following instead?

diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index b3b065c..034ecf0 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -640,17 +640,16 @@ static int __init sh_dmae_probe(struct
platform_device *pdev)
 #endif
        struct sh_dmae_device *shdev;

+       /* get platform data */
+       if (!pdev->dev.platform_data)
+               return -ENODEV;
+
        shdev = kzalloc(sizeof(struct sh_dmae_device), GFP_KERNEL);
        if (!shdev) {
                dev_err(&pdev->dev, "No enough memory\n");
-               err = -ENOMEM;
-               goto shdev_err;
+               return -ENOMEM;
        }

-       /* get platform data */
-       if (!pdev->dev.platform_data)
-               goto shdev_err;
-
        /* platform data */
        memcpy(&shdev->pdata, pdev->dev.platform_data,
                        sizeof(struct sh_dmae_pdata));
@@ -722,7 +721,6 @@ eirq_err:
 rst_err:
        kfree(shdev);

-shdev_err:
        return err;
 }
