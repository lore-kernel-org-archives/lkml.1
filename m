Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbXIYGCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbXIYGCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 02:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbXIYGCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 02:02:32 -0400
Received: from mail.queued.net ([207.210.101.209]:2501 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbXIYGCc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 02:02:32 -0400
Date: Tue, 25 Sep 2007 02:02:45 -0400
From: Andres Salomon <dilinger@queued.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org, akpm@linux-foundation.org,
       corbet@lwn.net
Subject: Re: [v4l-dvb-maintainer] [PATCH] cafe_ccic: default to allocating
 DMA buffers at probe time
Message-Id: <20070925020245.57fe4c2c.dilinger@queued.net>
In-Reply-To: <1190646257.8360.65.camel@gaivota>
References: <20070919014418.073543bc.dilinger@queued.net>
	<1190646257.8360.65.camel@gaivota>
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007 12:04:17 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> Hi Andres,
> 
> Still missing on your patch is your SOB ;) From what I got from Jon, he
> is ok with your patch.
> 
> Cheers,
> Mauro.


Whoops, sorry about that!   well, here it is (for the patch below):

Signed-off-by: Andres Salomon <dilinger@debian.org>


> 
> Em Qua, 2007-09-19 às 01:44 -0400, Andres Salomon escreveu:
> > By default, we allocate DMA buffers when actually reading from the video
> > capture device.  On a system with 128MB or 256MB of ram, it's very easy
> > for that memory to quickly become fragmented.  We've had users report
> > having 30+MB of memory free, but the cafe_ccic driver is still unable to
> > allocate DMA buffers.
> > 
> > Our workaround has been to make use of the 'alloc_bufs_at_load' parameter
> > to allocate DMA buffers during device probing.  This patch makes DMA
> > buffer allocation happen during device probe by default, and changes
> > the parameter to 'alloc_bufs_at_read'.  The camera hardware is there,
> > if the cafe_ccic driver is enabled/loaded it should do its best to ensure
> > that the camera is actually usable; delaying DMA buffer allocation
> > saves an insignicant amount of memory, and causes the driver to be much
> > less useful.
> > ---
> > 
> >  drivers/media/video/cafe_ccic.c |   18 +++++++++---------
> >  1 files changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
> > index ef53618..3588a59 100644
> > --- a/drivers/media/video/cafe_ccic.c
> > +++ b/drivers/media/video/cafe_ccic.c
> > @@ -63,13 +63,13 @@ MODULE_SUPPORTED_DEVICE("Video");
> >   */
> >  
> >  #define MAX_DMA_BUFS 3
> > -static int alloc_bufs_at_load = 0;
> > -module_param(alloc_bufs_at_load, bool, 0444);
> > -MODULE_PARM_DESC(alloc_bufs_at_load,
> > -		"Non-zero value causes DMA buffers to be allocated at module "
> > -		"load time.  This increases the chances of successfully getting "
> > -		"those buffers, but at the cost of nailing down the memory from "
> > -		"the outset.");
> > +static int alloc_bufs_at_read = 0;
> > +module_param(alloc_bufs_at_read, bool, 0444);
> > +MODULE_PARM_DESC(alloc_bufs_at_read,
> > +		"Non-zero value causes DMA buffers to be allocated when the "
> > +		"video capture device is read, rather than at module load "
> > +		"time.  This saves memory, but decreases the chances of "
> > +		"successfully getting those buffers.");
> >  
> >  static int n_dma_bufs = 3;
> >  module_param(n_dma_bufs, uint, 0644);
> > @@ -1503,7 +1503,7 @@ static int cafe_v4l_release(struct inode *inode, struct file *filp)
> >  	}
> >  	if (cam->users == 0) {
> >  		cafe_ctlr_power_down(cam);
> > -		if (! alloc_bufs_at_load)
> > +		if (alloc_bufs_at_read)
> >  			cafe_free_dma_bufs(cam);
> >  	}
> >  	mutex_unlock(&cam->s_mutex);
> > @@ -2162,7 +2162,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
> >  	/*
> >  	 * If so requested, try to get our DMA buffers now.
> >  	 */
> > -	if (alloc_bufs_at_load) {
> > +	if (!alloc_bufs_at_read) {
> >  		if (cafe_alloc_dma_bufs(cam, 1))
> >  			cam_warn(cam, "Unable to alloc DMA buffers at load"
> >  					" will try again later.");
> > 
> > _______________________________________________
> > v4l-dvb-maintainer mailing list
> > v4l-dvb-maintainer@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer
> -- 
> Cheers,
> Mauro
> 


-- 
Andres Salomon <dilinger@queued.net>
