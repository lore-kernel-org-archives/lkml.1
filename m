Return-Path: <linux-kernel-owner+w=401wt.eu-S1759033AbXHXHVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbXHXHVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 03:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXHXHUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 03:20:53 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:42340 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbXHXHUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 03:20:52 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC] USB: driver for iphone charging
Date: Fri, 24 Aug 2007 09:20:46 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Matt Colyer <matt@colyer.name>, jeffm@suse.de
References: <20070823224514.GA25830@kroah.com>
In-Reply-To: <20070823224514.GA25830@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708240920.46397.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 24 August 2007 schrieb Greg KH:

Hi,

> +static int select_configuration(struct usb_device *udev)
> +{
> +       char *dummy_buffer = kzalloc(2, GFP_KERNEL);
> +       int retval;
> +
> +       if (!dummy_buffer)
> +               return -ENOMEM;
> +
> +       dbg(&udev->dev, "Calling set_configuration\n");
> +       retval = usb_driver_set_configuration(udev, 3);
> +       if (retval) {
> +               dev_err(&udev->dev, "Set Configuration failed :%d.\n", retval);
> +               goto exit;
> +       }
> +
> +       dbg(&udev->dev, "Sending first magic command\n");
> +       retval = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x40, 0x40,
> +                                0x6400, 0, dummy_buffer, 0, 100);
> +

int usb_driver_set_configuration(struct usb_device *udev, int config)
{
	struct set_config_request *req;

	req = kmalloc(sizeof(*req), GFP_KERNEL);
	if (!req)
		return -ENOMEM;
	req->udev = udev;
	req->config = config;
	INIT_WORK(&req->work, driver_set_config_work);

	usb_get_dev(udev);
	schedule_work(&req->work);
	return 0;
}

This schedules the change via a workqueue, so you'll be reprobed. If you
fire of the first vendor command you are doing so before the configuration
is changed. How is this supposed to work?

	Regards
		Oliver
