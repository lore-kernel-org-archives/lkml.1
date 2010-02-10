Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0BJKU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 05:20:26 -0500
Received: from smtp.citrix.com ([66.165.176.89]:46466 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab0BJKUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:20:24 -0500
X-IronPort-AV: E=Sophos;i="4.49,442,1262581200"; 
   d="scan'208";a="7134673"
Subject: RE: [Xen-devel] Re: [PATCH 5/7] xen: Make event channel work with
 PV featured HVM
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "Nakajima, Jun" <jun.nakajima@intel.com>
CC: Sheng Yang <sheng@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
In-Reply-To: <54B2EB610B7F1340BB6A0D4CA04A4F1012BABE0E@orsmsx505.amr.corp.intel.com>
References: <1265616354-7384-1-git-send-email-sheng@linux.intel.com>
	 <1265616354-7384-6-git-send-email-sheng@linux.intel.com>
	 <1265716376.24394.32669.camel@zakaz.uk.xensource.com>
	 <201002092046.53222.sheng@linux.intel.com>
	 <1265724124.24394.33084.camel@zakaz.uk.xensource.com>
	 <54B2EB610B7F1340BB6A0D4CA04A4F1012BABE0E@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 10 Feb 2010 10:20:20 +0000
Message-ID: <1265797220.24394.36806.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-10 at 03:16 +0000, Nakajima, Jun wrote:
> Ian Campbell wrote on Tue, 9 Feb 2010 at 06:02:04:
> 
> > On Tue, 2010-02-09 at 12:46 +0000, Sheng Yang wrote:
> >> On Tuesday 09 February 2010 19:52:56 Ian Campbell wrote:
> >>> On Mon, 2010-02-08 at 08:05 +0000, Sheng Yang wrote:
> >>>> +       if (xen_hvm_pv_evtchn_enabled()) {
> >>>> +               if (enable_hvm_pv(HVM_PV_EVTCHN))
> >>>> +                       return -EINVAL;
> >>>> +[...]
> >>>> +               callback_via =
> >>>> HVM_CALLBACK_VECTOR(X86_PLATFORM_IPI_VECTOR); +
> >>>> set_callback_via(callback_via);
> >>>> +
> >>>> +               x86_platform_ipi_callback =
> > do_hvm_pv_evtchn_intr;
> >>> 
> >>> Why this indirection via X86_PLATFORM_IPI_VECTOR?
> >>> 
> >>> Apart from that why not use CALLBACKOP_register subop
> >>> CALLBACKTYPE_event pointing to xen_hypervisor_callback the same as a
> >>> full PV guest?
> >>> 
> >>> This would remove all the evtchn related code from HVMOP_enable_pv
> >>> which I think should be eventually unnecessary as an independent
> >>> hypercall since all HVM guests should simply be PV capable by default
> >>> -- the hypervisor only needs to track if the guest has made use of
> >>> specific PV functionality, not the umbrella "is PV" state.
> >>  The reason is the bounce frame buffer implemented by PV guest to
> >> inject a event is too complex here... Basically you need to setup a
> >> stack like hardware would do, and return to the certain guest CS:IP to
> >> handle this. And you need to take care of every case, e.g. guest in the
> >> ring0 or ring3, guest in the interrupt context or not, and the
> >> recursion of the handler, and so on.
> > 
> > The code for all this already exists on both the hypervisor and guest
> > side in order to support PV guests, would it not just be a case of
> > wiring it up for this case as well?
> 
> The code is not so useful for HVM guests. The current PV code uses the
> ring transition which maintains the processor state in the stack, to
> switch between the hypervisor and the guest, but HVM VM entry/exit
> does not use the stack at all. To implement an asynchronous event,
> i.e. callback handler for HVM, the simplest (and reliable) way is to
> use the architectural event (i.e. IDT-based). Otherwise, we need to
> modify various VMCS/VMCB fields (e.g. selectors, segments, stacks,
> etc.) depending on where the last VM happened using the OS-specific
> knowledge.

RIP and RSP are taken from the stack just prior to vmentry (by the code
in vmx/entry.S) but you are right that CS/SS etc are not handled in this
way which would be make things more complicated, probably not worth it.

> Having said that, the interface and implementation are different. I
> think we can use the same/similar code that registers the callback
> handler, by hiding such HVM-specific code from the common code path. 

Yes, I think that would be an improvement.

Even better would be if we could use the same entry point into the
kernel in both PV and HVM cases, with only the injection method on the
hypervisor side differing. AFAIK xen_hypervisor_callback expects a stack
frame very like a hardware exception so perhaps this works out? IOW can
we reference xen_hypervisor_callback directly in the IDT?

BTW I not sure we should be repurposing x86_platform_ipi in this way
(maybe this goes away with the above changes), I think it should be fine
to simply pick another free vector < 255 (perhaps even dynamically)?
There were objections on LKML to a patch which did a similar thing last
month (thread: Add "handle page fault" PV helper).

Ian.

