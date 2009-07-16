Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbZGPNvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbZGPNvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 09:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757112AbZGPNvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 09:51:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34653 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878AbZGPNvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 09:51:45 -0400
Date: Thu, 16 Jul 2009 16:50:48 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sheng Yang <sheng@linux.intel.com>
Cc: kvm@vger.kernel.org, Greg KH <gregkh@suse.de>, anthony@codemonkey.ws,
       avi@redhat.com, chrisw@redhat.com, hjk@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] uio: add generic driver for PCI 2.3 devices
Message-ID: <20090716135047.GB15975@redhat.com>
References: <20090715201340.GA12279@redhat.com> <20090715220829.GB31962@suse.de> <20090716123101.GA15975@redhat.com> <200907162133.07368.sheng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907162133.07368.sheng@linux.intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 09:33:05PM +0800, Sheng Yang wrote:
> On Thursday 16 July 2009 20:31:01 Michael S. Tsirkin wrote:
> > On Wed, Jul 15, 2009 at 03:08:29PM -0700, Greg KH wrote:
> > > On Wed, Jul 15, 2009 at 11:13:40PM +0300, Michael S. Tsirkin wrote:
> > > > This adds a generic uio driver that can bind to any PCI device.  First
> > > > user will be virtualization where a qemu userspace process needs to
> > > > give guest OS access to the device.
> > > >
> > > > Interrupts are handled using the Interrupt Disable bit in the PCI
> > > > command register and Interrupt Status bit in the PCI status register. 
> > > > All devices compliant to PCI 2.3 (circa 2002) and all compliant PCI
> > > > Express devices should support these bits.  Driver detects this
> > > > support, and won't bind to devices which do not support the Interrupt
> > > > Disable Bit in the command register.
> > > >
> > > > It's expected that more features of interest to virtualization will be
> > > > added to this driver in the future. Possibilities are: mmap for device
> > > > resources, MSI/MSI-X, eventfd (to interface with kvm), iommu.
> > > >
> > > > Acked-by: Chris Wright <chrisw@redhat.com>
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > ---
> > > >
> > > > Hans, Greg, please review and consider for upstream.
> > > >
> > > > This is intended to solve the problem in virtualization that shared
> > > > interrupts do not work with assigned devices. Earlier versions of this
> > > > patch have circulated on kvm@vger.
> > >
> > > How does this play with the pci-stub driver that I thought was written
> > > to solve this very problem?
> >
> > AFAIK the problem pci stub was written to solve is simply to bind to a
> > device. You then have to use another kernel module which looks the
> > device up with something like pci_get_bus_and_slot to do anything
> > useful. In particular, for non-shared interrupts, we can disable the
> > interrupt in the apic. But this does not work well for shared
> > interrupts. Thus this work.
> >
> > The uio driver will be used in virtualization scenarious, a couple
> > of possible ones that have been mentioned on the kvm list are:
> > - device assignment (guest access to device) for simple devices with
> >   shared interrupts: emulating PCI is tricky enough to better be done in
> >   userspace. shared interrupt support is important as it happens
> >   with real devices
> 
> One comments for shared interrupt: if you means guest device shares interrupt 
> with device in other domain(that means guest or host), it's still a security 
> hole, and our position seems still won't-do it. Could you explain how the 
> situation change with this patch? I am not sure if I understand your meaning 
> completely...
> 
> Thanks.

Yes, this lets you safely share an interrupt between guests. Here's how this works:
a device asserts interrupt
host (kernel) sets INTD bit in device, wakes up guest
guest handles interrupt and acks it
host (userspace) clears INTD bit in device

As you see, INTD bit is under control of the host, thus guest can not
deny service to other devices sharing the interrupt.

Performance is likely to be lower than with non-shared interrupts,
but that's often the case with interrupt sharing anyway.
-- 
MST
