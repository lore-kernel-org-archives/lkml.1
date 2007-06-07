Return-Path: <linux-kernel-owner+w=401wt.eu-S1764845AbXFGUA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764845AbXFGUA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbXFGUAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:00:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:58169 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbXFGUAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PC8vApodxt0qQpPrHB1X5dRcZsaIVkuUZX3uYs0bj0khLVd5JtW7nV62wiNOcr77NRLI2fNrEasKbo0pIZBTyfSeEDd+MxtWUooIW929U49NhiX5dTOJLQxlJc1tlpZC5hTQ1NnY+Ae0AmFLgBsukMDNqt5X4hzKs8COFca5cyo=
Message-ID: <d9def9db0706071300h4d25a37cye1ec9bc19248bea9@mail.gmail.com>
Date: Thu, 7 Jun 2007 22:00:10 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: pci probe
Cc: "Manu Abraham" <abraham.manu@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070529222735.GK4644@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4648B29A.6080406@gmail.com> <4649B270.8050002@gmail.com>
	 <20070516071851.GB19294@kroah.com> <464AF932.9070008@gmail.com>
	 <20070529222735.GK4644@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Greg KH <greg@kroah.com> wrote:
> On Wed, May 16, 2007 at 04:29:38PM +0400, Manu Abraham wrote:
> > Greg KH wrote:
> > > On Tue, May 15, 2007 at 05:15:28PM +0400, Manu Abraham wrote:
> > >> Manu Abraham wrote:
> > >>> Hi,
> > >>>
> > >>> I do have a device that's a multifunction device. Eventhough a MFD, it
> > >>> just has one Interrupt which is shared by by a Configuration space for
> > >>> each function. ie, INTA is shared between them functions.
> > >>>
> > >>> In such a case, i am wondering, (since pci_probe returns a pointer to
> > >>> one PCI function alone and i need to use both the functions in one
> > >>> module alone rather than using a module for each function and that the
> > >>> functions are quite similar for them to be used in different modules,
> > >>> such that a separate probe/ISR etc is used) whether using pci_get_device
> > >>> would be a better alternative to do manual searching for the functions
> > >>> in such a case.
> > >>>
> > >> Just figured out that pci_get_subsys() does work in a better. Looking at
> > >> kernel sources all i find is just one single user of pci_get_subsys()
> > >>
> > >> building the code around pci_get_subsys(), does this have any negative
> > >> impact ?
> > >
> > > Yes:
> > >     - your device will not show up properly in sysfs (no
> > >       device/driver binding ability from userspace, no good
> > >       information so that udev can properly name the device, etc.)
> >
> > This one sounds bad.
> >
> > >     - your driver will not work on any pci-hotplug type system (that
> > >       includes expresscard and pccard and lots of high-end servers.
> >
> > This doesn't matter
>
> Are you sure?  PCI Hotplug is showing up in more places that people
> realize...

In case of video4linux and dvb, there are cx88 and saa7134 based
pcmcia devices available which show up as PCI devices, both of these
drivers enable the interrupts as soon as they're connected and there's
no need to access the device nodes for that.
Another point is that they're not hotplug aware, the driver end up in
an endless loop or crashes linux if someone unplugs the device (even
if it's not in use).

>
> > >     - your driver will not be notified if the system is being
> > >       suspended or resumed or wanting to drop into a low power
> > >       state.
> > >     - another driver can bind to your device without you ever
> > >       knowing it.
> >
> > These also sound bad.
> >
> > > So in short, use pci_probe and just handle the fact that you need to be
> > > called for two PCI devices and bind to both of them.  It shouldn't be
> > > that hard...
> >
> > Thanks for the explanation.
> >
> > Do you mean to have two PCIID tables ? But then that does mean 2 modules
> > don't you ? (i thought probe would be called once per module) Or you
> > mean to say use PCI_ANY_ID in the table to match multiple devices and
> > then allow probe to return a list of devices ?
>
>
> No, you can specify multiple devices in the same device id table, and
> your driver will get called for all of the matching devices.  You just
> need to "bind" them together in your driver to be able to handle
> everything properly.  It shouldn't be that tough.
>

Uwe posted an example how to tie multiple functions of a device
together, there are quite a few ways how to solve that problem.

http://linuxtv.org/pipermail/linux-dvb/2007-June/018481.html

Markus
