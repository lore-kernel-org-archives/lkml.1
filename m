Return-Path: <linux-kernel-owner+w=401wt.eu-S1765552AbXIMTwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765552AbXIMTwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbXIMTwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:52:42 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:55222 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755189AbXIMTwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:52:41 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Thu, 13 Sep 2007 21:52:03 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: "Andi Kleen" <ak@suse.de>
cc: "Greg KH" <greg@kroah.com>, "Yinghai Lu" <Yinghai.Lu@sun.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Martin Mares" <mj@ucw.cz>,
       "dean gaudet" <dean@arctic.org>,
       "Robert Richter" <robert.richter@amd.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: set cfg_size for AMD Family 10h in case
 MMCONFIG is used
Message-ID: <20070913195203.GA1131@alberich.amd.com>
References: <200709121921.43950.yinghai.lu@sun.com>
 <200709131147.43446.ak@suse.de> <20070913104704.GA3878@kroah.com>
 <200709131353.15752.ak@suse.de>
MIME-Version: 1.0
In-Reply-To: <200709131353.15752.ak@suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 13 Sep 2007 19:52:07.0203 (UTC)
 FILETIME=[908F4730:01C7F63F]
X-WSS-ID: 6AF74B7F0X87459291-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 01:53:15PM +0200, Andi Kleen wrote:
> On Thursday 13 September 2007 12:47, Greg KH wrote:
> > On Thu, Sep 13, 2007 at 11:47:42AM +0200, Andi Kleen wrote:
> > > On Thursday 13 September 2007 04:21, Yinghai Lu wrote:
> > > > [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG is
> > > > used.
> > > >
> > > > reuse pci_cfg_space_size but skip check pci express and pci-x CAP ID.
> > >
> > > I just rejected a similar patch -- this should be done using MMCONFIG
> >
> > But what about for broken machines without the proper MMCONFIG entries?
> > They still need a way to get access to this config space,
> 
> If there are any devices that need it. IBS and PCI-E error handling 
> do, but they're quite obscure.
> 
> Also so far we don't know of any Fam 10h systems without MMCONFIG
> entries. Fam10h requires a new BIOS so it's reasonable to assume
> that the new BIOSes will do better.

IMHO support for all config space access methods should be added to the kernel.
And it should be added at a central point. Not waiting for drivers to do it
their own way if they need to use it.

The more complicated/important question is how to decide which access method
should be used for a device. (Something similar to the pci_mmcfg_fallback_slots
stuff that exists already for K8 NB.)
But that needs some more thinking.

Here a summary wrt family 10h extended config space access methods.
(Most of this stuff I verified with some patched kernels. I didn't
eavesdropping on the physical links though ...)

For family 10h we have 3 methods
(1) "legacy" MMCONFIG access (via south bridge)
(2) mmconfig access via CPU/NB (new with fam10h, using the new MMIO
    config base MSR)
(3) CF8/CFC ECS access (new with fam10h, has to be enabled in the NB_CFG MSR)

- If (1) is used  and (2)+(3) are not configurred there is no way to access
  NB config space with mmconfig accesses. Which implies that NB ECS cannot
  be accessed.
  So you can only access NB standard config space via "legacy" CF8/CFC.
  This equals what we have with K8.
  => ECS is accessible just for external devices (not the NB ECS).

- If (2) is used, mmconfig accesses are translated by CPU/NB. So this will
  result in (extended) config cycles on the link to the south bridge.
  This works for both NB config space and config space for normal PCI(e) devices.
  => ECS is accessible for all devices via that method.

- And finally with (3) you can also access both NB config space and the config
  space of external devices. The CPU/NB does the translation and will also
  create (extended) config cycles here.
  => ECS is accessible for all devices via that method.
  (But of course not in the same "atomic" manner like with mmconfig.)

Then we have different prereqs for those methods:
- For (1) the ACPI stuff is required.
- For (2) and (3) some MSRs have to be set up.

Ah, yes in case I didn't mention that: ;-)
Using (2) you haven't such a strict dependency on that ACPI stuff.
Would be cool to disable MCFG at all and configure mmconfig just in
the CPU, no?


Regards,

Andreas

-- 
Operating | AMD Saxony Limited Liability Company & Co. KG,
  System  | Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 Research | Register Court Dresden: HRA 4896, General Partner authorized
  Center  | to represent: AMD Saxony LLC (Wilmington, Delaware, US)
  (OSRC)  | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy



