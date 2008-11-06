Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbYKFVhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbYKFVhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbYKFVhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:37:19 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:25290 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYKFVhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:37:17 -0500
From: "Fischer, Anna" <anna.fischer@hp.com>
To: Greg KH <greg@kroah.com>, H L <swdevyid@yahoo.com>
CC: "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "Chiang, Alexander" <achiang@hp.com>, "matthew@wil.cx" <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Date: Thu, 6 Nov 2008 21:35:57 +0000
Subject: RE: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Thread-Topic: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
Thread-Index: AclAPvKtRKsTjjwkSHiVnONPsOZ8eQAEEXjg
Message-ID: <0199E0D51A61344794750DC57738F58E5E26F99718@GVW1118EXC.americas.hpqcorp.net>
References: <20081106164919.GA4099@kroah.com>
	<392264.50990.qm@web45103.mail.sp1.yahoo.com>
 <20081106182443.GB17782@kroah.com>
In-Reply-To: <20081106182443.GB17782@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
>
> On Thu, Nov 06, 2008 at 10:05:39AM -0800, H L wrote:
> >
> > --- On Thu, 11/6/08, Greg KH <greg@kroah.com> wrote:
> >
> > > On Thu, Nov 06, 2008 at 08:41:53AM -0800, H L wrote:
> > > > I have not modified any existing drivers, but instead
> > > I threw together
> > > > a bare-bones module enabling me to make a call to
> > > pci_iov_register()
> > > > and then poke at an SR-IOV adapter's /sys entries
> > > for which no driver
> > > > was loaded.
> > > >
> > > > It appears from my perusal thus far that drivers using
> > > these new
> > > > SR-IOV patches will require modification; i.e. the
> > > driver associated
> > > > with the Physical Function (PF) will be required to
> > > make the
> > > > pci_iov_register() call along with the requisite
> > > notify() function.
> > > > Essentially this suggests to me a model for the PF
> > > driver to perform
> > > > any "global actions" or setup on behalf of
> > > VFs before enabling them
> > > > after which VF drivers could be associated.
> > >
> > > Where would the VF drivers have to be associated?  On the
> > > "pci_dev"
> > > level or on a higher one?
> >
> >
> > I have not yet fully grocked Yu Zhao's model to answer this.  That
> > said, I would *hope* to find it on the "pci_dev" level.
>
> Me too.
>
> > > Will all drivers that want to bind to a "VF"
> > > device need to be
> > > rewritten?
> >
> > Not necessarily, or perhaps minimally; depends on hardware/firmware
> > and actions the driver wants to take.  An example here might assist.
> > Let's just say someone has created, oh, I don't know, maybe an SR-IOV
> > NIC.  Now, for 'general' I/O operations to pass network traffic back
> > and forth there would ideally be no difference in the actions and
> > therefore behavior of a PF driver and a VF driver.  But, what do you
> > do in the instance a VF wants to change link-speed?  As that physical
> > characteristic affects all VFs, how do you handle that?  This is
> where
> > the hardware/firmware implementation part comes to play.  If a VF
> > driver performs some actions to initiate the change in link speed,
> the
> > logic in the adapter could be anything like:
>
> <snip>
>
> Yes, I agree that all of this needs to be done, somehow.
>
> It's that "somehow" that I am interested in trying to see how it works
> out.
>
> > >
> > > > I have so far only seen Yu Zhao's
> > > "7-patch" set.  I've not yet looked
> > > > at his subsequently tendered "15-patch" set
> > > so I don't know what has
> > > > changed.    The hardware/firmware implementation for
> > > any given SR-IOV
> > > > compatible device, will determine the extent of
> > > differences required
> > > > between a PF driver and a VF driver.
> > >
> > > Yeah, that's what I'm worried/curious about.
> > > Without seeing the code
> > > for such a driver, how can we properly evaluate if this
> > > infrastructure
> > > is the correct one and the proper way to do all of this?
> >
> >
> > As the example above demonstrates, that's a tough question to answer.
> > Ideally, in my view, there would only be one driver written per SR-
> IOV
> > device and it would contain the logic to "do the right things" based
> > on whether its running as a PF or VF with that determination easily
> > accomplished by testing the existence of the SR-IOV extended
> > capability.    Then, in an effort to minimize (if not eliminate) the
> > complexities of driver-to-driver actions for fielding "global
> events",
> > contain as much of the logic as is possible within the adapter.
> > Minimizing the efforts required for the device driver writers in my
> > opinion paves the way to greater adoption of this technology.
>
> Yes, making things easier is the key here.
>
> Perhaps some of this could be hidden with a new bus type for these
> kinds
> of devices?  Or a "virtual" bus of pci devices that the original SR-IOV
> device creates that corrispond to the individual virtual PCI devices?
> If that were the case, then it might be a lot easier in the end.

I think a standard communication channel in Linux for SR-IOV devices
would be a good start, and help to adopt the technology. Something
like the virtual bus you are describing. It means that vendors do
not need to write their own communication channel in the drivers.
It would need to have well defined APIs though, as I guess that
devices will have very different capabilities and hardware
implementations for PFs and VFs, and so they might have very
different events and information to propagate.

Anna
