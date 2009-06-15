Return-Path: <linux-kernel-owner+w=401wt.eu-S1762404AbZFOPcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762404AbZFOPcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbZFOPby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:31:54 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:45642 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757279AbZFOPbw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:31:52 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 11:31:52 EDT
X-SpamScore: -33
X-BigFish: VPS-33(zz542N1432R4015L1805M9371Pzz1202hzzz2dh17ch17dh6bh61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] fbdev/xilinxfb: Fix improper casting and tighen up probe path
Date: Mon, 15 Jun 2009 09:16:43 -0600
In-Reply-To: <20090612175634.12827.12207.stgit@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fbdev/xilinxfb: Fix improper casting and tighen up probe path
Thread-Index: AcnrhzgVpKec9y03QnqT6EGrQ8sUrQCRPHsg
References: <20090612175634.12827.12207.stgit@localhost.localdomain>
From: John Linn <John.Linn@xilinx.com>
To: "Grant Likely" <grant.likely@secretlab.ca>, <linuxppc-dev@ozlabs.org>,
       <linux-kernel@vger.kernel.org>, <benh@kernel.crashing.org>
X-OriginalArrivalTime: 15 Jun 2009 15:16:44.0989 (UTC) FILETIME=[4B573ED0:01C9EDCC]
Message-ID: <20090615151646.6ADA0E5805C@mail92-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Grant Likely [mailto:grant.likely@secretlab.ca]
> Sent: Friday, June 12, 2009 11:57 AM
> To: linuxppc-dev@ozlabs.org; linux-kernel@vger.kernel.org;
benh@kernel.crashing.org; John Linn
> Subject: [PATCH] fbdev/xilinxfb: Fix improper casting and tighen up
probe path
> 
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> The xilinxfb driver is improperly casting a physical address to a
> u32, and the probe routine isn't as straight forward as it could be.
> (discovered by gcc spitting out warnings on most recent change to
> xilinxfb driver).
> 
> This patch fixes the cast and simplifies the probe path.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> John, can you please test and verify this fix is correct?

I will try to test it today.

-- John

> 
> Thanks,
> g.
> 
>  drivers/video/xilinxfb.c |   59
++++++++++++++++++----------------------------
>  1 files changed, 23 insertions(+), 36 deletions(-)
> 
> 
> diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
> index 7a868bd..b68b331 100644
> --- a/drivers/video/xilinxfb.c
> +++ b/drivers/video/xilinxfb.c
> @@ -124,7 +124,6 @@ struct xilinxfb_drvdata {
>  						registers */
> 
>  	dcr_host_t      dcr_host;
> -	unsigned int    dcr_start;
>  	unsigned int    dcr_len;
> 
>  	void		*fb_virt;	/* virt. address of the frame
buffer */
> @@ -325,8 +324,8 @@ static int xilinxfb_assign(struct device *dev,
>  					drvdata->regs);
>  	}
>  	/* Put a banner in the log (for DEBUG) */
> -	dev_dbg(dev, "fb: phys=%p, virt=%p, size=%x\n",
> -		(void *)drvdata->fb_phys, drvdata->fb_virt, fbsize);
> +	dev_dbg(dev, "fb: phys=%llx, virt=%p, size=%x\n",
> +		(unsigned long long)drvdata->fb_phys, drvdata->fb_virt,
fbsize);
> 
>  	return 0;	/* success */
> 
> @@ -404,9 +403,7 @@ xilinxfb_of_probe(struct of_device *op, const
struct of_device_id *match)
>  	u32 tft_access;
>  	struct xilinxfb_platform_data pdata;
>  	struct resource res;
> -	int size, rc;
> -	int start = 0, len = 0;
> -	dcr_host_t dcr_host;
> +	int size, rc, start;
>  	struct xilinxfb_drvdata *drvdata;
> 
>  	/* Copy with the default pdata (not a ptr reference!) */
> @@ -414,35 +411,39 @@ xilinxfb_of_probe(struct of_device *op, const
struct of_device_id *match)
> 
>  	dev_dbg(&op->dev, "xilinxfb_of_probe(%p, %p)\n", op, match);
> 
> +	/* Allocate the driver data region */
> +	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
> +	if (!drvdata) {
> +		dev_err(&op->dev, "Couldn't allocate device private
record\n");
> +		return -ENOMEM;
> +	}
> +
>  	/*
>  	 * To check whether the core is connected directly to DCR or PLB
>  	 * interface and initialize the tft_access accordingly.
>  	 */
>  	p = (u32 *)of_get_property(op->node, "xlnx,dcr-splb-slave-if",
NULL);
> -
> -	if (p)
> -		tft_access = *p;
> -	else
> -		tft_access = 0;		/* For backward compatibility */
> +	tft_access = p ? *p : 0;
> 
>  	/*
>  	 * Fill the resource structure if its direct PLB interface
>  	 * otherwise fill the dcr_host structure.
>  	 */
>  	if (tft_access) {
> +		drvdata->flags |= PLB_ACCESS_FLAG;
>  		rc = of_address_to_resource(op->node, 0, &res);
>  		if (rc) {
>  			dev_err(&op->dev, "invalid address\n");
> -			return -ENODEV;
> +			goto err;
>  		}
> -
>  	} else {
> +		res.start = 0;
>  		start = dcr_resource_start(op->node, 0);
> -		len = dcr_resource_len(op->node, 0);
> -		dcr_host = dcr_map(op->node, start, len);
> -		if (!DCR_MAP_OK(dcr_host)) {
> -			dev_err(&op->dev, "invalid address\n");
> -			return -ENODEV;
> +		drvdata->dcr_len = dcr_resource_len(op->node, 0);
> +		drvdata->dcr_host = dcr_map(op->node, start,
drvdata->len);
> +		if (!DCR_MAP_OK(drvdata->dcr_host)) {
> +			dev_err(&op->dev, "invalid DCR address\n");
> +			goto err;
>  		}
>  	}
> 
> @@ -467,26 +468,12 @@ xilinxfb_of_probe(struct of_device *op, const
struct of_device_id *match)
>  	if (of_find_property(op->node, "rotate-display", NULL))
>  		pdata.rotate_screen = 1;
> 
> -	/* Allocate the driver data region */
> -	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
> -	if (!drvdata) {
> -		dev_err(&op->dev, "Couldn't allocate device private
record\n");
> -		return -ENOMEM;
> -	}
>  	dev_set_drvdata(&op->dev, drvdata);
> +	return xilinxfb_assign(&op->dev, drvdata, res.start, &pdata);
> 
> -	if (tft_access)
> -		drvdata->flags |= PLB_ACCESS_FLAG;
> -
> -	/* Arguments are passed based on the interface */
> -	if (drvdata->flags & PLB_ACCESS_FLAG) {
> -		return xilinxfb_assign(&op->dev, drvdata, res.start,
&pdata);
> -	} else {
> -		drvdata->dcr_start = start;
> -		drvdata->dcr_len = len;
> -		drvdata->dcr_host = dcr_host;
> -		return xilinxfb_assign(&op->dev, drvdata, 0, &pdata);
> -	}
> + err:
> +	kfree(drvdata);
> +	return -ENODEV;
>  }
> 
>  static int __devexit xilinxfb_of_remove(struct of_device *op)
> 


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


