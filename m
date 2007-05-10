Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbXEJGlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbXEJGlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbXEJGli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:41:38 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:59449 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbXEJGlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=s/tXEKpTwB8+5+7Pb6eLwr3aCYf8HuqtYmJF83pOnf6rPiUxNatZJ3xUMwUpNemAPqBgnwOAeqf13N1WYHODIO/E3euS7Dxi7bmpagJcPdVO/ArLhYJemZjh9zYX1mf3nmus2/2sJV8pbqmXkSaKgrRiqQ8pI28TgpKhY6srLv4=
Message-ID: <a8f16e2b0705092341w14204283q9ddc225db73a5001@mail.gmail.com>
Date: Thu, 10 May 2007 10:41:36 +0400
From: "Dan Kruchinin" <dubalom@gmail.com>
To: "Randy Dunlap" <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       linux-usb-devel@projects.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH -mm] drivers/usb/core/config.c: kzalloc(0, ..)
In-Reply-To: <20070508094502.efc32182.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070508141453.GA12771@kroah.com>
	 <Pine.LNX.4.44L0.0705081152590.3217-100000@iolanthe.rowland.org>
	 <20070508094502.efc32182.rdunlap@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Tue, 8 May 2007 11:57:07 -0400 (EDT) Alan Stern wrote:
>
> > On Tue, 8 May 2007, Greg KH wrote:
> >
> > > >  The problem was in drivers/usb/core/config.c in function
> > > >  usb_parse_interface:
> > > >  ---
> > > >  num_ep = num_ep_orig = alt->desc.bNumEndpoints;
> > > >  ...
> > > >  len = sizeof(struct usb_host_endpoint) * num_ep;
> > > >  alt->endpoint = kzalloc(len, GFP_KERNEL);
> > > >  ---
> > > >
> > > >  num_ep can be 0, as it was in my case, so following patch makes this
> > > >  situation more obvious
> > > >  and clear.
> >
> > How about instead just doing:
> >
> > +     num_ep = max(num_ep, 1);
> >       len = sizeof(struct usb_host_endpoint) * num_ep;
> >
> > Also, wasn't it true at one point that it was legal to call kmalloc() with
> > a length of 0?  ISTR seeing somewhere that it's true for regular malloc().
>
> kmalloc(0) was legal with CONFIG_SLAB=y.  However, there is now
> something called SLUB, which just returned an error when size == 0.

SLUB works correctly with kmalloc(0) too, but it calls
WARN_ON_ONCE(size == 0);
in include/linux/slub_def.h: kmalloc_index.

btw: as I know when kmalloc(0) both slub and slab allocate the
smallest possible size. Can this size be smaller than sizeof(struct
usb_host_endpoint)? If it is, may it be a problem?

thanks.

Dan Kruchinin.

> It has recently been modified to mirror the SLAB behavior but also
> do a stack dump so that "bad" callers can be fixed.
>
