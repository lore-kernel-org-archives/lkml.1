Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYLJNIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYLJNIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYLJNIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:08:31 -0500
Received: from mga03.intel.com ([143.182.124.21]:21821 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657AbYLJNIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:08:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,747,1220252400"; 
   d="scan'208";a="88594410"
Date: Wed, 10 Dec 2008 20:43:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: use stack allocation for struct usb_ctrlrequest
Message-ID: <20081210124308.GB6772@localhost>
References: <20081210073247.GA18630@localhost> <200812101040.09886.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812101040.09886.laurent.pinchart@skynet.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, Dec 10, 2008 at 11:40:09AM +0200, Laurent Pinchart wrote:
> Hi Wu,
> 
> On Wednesday 10 December 2008, Wu Fengguang wrote:
> > sizeof(struct usb_ctrlrequest) = 8, which is as small as the *dt pointer
> > in a 64bit system.
> 
> The usb_ctrlrequest pointer is passed down to the hardware and must point to 
> DMA-able memory. For this reason you can't use the stack and must kmalloc() 
> the structure.

Ah thanks for the background. Does GFP_NOIO guarantee that?
e.g. what if the memory is allocated from ZONE_HIGHMEM?

Thanks,
Fengguang

> 
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  drivers/usb/core/message.c |   27 ++++++++-------------------
> >  1 file changed, 8 insertions(+), 19 deletions(-)
> >
> > --- linux-2.6.orig/drivers/usb/core/message.c
> > +++ linux-2.6/drivers/usb/core/message.c
> > @@ -130,26 +130,15 @@ int usb_control_msg(struct usb_device *d
> >  		    __u8 requesttype, __u16 value, __u16 index, void *data,
> >  		    __u16 size, int timeout)
> >  {
> > -	struct usb_ctrlrequest *dr;
> > -	int ret;
> > -
> > -	dr = kmalloc(sizeof(struct usb_ctrlrequest), GFP_NOIO);
> > -	if (!dr)
> > -		return -ENOMEM;
> > -
> > -	dr->bRequestType = requesttype;
> > -	dr->bRequest = request;
> > -	dr->wValue = cpu_to_le16p(&value);
> > -	dr->wIndex = cpu_to_le16p(&index);
> > -	dr->wLength = cpu_to_le16p(&size);
> > +	struct usb_ctrlrequest dr = {
> > +		.bRequestType = requesttype,
> > +		.bRequest = request,
> > +		.wValue = cpu_to_le16p(&value),
> > +		.wIndex = cpu_to_le16p(&index),
> > +		.wLength = cpu_to_le16p(&size),
> > +	};
> >
> > -	/* dbg("usb_control_msg"); */
> > -
> > -	ret = usb_internal_control_msg(dev, pipe, dr, data, size, timeout);
> > -
> > -	kfree(dr);
> > -
> > -	return ret;
> > +	return usb_internal_control_msg(dev, pipe, &dr, data, size, timeout);
> >  }
> >  EXPORT_SYMBOL_GPL(usb_control_msg);
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
