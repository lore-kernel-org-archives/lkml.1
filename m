Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab0BIOCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 09:02:11 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:15669 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab0BIOCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:02:09 -0500
X-IronPort-AV: E=Sophos;i="4.49,436,1262581200"; 
   d="scan'208";a="83415095"
Subject: Re: [Xen-devel] Re: [PATCH 5/7] xen: Make event channel work with
 PV featured HVM
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Sheng Yang <sheng@linux.intel.com>
CC: xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <201002092046.53222.sheng@linux.intel.com>
References: <1265616354-7384-1-git-send-email-sheng@linux.intel.com>
	 <1265616354-7384-6-git-send-email-sheng@linux.intel.com>
	 <1265716376.24394.32669.camel@zakaz.uk.xensource.com>
	 <201002092046.53222.sheng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 9 Feb 2010 14:02:04 +0000
Message-ID: <1265724124.24394.33084.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-09 at 12:46 +0000, Sheng Yang wrote:
> On Tuesday 09 February 2010 19:52:56 Ian Campbell wrote:
> > On Mon, 2010-02-08 at 08:05 +0000, Sheng Yang wrote:
> > > +       if (xen_hvm_pv_evtchn_enabled()) {
> > > +               if (enable_hvm_pv(HVM_PV_EVTCHN))
> > > +                       return -EINVAL;
> > > +[...]
> > > +               callback_via =
> > > HVM_CALLBACK_VECTOR(X86_PLATFORM_IPI_VECTOR); +              
> > > set_callback_via(callback_via);
> > > +
> > > +               x86_platform_ipi_callback = do_hvm_pv_evtchn_intr;
> > 
> > Why this indirection via X86_PLATFORM_IPI_VECTOR?
> > 
> > Apart from that why not use CALLBACKOP_register subop CALLBACKTYPE_event
> > pointing to xen_hypervisor_callback the same as a full PV guest?
> > 
> > This would remove all the evtchn related code from HVMOP_enable_pv which
> > I think should be eventually unnecessary as an independent hypercall
> > since all HVM guests should simply be PV capable by default -- the
> > hypervisor only needs to track if the guest has made use of specific PV
> > functionality, not the umbrella "is PV" state.
> 
> The reason is the bounce frame buffer implemented by PV guest to inject a 
> event is too complex here... Basically you need to setup a stack like hardware 
> would do, and return to the certain guest CS:IP to handle this. And you need 
> to take care of every case, e.g. guest in the ring0 or ring3, guest in the 
> interrupt context or not, and the recursion of the handler, and so on. 

The code for all this already exists on both the hypervisor and guest
side in order to support PV guests, would it not just be a case of
wiring it up for this case as well?

> Hardware can easily handle all these elegantly, you just need to inject a 
> vector through hardware provided method. That's much easily and elegant. Take 
> the advantage of hardware is still a part of our target. :)

I thought one of the points of this patchset was that there was overhead
associated with the hardware event injection mechanisms which you wanted
to avoid?

As it stands what you appear to be implementing does not seem to vary
greatly from the existing PVonHVM PCI IRQ associated with the virtual
PCI device.

> And even with CALLBACKOP_register, I think the change in hypervisor is needed. 
> And I think the updated approach is near to your idea, and  I am totally agree 
> that a functionality based enabling is better than a big umbrella. Now you can 
> see, a generic enabling is discard, and current the enabling is in feature 
> branch enabling, one at a time(though there is only one now...). The message 
> for the evtchn enabling of HVM hypercall transfered is, the guest won't use 
> IOAPIC/LAPIC now, it would purely use evtchn; so hypervisor indeed need change 
> to continue to service the guest.

There have been objections from several people to this mutually
exclusive *APIC or evtchn approach. I understand that your immediate aim
is to move everything to evtchn and that this is the easiest path to
that goal but you are then tying the hypervisor into supporting the
least flexible possible interface forever. Instead lets try and define
an interface which is flexible enough that we think it can be supported
for the long term which can also be used to meet your immediate aims.
(IOW if the guest wants to request evtchn injection for every individual
interrupt then, fine, it may do so, but if it doesn't want to do that
then the hypervisor should not force it).

If you make the distinction between evtchn and *APIC interrupts in the
LAPIC at the vector level as Stefano suggests doesn't the more flexible
interface naturally present itself? Plus you get MSI and passthrough
support as well.

Ian.

