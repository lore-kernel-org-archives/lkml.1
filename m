Return-Path: <linux-kernel-owner+w=401wt.eu-S1754941AbZI3XdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941AbZI3XdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbZI3XdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:33:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:37167 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbZI3XdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:33:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,482,1249282800"; 
   d="scan'208";a="193738148"
From: "Kay, Allen M" <allen.m.kay@intel.com>
To: Chris Wright <chrisw@sous-sol.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>
Date: Wed, 30 Sep 2009 16:33:11 -0700
Subject: RE: [PATCH ACS v3 1/1]
Thread-Topic: [PATCH ACS v3 1/1]
Thread-Index: AcpBNUByw+AYQgdOS52xYDDwMgRMKgAtDkqg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E2F0411F@orsmsx505.amr.corp.intel.com>
References: <1253231193-5753-1-git-send-email-allen.m.kay@intel.com>
 <20090929000041.GB3958@sequoia.sous-sol.org>
 <57C9024A16AD2D4C97DC78E552063EA3E2EA3B70@orsmsx505.amr.corp.intel.com>
 <20090929184650.GF3958@sequoia.sous-sol.org>
In-Reply-To: <20090929184650.GF3958@sequoia.sous-sol.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I did not generateany errors to see if AER is working, did you?
>

No, I believe AER RC interrupts are turned off by default.  I can try to turn it on to see if I see anything.

> This means adding direct translated P2P support, no?

Yes, I believe PCIe switches will need to be enhanced to differentiate between transactions with translated addresses and un-translated addresses to support P2P.

>
> And what does the device cache when the IOMMU is in PT mode?  I'm mainly voicing concern
> about the non-IOV case (i.e. common case) that this impacts by enabling as a default.
>

I don't think device caches translation when VT-d is in PT mode.

On the other hand, can we say VT-d PT mode is mainly for KVM virtualization use case?  If so, is it reasonable to say performance of host P2P in this mode is not of highest priority?

If not, another option is to have a kernel boot parameter to configure an kernel boot instance to be either host kernel optimized or virtualization optimized.  I don't know whether this is a reasonable or not ...


-----Original Message-----
From: linux-pci-owner@vger.kernel.org [mailto:linux-pci-owner@vger.kernel.org] On Behalf Of Chris Wright
Sent: Tuesday, September 29, 2009 11:47 AM
To: Kay, Allen M
Cc: Chris Wright; linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; jbarnes@virtuousgeek.org; matthew@wil.cx
Subject: Re: [PATCH ACS v3 1/1]

* Kay, Allen M (allen.m.kay@intel.com) wrote:
> >
> >This may negatively impact p2p traffic throughput for devices that don't
> >need it.  Have you considered this impact or attempted to measure it?
> >
> 
> As far as I know, there is no existing PCIe devices that have ACS capable PCIe switches.  This means this patch will not impact existing P2P devices.  On the NHM platform I tested this patch on, only root ports support ACS which has no material impact on PCIe transactions since whatever upstream traffic root port sees is already forwarded to the root complex anyways.

BTW, I tested it as well...works as advertised ;-)  I did not generate
any errors to see if AER is working, did you?

> As for future devices that does have ACS capable PCIe switches, this patch can cause potential P2P performance issue as you indicated.  Although PCI IOV SIG has yet to make a decision on this issue, it would be reasonable to expect this problem can be mitigated with ATS capable devices.  For example, it would be reasonable to expect translated addresses can be routed directly to the peer device while un-translated addresses would have to be routed to the root complex.

This means adding direct translated P2P support, no?  And what does the
device cache when the IOMMU is in PT mode?  I'm mainly voicing concern
about the non-IOV case (i.e. common case) that this impacts by enabling
as a default.

> By the way, PLX technology announced first such switch on 8/26.  We will be take a look at these devices as soon as we get hold of these in our lab.

Or multifunction devices, but any testing is good.

> >An alternative approach would be to enable this during device assignment.
> >
> 
> I have indeed spent some time playing around with a patch that does this.  There are some potential drawbacks. Given that PCI is already enabled at the time of device assignment, enabling P2P upstream forwarding might disrupt in flight PCIe transactions.  In addition, this means we need separate patches for enabling ACS for KVM and Xen as device assignment for KVM and Xen do not share code paths.

I hadn't considered in-flight transactions.  The device should be
quiesced and reset before assignment, but that doesn't account for
other devices effected by intermediate downstream port ACS changes.
It's also not entirely clear what to do on de-assignment.  Would be a
bit odd, but could be driven from userspace.

> >Also, there is no checking that the relevant path through the topology has
> >the right capabilties.  Is there any reason you left that out?  It would
> >certainly simplify the filtering logic, for example.  
> >
> 
> Do you mean enable p2p forwarding on all upstream PCIe switches only if all of them are ACS capable?  I can see this can potentially simplify filtering software to just check the lowest level PCIe switch.

Yeah, and the RC requirements too, of course.

> This appears to be a trade-off between whether we want put the complexity in Linux PCI driver or in the user mode filtering code.  In my mind, if we take the view that the device filtering software is the ultimate authority in determining whether a device is assignable, it probably should not trust the host to always do the right thing from virtualization standpoint.  If a paranoid filtering software always checks the entire path from the device to the root complex anyways, it might be reasonable to simplify the code in the kernel.

The reason I mention it is not just filtering, but can create a platform
w/ undefined behaviour w/out checking.

> >And given some states result in undefined behavior, perhaps it makes sense to check
> >while enabling ACS.
> >
> 
> By "undefined behavior", do you mean when there a mix of ACS and non-ACS capable PCIe switches and P2P upstream forwarding is enabled in ACS capable PCIe switches?  I would expect the aggregate behavior is the same as no P2P upstream forwarding.

Yes, that's what I mean.

> Let's say we have a configuration where the lowest PCIe switch is ACS capable and it has P2P upstream forwarding enabled.  However, the PCIe switch just above it is not ACS capable.
> 
> I would expect the following behavior:
> 
> 1) P2P transaction is forwarded upstream by the ACS capable PCIe switch
> 2) non-ACS capable switch sends the transaction back
> 3) ACS capable switch sends the transaction to the peer device.
> 
> The aggregate result is the transaction behaved as if all the switches are not ACS capable.

Right, although it's implementation specific what actually happens.
May not matter much, I just don't know what switch vendors will do.

> > I'd call it pci_enable_acs...in fact, the kdoc above tries something close to that ;-)
> >
> 
> No problem, I can change the code to incorporate this once we have an agreement on other items.

thanks,
-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-pci" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
