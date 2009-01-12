Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbZALUo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbZALUo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZALUoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:44:20 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:34574 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZALUoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:44:19 -0500
Date: Mon, 12 Jan 2009 12:44:17 -0800
From: Ira Snyder <iws@ovro.caltech.edu>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>,
       "leoli@freescale.com" <leoli@freescale.com>,
       "zw@zh-kernel.org" <zw@zh-kernel.org>
Subject: Re: dmaengine: BUG: Unable to handle kernel paging request
Message-ID: <20090112204417.GB2364@ovro.caltech.edu>
References: <20090112180423.GA2364@ovro.caltech.edu> <1231787318.25777.10.camel@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231787318.25777.10.camel@dwillia2-linux.ch.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 12 Jan 2009 12:44:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 12:08:38PM -0700, Dan Williams wrote:
> On Mon, 2009-01-12 at 11:04 -0700, Ira Snyder wrote:
> > Hello all,
> > 
> > I'm working on a driver that uses DMAEngine. With the recent changes,
> > the driver doesn't work anymore.
> > 
> > I believe I have tracked it down to commit
> > 41d5e59c1299f27983977bcfe3b360600996051c, but it could be one of the
> > other DMAEngine commits.
> > 
> > The code that crashes is in mm/dmapool.c, line 178:
> > if (list_empty(&dev->dma_pools))
> > 
> > I distilled the crash down to the following simple driver, which should
> > just get a reference to dmaengine, in preparation for acquiring a
> > channel to use.
> 
> I believe the problem is that the driver uses the channel device value
> before it is created.  Prior to this patch the following line in
> fsl_dma_chan_probe:
> 
> new_fsl_chan->dev = &new_fsl_chan->common.dev
> 
> ...would retrieve a pointer to the uninitialized struct device in
> dma_chan.  The later call to dma_async_device_register in
> of_fsl_dma_probe fixed up this uninitialized data.
> 
> However, the dmaengine sysfs implementation was fixed to support proper
> lifetime rules which means that the current:
> 
> new_fsl_chan->dev = &new_fsl_chan->common.dev->device;
> 
> ...retrieves a NULL pointer because new_fsl_chan->common.dev has not
> been allocated at this point.
> 
> The following may fix this up...
> 
> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> index ca70a21..748e140 100644
> --- a/drivers/dma/fsldma.c
> +++ b/drivers/dma/fsldma.c
> @@ -822,7 +822,7 @@ static int __devinit fsl_dma_chan_probe(struct fsl_dma_device *fdev,
>  	 */
>  	WARN_ON(fdev->feature != new_fsl_chan->feature);
>  
> -	new_fsl_chan->dev = &new_fsl_chan->common.dev->device;
> +	new_fsl_chan->dev = fdev->dev;
>  	new_fsl_chan->reg_base = ioremap(new_fsl_chan->reg.start,
>  			new_fsl_chan->reg.end - new_fsl_chan->reg.start + 1);
>  
> 
> 

Yep, this patch works great. The /sys/class/dma/dma0chan[0123] nodes
still show up fine. DMA is working.

Thanks,
Ira
