Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbXE3IeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbXE3IeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbXE3IeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:34:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47814 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXE3IeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:34:11 -0400
Date: Tue, 29 May 2007 15:27:35 -0700
From: Greg KH <greg@kroah.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci probe
Message-ID: <20070529222735.GK4644@kroah.com>
References: <4648B29A.6080406@gmail.com> <4649B270.8050002@gmail.com> <20070516071851.GB19294@kroah.com> <464AF932.9070008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464AF932.9070008@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 04:29:38PM +0400, Manu Abraham wrote:
> Greg KH wrote:
> > On Tue, May 15, 2007 at 05:15:28PM +0400, Manu Abraham wrote:
> >> Manu Abraham wrote:
> >>> Hi,
> >>>
> >>> I do have a device that's a multifunction device. Eventhough a MFD, it
> >>> just has one Interrupt which is shared by by a Configuration space for
> >>> each function. ie, INTA is shared between them functions.
> >>>
> >>> In such a case, i am wondering, (since pci_probe returns a pointer to
> >>> one PCI function alone and i need to use both the functions in one
> >>> module alone rather than using a module for each function and that the
> >>> functions are quite similar for them to be used in different modules,
> >>> such that a separate probe/ISR etc is used) whether using pci_get_device
> >>> would be a better alternative to do manual searching for the functions
> >>> in such a case.
> >>>
> >> Just figured out that pci_get_subsys() does work in a better. Looking at
> >> kernel sources all i find is just one single user of pci_get_subsys()
> >>
> >> building the code around pci_get_subsys(), does this have any negative
> >> impact ?
> > 
> > Yes:
> > 	- your device will not show up properly in sysfs (no
> > 	  device/driver binding ability from userspace, no good
> > 	  information so that udev can properly name the device, etc.)
> 
> This one sounds bad.
> 
> > 	- your driver will not work on any pci-hotplug type system (that
> > 	  includes expresscard and pccard and lots of high-end servers.
> 
> This doesn't matter

Are you sure?  PCI Hotplug is showing up in more places that people
realize...

> > 	- your driver will not be notified if the system is being
> > 	  suspended or resumed or wanting to drop into a low power
> > 	  state.
> > 	- another driver can bind to your device without you ever
> > 	  knowing it.
> 
> These also sound bad.
> 
> > So in short, use pci_probe and just handle the fact that you need to be
> > called for two PCI devices and bind to both of them.  It shouldn't be
> > that hard...
> 
> Thanks for the explanation.
> 
> Do you mean to have two PCIID tables ? But then that does mean 2 modules
> don't you ? (i thought probe would be called once per module) Or you
> mean to say use PCI_ANY_ID in the table to match multiple devices and
> then allow probe to return a list of devices ?


No, you can specify multiple devices in the same device id table, and
your driver will get called for all of the matching devices.  You just
need to "bind" them together in your driver to be able to handle
everything properly.  It shouldn't be that tough.

thanks,

greg k-h
