Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbYH0QFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbYH0QFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757081AbYH0QFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:05:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbYH0QFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:05:00 -0400
Date: Wed, 27 Aug 2008 08:40:50 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, Stefan Kopp <stefan_kopp@agilent.com>,
       Marcel Janssen <korgull@home.nl>, Felipe Balbi <me@felipebalbi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: add USB test and measurement class driver
Message-ID: <20080827154050.GB19710@kroah.com>
References: <20080827000501.GA29570@kroah.com> <200808271008.25779.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200808271008.25779.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 10:08:24AM +0200, Oliver Neukum wrote:
> Am Mittwoch 27 August 2008 02:05:01 schrieb Greg KH:
> > +       intf = usb_find_interface(&usbtmc_driver, iminor(inode));
> > +       if (!intf) {
> > +               printk(KERN_ERR KBUILD_MODNAME
> > +                      ": can not find device for minor %d", iminor(inode));
> > +               return -ENODEV;
> > +       }
> > +
> > +       data = usb_get_intfdata(intf);
> > +       kref_get(&data->kref);
> > +
> > +       /* Store pointer in file structure's private data field */
> > +       filp->private_data = data;
> > +
> > +       dev = &data->intf->dev;
> 
> > +static void usbtmc_delete(struct kref *kref)
> > +{
> > +       struct usbtmc_device_data *data = to_usbtmc_data(kref);
> > +
> > +       usb_put_dev(data->usb_dev);
> > +       kfree(data->buffer);
> > +       kfree(data);
> > +}
> > +
> 
> This is a race condition.
> 
> CPU A					CPU B
> open()
> usb_find_interface()
> 						disconnect()
> 						kref_put()
> 						usbtmc_delete()
> 						kfree()
> kref_get()
> 
> You can write to free memory. You must use a static mutex for
> mutual exclusion between open() and disconnect()

Ah, thanks, for some reason I thought that this wasn't needed with the
kref code, but you are correct.

Hm, in looking at the usb driver tree, there are lots of drivers in
there with that problem :)

Now fixed up in this driver.

thanks,

greg k-h
