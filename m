Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbYCZNEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbYCZNEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 09:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYCZNDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 09:03:52 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:28918 "EHLO
	outbound1-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938AbYCZNDv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 09:03:51 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0JYC9LP-01-QRM-01
Message-ID: <47EA48C2.4040407@amd.com>
Date: Wed, 26 Mar 2008 13:59:46 +0100
From: Thomas Dahlmann <thomas.dahlmann@amd.com>
User-Agent: Thunderbird 1.5.0.5 (Windows/20060719)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] mem leak fixes for AMD 5536 UDC high/full speed USB device
 controller driver
References: <alpine.LNX.1.00.0803212335130.10052@dragon.funnycrock.com>
In-Reply-To: <alpine.LNX.1.00.0803212335130.10052@dragon.funnycrock.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 Mar 2008 13:02:29.0387 (UTC) FILETIME=[A5976DB0:01C88F41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK, thanks.

While testing some of these error cases I found that
there is even some more improvement possible which
I will have to do e.g. changing udc_pci_remove().

Thomas

Jesper Juhl wrote:
> In drivers/usb/gadget/amd5536udc.c::udc_pci_probe(),
> sizeof(struct udc) storage is allocated for 'dev'.
>
> There are many exit points from the function where
> 'dev' is not free'd but has also not yet been used
> for anything. The following patch free's 'dev' at the
> return points where it has not yet been used.
>
> Please consider applying.
>
>
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
>
>  amd5536udc.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
> index b663f23..fc6f348 100644
> --- a/drivers/usb/gadget/amd5536udc.c
> +++ b/drivers/usb/gadget/amd5536udc.c
> @@ -3248,6 +3248,8 @@ static int udc_pci_probe(
>  
>  	/* pci setup */
>  	if (pci_enable_device(pdev) < 0) {
> +		kfree(dev);
> +		dev = 0;
>  		retval = -ENODEV;
>  		goto finished;
>  	}
> @@ -3259,6 +3261,8 @@ static int udc_pci_probe(
>  
>  	if (!request_mem_region(resource, len, name)) {
>  		dev_dbg(&pdev->dev, "pci device used already\n");
> +		kfree(dev);
> +		dev = 0;
>  		retval = -EBUSY;
>  		goto finished;
>  	}
> @@ -3267,18 +3271,24 @@ static int udc_pci_probe(
>  	dev->virt_addr = ioremap_nocache(resource, len);
>  	if (dev->virt_addr == NULL) {
>  		dev_dbg(&pdev->dev, "start address cannot be mapped\n");
> +		kfree(dev);
> +		dev = 0;
>  		retval = -EFAULT;
>  		goto finished;
>  	}
>  
>  	if (!pdev->irq) {
>  		dev_err(&dev->pdev->dev, "irq not set\n");
> +		kfree(dev);
> +		dev = 0;
>  		retval = -ENODEV;
>  		goto finished;
>  	}
>  
>  	if (request_irq(pdev->irq, udc_irq, IRQF_SHARED, name, dev) != 0) {
>  		dev_dbg(&dev->pdev->dev, "request_irq(%d) fail\n", pdev->irq);
> +		kfree(dev);
> +		dev = 0;
>  		retval = -EBUSY;
>  		goto finished;
>  	}
>
>
>
>
>   


-- 
Thomas Dahlmann
Software Engineer
AMD, Customer Support Services
voice: (+49 351) 277-6017
fax  : (+49 351) 277-96017
email: Thomas.Dahlmann@amd.com
http://www.amd.com

AMD Saxony Limited Liability Company & Co. KG
Sitz (Geschäftsanschrift): Wilschdorfer Landstr. 101, 01109 Dresden, Deutschland
Registergericht Dresden: HRA 4896
Vertretungsberechtigter Komplementär: AMD Saxony LLC (Sitz Wilmington, Delaware, USA)
Geschäftsführer der AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


