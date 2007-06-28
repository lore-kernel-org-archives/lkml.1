Return-Path: <linux-kernel-owner+w=401wt.eu-S932475AbXF1XYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbXF1XYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 19:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764592AbXF1XYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 19:24:40 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:50524 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763473AbXF1XYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 19:24:39 -0400
Date: Thu, 28 Jun 2007 16:25:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, akpm <akpm@linux-foundation.org>
Subject: [PATCH] pci.h stubs (for EDD build error)
Message-Id: <20070628162554.81e3d09d.randy.dunlap@oracle.com>
In-Reply-To: <20070627024505.GA30197@humbolt.us.dell.com>
References: <20070626132622.3226261a.randy.dunlap@oracle.com>
	<20070627024505.GA30197@humbolt.us.dell.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2007 21:45:05 -0500 Matt Domsch wrote:

> On Tue, Jun 26, 2007 at 01:26:22PM -0700, Randy Dunlap wrote:
> > Hi,
> > 
> > CONFIG_EDD does not depend on PCI, but edd.c uses pci_* interface
> > functions, resulting in:
> > 
> >   CC [M]  drivers/firmware/edd.o
> > drivers/firmware/edd.c: In function 'edd_get_pci_dev':
> > drivers/firmware/edd.c:672: warning: implicit declaration of function 'pci_get_bus_and_slot'
> > drivers/firmware/edd.c:673: warning: return makes pointer from integer without a cast
> > ...
> > ERROR: "pci_get_bus_and_slot" [drivers/firmware/edd.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> > 
> > 
> > Should EDD depend on PCI or should some parts of edd.c be stubbed?
> 
> Good catch, thanks.
> 
> It should be stubbed, in include/linux/pci.h where all the other PCI
> functions are stubbed for the !CONFIG_PCI case.
> 
> There are several functions in include/linux/pci.h that have been
> added in the CONFIG_PCI case, but not stubbed in !CONFIG_PCI.
> pci_get_bus_and_slot() is just one of those.  That list appears to
> include:
> 
> struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
> struct pci_dev *pci_get_slot (struct pci_bus *bus, unsigned int devfn);
> struct pci_dev *pci_get_bus_and_slot (unsigned int bus, unsigned int devfn);

Did those -- patch is below.

Get clean build of drivers/firmware/edd.c with this patch
even when CONFIG_PCI=n.


> Perhaps arguably, functions that take a struct pci_dev * as an
> argument need not be stubbed, as they shouldn't be called with a null
> pointer argument in the first place.  These include:
> 
> int pci_find_ht_capability (struct pci_dev *dev, int ht_cap);
> int pci_find_next_ht_capability (struct pci_dev *dev, int pos, int ht_cap);
> static inline int pci_is_managed(struct pci_dev *pdev)
> 
> 
> I'm out of the office this week and next, but will add to my (growing)
> list of cleanups to do when I'm back and more online, unless you or
> someone wants to get to it first. :-)



From: Randy Dunlap <randy.dunlap@oracle.com>

Provide stubs for more PCI bus/slot functions when CONFIG_PCI=n.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/pci.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- linux-2622-rc6.orig/include/linux/pci.h
+++ linux-2622-rc6/include/linux/pci.h
@@ -748,6 +748,17 @@ static inline void pci_release_regions(s
 static inline void pci_block_user_cfg_access(struct pci_dev *dev) { }
 static inline void pci_unblock_user_cfg_access(struct pci_dev *dev) { }
 
+static inline struct pci_bus *pci_find_next_bus(const struct pci_bus *from)
+{ return NULL; }
+
+static inline struct pci_dev *pci_get_slot(struct pci_bus *bus,
+						unsigned int devfn)
+{ return NULL; }
+
+static inline struct pci_dev *pci_get_bus_and_slot(unsigned int bus,
+						unsigned int devfn)
+{ return NULL; }
+
 #endif /* CONFIG_PCI */
 
 /* Include architecture-dependent settings and functions */
