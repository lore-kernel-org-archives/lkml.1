Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbYKFSFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbYKFSFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 13:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYKFSFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 13:05:41 -0500
Received: from n72.bullet.mail.sp1.yahoo.com ([98.136.44.34]:46239 "HELO
	n72.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750983AbYKFSFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 13:05:40 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 593912.77089.bm@omp409.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=MNAeOcumn5zNrqsP+mTpB1EXZ5uuvY2jax21BYCNPnQZSxhONjhfYIUJS1rGLaFg3+CEsQGzNjgwACJQvoBri20t8pb8wyLgkPzPzptnqXYMfVyWsQ/cD2/77TsJV8ctIx+8qjIYBhpgYxNKUQiKbQ0uRGkRn9a2ageXnjHizAU=;
X-YMail-OSG: FcfuWBEVM1n1wQ1d4VnLro9jZbCF2KDBU4s5Jjpek_6TbH6B321ybDvuh0MgrNNwZ5tFE9CATjQ4ywrQ1.5rnMwz1IghyWxCiAboFErV6gEwdUDnCurJOiXAsfFjIszU4jy_ythFZCryXk_ALYvLmthzOjZ9
X-Mailer: YahooMailWebService/0.7.260.1
Date: Thu, 6 Nov 2008 10:05:39 -0800 (PST)
From: H L <swdevyid@yahoo.com>
Reply-To: swdevyid@yahoo.com
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
To: Greg KH <greg@kroah.com>
Cc: Yu Zhao <yu.zhao@intel.com>, randy.dunlap@oracle.com,
       grundler@parisc-linux.org, achiang@hp.com, matthew@wil.cx,
       linux-pci@vger.kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <20081106164919.GA4099@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <392264.50990.qm@web45103.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Thu, 11/6/08, Greg KH <greg@kroah.com> wrote:
 
> On Thu, Nov 06, 2008 at 08:41:53AM -0800, H L wrote:
> > I have not modified any existing drivers, but instead
> I threw together
> > a bare-bones module enabling me to make a call to
> pci_iov_register()
> > and then poke at an SR-IOV adapter's /sys entries
> for which no driver
> > was loaded.
> > 
> > It appears from my perusal thus far that drivers using
> these new
> > SR-IOV patches will require modification; i.e. the
> driver associated
> > with the Physical Function (PF) will be required to
> make the
> > pci_iov_register() call along with the requisite
> notify() function.
> > Essentially this suggests to me a model for the PF
> driver to perform
> > any "global actions" or setup on behalf of
> VFs before enabling them
> > after which VF drivers could be associated.
> 
> Where would the VF drivers have to be associated?  On the
> "pci_dev"
> level or on a higher one?


I have not yet fully grocked Yu Zhao's model to answer this.  That said, I would *hope* to find it on the "pci_dev" level.


> Will all drivers that want to bind to a "VF"
> device need to be
> rewritten?

Not necessarily, or perhaps minimally; depends on hardware/firmware and actions the driver wants to take.  An example here might assist.  Let's just say someone has created, oh, I don't know, maybe an SR-IOV NIC.  Now, for 'general' I/O operations to pass network traffic back and forth there would ideally be no difference in the actions and therefore behavior of a PF driver and a VF driver.  But, what do you do in the instance a VF wants to change link-speed?  As that physical characteristic affects all VFs, how do you handle that?  This is where the hardware/firmware implementation part comes to play.  If a VF driver performs some actions to initiate the change in link speed, the logic in the adapter could be anything like:

1.  Acknowledge the request as if it were really done, but effectively ignore it.  The Independent Hardware Vendor (IHV) might dictate that if you want to change any "global" characteristics of an adapter, you may only do so via the PF driver.  Granted, this, depending on the device class, may just not be acceptable.

2.  Acknowledge the request and then trigger an interrupt to the PF driver to have it assist.  The PF driver might then just set the new link-speed, or it could result in a PF driver communicating by some mechanism to all of the VF driver instances that this change of link-speed was requested.

3.  Acknowledge the request and perform inner PF and VF communication of this event within the logic of the card (e.g. to "vote" on whether or not to perform this action) with interrupts and associated status delivered to all PF and VF drivers.

The list goes on.

> 
> > I have so far only seen Yu Zhao's
> "7-patch" set.  I've not yet looked
> > at his subsequently tendered "15-patch" set
> so I don't know what has
> > changed.    The hardware/firmware implementation for
> any given SR-IOV
> > compatible device, will determine the extent of
> differences required
> > between a PF driver and a VF driver.
> 
> Yeah, that's what I'm worried/curious about. 
> Without seeing the code
> for such a driver, how can we properly evaluate if this
> infrastructure
> is the correct one and the proper way to do all of this?


As the example above demonstrates, that's a tough question to answer.  Ideally, in my view, there would only be one driver written per SR-IOV device and it would contain the logic to "do the right things" based on whether its running as a PF or VF with that determination easily accomplished by testing the existence of the SR-IOV extended capability.    Then, in an effort to minimize (if not eliminate) the complexities of driver-to-driver actions for fielding "global events", contain as much of the logic as is possible within the adapter.  Minimizing the efforts required for the device driver writers in my opinion paves the way to greater adoption of this technology.



      

