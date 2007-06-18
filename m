Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbXFRCRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbXFRCRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 22:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbXFRCRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 22:17:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:36287 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbXFRCRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 22:17:06 -0400
Subject: PCI userland access non-mmap APIs, kernel access to legacy space
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       Ian Romanick <idr@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain
Date: Mon, 18 Jun 2007 12:16:44 +1000
Message-Id: <1182133004.26853.229.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks !

Before I start actually writing code, I want to do a quick brain dump
here to see if there are any objections.

So a problem we have is that on non-x86, we expect to be able to access
PCI IO space via mmap'ing of sysfs based "resource" files.

However, there are various PCI host bridges out there that don't make
that a practical solution. So far, I have two cases on ppc of bridges
that either use indirect access for the IO space or require specific HW
workarounds on accesses that involve spinlocks (to properly deal with
the non-posted aspect of IO transactions). In addition, Lennert tells me
that similar issues exist on ARM.

Thus, I would like to introduce an additional read/write interface to
sysfs "resource" files (and then get Ian's libpciaccess use that when
mmap is unavailable).

In fact, it's funny in a way becauase the "legacy" files interface is
already read/write based (exclusively even, mmap isn't supported) for
legacy IOs.

I beleive that doing so is better than trying to extend /dev/port to
understand multiple domains, >64K IO space, etc... etc...., because you
don't have to understand all the remapping tricks that the operating
system might be doing behind the scene, just open the resource file (or
the legacy file of that bus for legacy accesses) and read/write to it.

Any objection ?

Also, while at it, I would like to introduce a pair of in-kernel
interfaces:

int pci_translate_legacy_resource(struct pci_bus *bus, struct resource *res);

Which takes a resource containing an absolute legacy range on that bus
(for example, an IO resource with the VGA port numbers, or a memory
resource with the VGA text mode aperture). That resource is then
"converted" for the given PCI bus. For x86, that function would boil
down to "return 0;".

The reason is that on multiple domains machines, it's actually not
trivial to figure out where the legacy space of a given domain is
mapped, if available at all. The above function is a way to solve that
problem, allowing things like vgacon to work in multi-domains setup
without half of the current arch specific hacks in there.

That would be also allowed to fail (some platforms can't give access to
legacy memory or legacy IOs at all).

We could probably even implement the pci sysfs "legacy" interface on top
of these as well, thus making it generic to all platforms.

Any objection there too ?

Cheers,
Ben.


