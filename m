Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab0BLL43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:56:29 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:1415 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab0BLL42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:56:28 -0500
X-IronPort-AV: E=Sophos;i="4.49,459,1262563200"; 
   d="scan'208";a="9443047"
Date: Fri, 12 Feb 2010 11:59:16 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Sheng Yang <sheng@linux.intel.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH 5/7] xen: Make event channel work with
 PV featured HVe
In-Reply-To: <201002111759.26302.sheng@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1002111225150.26970@kaball-desktop>
References: <1265616354-7384-1-git-send-email-sheng@linux.intel.com> <201002100117.54755.sheng@linux.intel.com> <alpine.DEB.2.00.1002091731500.11349@kaball-desktop> <201002111759.26302.sheng@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Sheng Yang wrote:
> 
> The MSI/MSI-X is the target, but if we add more code then we want benefit from 
> them. Stick with LAPIC is no benefit I think.
> 

We wouldn't stick with LAPIC: the guest could still decide to use event
channels for all the vectors and LAPIC usage would be avoided, and it is
probably what is going to happen.


> > You said that you are working on patches to make MSI devices work: maybe
> > seeing a working implementation of that would convince us about which one
> > is the correct approach.
> 
> Um, we don't want to show code to the community before it's mature. I can 
> describe one implementation: it add a hook in arch_setup_msi_irqs(), and write 
> the self-defined MSI data/addr(contained event channel information) to the PCI 
> configuration/MMIO; then hypervisor/qemu can intercept and parse it, then we 
> can get the event when real device's interrupt injected.
> 

your approach needs:

- global enable of evtchns in place of legacy irqs on the linux side
- special translation irq -> evtchn in irq.c on the xen side
- special requests of evtchns in place of MSIs on the linux side
  (touching generic kernel code)
- special handling of evtchns in place of MSIs on the qemu/xen side

the last two points are particularly worrying.
My approach needs:

- per vector enable of evtchns on the linux side
- special delivery of evtchns for guest's vectors in vlapic.c on the xen side

I think it is worth giving it a try, given that it is simpler and it
doesn't need any change in the generic kernel code.

In any case it seems to me that the MSI\evtchn work should be part of
this patch series, because it is difficult to understand if your
approach makes sense or not without it. We should probably just wait for
it to be complete before proceeding further.

