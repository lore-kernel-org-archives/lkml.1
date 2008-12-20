Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbYLTUTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbYLTUTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 15:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYLTUTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 15:19:36 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:52795 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbYLTUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 15:19:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=DNkKVxfzjWx9g4HZ+5xEok5XVSYjQqNcUlBYWA9EcMYd01SCst5k2bBSbdoPc9zjDi
         l6g262ato2n3mctKMmhcXN0BUjCRP58gjEInZW9OTk4gNGb277VDcOg1UmTFggcy1ADg
         YR6g9ygB/+wXrBjPleu+6HR2Va+j4ut0lp7VU=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH] sh: maple: add support for Maple controller as a joystick
Date: Sat, 20 Dec 2008 12:19:12 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-134.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>,
       "linux-sh" <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Paul Mundt <lethal@linux-sh.org>
References: <1229728542.1441.6.camel@localhost.localdomain> <20081220151511.GA6528@console-pimps.org> <1229789248.6502.4.camel@localhost.localdomain>
In-Reply-To: <1229789248.6502.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812201219.12511.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 December 2008 08:07:27 Adrian McMenamin wrote:
> On Sat, 2008-12-20 at 15:16 +0000, Matt Fleming wrote:
> > On Fri, Dec 19, 2008 at 11:15:42PM +0000, Adrian McMenamin wrote:
> > > Add support for the SEGA Dreamcast Maple controller as a joystick
> >
> > [snip]
> >
> > > +	struct dc_pad *pad = maple_get_drvdata(mapledev);
> > > +	struct input_dev *dev = pad->dev;
> > > +	unsigned char *res = mq->recvbuf;
> > > +
> > > +	buttons = ~cpu_to_le16(*(unsigned short *)(res + 8));
> > > +
> >
> > I may be wrong but shouldn't this use the I/O accessor functions?
>
> It's not iomemory, so I don't think so. The maple bus writes to a buffer
> in the physical RAM.
>

Hmm, but why we are going _from_ cpu order to le16??? I'd expect we
wanted to do conversion the other way around. I pulled it out of 'next'
for now.

> > > +
> > > +	pad = kzalloc(sizeof(struct dc_pad), GFP_KERNEL);
> > > +	idev = input_allocate_device();
> > > +	if (!pad || !idev){
> > > +		error = ENOMEM;
> > > +		goto fail;
> > > +	}
> >
> > [snip]
> >
> > > +fail:
> > > +	input_free_device(pad->dev);
> >
> > Possible NULL pointer dereference?
>
> No, because input_free_device is:
>
> void input_free_device(struct input_dev *dev)
> {
>         if (dev)
>                input_put_device(dev);
> }
> EXPORT_SYMBOL(input_free_device);

But we need to be freeing idev, not pad->dev because pad might
be NULL.

-- 
Dmitry
