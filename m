Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbXK3XGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbXK3XGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbXK3XG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:06:26 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:16821 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbXK3XGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:06:25 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2007 18:06:25 EST
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: WARNING: at kernel/resource.c:189 __release_resource
Date: Fri, 30 Nov 2007 15:58:13 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, matthew@wil.cx,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, drzeus@drzeus.cx
References: <4745F77C.7040402@gmail.com> <200711301408.13422.bjorn.helgaas@hp.com> <47509393.8000703@gmail.com>
In-Reply-To: <47509393.8000703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711301558.13538.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2007 03:49:55 pm Jiri Slaby wrote:
> On 11/30/2007 10:08 PM, Bjorn Helgaas wrote:
> > On Thursday 29 November 2007 05:42:07 pm Andrew Morton wrote:
> >> On Thu, 29 Nov 2007 16:40:37 -0700
> >>> Maybe we could either remove the pnp_{stop,start}_dev() calls
> >>> from the suspend/resume path, or move the PNP resource management
> >>> out of pnp_{start,stop}_dev().
> >>>
> >>> Bjorn
> >>>
> >>> [1] http://lkml.org/lkml/2005/11/30/39
> >> So was this particular problem caused/exposed by
> >> pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch, or is
> >> it in mainline?
> > 
> > I'm pretty sure this problem is caused by that patch, so we
> > we shouldn't see this in mainline.
> > 
> > Jiri, can you try the additional patch below, please?
> > 
> > Index: linux-mm/drivers/pnp/driver.c
> > ===================================================================
> > --- linux-mm.orig/drivers/pnp/driver.c	2007-11-30 13:58:25.000000000 -0700
> > +++ linux-mm/drivers/pnp/driver.c	2007-11-30 13:59:37.000000000 -0700
> > @@ -161,13 +161,6 @@
> >  			return error;
> >  	}
> >  
> > -	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE) &&
> > -	    pnp_can_disable(pnp_dev)) {
> > -		error = pnp_stop_dev(pnp_dev);
> > -		if (error)
> > -			return error;
> > -	}
> > -
> >  	if (pnp_dev->protocol && pnp_dev->protocol->suspend)
> >  		pnp_dev->protocol->suspend(pnp_dev, state);
> >  	return 0;
> > @@ -185,12 +178,6 @@
> >  	if (pnp_dev->protocol && pnp_dev->protocol->resume)
> >  		pnp_dev->protocol->resume(pnp_dev);
> >  
> > -	if (!(pnp_drv->flags & PNP_DRIVER_RES_DO_NOT_CHANGE)) {
> > -		error = pnp_start_dev(pnp_dev);
> > -		if (error)
> > -			return error;
> > -	}
> > -
> >  	if (pnp_drv->resume)
> >  		return pnp_drv->resume(pnp_dev);
> >  
> 
> No, it breaks suspend.

Thanks for trying it.  What are the symptoms?  I'd like to understand
why we need to stop the devices before suspend.

Bjorn
