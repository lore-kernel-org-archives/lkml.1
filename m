Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbYKZJ44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbYKZJ44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 04:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYKZJ4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 04:56:47 -0500
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:46103 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYKZJ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 04:56:46 -0500
Date: Wed, 26 Nov 2008 01:56:45 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: "Darrick J. Wong" <djwong@us.ibm.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] fakephp: Allocate PCI resources before adding the	device
In-Reply-To: <20081126074808.GE6539@plum>
Message-ID: <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com>
 <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp> <20081126074808.GE6539@plum>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008, Darrick J. Wong wrote:
> On Tue, Nov 25, 2008 at 08:46:37PM -0800, Trent Piepho wrote:
> >
> > I've had a patch to fakephp that did something like this for a while, but I
> > called pci_bus_assign_resources() _after_ adding the devices with calls to
> > pci_bus_add_device().  It seems like that might be easier, to just add all
> > the devices and then call pci_bus_assign_resources() when done.  It appears
> > to work fine for me.  Is there a reason this is wrong?
>
> afaict, pci_bus_add_devices calls device_add to set up sysfs files and
> trigger a event that can (ultimately) cause a pci probe action to
> happen... but the probe will fail because the resources aren't ready.
> In any case, if a device shows up in sysfs I'd assume that to mean that
> the device is ready to go--all the BARs are reserved for the device,
> etc.  For sure, I woudn't expect to be racing
> pci_bus_assign_resources().

Ok, that makes sense.  The device I'm using fakephp for doesn't have a
kernel driver so I wouldn't have noticed that.

Have you tested this with a device that isn't present at boot?  I found
that I needed to a call to pci_enable_device() after assigning resources,
otherwise the BARs wouldn't be enabled.  This only happened if the device
wasn't present at boot time.

My hardware doesn't run on the latest kernel so I can't test it.  It looks
like there have been a bunch of pci hotplug changes so back porting this
might not be feasible.  It also looks a previous patch by Alex Chiang
completely changed the sysfs interface for fakephp.  I thought sysfs
interfaces were supposed to be stable?!  Also looks like it made fakephp
useless.  How are you supposed to figure out which "fake-n" directory is
the right one to disable the device you want?
