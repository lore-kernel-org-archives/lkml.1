Return-Path: <linux-kernel-owner+w=401wt.eu-S934142AbXEHQkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142AbXEHQkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934094AbXEHQkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:40:16 -0400
Received: from xenotime.net ([66.160.160.81]:47830 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933903AbXEHQkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:40:13 -0400
Date: Tue, 8 May 2007 09:45:02 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Dan Kruchinin <dubalom@gmail.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [PATCH -mm] drivers/usb/core/config.c:
 kzalloc(0, ..)
Message-Id: <20070508094502.efc32182.rdunlap@xenotime.net>
In-Reply-To: <Pine.LNX.4.44L0.0705081152590.3217-100000@iolanthe.rowland.org>
References: <20070508141453.GA12771@kroah.com>
	<Pine.LNX.4.44L0.0705081152590.3217-100000@iolanthe.rowland.org>
Organization: YPO4
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 11:57:07 -0400 (EDT) Alan Stern wrote:

> On Tue, 8 May 2007, Greg KH wrote:
> 
> > >  The problem was in drivers/usb/core/config.c in function 
> > >  usb_parse_interface:
> > >  ---
> > >  num_ep = num_ep_orig = alt->desc.bNumEndpoints;
> > >  ...
> > >  len = sizeof(struct usb_host_endpoint) * num_ep;
> > >  alt->endpoint = kzalloc(len, GFP_KERNEL);
> > >  ---
> > > 
> > >  num_ep can be 0, as it was in my case, so following patch makes this
> > >  situation more obvious
> > >  and clear.
> 
> How about instead just doing:
> 
> +	num_ep = max(num_ep, 1);
>  	len = sizeof(struct usb_host_endpoint) * num_ep;
> 
> Also, wasn't it true at one point that it was legal to call kmalloc() with 
> a length of 0?  ISTR seeing somewhere that it's true for regular malloc().

kmalloc(0) was legal with CONFIG_SLAB=y.  However, there is now
something called SLUB, which just returned an error when size == 0.
It has recently been modified to mirror the SLAB behavior but also
do a stack dump so that "bad" callers can be fixed.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
