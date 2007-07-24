Return-Path: <linux-kernel-owner+w=401wt.eu-S1762902AbXGXIEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762902AbXGXIEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbXGXIEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:04:05 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:24368 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbXGXIDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:03:22 -0400
Date: Tue, 24 Jul 2007 10:03:14 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sysfs/udev broken in latest git?
Message-ID: <20070724100314.3c606131@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070724072540.GA835@suse.de>
References: <46A59EAA.9030105@simon.arlott.org.uk>
	<20070724072540.GA835@suse.de>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 00:25:40 -0700,
Greg KH <gregkh@suse.de> wrote:

> On Tue, Jul 24, 2007 at 07:39:38AM +0100, Simon Arlott wrote:
> > The following commit appears to break some of my udev rules (I don't 
> > have the time to finish the bisect right now, but there's only four 
> > changes showing in "git bisect visualize" - this one is tagged 
> > bisect/bad, and the other three are docs/docs/unrelated).
> > 
> > Neither of these symlinks get created by udev on kernels marked bad 
> > (see bisect log below):
> > 
> > ACTION=="add", \
> >         KERNEL=="event*", \
> >         SUBSYSTEM=="input", \
> >         SYSFS{description}=="i8042 KBD port", \
> >         NAME="input/%k", \
> >         SYMLINK="input/i8042-kbd", \
> >         MODE="0640", \
> >         GROUP="event"
> > 
> > ACTION=="add", \
> >         KERNEL=="event*", \
> >         SUBSYSTEM=="input", \
> >         SYSFS{manufacturer}=="Logitech", \
> >         SYSFS{product}=="USB-PS/2 Optical Mouse", \
> >         NAME="input/%k", \
> >         SYMLINK="input/logitech-mouse", \
> >         MODE="0640", \
> >         GROUP="event"

> Ugh, I thought this was all fixed up properly :(

I thought this as well :(

But I'm a bit confused: The patch in git has

+       /* only bus-device parents get a "device"-link */
+       if (dev->parent && dev->parent->bus) {
+               error = sysfs_create_link(&dev->kobj, &dev->parent->kobj,
+                                         "device");

and

-               if (parent) {
-                       sysfs_create_link(&dev->kobj, &dev->parent->kobj,
-                                                       "device");

which really look like two different things. (My original patch didn't
have the check for the parent's bus.) Don't know what happened here :(

(Simon: Do the links reappear if you change
	if (dev->parent && dev->parent->bus)
to
	if (dev->parent)
in device_add_class_symlinks()?)
