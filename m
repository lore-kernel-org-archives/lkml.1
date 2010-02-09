Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0BIR6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:58:52 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:61842 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab0BIR6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:58:50 -0500
X-IronPort-AV: E=Sophos;i="4.49,437,1262563200"; 
   d="scan'208";a="9391749"
Date: Tue, 9 Feb 2010 18:01:30 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Sheng Yang <sheng@linux.intel.com>
CC: Ian Campbell <Ian.Campbell@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] Re: [PATCH 5/7] xen: Make event channel work with
 PV featured HVM
In-Reply-To: <201002100117.54755.sheng@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1002091731500.11349@kaball-desktop>
References: <1265616354-7384-1-git-send-email-sheng@linux.intel.com> <201002092046.53222.sheng@linux.intel.com> <1265724124.24394.33084.camel@zakaz.uk.xensource.com> <201002100117.54755.sheng@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Feb 2010, Sheng Yang wrote:
> Thanks Stefano, I haven't consider this before...
> 
> But for evtchn/vector mapping, I think there is still problem existed for this 
> case.
> 
> For natively support MSI, LAPIC is a must. Because IA32 MSI msg/addr not 
> only contained the vector number, but also contained information like LAPIC 
> delivery mode/destination mode etc. If we want to natively support MSI, we 
> need LAPIC. But discard LAPIC is the target of this patchset, due to it's 
> unnecessary VMExit; and we would replace it with evtchn.
> 
> And still, the target of this patch is: we want to eliminate the overhead of 
> interrupt handling. Especially, our target overhead is *APIC, because they 
> would cause unnecessary VMExit in the current hardware(e.g. EOI). Then we 
> introduced the evtchn, because it's a mature shared memory based event 
> delivery mechanism, with the minimal overhead. We replace the *APIC with 
> dynamic IRQ chip which is more efficient, and no more unnecessary VMExit. 
> Because we enabled evtchn, so we can support PV driver seamless - but you know 
> this can also be done by platform PCI driver. The main target of this patch is 
> to benefit interrupt intensive assigned devices. And we would only support 
> MSI/MSI-X devices(if you don't mind two lines more code in Xen, we can also 
> get assigned device support now, with MSI2INTx translation, but I think it's a 
> little hacky). We are working on evtchn support on MSI/MSI-X devices; we 
> already have workable patches, but we want to get a solution for both PV 
> featured HVM and pv_ops dom0, so we are still purposing an approach that 
> upstream Linux can accept.
> 
> In fact, I don't think guest evtchn code was written with coexisted with other 
> interrupt delivery mechanism in mind. Many codes is exclusive, self-
> maintained. So use it exclusive seems a good idea to keep it simple and nature 
> to me(sure, the easy way as well). I think it's maybe necessary to touch some 
> generic code if making evtchn coexist with *APIC. At the same time, MSI/MSI-X 
> benefit is a must for us, which means no LAPIC...

First you say that for MSI to work LAPIC is a must, but then you say
that for performance gains you want to avoid LAPIC altogether.
Which one is the correct one?

If you want to avoid LAPIC then my suggestion of mapping vectors into
event channels is still a good one (if it is actually possible to do
without touching generic kernel code, but to be sure it needs to be
tried).

Regarding making event channels coexist with *APIC, my suggestion is
actually more similar to what you have already done than you think:
instead of a global switch just use a per-device (actually
per-vector) switch.
The principal difference would be that in xen instead of having all the
assert_irq related changes and a global if( is_hvm_pv_evtchn_domaini(d) ),
your changes would be limited to vlapic.c and you would check that the
guest enabled event channels as a delivery mechanism for that particular
vector, like if ( delivery_mode(vlapic, vec) == EVENT_CHANNEL ).

> And I still have question on "flexibility": how much we can benefit if evtchn 
> can coexist with *APIC? What I can think of is some level triggered 
> interrupts, like USB, but they are rare and not useful when we targeting 
> servers. Well, in this case I think PVonHVM could fit the job better...

it is not only about flexibility, but also about code changes in
delicate code paths and designing a system that can work with pci
passthrough and MSI too.
You said that you are working on patches to make MSI devices work: maybe
seeing a working implementation of that would convince us about which one
is the correct approach.

