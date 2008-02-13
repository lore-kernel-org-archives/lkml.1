Return-Path: <linux-kernel-owner+w=401wt.eu-S1764921AbYBMPSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764921AbYBMPSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbYBMPSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:18:05 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:62274 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYBMPSB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:18:01 -0500
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] drivers/base: export gpl (un)register_memory_notifier
Date: Wed, 13 Feb 2008 16:17:57 +0100
User-Agent: KMail/1.8.2
Cc: Dave Hansen <haveblue@us.ibm.com>, Thomas Klein <tklein@de.ibm.com>,
       "Themann, Jan-Bernd" <themann@de.ibm.com>,
       netdev <netdev@vger.kernel.org>, apw <apw@uk.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Klein <osstklei@de.ibm.com>,
       Christoph Raisch <RAISCH@de.ibm.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Greg KH <greg@kroah.com>
References: <200802111724.12416.ossthema@de.ibm.com> <1202748429.8276.21.camel@nimitz.home.sr71.net>
In-Reply-To: <1202748429.8276.21.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802131617.58646.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Monday 11 February 2008 17:47, Dave Hansen wrote:
> Also, just ripping down and completely re-doing the entire mass of cards
> every time a 16MB area of memory is added or removed seems like an
> awfully big sledgehammer to me.  I would *HATE* to see anybody else
> using this driver as an example to work off of?  Can't you just keep
> track of which areas the driver is actually *USING* and only worry about
> changing mappings if that intersects with an area having hotplug done on
> it?


to form a base for the eHEA memory add / remove concept discussion:

Explanation of the current eHEA memory add / remove concept:

Constraints imposed by HW / FW:
- eHEA has own MMU
- eHEA  Memory Regions (MRs) are used by the eHEA MMU  to translate virtual
  addresses to absolute addresses (like DMA mapped memory on a PCI bus)
- The number of MRs is limited (not enough to have one MR per packet)
- Registration of MRs is comparativley slow as done via slow firmware call
(H_CALL)
- MRs can have a maximum size of the memory available under linux
- MRs cover a contiguous virtual memory block (no holes)

Because of this there is just one big MR that covers entire kernel memory.
We also need a mapping table from kernel addresses to this
contiguous "virtual memory IO space" (here called ehea_bmap).

- When memory is added / removed to LPAR (and linux), the MR has to be updated.
  This can only be done by destroying and recreating the MR. There is no H_CALL
  to modify MR size. To find holes in the linux kernel memory layout we have to
  iterate over the memory sections for recreating a ehea_bmap
  (otherwise MR would be bigger then available memory causing the
  registration to fail)

- DLPAR userspace tools, kernel, driver, firmware and HMC are involved in that
  process on System p

Memory add: version without a external memory notifier call
- new memory used in a transfer_xmit will result in a "ehea_bmap
  translation miss", which triggers a rebuild and reregistration
  of the ehea_bmap based on the current kernel memory setup.
- advantage: the number of MR rebuilds is reduced significantly compared to
  a rebuild for each 16MB chunk of memory added.

Memory add: version with external notifier call:
- We still need a ehea_bmap (whatever structure it has)

Memory remove with notifier:
- We have to rebuild the ehea_bmap instantly to remove the pages that are
  no longer available. Without doing that, the firmware (pHYP) cannot remove
  that memory from the LPAR. As we don't know if or how many additional 
  sections are to be removed before the DLPAR user space tool tells the 
  firmware to remove the memory, we can't wait with the rebuild.


Our current understanding about the current Memory Hotplug System are
(please correct me
if I'm wrong):

- depends on sparse mem
- only whole memory sections are added / removed
- for each section a memory resource is registered


>From the driver side we need:
- some kind of memory notification mechanism.
  For memory add we can live without any external memory notification
  event. For memory remove we do need an external trigger (see explanation
  above).
- a way to iterate over all kernel pages and a way to detect holes in the
  kernel memory layout in order to build up our own ehea_bmap.


Memory notification trigger:
- These triggers exist, an exported "register_memory_notifier" /
  "unregister_memory_notifier" would work in this scheme

Functions to use while building ehea_bmap + MRs:
- Use either the functions that are used by the memory hotplug system as
  well, that means using the section defines + functions (section_nr_to_pfn,
  pfn_valid)
- Use currently other not exported functions in kernel/resource.c, like
  walk_memory_resource (where we would still need the maximum possible number
  of pages NR_MEM_SECTIONS)
- Maybe some kind of new interface?

What would you suggest?

Regards,
Jan-Bernd & Christoph
