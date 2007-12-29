Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbXL2WCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbXL2WCO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 17:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbXL2WCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 17:02:00 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1627 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752053AbXL2WB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 17:01:59 -0500
Date: Sat, 29 Dec 2007 17:01:57 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dave Young <hidave.darkstar@gmail.com>
cc: Greg KH <gregkh@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
In-Reply-To: <a8e1da0712282307p3723857ex534d787f128db112@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0712291652540.26261-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Dec 2007, Dave Young wrote:

> On Dec 29, 2007 1:06 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> >
> > On Dec 29, 2007 12:42 PM, Greg KH <gregkh@suse.de> wrote:
> > > On Sat, Dec 29, 2007 at 10:36:49AM +0800, Dave Young wrote:
> > > > >
> > > > The full boot dmesg with lockdep output is out, there's one warnings in it :
> > >
> > > Please fix that warning before the next repost of these patches (along
> > > with fixing the problem of them not being able to be applied and
> > > successfully built at every point in the series...)
> > >
> >
> > Ok, thanks, I will fix them and repost.
> >
> 
> Hi,
> After digging the code, I feel hard to fix the lockdep warning due to
> some misterious relationship with usb.
> 
> Could someone help on this? thanks.
> Add usb-devel list as cc

The problem isn't specific to USB.  And you will not be able to fix it 
unless you make drastic changes to the lockdep checker.

lockdep warns whenever a task acquires a mutex while holding another
mutex of the same kind (that is, the same member in another structure
of the same type).  But there are lots of places where the kernel needs
to acquire dev->sem for one device while already holding
dev->parent->sem.  There's no way to remove these, which means there's
no way to prevent lockdep from issuing a warning.

Around a month ago I had a discussion with Peter Zijlstra about the
problems in converting the device semaphores to mutexes; you may be
able to find it in the LKML archives.  Doing the conversion while
keeping lockdep happy is a very hard problem and we were not able to
solve it.

It's possible that you may be able to convert the semaphores in struct
class or other structures.  But you won't succeed with struct device.

Alan Stern

