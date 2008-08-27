Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbYH0IHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbYH0IHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 04:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYH0IHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 04:07:14 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:49925 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYH0IHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 04:07:13 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] USB: add USB test and measurement class driver
Date: Wed, 27 Aug 2008 10:08:24 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, Stefan Kopp <stefan_kopp@agilent.com>,
       Marcel Janssen <korgull@home.nl>, Felipe Balbi <me@felipebalbi.com>,
       linux-kernel@vger.kernel.org
References: <20080827000501.GA29570@kroah.com>
In-Reply-To: <20080827000501.GA29570@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808271008.25779.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 27 August 2008 02:05:01 schrieb Greg KH:
> +       intf = usb_find_interface(&usbtmc_driver, iminor(inode));
> +       if (!intf) {
> +               printk(KERN_ERR KBUILD_MODNAME
> +                      ": can not find device for minor %d", iminor(inode));
> +               return -ENODEV;
> +       }
> +
> +       data = usb_get_intfdata(intf);
> +       kref_get(&data->kref);
> +
> +       /* Store pointer in file structure's private data field */
> +       filp->private_data = data;
> +
> +       dev = &data->intf->dev;

> +static void usbtmc_delete(struct kref *kref)
> +{
> +       struct usbtmc_device_data *data = to_usbtmc_data(kref);
> +
> +       usb_put_dev(data->usb_dev);
> +       kfree(data->buffer);
> +       kfree(data);
> +}
> +

This is a race condition.

CPU A					CPU B
open()
usb_find_interface()
						disconnect()
						kref_put()
						usbtmc_delete()
						kfree()
kref_get()

You can write to free memory. You must use a static mutex for
mutual exclusion between open() and disconnect()

	Regards
		Oliver

