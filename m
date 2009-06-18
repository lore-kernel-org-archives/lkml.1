Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbZFRAjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbZFRAjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 20:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZFRAj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 20:39:29 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:42168 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbZFRAj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 20:39:28 -0400
Date: Wed, 17 Jun 2009 18:38:08 -0600
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Matthew Wilcox <matthew@wil.cx>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       a.beregalov@gmail.com
Subject: Re: linux-next: Tree for June 17 (pci/slot)
Message-ID: <20090618003808.GA29472@ldl.fc.hp.com>
References: <20090617155354.075c60ae.sfr@canb.auug.org.au> <4A39194B.2060200@oracle.com> <20090617163604.GT19977@parisc-linux.org> <20090617102901.6e39aac2@jbarnes-g45> <4A392B48.7060206@oracle.com> <20090617161001.734321be@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617161001.734321be@jbarnes-g45>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesse Barnes <jbarnes@virtuousgeek.org>:
> On Wed, 17 Jun 2009 10:43:36 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > Jesse Barnes wrote:
> > > On Wed, 17 Jun 2009 10:36:04 -0600
> > > Matthew Wilcox <matthew@wil.cx> wrote:
> > > 
> > >> On Wed, Jun 17, 2009 at 09:26:51AM -0700, Randy Dunlap wrote:
> > >>> Stephen Rothwell wrote:
> > >>>> Hi all,
> > >>>>
> > >>>> Changes since 20090616:
> > >>>
> > >>> When CONFIG_SYSFS=n:
> > >>>
> > >>> drivers/pci/slot.c:327: error: 'module_kset' undeclared (first use
> > >>> in this function)
> > >> Is there any point to pci_slot existing without CONFIG_SYSFS?
> > >> I don't see how you can interact with it in any meaningful way.
> > >> Perhaps CONFIG_PCI_SLOT should depend on CONFIG_SYSFS?
> > > 
> > > I've got a code fix queued up, but maybe a Kconfig dependency is the
> > > way to go...
> > 
> > What is the code fix like?
> > The Kconfig fix makes sense to me.
> > 
> > 
> Here's the patch I have (sorry cut & paste):
> 
> Fix this build error when CONFIG_SYSFS is not set:
> drivers/pci/slot.c: In function 'pci_hp_create_module_link':
> drivers/pci/slot.c:327: error: 'module_kset' undeclared
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

I agree with Matthew. You can't do anything useful with the
functionality in drivers/pci/slot.o unless you have sysfs, so a
Kconfig dependency is more appropriate.

From: Alex Chiang <achiang@hp.com>

PCI: drivers/pci/slot.c should depend on CONFIG_SYSFS

There is no way to interact with a physical PCI slot without
sysfs, so encode the dependency and prevent this build error:

	drivers/pci/slot.c: In function 'pci_hp_create_module_link':
	drivers/pci/slot.c:327: error: 'module_kset' undeclared

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fix-suggested-by: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index ba6af16..ed32f67 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -2,10 +2,11 @@
 # Makefile for the PCI bus specific drivers.
 #
 
-obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o slot.o \
+obj-y		+= access.o bus.o probe.o remove.o pci.o quirks.o \
 			pci-driver.o search.o pci-sysfs.o rom.o setup-res.o \
 			irq.o
 obj-$(CONFIG_PROC_FS) += proc.o
+obj-$(CONFIG_SYSFS) += slot.o
 
 # Build PCI Express stuff if needed
 obj-$(CONFIG_PCIEPORTBUS) += pcie/
