Return-Path: <linux-kernel-owner+w=401wt.eu-S932299AbXBSOkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299AbXBSOkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932309AbXBSOkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:40:12 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:44626 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbXBSOkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:40:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fZRFZliSAlZjNbVedkxyAknYG+mHPzIIBHOx7zsKH6245hPnfzqvnSAZICY9gMHZRxpNjq15wW3avNZEDMiRZ7LBo50iwmFO6yanwyYJHdbEsWbMSWwjKtCke7ebsRAKBqMR+QqIcESfV5xaSZCutqXEWxUmhKoiD+dc52+jvWc=
Message-ID: <d120d5000702190640y58b0d75akb1579b7c611879eb@mail.gmail.com>
Date: Mon, 19 Feb 2007 09:40:09 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH] platform: reorder platform_device_del
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070219102335.8d56dddd.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070218213020.5618eb98.khali@linux-fr.org>
	 <200702190105.31051.dtor@insightbb.com>
	 <20070219102335.8d56dddd.khali@linux-fr.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On 2/19/07, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Dmitry,
>
> On Mon, 19 Feb 2007 01:05:30 -0500, Dmitry Torokhov wrote:
> > On Sunday 18 February 2007 15:30, Jean Delvare wrote:
> > > In platform_device_del(), we currently delete the device resources
> > > first, then we delete the device itself. This causes a (minor) bug to
> > > occur when one unregisters a platform device before unregistering its
> > > platform driver, and the driver is requesting (in .probe()) and
> > > releasing (in .remove()) a resource of the device. The device
> > > resources are already gone by the time the driver gets the chance to
> > > release the resources it had been requesting, causing an error like:
> > > Trying to free nonexistent resource <0000000000000295-0000000000000296>
> > >
> > > If the platform driver is unregistered first, the problem doesn't
> > > occur, as the driver will have the opportunity to release the
> > > resources it had requested before the device resources themselves are
> > > released. It's a bit odd that unregistering the driver first or the
> > > device first doesn't lead to the same result.
> >
> > I am not sure that this is correct argument. Why does a driver request
> > and release device's resources? "Higher power" has already requested
> > these resources for the device and this is not drivers task to free
> > them.
>
> My understanding is that, in the device driver model, devices _declare_
> resources, and it's up to the drivers to actually request the ones they
> wish to use. Looking at /proc/ioports, this hierarchy is quite visible.
> And while not all platform drivers actually request their device's
> resource, quite a few do (I counted 95 out of 228), so I'm definitely
> not the only one thinking it is the right thing to do.
>
> If the intent was that devices request the resources and the drivers
> don't have to care, then a driver requesting a device's resource should
> be returned an error. Instead, it works fine, which make me confident
> that I got the idea right.

But the thing is that when you add resources to a platofrm device it
is platform_device_add() that marks resources as busy and therefore it
is not driver's task to delete them. If you want driver to request
resources you better pass them through a private data structure
attached to a device.

The attached resources are normally used by arch setup codes that
posess the knowledge about whether a device is present on a box and
what IO port or memory region is used. The device is usualy there and
its resources fixed and not available to anyone else even if there is
no driver to actually control the device.

>
> >       However you are right that we should not free resources until
> > device is marked for deletion and driver's ->remove() method completes
> > but I would not rely on surrounding code for keeping an extra reference
> > and would just take one explicitely in platform_device_del().
>
> You mean that you wouldn't trust the rest of the platform driver core,
> which lives in the same source file, to do the right thing? That's
> being too defensive IMHO, and I don't think we usually do that. Greg?
>

platform_device_del() is public so all bets are off...

-- 
Dmitry
