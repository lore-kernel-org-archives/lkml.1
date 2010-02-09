Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0BIRRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:17:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:32005 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab0BIRRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:17:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,437,1262592000"; 
   d="scan'208";a="594446423"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [Xen-devel] Re: [PATCH 5/7] xen: Make event channel work with PV featured HVM
Date: Wed, 10 Feb 2010 01:17:54 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "xen-devel" <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
References: <1265616354-7384-1-git-send-email-sheng@linux.intel.com> <201002092046.53222.sheng@linux.intel.com> <1265724124.24394.33084.camel@zakaz.uk.xensource.com>
In-Reply-To: <1265724124.24394.33084.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002100117.54755.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 February 2010 22:02:04 Ian Campbell wrote:
> On Tue, 2010-02-09 at 12:46 +0000, Sheng Yang wrote:
> > On Tuesday 09 February 2010 19:52:56 Ian Campbell wrote:
> > > On Mon, 2010-02-08 at 08:05 +0000, Sheng Yang wrote:
> > > > +       if (xen_hvm_pv_evtchn_enabled()) {
> > > > +               if (enable_hvm_pv(HVM_PV_EVTCHN))
> > > > +                       return -EINVAL;
> > > > +[...]
> > > > +               callback_via =
> > > > HVM_CALLBACK_VECTOR(X86_PLATFORM_IPI_VECTOR); +
> > > > set_callback_via(callback_via);
> > > > +
> > > > +               x86_platform_ipi_callback = do_hvm_pv_evtchn_intr;
> > >
> > > Why this indirection via X86_PLATFORM_IPI_VECTOR?
> > >
> > > Apart from that why not use CALLBACKOP_register subop
> > > CALLBACKTYPE_event pointing to xen_hypervisor_callback the same as a
> > > full PV guest?
> > >
> > > This would remove all the evtchn related code from HVMOP_enable_pv
> > > which I think should be eventually unnecessary as an independent
> > > hypercall since all HVM guests should simply be PV capable by default
> > > -- the hypervisor only needs to track if the guest has made use of
> > > specific PV functionality, not the umbrella "is PV" state.
> >
> > The reason is the bounce frame buffer implemented by PV guest to inject a
> > event is too complex here... Basically you need to setup a stack like
> > hardware would do, and return to the certain guest CS:IP to handle this.
> > And you need to take care of every case, e.g. guest in the ring0 or
> > ring3, guest in the interrupt context or not, and the recursion of the
> > handler, and so on.
> 
> The code for all this already exists on both the hypervisor and guest
> side in order to support PV guests, would it not just be a case of
> wiring it up for this case as well?
> 
> > Hardware can easily handle all these elegantly, you just need to inject a
> > vector through hardware provided method. That's much easily and elegant.
> > Take the advantage of hardware is still a part of our target. :)
> 
> I thought one of the points of this patchset was that there was overhead
> associated with the hardware event injection mechanisms which you wanted
> to avoid?

No, I am not sure what's the overhead you are meaning here. I think I haven't 
express me well... The overhead we want to eliminate is the unnecessary VMExit 
due to *APIC, e.g. EOI. PV callback injection won't benefit in this case I 
think.
> 
> As it stands what you appear to be implementing does not seem to vary
> greatly from the existing PVonHVM PCI IRQ associated with the virtual
> PCI device.

PV driver is not our target. Our target is interrupt intensive assigned 
device, with MSI/MSI-x. And we would share the solution with pv_ops dom0 as we 
planned.

And this is still different from PVonHVM PCI IRQ injection, because the 
ack_irq won't cause VMExit. That's the overhead we targeted.
> 
> > And even with CALLBACKOP_register, I think the change in hypervisor is
> > needed. And I think the updated approach is near to your idea, and  I am
> > totally agree that a functionality based enabling is better than a big
> > umbrella. Now you can see, a generic enabling is discard, and current the
> > enabling is in feature branch enabling, one at a time(though there is
> > only one now...). The message for the evtchn enabling of HVM hypercall
> > transfered is, the guest won't use IOAPIC/LAPIC now, it would purely use
> > evtchn; so hypervisor indeed need change to continue to service the
> > guest.
> 
> There have been objections from several people to this mutually
> exclusive *APIC or evtchn approach. I understand that your immediate aim
> is to move everything to evtchn and that this is the easiest path to
> that goal but you are then tying the hypervisor into supporting the
> least flexible possible interface forever. Instead lets try and define
> an interface which is flexible enough that we think it can be supported
> for the long term which can also be used to meet your immediate aims.
> (IOW if the guest wants to request evtchn injection for every individual
> interrupt then, fine, it may do so, but if it doesn't want to do that
> then the hypervisor should not force it).
> 
> If you make the distinction between evtchn and *APIC interrupts in the
> LAPIC at the vector level as Stefano suggests doesn't the more flexible
> interface naturally present itself? Plus you get MSI and passthrough
> support as well.

Thanks Stefano, I haven't consider this before...

But for evtchn/vector mapping, I think there is still problem existed for this 
case.

For natively support MSI, LAPIC is a must. Because IA32 MSI msg/addr not 
only contained the vector number, but also contained information like LAPIC 
delivery mode/destination mode etc. If we want to natively support MSI, we 
need LAPIC. But discard LAPIC is the target of this patchset, due to it's 
unnecessary VMExit; and we would replace it with evtchn.

And still, the target of this patch is: we want to eliminate the overhead of 
interrupt handling. Especially, our target overhead is *APIC, because they 
would cause unnecessary VMExit in the current hardware(e.g. EOI). Then we 
introduced the evtchn, because it's a mature shared memory based event 
delivery mechanism, with the minimal overhead. We replace the *APIC with 
dynamic IRQ chip which is more efficient, and no more unnecessary VMExit. 
Because we enabled evtchn, so we can support PV driver seamless - but you know 
this can also be done by platform PCI driver. The main target of this patch is 
to benefit interrupt intensive assigned devices. And we would only support 
MSI/MSI-X devices(if you don't mind two lines more code in Xen, we can also 
get assigned device support now, with MSI2INTx translation, but I think it's a 
little hacky). We are working on evtchn support on MSI/MSI-X devices; we 
already have workable patches, but we want to get a solution for both PV 
featured HVM and pv_ops dom0, so we are still purposing an approach that 
upstream Linux can accept.

In fact, I don't think guest evtchn code was written with coexisted with other 
interrupt delivery mechanism in mind. Many codes is exclusive, self-
maintained. So use it exclusive seems a good idea to keep it simple and nature 
to me(sure, the easy way as well). I think it's maybe necessary to touch some 
generic code if making evtchn coexist with *APIC. At the same time, MSI/MSI-X 
benefit is a must for us, which means no LAPIC...

And I still have question on "flexibility": how much we can benefit if evtchn 
can coexist with *APIC? What I can think of is some level triggered 
interrupts, like USB, but they are rare and not useful when we targeting 
servers. Well, in this case I think PVonHVM could fit the job better...

-- 
regards
Yang, Sheng
