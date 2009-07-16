Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZGPNdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZGPNdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 09:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbZGPNdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 09:33:19 -0400
Received: from mga12.intel.com ([143.182.124.36]:49539 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755993AbZGPNdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 09:33:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,411,1243839600"; 
   d="scan'208";a="165706410"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: kvm@vger.kernel.org
Subject: Re: [PATCHv4] uio: add generic driver for PCI 2.3 devices
Date: Thu, 16 Jul 2009 21:33:05 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; x86_64; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Greg KH <gregkh@suse.de>,
       anthony@codemonkey.ws, avi@redhat.com, chrisw@redhat.com,
       hjk@linutronix.de, linux-kernel@vger.kernel.org
References: <20090715201340.GA12279@redhat.com> <20090715220829.GB31962@suse.de> <20090716123101.GA15975@redhat.com>
In-Reply-To: <20090716123101.GA15975@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907162133.07368.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 July 2009 20:31:01 Michael S. Tsirkin wrote:
> On Wed, Jul 15, 2009 at 03:08:29PM -0700, Greg KH wrote:
> > On Wed, Jul 15, 2009 at 11:13:40PM +0300, Michael S. Tsirkin wrote:
> > > This adds a generic uio driver that can bind to any PCI device.  First
> > > user will be virtualization where a qemu userspace process needs to
> > > give guest OS access to the device.
> > >
> > > Interrupts are handled using the Interrupt Disable bit in the PCI
> > > command register and Interrupt Status bit in the PCI status register. 
> > > All devices compliant to PCI 2.3 (circa 2002) and all compliant PCI
> > > Express devices should support these bits.  Driver detects this
> > > support, and won't bind to devices which do not support the Interrupt
> > > Disable Bit in the command register.
> > >
> > > It's expected that more features of interest to virtualization will be
> > > added to this driver in the future. Possibilities are: mmap for device
> > > resources, MSI/MSI-X, eventfd (to interface with kvm), iommu.
> > >
> > > Acked-by: Chris Wright <chrisw@redhat.com>
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >
> > > Hans, Greg, please review and consider for upstream.
> > >
> > > This is intended to solve the problem in virtualization that shared
> > > interrupts do not work with assigned devices. Earlier versions of this
> > > patch have circulated on kvm@vger.
> >
> > How does this play with the pci-stub driver that I thought was written
> > to solve this very problem?
>
> AFAIK the problem pci stub was written to solve is simply to bind to a
> device. You then have to use another kernel module which looks the
> device up with something like pci_get_bus_and_slot to do anything
> useful. In particular, for non-shared interrupts, we can disable the
> interrupt in the apic. But this does not work well for shared
> interrupts. Thus this work.
>
> The uio driver will be used in virtualization scenarious, a couple
> of possible ones that have been mentioned on the kvm list are:
> - device assignment (guest access to device) for simple devices with
>   shared interrupts: emulating PCI is tricky enough to better be done in
>   userspace. shared interrupt support is important as it happens
>   with real devices

One comments for shared interrupt: if you means guest device shares interrupt 
with device in other domain(that means guest or host), it's still a security 
hole, and our position seems still won't-do it. Could you explain how the 
situation change with this patch? I am not sure if I understand your meaning 
completely...

Thanks.

-- 
regards
Yang, Sheng

> - simple communication between guest and host:
>   we create a virtual device in host, and userspace
>   driver in guest gets events and passes them on
>   to e.g. dbus. shared interrupt support is important
>   to avoid wasting irqs
>
> >  Will it conflict?
>
> No in a sense that you can't bind both drivers to the same device.
>
> > In fact, it looks like you copied the comments for this driver directly
> > from the pci-stub driver :)
>
> Right.
>
> > How about moving that documentation into a place that people will notice
> > it, like the rest of the UIO documentation?
>
> OK.
>
> > And right now you are just sending the irq to userspace, what is
> > userspace supposed to do with it?
>
> Userspace uses libpci (i.e. pci sysfs) to talk to the device and to
> re-enable interrupts by writing to the command register.
>
> In the case of device assignment, this will be qemu which
> acts as a proxy for driver running in guest context.
> In case of uio loaded in guest, the driver will be in guest
> userspace, and the device is emulated in qemu.
>
> > Do you have a userspace program that
> > uses this interface today to verify that everything works?  If so, care
> > to provide a pointer to it?
>
> Sure. I used an emulated device for this.
> First, you patch qemu to add the device:
> http://www.linux-kvm.org/downloads/mst/test_irq.patch
>
> Now, run with the new kernel (-kernel flag), adding
>  -device test-irq
>
> Once in guest, assign the device id
> echo "1af4 2009" > /sys/bus/pci/drivers/uio_pci_generic/new_id
>
> Compile and run this driver:
> http://www.linux-kvm.org/downloads/mst/testuio.c
> (it does not use any libraries besides libc,
>  so just gcc testuio.c -o testuio)
>
> And now make the device assert interrupts, like this:
>
> while
> sleep 1
> do
> setpci -s 00:04.0 0x40.B=0x1
> done
>
> You should see messages printed as the driver gets interrupts, but no
> error messages about missed interrupts.
>
> > thanks,
> >
> > greg k-h
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


