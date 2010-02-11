Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab0BKJ7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 04:59:08 -0500
Received: from mga06.intel.com ([134.134.136.21]:62495 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753242Ab0BKJ7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 04:59:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,450,1262592000"; 
   d="scan'208";a="595041682"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] Re: [PATCH 5/7] xen: Make event channel work with PV featured HVM
Date: Thu, 11 Feb 2010 17:59:26 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1265616354-7384-1-git-send-email-sheng@linux.intel.com> <201002100117.54755.sheng@linux.intel.com> <alpine.DEB.2.00.1002091731500.11349@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1002091731500.11349@kaball-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002111759.26302.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 February 2010 02:01:30 Stefano Stabellini wrote:
> On Tue, 9 Feb 2010, Sheng Yang wrote:
> > Thanks Stefano, I haven't consider this before...
> >
> > But for evtchn/vector mapping, I think there is still problem existed for
> > this case.
> >
> > For natively support MSI, LAPIC is a must. Because IA32 MSI msg/addr not
> > only contained the vector number, but also contained information like
> > LAPIC delivery mode/destination mode etc. If we want to natively support
> > MSI, we need LAPIC. But discard LAPIC is the target of this patchset, due
> > to it's unnecessary VMExit; and we would replace it with evtchn.
> >
> > And still, the target of this patch is: we want to eliminate the overhead
> > of interrupt handling. Especially, our target overhead is *APIC, because
> > they would cause unnecessary VMExit in the current hardware(e.g. EOI).
> > Then we introduced the evtchn, because it's a mature shared memory based
> > event delivery mechanism, with the minimal overhead. We replace the *APIC
> > with dynamic IRQ chip which is more efficient, and no more unnecessary
> > VMExit. Because we enabled evtchn, so we can support PV driver seamless -
> > but you know this can also be done by platform PCI driver. The main
> > target of this patch is to benefit interrupt intensive assigned devices.
> > And we would only support MSI/MSI-X devices(if you don't mind two lines
> > more code in Xen, we can also get assigned device support now, with
> > MSI2INTx translation, but I think it's a little hacky). We are working on
> > evtchn support on MSI/MSI-X devices; we already have workable patches,
> > but we want to get a solution for both PV featured HVM and pv_ops dom0,
> > so we are still purposing an approach that upstream Linux can accept.
> >
> > In fact, I don't think guest evtchn code was written with coexisted with
> > other interrupt delivery mechanism in mind. Many codes is exclusive,
> > self- maintained. So use it exclusive seems a good idea to keep it simple
> > and nature to me(sure, the easy way as well). I think it's maybe
> > necessary to touch some generic code if making evtchn coexist with *APIC.
> > At the same time, MSI/MSI-X benefit is a must for us, which means no
> > LAPIC...
> 
> First you say that for MSI to work LAPIC is a must, but then you say
> that for performance gains you want to avoid LAPIC altogether.
> Which one is the correct one?

What I mean is, if you want to support MSI without modification of 
generic kernel code(natively support), LAPIC is a must. But we want to avoid 
LAPIC to get performance gain, so we would have to modify generic kernel code, 
and discard LAPIC. And the same method applied to pv_ops dom0, because it use 
evtchn as well.
 
> If you want to avoid LAPIC then my suggestion of mapping vectors into
> event channels is still a good one (if it is actually possible to do
> without touching generic kernel code, but to be sure it needs to be
> tried).

Could you elaborate your idea? Per my understanding, seems it can't make 
situation better. I've explained a part of the reason. 

> Regarding making event channels coexist with *APIC, my suggestion is
> actually more similar to what you have already done than you think:
> instead of a global switch just use a per-device (actually
> per-vector) switch.
>
> The principal difference would be that in xen instead of having all the
> assert_irq related changes and a global if( is_hvm_pv_evtchn_domaini(d) ),
> your changes would be limited to vlapic.c and you would check that the
> guest enabled event channels as a delivery mechanism for that particular
> vector, like if ( delivery_mode(vlapic, vec) == EVENT_CHANNEL ).

This can be done with per-vector/evtchn within the current framework. The 
virq_to_evtchn[] can do these, because they are enabled by bind_virq 
hypercall. I can update this, the semantic reason sound good. But I still have 
reservations to change the delivery mechanism of each vector. I'd like stick 
to the typical usage mode, and keep it simple.

But I don't think vlapic is a good place for this. The interrupt delivery 
mechanism should be higher level, vlapic means you stick with *APIC mechanism, 
but it's not true.

> > And I still have question on "flexibility": how much we can benefit if
> > evtchn can coexist with *APIC? What I can think of is some level
> > triggered interrupts, like USB, but they are rare and not useful when we
> > targeting servers. Well, in this case I think PVonHVM could fit the job
> > better...
> 
> it is not only about flexibility, but also about code changes in
> delicate code paths and designing a system that can work with pci
> passthrough and MSI too.

The MSI/MSI-X is the target, but if we add more code then we want benefit from 
them. Stick with LAPIC is no benefit I think.

> You said that you are working on patches to make MSI devices work: maybe
> seeing a working implementation of that would convince us about which one
> is the correct approach.

Um, we don't want to show code to the community before it's mature. I can 
describe one implementation: it add a hook in arch_setup_msi_irqs(), and write 
the self-defined MSI data/addr(contained event channel information) to the PCI 
configuration/MMIO; then hypervisor/qemu can intercept and parse it, then we 
can get the event when real device's interrupt injected.

-- 
regards
Yang, Sheng
