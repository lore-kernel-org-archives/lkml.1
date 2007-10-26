Return-Path: <linux-kernel-owner+w=401wt.eu-S1762717AbXJZCvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762717AbXJZCvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbXJZCvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:51:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35823 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbXJZCvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:51:08 -0400
Date: Thu, 25 Oct 2007 19:42:01 -0700
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, bbpetkov@yahoo.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] usb+sysfs: duplicate filename
	'bInterfaceNumber'
Message-ID: <20071026024201.GA21311@kroah.com>
References: <20071025090659.GA2847@darkstar.te-china.tietoenator.com> <20071025181156.GB10720@kroah.com> <a8e1da0710251901r56c27efdkc7ca729c0bac003d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0710251901r56c27efdkc7ca729c0bac003d@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 10:01:49AM +0800, Dave Young wrote:
> On 10/26/07, Greg KH <greg@kroah.com> wrote:
> > On Thu, Oct 25, 2007 at 05:06:59PM +0800, Dave Young wrote:
> > > On 10/19/07, Greg KH <greg@kroah.com> wrote:
> > > >On Wed, Oct 17, 2007 at 10:48:52AM -0400, Alan Stern wrote:
> > > >> On Tue, 16 Oct 2007, Matthew Dharm wrote:
> > > >>
> > > >> > On Tue, Oct 16, 2007 at 02:04:43PM -0400, Alan Stern wrote:
> > > >> > > On Tue, 16 Oct 2007, Matthew Dharm wrote:
> > > >> > >
> > > >> > > > I haven't looked at this code at all, but neither approach feels
> > > >> > > > right to
> > > >> > > > me.
> > > >> > > >
> > > >> > > > How does this work at all?  Even if you load a driver later,
> > > >> > > > wouldn't it
> > > >> > > > call usb_set_interface(), which would call
> > > >> > > > usb_create_sysfs_intf_files()
> > > >> > > > and hit the same issue?
> > > >> > >
> > > >> > > usb_set_interface() is smart enough to remove the old interface
> > > >> > > files
> > > >> > > before creating new ones, since it expects them to exist already.
> > > >> > > Hence there's no problem in that scenario.
> > > >> > >
> > > >> > > But usb_set_configuration doesn't expect there to be any
> > > >> > > pre-existing
> > > >> > > interface files, because there isn't even an interface until the
> > > >> > > registration is performed.
> > > >> >
> > > >> > And I'm guessing that you can't call usb_create_sysfs_intf_files()
> > > >> > until
> > > >> > registration is performed, right?
> > > >>
> > > >> Right.
> > > >>
> > > >> > > The most important reason has to do with the endpoint
> > > >> > > pseudo-devices.
> > > >> > > Different altsettings can have different endpoints, so those have
> > > >> > > to be
> > > >> > > removed and re-created whenever the altsetting changes.
> > > >> >
> > > >> > Right, altsettings.  I forgot about those.  I only ever think in
> > > >> > terms of
> > > >> > multiple configurations.
> > > >> >
> > > >> > *grumble*
> > > >> >
> > > >> > If usb_set_interface() has to be smart enough to remove existing
> > > >> > files
> > > >> > first already, then I guess it's reasonably symmetric to have
> > > >> > usb_set_configuration() have the same smarts.  Maybe they can share
> > > >> > some
> > > >> > common code, even.
> > > >>
> > > >> It's not a big deal to remove the files first.  In fact, here's a
> > > >> patch
> > > >> to do it.  Dave, see if this doesn't fix your problem.  I don't like
> > > >> it
> > > >> much because it does an unnecessary remove/create cycle, but that's
> > > >> better than doing something wrong.
> > > >>
> > > >> It's slightly odd that the sysfs core logs an error when you try to
> > > >> create the same file twice but it doesn't when you try to remove a
> > > >> non-existent file (or try to remove an existing file twice).  Oh
> > > >> well...
> > > >
> > > >I used to have the 'remove a non-existant file' warning, but that just
> > > >triggered _way_ too many responses :)
> > > >
> > > >
> > > >> Index: usb-2.6/drivers/usb/core/message.c
> > > >> ===================================================================
> > > >> --- usb-2.6.orig/drivers/usb/core/message.c
> > > >> +++ usb-2.6/drivers/usb/core/message.c
> > > >> @@ -1643,7 +1643,13 @@ free_interfaces:
> > > >>                               intf->dev.bus_id, ret);
> > > >>                       continue;
> > > >>               }
> > > >> -             usb_create_sysfs_intf_files (intf);
> > > >> +
> > > >> +             /* The driver's probe method can call
> > > >> usb_set_interface(),
> > > >> +              * which would mean the interface's sysfs files are
> > > >> already
> > > >> +              * created.  Just in case, we'll remove them first.
> > > >> +              */
> > > >> +             usb_remove_sysfs_intf_files(intf);
> > > >> +             usb_create_sysfs_intf_files(intf);
> > > >>       }
> > > >
> > > >If this fixes the problem, care to resend it with a signed-off-by:?
> > > >
> > > >Yeah, it's not the nicest solution, but I can't think of any other one
> > > >either right now :(
> > > Hi, greg
> > >
> > > How about this patch (based on 2.6.24-rc1):
> > >
> > > diff -upr linux/drivers/usb/core/message.c linux.new/drivers/usb/core/message.c
> > > --- linux/drivers/usb/core/message.c  2007-10-25 16:41:32.000000000 +0800
> > > +++ linux.new/drivers/usb/core/message.c      2007-10-25 16:39:38.000000000 +0800
> > > @@ -1641,7 +1641,8 @@ free_interfaces:
> > >                               intf->dev.bus_id, ret);
> > >                       continue;
> > >               }
> > > -             usb_create_sysfs_intf_files (intf);
> > > +             if(!usb_sysfs_intf_exist(intf))
> > > +                     usb_create_sysfs_intf_files (intf);
> > >       }
> > >
> > >       usb_autosuspend_device(dev);
> > > diff -upr linux/drivers/usb/core/sysfs.c linux.new/drivers/usb/core/sysfs.c
> > > --- linux/drivers/usb/core/sysfs.c    2007-10-25 16:40:16.000000000 +0800
> > > +++ linux.new/drivers/usb/core/sysfs.c        2007-10-25 16:39:32.000000000 +0800
> > > @@ -728,6 +728,13 @@ static inline void usb_remove_intf_ep_fi
> > >               usb_remove_ep_files(&iface_desc->endpoint[i]);
> > >  }
> > >
> > > +int usb_sysfs_intf_exist(struct usb_interface *intf)
> > > +{
> > > +     struct device *dev = &intf->dev;
> > > +
> > > +     return sysfs_dirent_exist(&dev->kobj, intf_attrs[0]->name);
> >
> > The issue is that you can't just test for the first file.  If you look
> > at the logic in the usb_create_sysfs_intf_file() code, we do create
> > different files based on the current interface.  So this might not
> > always end up with the proper files in userspace, from what I can tell.
> >
> Yes, I know this is not good, it just fixed the bug for me. It's hard
> to test all files simply.
> 
> The duplicate file issue is still there,  what to do then?
> Alan, could you send the "remove before create" patch with your signed-off?

I sent that patch to Linus a few hours ago :)

> Anyway the sysfs_dirent_exist is useful for extern use, How about add
> and export this function? Greg, If you agree, I would send it as
> another patch.

What would need that function?  And what ensures that if you check that
the file exists, it doesn't go away right after that?

thanks,

greg k-h
