Return-Path: <linux-kernel-owner+w=401wt.eu-S1762730AbXF1GNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762730AbXF1GNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 02:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbXF1GM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 02:12:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:16752 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbXF1GM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 02:12:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mDZhsBBhyv8WL/G4RDNW+fqUmXPZLiyZ+Gln1AObzPlhsbQ5GNRjBuxkvWiNwMLgRrxdkVYpqebsYoqCS4IPcHrelmmHFhnKpcEcNBTDdqs5b5kWu3/rAoJ30Nk0NnxTMuk+QF3BAy8EcyPb7lTGVpyFVhxP2iYiHqwBR3zh3xA=
Message-ID: <a8e1da0706272312t46c01984l56d982adca327053@mail.gmail.com>
Date: Thu, 28 Jun 2007 06:12:56 +0000
From: "dave young" <hidave.darkstar@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: [PATCH] atkbd: cleanup only once
Cc: "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <200706280118.36052.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070627105907.GA1802@darkstar.te-china.tietoenator.com>
	 <200706270059.33550.dtor@insightbb.com>
	 <a8e1da0706262202i3af320a7gaec8a5f0680beb13@mail.gmail.com>
	 <200706280118.36052.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>2007/6/28, Dmitry Torokhov <dtor@insightbb.com>:
> On Wednesday 27 June 2007 01:02, dave young wrote:
> > 2007/6/27, Dmitry Torokhov <dtor@insightbb.com>:
> > > On Wednesday 27 June 2007 00:28, Greg KH wrote:
> > > > On Wed, Jun 27, 2007 at 12:34:09AM -0400, Dmitry Torokhov wrote:
> > > > > Hi Dave,
> > > > >
> > > > > On Wednesday 27 June 2007 06:59, Dave Young wrote:
> > > > > > Hi,
> > > > > >
> > > > > > If you press ctrl+alt+del several times as kernel booting (before user level bootin), the kernel will oops. I found the ps2_command is called more than once, then the ps2dev->serio maybe NULL pointer.
> > > > > >
> > > > > > 2.6.22-rc5 and 2.6.22-rc6 have same result.
> > > > > >
> > > > > > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > > > > > ---
> > > > > > diff -upr linux/drivers/input/keyboard/atkbd.c linux.new/drivers/input/keyboard/atkbd.c
> > > > > > --- linux/drivers/input/keyboard/atkbd.c  2007-06-27 10:38:37.000000000 +0000
> > > > > > +++ linux.new/drivers/input/keyboard/atkbd.c      2007-06-27 10:37:39.000000000 +0000
> > > > > > @@ -795,6 +795,11 @@ static int atkbd_activate(struct atkbd *
> > > > > >
> > > > > >  static void atkbd_cleanup(struct serio *serio)
> > > > > >  {
> > > > > > + static int flag;
> > > > > > +
> > > > > > + if(flag)
> > > > > > +         return;
> > > > > > + flag = 1;
> > > > >
> > > > > Unfortunately this will prevent atkbd from resetting keyboard on 2nd
> > > > > suspend attempt. It will also not work if you have an active MUX and
> > > > > have a couple of keyboards connected.
> > > > >
> > > > > Greg, now that you removed rwsem from subsystem (and subsystem itself
> > > > > for that matter) there is nothing as far as I can see that stops
> > > > > several threads from running device_shutdown() simultaneously. I also
> > > > > do not see what would isolate device probing and shutting them down
> > > > > at the same time. Am I missing something?
> > > >
> > > > There was never anything stopping that from happening before.  No driver
> > > > core code was using that rwsem, so it wasn't protecting anything,
> > > > despite people trying to use it as if it was :)
> > > >
> > >
> > > It did protect device_shutdown() from itself, didn't it?
> > >
> > > --
> > > Dmitry
> > >
> > how about check ps2dev->serio in ps2_command before use it?
>
> I don't think we ever set it to NULL. Does the patch below help any?
>
> --
> Dmitry
>
>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
>
>  drivers/input/serio/serio.c |    2 ++
>  1 files changed, 2 insertions(+)
>
> Index: work/drivers/input/serio/serio.c
> ===================================================================
> --- work.orig/drivers/input/serio/serio.c
> +++ work/drivers/input/serio/serio.c
> @@ -769,8 +769,10 @@ static int serio_driver_remove(struct de
>
>  static void serio_cleanup(struct serio *serio)
>  {
> +       mutex_lock(&serio->drv_mutex);
>         if (serio->drv && serio->drv->cleanup)
>                 serio->drv->cleanup(serio);
> +       mutex_unlock(&serio->drv_mutex);
>  }
>
>  static void serio_shutdown(struct device *dev)
>

Yes, l tested with this patch, looks good to me.

Regards
dave
