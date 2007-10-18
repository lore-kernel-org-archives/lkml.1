Return-Path: <linux-kernel-owner+w=401wt.eu-S1763659AbXJRBwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763659AbXJRBwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbXJRBwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:52:08 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:5309 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbXJRBwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O+YlBNUUC2E8CyA9Hn6SoTRXgK+OGWaXAEyu+f0Xd5y7WSh1m1XM1eKLBGr15lHhA/Eby7ywGkFfxkThssJDFWA2waHo/t/8oj9CoIt6kc9QYRYgdibrwVt9S6U3OzK91kfKivzKf+tvtFYIhwD843CGYwwVWEiVpZYbotq1YeA=
Message-ID: <a8e1da0710171852s679b57bdp817c3a1d636c1b9d@mail.gmail.com>
Date: Thu, 18 Oct 2007 09:52:03 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] usb+sysfs: duplicate filename 'bInterfaceNumber'
Cc: "Matthew Dharm" <mdharm-kernel@one-eyed-alien.net>,
       "Greg KH" <greg@kroah.com>, bbpetkov@yahoo.de,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "USB development list" <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0710171040440.4468-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071016191323.GC24082@one-eyed-alien.net>
	 <Pine.LNX.4.44L0.0710171040440.4468-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/07, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 16 Oct 2007, Matthew Dharm wrote:
>
> > On Tue, Oct 16, 2007 at 02:04:43PM -0400, Alan Stern wrote:
> > > On Tue, 16 Oct 2007, Matthew Dharm wrote:
> > >
> > > > I haven't looked at this code at all, but neither approach feels right to
> > > > me.
> > > >
> > > > How does this work at all?  Even if you load a driver later, wouldn't it
> > > > call usb_set_interface(), which would call usb_create_sysfs_intf_files()
> > > > and hit the same issue?
> > >
> > > usb_set_interface() is smart enough to remove the old interface files
> > > before creating new ones, since it expects them to exist already.
> > > Hence there's no problem in that scenario.
> > >
> > > But usb_set_configuration doesn't expect there to be any pre-existing
> > > interface files, because there isn't even an interface until the
> > > registration is performed.
> >
> > And I'm guessing that you can't call usb_create_sysfs_intf_files() until
> > registration is performed, right?
>
> Right.
>
> > > The most important reason has to do with the endpoint pseudo-devices.
> > > Different altsettings can have different endpoints, so those have to be
> > > removed and re-created whenever the altsetting changes.
> >
> > Right, altsettings.  I forgot about those.  I only ever think in terms of
> > multiple configurations.
> >
> > *grumble*
> >
> > If usb_set_interface() has to be smart enough to remove existing files
> > first already, then I guess it's reasonably symmetric to have
> > usb_set_configuration() have the same smarts.  Maybe they can share some
> > common code, even.
>
> It's not a big deal to remove the files first.  In fact, here's a patch
> to do it.  Dave, see if this doesn't fix your problem.  I don't like it
> much because it does an unnecessary remove/create cycle, but that's
> better than doing something wrong.

Although it's not the best fix, the problem is fixed, Thanks.

>
> It's slightly odd that the sysfs core logs an error when you try to
> create the same file twice but it doesn't when you try to remove a
> non-existent file (or try to remove an existing file twice).  Oh
> well...
>
> Alan Stern
>
>
>
> Index: usb-2.6/drivers/usb/core/message.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/core/message.c
> +++ usb-2.6/drivers/usb/core/message.c
> @@ -1643,7 +1643,13 @@ free_interfaces:
>                                 intf->dev.bus_id, ret);
>                         continue;
>                 }
> -               usb_create_sysfs_intf_files (intf);
> +
> +               /* The driver's probe method can call usb_set_interface(),
> +                * which would mean the interface's sysfs files are already
> +                * created.  Just in case, we'll remove them first.
> +                */
> +               usb_remove_sysfs_intf_files(intf);
> +               usb_create_sysfs_intf_files(intf);
>         }
>
>         usb_autosuspend_device(dev);
>
>
