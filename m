Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbZKRPvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbZKRPvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 10:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757207AbZKRPvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 10:51:11 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53177 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754503AbZKRPvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 10:51:10 -0500
Date: Wed, 18 Nov 2009 10:51:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
       <accessrunner-general@lists.sourceforge.net>
Subject: Re: cxacru usb_bulk_msg() firmware upload 36x slower with OHCI vs.
 UHCI
In-Reply-To: <f9dbd9c6516a5f8e45d3883636b97bd5a9c2c1e5@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
Message-ID: <Pine.LNX.4.44L0.0911181045060.3036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009, Simon Arlott wrote:

> Can anyone explain this speed difference I'm seeing with usb_bulk_msg()?
> 
> Increasing the size of the data doesn't improve the speed at all. This
> makes firmware loading take significantly longer with OHCI.
> 
> I've tested this with two UHCI controllers, two OHCI controllers, and
> two different versions of the device. Even on the same system with the
> same device the speed difference occurs between OHCI and UHCI.
> 
> I've added a debug line to drivers/usb/atm/cxacru.c in cxacru_fw(),
> which uploads the firmware in PAGE_SIZE chunks:
> +                       printk(KERN_INFO "cxacru: sending fw %#x size %#x to %#x", fw, offb, offd);
>                         ret = usb_bulk_msg(usb_dev, usb_sndbulkpipe(usb_dev, CXACRU_EP_CMD),
> 
> 
> With OHCI and PAGE_SIZE chunks (4KB):
> [2567188.504299] cxacru: sending fw 0x3 size 0x1000 to 0xe00
> [2567188.760293] cxacru: sending fw 0x3 size 0x1000 to 0x1c00
> [2567189.016258] cxacru: sending fw 0x3 size 0x1000 to 0x2a00
> [2567189.272235] cxacru: sending fw 0x3 size 0x1000 to 0x3800
> [2567189.528210] cxacru: sending fw 0x3 size 0x1000 to 0x4600
> [2567189.784488] cxacru: sending fw 0x3 size 0x1000 to 0x5400
> ...
> [2567233.044134] cxacru: sending fw 0x3 size 0x2c0 to 0x98668

...

> With OHCI and PAGE_SIZE*8 chunks (32KB):
> [ 4731.826738] cxacru: sending fw 0x3 size 0x8000 to 0x7000
> [ 4733.874628] cxacru: sending fw 0x3 size 0x8000 to 0xe000
> [ 4735.922353] cxacru: sending fw 0x3 size 0x8000 to 0x15000
> [ 4737.970153] cxacru: sending fw 0x3 size 0x8000 to 0x1c000
> [ 4740.017937] cxacru: sending fw 0x3 size 0x8000 to 0x23000
> [ 4742.065814] cxacru: sending fw 0x3 size 0x8000 to 0x2a000
> ...
> [ 4774.830569] cxacru: sending fw 0x3 size 0x62c0 to #98668

Each OHCI transfer requires about 256 ms per 4-KB page.  There's no 
obvious reason for this to take so long.  I'd guess it was caused by a 
hardware problem except that you say the same thing happened with two 
different controllers.  Were they both on the same computer?

You may have to do a bisection search to find the answer.

Alan Stern

