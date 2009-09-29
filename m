Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbZI2Rql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbZI2Rql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZI2Rqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:46:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:9029 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZI2Rqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:46:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,474,1249282800"; 
   d="scan'208";a="731281664"
From: "Kay, Allen M" <allen.m.kay@intel.com>
To: Chris Wright <chrisw@sous-sol.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>
Date: Tue, 29 Sep 2009 10:46:42 -0700
Subject: RE: [PATCH ACS v3 1/1]
Thread-Topic: [PATCH ACS v3 1/1]
Thread-Index: AcpAl+ZcNbaqbj7HTXGFivwZE4Z1WAAAtKbA
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E2EA3B70@orsmsx505.amr.corp.intel.com>
References: <1253231193-5753-1-git-send-email-allen.m.kay@intel.com>
 <20090929000041.GB3958@sequoia.sous-sol.org>
In-Reply-To: <20090929000041.GB3958@sequoia.sous-sol.org>
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
>This may negatively impact p2p traffic throughput for devices that don't
>need it.  Have you considered this impact or attempted to measure it?
>

As far as I know, there is no existing PCIe devices that have ACS capable PCIe switches.  This means this patch will not impact existing P2P devices.  On the NHM platform I tested this patch on, only root ports support ACS which has no material impact on PCIe transactions since whatever upstream traffic root port sees is already forwarded to the root complex anyways.

As for future devices that does have ACS capable PCIe switches, this patch can cause potential P2P performance issue as you indicated.  Although PCI IOV SIG has yet to make a decision on this issue, it would be reasonable to expect this problem can be mitigated with ATS capable devices.  For example, it would be reasonable to expect translated addresses can be routed directly to the peer device while un-translated addresses would have to be routed to the root complex.

By the way, PLX technology announced first such switch on 8/26.  We will be take a look at these devices as soon as we get hold of these in our lab.

>
>An alternative approach would be to enable this during device assignment.
>

I have indeed spent some time playing around with a patch that does this.  There are some potential drawbacks. Given that PCI is already enabled at the time of device assignment, enabling P2P upstream forwarding might disrupt in flight PCIe transactions.  In addition, this means we need separate patches for enabling ACS for KVM and Xen as device assignment for KVM and Xen do not share code paths.

>
>Also, there is no checking that the relevant path through the topology has
>the right capabilties.  Is there any reason you left that out?  It would
>certainly simplify the filtering logic, for example.  
>

Do you mean enable p2p forwarding on all upstream PCIe switches only if all of them are ACS capable?  I can see this can potentially simplify filtering software to just check the lowest level PCIe switch.

This appears to be a trade-off between whether we want put the complexity in Linux PCI driver or in the user mode filtering code.  In my mind, if we take the view that the device filtering software is the ultimate authority in determining whether a device is assignable, it probably should not trust the host to always do the right thing from virtualization standpoint.  If a paranoid filtering software always checks the entire path from the device to the root complex anyways, it might be reasonable to simplify the code in the kernel.

>
>And given some states result in undefined behavior, perhaps it makes sense to check
>while enabling ACS.
>

By "undefined behavior", do you mean when there a mix of ACS and non-ACS capable PCIe switches and P2P upstream forwarding is enabled in ACS capable PCIe switches?  I would expect the aggregate behavior is the same as no P2P upstream forwarding.

Let's say we have a configuration where the lowest PCIe switch is ACS capable and it has P2P upstream forwarding enabled.  However, the PCIe switch just above it is not ACS capable.

I would expect the following behavior:

1) P2P transaction is forwarded upstream by the ACS capable PCIe switch
2) non-ACS capable switch sends the transaction back
3) ACS capable switch sends the transaction to the peer device.

The aggregate result is the transaction behaved as if all the switches are not ACS capable.

>
> I'd call it pci_enable_acs...in fact, the kdoc above tries something close to that ;-)
>

No problem, I can change the code to incorporate this once we have an agreement on other items.


Allen  
