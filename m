Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0BIMqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 07:46:49 -0500
Received: from mga09.intel.com ([134.134.136.24]:61506 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab0BIMqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 07:46:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,436,1262592000"; 
   d="scan'208";a="594378056"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH 5/7] xen: Make event channel work with PV featured HVM
Date: Tue, 9 Feb 2010 20:46:53 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1265616354-7384-1-git-send-email-sheng@linux.intel.com> <1265616354-7384-6-git-send-email-sheng@linux.intel.com> <1265716376.24394.32669.camel@zakaz.uk.xensource.com>
In-Reply-To: <1265716376.24394.32669.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002092046.53222.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 February 2010 19:52:56 Ian Campbell wrote:
> On Mon, 2010-02-08 at 08:05 +0000, Sheng Yang wrote:
> > +       if (xen_hvm_pv_evtchn_enabled()) {
> > +               if (enable_hvm_pv(HVM_PV_EVTCHN))
> > +                       return -EINVAL;
> > +[...]
> > +               callback_via =
> > HVM_CALLBACK_VECTOR(X86_PLATFORM_IPI_VECTOR); +              
> > set_callback_via(callback_via);
> > +
> > +               x86_platform_ipi_callback = do_hvm_pv_evtchn_intr;
> 
> Why this indirection via X86_PLATFORM_IPI_VECTOR?
> 
> Apart from that why not use CALLBACKOP_register subop CALLBACKTYPE_event
> pointing to xen_hypervisor_callback the same as a full PV guest?
> 
> This would remove all the evtchn related code from HVMOP_enable_pv which
> I think should be eventually unnecessary as an independent hypercall
> since all HVM guests should simply be PV capable by default -- the
> hypervisor only needs to track if the guest has made use of specific PV
> functionality, not the umbrella "is PV" state.

The reason is the bounce frame buffer implemented by PV guest to inject a 
event is too complex here... Basically you need to setup a stack like hardware 
would do, and return to the certain guest CS:IP to handle this. And you need 
to take care of every case, e.g. guest in the ring0 or ring3, guest in the 
interrupt context or not, and the recursion of the handler, and so on. 
Hardware can easily handle all these elegantly, you just need to inject a 
vector through hardware provided method. That's much easily and elegant. Take 
the advantage of hardware is still a part of our target. :)

And even with CALLBACKOP_register, I think the change in hypervisor is needed. 
And I think the updated approach is near to your idea, and  I am totally agree 
that a functionality based enabling is better than a big umbrella. Now you can 
see, a generic enabling is discard, and current the enabling is in feature 
branch enabling, one at a time(though there is only one now...). The message 
for the evtchn enabling of HVM hypercall transfered is, the guest won't use 
IOAPIC/LAPIC now, it would purely use evtchn; so hypervisor indeed need change 
to continue to service the guest. The "umbrella 'is PV'" isn't in usage now(in 
fact I still put a flag there because I was wandering if I can optimize PV 
halt if hypervisor is aware of it, but maybe it's too early to consider this 
now..). The only three positions in Xen patch mentioned hvm_pv, are for 
evtchn. So the meaning here is: HVM can be PV featured, but sometime(e.g. for 
evtchn) hypervisor need aware of the state of guest, so we have judgment for 
evtchn, as well as clear the hardware TSC offset in preparing for the PV timer 
which would come along with evtchn. That is something we have to do. And we 
don't have the similar thing for halt now, because hypervisor don't need to 
know about it. We only let hypervisor know when it's necessary.

I would remove XEN_HVM_PV_ENABLED flags in the xen patchset, if it remind you 
of the umbrella of "HVM PV" features.

-- 
regards
Yang, Sheng

