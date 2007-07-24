Return-Path: <linux-kernel-owner+w=401wt.eu-S934864AbXGXJUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934864AbXGXJUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759924AbXGXJUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:20:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:60745 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbXGXJUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:20:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WpPh1IsMLWgCfpNDxIhcUWBcOgcLaHRr8KKRFNdpuyAZoal2jQV8xbwuSBx0NTk5phC6PjoPQ/ALJ1lzFqVz7PySQFRQkd7M25uIYI7OYqqWY/diiyfS7wcV8vAUpwR/yyto0/iRORmJC/Jxyay6wk7s3cWEtIkRmdX1ZfZDH6o=
Message-ID: <3ae72650707240220l737fb031hb4e326b0f1fe0e45@mail.gmail.com>
Date: Tue, 24 Jul 2007 11:20:02 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: sysfs/udev broken in latest git?
Cc: "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "Simon Arlott" <simon@fire.lp0.eu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070724084654.GB13152@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A59EAA.9030105@simon.arlott.org.uk>
	 <20070724072540.GA835@suse.de>
	 <20070724100314.3c606131@gondolin.boeblingen.de.ibm.com>
	 <20070724084654.GB13152@suse.de>
X-Google-Sender-Auth: 44cdc12a02a3fac5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Greg KH <gregkh@suse.de> wrote:
> On Tue, Jul 24, 2007 at 10:03:14AM +0200, Cornelia Huck wrote:
> > On Tue, 24 Jul 2007 00:25:40 -0700,
> > Greg KH <gregkh@suse.de> wrote:
> >
> > > On Tue, Jul 24, 2007 at 07:39:38AM +0100, Simon Arlott wrote:
> > > > The following commit appears to break some of my udev rules (I don't
> > > > have the time to finish the bisect right now, but there's only four
> > > > changes showing in "git bisect visualize" - this one is tagged
> > > > bisect/bad, and the other three are docs/docs/unrelated).
> > > >
> > > > Neither of these symlinks get created by udev on kernels marked bad
> > > > (see bisect log below):
> > > >
> > > > ACTION=="add", \
> > > >         KERNEL=="event*", \
> > > >         SUBSYSTEM=="input", \
> > > >         SYSFS{description}=="i8042 KBD port", \
> > > >         NAME="input/%k", \
> > > >         SYMLINK="input/i8042-kbd", \
> > > >         MODE="0640", \
> > > >         GROUP="event"
> > > >
> > > > ACTION=="add", \
> > > >         KERNEL=="event*", \
> > > >         SUBSYSTEM=="input", \
> > > >         SYSFS{manufacturer}=="Logitech", \
> > > >         SYSFS{product}=="USB-PS/2 Optical Mouse", \
> > > >         NAME="input/%k", \
> > > >         SYMLINK="input/logitech-mouse", \
> > > >         MODE="0640", \
> > > >         GROUP="event"

Simon, please run:
  udevinfo --attribute-walk --path=<devpath>
for the mouse on the working and the non-working kernel.

And make sure you have only one rule for input devices or  use
SYMLINK+="", otherwise it overwrites any earlier rule. And if you have
an earlier rule which already names the device, this one will be
ignored because it has NAME= in it.

> > > Ugh, I thought this was all fixed up properly :(
> >
> > I thought this as well :(
> >
> > But I'm a bit confused: The patch in git has
> >
> > +       /* only bus-device parents get a "device"-link */
> > +       if (dev->parent && dev->parent->bus) {
> > +               error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
> > +                                         "device");
> >
> > and
> >
> > -               if (parent) {
> > -                       sysfs_create_link(&dev->kobj, &dev->parent->kobj,
> > -                                                       "device");
> >
> > which really look like two different things. (My original patch didn't
> > have the check for the parent's bus.) Don't know what happened here :(
>
> Ugh, this might be a merge issue with Kay's block layer device work that
> was in my tree, but I had to merge by hand around this area.
>
> > (Simon: Do the links reappear if you change
> >       if (dev->parent && dev->parent->bus)
> > to
> >       if (dev->parent)
> > in device_add_class_symlinks()?)
>
> Yeah, that would be good to find out.
>
> Kay, did I mess up the merge here?

It looks fine to me. "device" links must never point to anything else
than a bus device.

Kay
