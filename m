Return-Path: <linux-kernel-owner+w=401wt.eu-S1762835AbYBFXD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762835AbYBFXD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757932AbYBFXDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:03:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54582 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440AbYBFXDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:03:19 -0500
Date: Wed, 6 Feb 2008 15:01:27 -0800
From: Greg KH <greg@kroah.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@users.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 2/2] - SH/Dreamcast - fix maple bus bugs
Message-ID: <20080206230127.GA9614@kroah.com>
References: <1202337981.6162.8.camel@localhost.localdomain> <1202338431.6162.15.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202338431.6162.15.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 10:53:51PM +0000, Adrian McMenamin wrote:
> -	dev->function = function;
> -	dev->dev.bus = &maple_bus_type;
> -	dev->dev.parent = &maple_bus;
> -	dev->dev.release = &maple_release_device;
> -	retval = device_register(&dev->dev);
> -	if (retval) {
> -		printk(KERN_INFO
> -		       "Maple bus: Attempt to register device (%x, %x) failed.\n",
> -		       dev->port, dev->unit);
> -		maple_free_dev(dev);
> +	mdev->function = function;
> +	mdev->dev.release = &maple_release_device;
> +	if (mdev->registered == 0) {
> +		retval = device_register(&mdev->dev);
> +		if (retval) {
> +			printk(KERN_INFO
> +			"Maple bus: Attempt to register device"
> +			" (%x, %x) failed.\n",
> +			mdev->port, mdev->unit);
> +			maple_free_dev(mdev);
> +			mdev = NULL;
> +			return;
> +		}
> +		mdev->registered = 1;
>  	}
> -	dev->registered = 1;

I think you are still papering over the real problem here of trying to
register a device twice.  That's something you should never be doing,
and your bus walking logic must be incorrect...

thanks,

greg k-h
