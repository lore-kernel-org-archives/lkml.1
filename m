Return-Path: <linux-kernel-owner+w=401wt.eu-S1765785AbXFRVPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765785AbXFRVPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762492AbXFRVPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:15:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:16968 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760951AbXFRVPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:15:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,436,1175497200"; 
   d="scan'208";a="240541001"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: PCI userland access non-mmap APIs, kernel access to legacy space
Date: Mon, 18 Jun 2007 14:14:24 -0700
User-Agent: KMail/1.9.6
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       Ian Romanick <idr@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>,
       Kyle McMartin <kyle@mcmartin.ca>
References: <1182133004.26853.229.camel@localhost.localdomain>
In-Reply-To: <1182133004.26853.229.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706181414.25647.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 17, 2007 7:16:44 Benjamin Herrenschmidt wrote:
> Hi folks !
>
> Before I start actually writing code, I want to do a quick brain dump
> here to see if there are any objections.
>
> So a problem we have is that on non-x86, we expect to be able to
> access PCI IO space via mmap'ing of sysfs based "resource" files.
>
> However, there are various PCI host bridges out there that don't make
> that a practical solution. So far, I have two cases on ppc of bridges
> that either use indirect access for the IO space or require specific
> HW workarounds on accesses that involve spinlocks (to properly deal
> with the non-posted aspect of IO transactions). In addition, Lennert
> tells me that similar issues exist on ARM.
>
> Thus, I would like to introduce an additional read/write interface to
> sysfs "resource" files (and then get Ian's libpciaccess use that when
> mmap is unavailable).
>
> In fact, it's funny in a way becauase the "legacy" files interface is
> already read/write based (exclusively even, mmap isn't supported) for
> legacy IOs.
>
> I beleive that doing so is better than trying to extend /dev/port to
> understand multiple domains, >64K IO space, etc... etc...., because
> you don't have to understand all the remapping tricks that the
> operating system might be doing behind the scene, just open the
> resource file (or the legacy file of that bus for legacy accesses)
> and read/write to it.
>
> Any objection ?

Sounds like a good idea.  Originally, the "legacy_io" file was 
implemented this way because I knew of machines that couldn't properly 
handle it as a mmappable interface.  But when I pinged people about the 
resource files, I didn't hear anything, so they were just done with 
mmap.

But adding read/write is fine with me.  In fact, having read/write hooks 
for the memory backed resource files is also nice, since it makes 
dealing with them on the command line a bit easier.

> Also, while at it, I would like to introduce a pair of in-kernel
> interfaces:

What's the other half of the pair?

> int pci_translate_legacy_resource(struct pci_bus *bus, struct
> resource *res);
>
> Which takes a resource containing an absolute legacy range on that
> bus (for example, an IO resource with the VGA port numbers, or a
> memory resource with the VGA text mode aperture). That resource is
> then "converted" for the given PCI bus. For x86, that function would
> boil down to "return 0;".
>
> The reason is that on multiple domains machines, it's actually not
> trivial to figure out where the legacy space of a given domain is
> mapped, if available at all. The above function is a way to solve
> that problem, allowing things like vgacon to work in multi-domains
> setup without half of the current arch specific hacks in there.
>
> That would be also allowed to fail (some platforms can't give access
> to legacy memory or legacy IOs at all).
>
> We could probably even implement the pci sysfs "legacy" interface on
> top of these as well, thus making it generic to all platforms.
>
> Any objection there too ?

Yeah, sounds like a good additional abstraction for that interface.  
Should make porting it to other arches easier (I talked with kyle about 
this last week, so maybe this'll give him motivation to do it for 
parisc).

Jesse
