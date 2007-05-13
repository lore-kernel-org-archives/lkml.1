Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbXEMSyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbXEMSyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 14:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbXEMSx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 14:53:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757988AbXEMSx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 14:53:58 -0400
Date: Sun, 13 May 2007 11:46:26 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Soeren Sonnenburg <kernel@nn7.de>, linux-input@atrey.karlin.mff.cuni.cz,
       nicolas@boichat.ch, linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>, zaitcev@redhat.com
Subject: Re: [PATCH] Make appletouch shut up when it has nothing to say
Message-Id: <20070513114626.d943999a.zaitcev@redhat.com>
In-Reply-To: <20070513172052.GA26712@srcf.ucam.org>
References: <1178995886.4168.10.camel@localhost>
	<20070513172052.GA26712@srcf.ucam.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 18:20:53 +0100, Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> +static void atp_reinit(struct work_struct *work)
> +{
> +	char data[8];
> +	size = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
> +			       ATP_GEYSER3_MODE_READ_REQUEST_ID,
> +			       USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> +			       ATP_GEYSER3_MODE_REQUEST_VALUE,
> +			       ATP_GEYSER3_MODE_REQUEST_INDEX, &data, 8, 5000);

Generally speaking, DMA-ing from stack is not allowed. Maybe you want
to add a comment saying "buffer on stack because this is Mac-only driver".
I would not ask for kmalloc here which is entirely pointless.

> +
> +		/* Geyser 3 will continue to send packets continually after
> +		   the first touch unless reinitialised. Do so if it's been
> +		   idle for a while in order to avoid waking the kernel up
> +		   several hundred times a second */
> +		if (dev->idlecount >= 10)
> +			queue_work (appletouch_wq, &dev->work);

So, why don't you check for Geyser 3 or whatnot here instead of doing
it inside the work function? Why poking workqueue on other systems?

> +	appletouch_wq = create_singlethread_workqueue("kappletouch");
> +	if (!appletouch_wq) {
> +		printk(KERN_ERR "appletouch: failed to create workqueue\n");
> +		return -ENOMEM;
> +	}
>  	return usb_register(&atp_driver);

I'm wondering about the wisdom of this too. Why won't the stock
workqueue work? We have way too many daemons already. Plus, making
one more unconditionally regardless of hardware present seems like
stepping over the line to me.

Overall this seems like a good patch to me, only needs to be less
intrusive for owners of other hardware.

-- Pete
