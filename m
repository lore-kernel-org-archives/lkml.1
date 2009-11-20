Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZKTWlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZKTWlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 17:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbZKTWle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 17:41:34 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:37333 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754752AbZKTWld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 17:41:33 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH v4] [RFC] NEXIO (or iNexio) support for usbtouchscreen
Date: Fri, 20 Nov 2009 23:41:29 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, daniel.ritz@gmx.ch,
       linux-kernel@vger.kernel.org
References: <200911161515.00907.linux@rainbow-software.org> <200911201021.45410.linux@rainbow-software.org> <200911201943.46696.oliver@neukum.org>
In-Reply-To: <200911201943.46696.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911202341.31496.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 November 2009 19:43:46 Oliver Neukum wrote:
> Am Freitag, 20. November 2009 10:21:43 schrieb Ondrej Zary:
> > On Thursday 19 November 2009, Oliver Neukum wrote:
> > > > +struct nexio_priv {
> > > > +	struct urb *ack;
> > > > +	char ack_buf[2];
> > > > +};
> > >
> > > No. Every buffer needs to have an exclusive cache line for DMA
> > > to work on the incoherent archotectures. Therefore you must allocate
> > > each buffer with its own kmalloc.
> >
> > OK, thanks for your patience.
>
> No problem. I should have explained better.
>
> > > > +	/* read replies */
> > > > +	for (i = 0; i < 3; i++) {
> > > > +		memset(buf, 0, NEXIO_BUFSIZE);
> > > > +		ret = usb_bulk_msg(dev, usb_rcvbulkpipe(dev, NEXIO_INPUT_EP),
> > > > +				   buf, NEXIO_BUFSIZE, &actual_len,
> > > > +				   NEXIO_TIMEOUT);
> > > > +		if (ret < 0 || actual_len < 1 || buf[1] != actual_len)
> > > > +			continue;
> > > > +		switch (buf[0]) {
> > > > +			case 0x83:	/* firmware version */
> > > > +				firmware_ver = kstrdup(&buf[2], GFP_KERNEL);
>
> On second thought this is not nice. If a device is broken enough to report
> a name or a firmware version twice, you produce a memory leak.
> Do you know very buggy devices to exist?

Oh yes, that might be a problem - I'll add a NULL check before kstrdup. And 
maybe it should not be hardcoded to 3 reads - had to check this.

> > > > +				break;
> > > > +			case 0x84:	/* device name */
> > > > +				device_name = kstrdup(&buf[2], GFP_KERNEL);
> > > > +				break;
> > > > +		}
> > > > +	}
> > > > +	printk(KERN_INFO "Nexio device: %s, firmware version: %s\n",
> > > > +	       device_name, firmware_ver);
> > >
> > > How do you know device_name and firmware_ver are not NULL?
> >
> > printk works fine with NULL, it prints <NULL>. Is it necessary to add
> > more code only to make the output nice?
>
> No, for niceness it is not necessary. The question is whether you want
> to treat this as an error or print a warning. That is a matter of taste.

As there's no datasheet and I have only one device (with one firmware 
version), ignoring it looks like the best "solution".

I'll also want to remove NEXIO_INPUT_EP and NEXIO_OUTPUT_EP constants - the 
endpoint addresses can be found at runtine (there's only one input and one 
output endpoint). I think that to do this in nexio_init(), it needs to 
know "struct usb_interface *" instead of "struct usb_device *". I have a 
patch ready (but forgot to take it so it needs to wait until next week) that 
replaces "struct usb_device *udev" in struct usbtouch_usb with "struct 
usb_interface *interface" - is it a good idea?

>
> > Looks like a bug in the original usbtouchscreen code. There's no locking.
> > Will a spinlock in usbtouch_open() and usbtouch_disconnect() fix it? Or
> > do you see more problems here?
>
> You must not call usb_kill_urb() with a spinlock held.
> I'll lokk at the usbtouchscreen code.
> The new version looks good to me.
>
> 	Regards
> 		Oliver
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Ondrej Zary
