Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbYIKLbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbYIKLbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 07:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYIKLaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 07:30:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:44848 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752173AbYIKLaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 07:30:55 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19njDg18DVn7NnenmqD2DmstmK6Yjo3MCnDGJWlRt
	QTdPUmiMfDrbQb
Date: Thu, 11 Sep 2008 13:30:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: roel kluin <roel.kluin@gmail.com>
cc: mchehab@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: pxa-camera: Unsigned dma_chans[] cannot be
 negative
In-Reply-To: <48C7F1EA.6070008@gmail.com>
Message-ID: <Pine.LNX.4.64.0809102334080.8749@axis700.grange>
References: <48C7F1EA.6070008@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2008, roel kluin wrote:

> Unsigned dma_chans[] cannot be negative
> 
> Note that also the third time dma_chans[0] < 0 was tested instead of dma_chans[2]
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index ead87dd..950a2d4 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -1078,7 +1078,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  	struct pxa_camera_dev *pcdev;
>  	struct resource *res;
>  	void __iomem *base;
> -	int irq;
> +	int irq, retval;
>  	int err = 0;

You don't need an extra variable here, please just use err.

>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -1144,31 +1144,34 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  	pcdev->dev = &pdev->dev;
>  
>  	/* request dma */
> -	pcdev->dma_chans[0] = pxa_request_dma("CI_Y", DMA_PRIO_HIGH,
> +	retval = pxa_request_dma("CI_Y", DMA_PRIO_HIGH,
>  					      pxa_camera_dma_irq_y, pcdev);

also, please align the second line to start behind the opening 
parenthesis:

-	pcdev->dma_chans[0] = pxa_request_dma("CI_Y", DMA_PRIO_HIGH,
- 					      pxa_camera_dma_irq_y, pcdev);
+	err = pxa_request_dma("CI_Y", DMA_PRIO_HIGH,
+			      pxa_camera_dma_irq_y, pcdev);

> -	if (pcdev->dma_chans[0] < 0) {
> +	if (retval < 0) {
>  		dev_err(pcdev->dev, "Can't request DMA for Y\n");
>  		err = -ENOMEM;

...and then remove this overwriting, anyway I don't think -ENOMEM is a 
very good return code here. Just return with what pxa_request_dma 
returned.

>  		goto exit_iounmap;
>  	}
> +	pcdev->dma_chans[0] = retval;
>  	dev_dbg(pcdev->dev, "got DMA channel %d\n", pcdev->dma_chans[0]);
>  
> -	pcdev->dma_chans[1] = pxa_request_dma("CI_U", DMA_PRIO_HIGH,
> +	retval = pxa_request_dma("CI_U", DMA_PRIO_HIGH,
>  					      pxa_camera_dma_irq_u, pcdev);
> -	if (pcdev->dma_chans[1] < 0) {
> +	if (retval < 0) {
>  		dev_err(pcdev->dev, "Can't request DMA for U\n");
>  		err = -ENOMEM;
>  		goto exit_free_dma_y;
>  	}
> +	pcdev->dma_chans[1] = retval;
>  	dev_dbg(pcdev->dev, "got DMA channel (U) %d\n", pcdev->dma_chans[1]);
>  
> -	pcdev->dma_chans[2] = pxa_request_dma("CI_V", DMA_PRIO_HIGH,
> +	retval = pxa_request_dma("CI_V", DMA_PRIO_HIGH,
>  					      pxa_camera_dma_irq_v, pcdev);
> -	if (pcdev->dma_chans[0] < 0) {
> +	if (retval < 0) {
>  		dev_err(pcdev->dev, "Can't request DMA for V\n");
>  		err = -ENOMEM;
>  		goto exit_free_dma_u;
>  	}
> +	pcdev->dma_chans[2] = retval;
>  	dev_dbg(pcdev->dev, "got DMA channel (V) %d\n", pcdev->dma_chans[2]);
>  
>  	DRCMR68 = pcdev->dma_chans[0] | DRCMR_MAPVLD;

Otherwise looks good! Please, resubmit and I'll pass it on to v4l 
maintainer.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
