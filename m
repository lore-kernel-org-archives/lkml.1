Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbYHZPXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbYHZPXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 11:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYHZPXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 11:23:39 -0400
Received: from ns2.suse.de ([195.135.220.15]:56949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbYHZPXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 11:23:39 -0400
Date: Tue, 26 Aug 2008 08:20:34 -0700
From: Greg KH <gregkh@suse.de>
To: Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [2.6.27-rc4-git4] compilation warnings
Message-ID: <20080826152034.GA6593@suse.de>
References: <48B3CEEA.90400@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48B3CEEA.90400@numericable.fr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 11:37:46AM +0200, Rufus & Azrael wrote:
> Hello all,
>
> Fresh 2.6.27-rc4-git4 causes these compilation warnings on my amd64 box 
> with gcc-4.3.1 :
>
> drivers/pci/search.c: In function ‘pci_get_dev_by_id’:
> drivers/pci/search.c:284: attention : passing argument 1 of 
> ‘pci_dev_put’ discards qualifiers from pointer target type
>
> following this commit : ebca4f1bce1eb7b91a63c515db66316db9391221 PCI: fix 
> reference leak in pci_get_dev_by_id()

Ick, sorry about that, I said my fix was not even build tested :)

Here's a fix for this, Jesse, care to forward this on?

thanks,

greg k-h

--------------

From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: PCI: fix compiler warnings in pci_get_subsys()

From: Greg Kroah-Hartman <gregkh@suse.de>

pci_get_subsys() changed in 2.6.26 so that the from pointer is modified when
the call is being invoked, so fix up the 'const' marking of it that the
compiler is complaining about.

Reported-by: Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/search.c |    6 +++---
 include/linux/pci.h  |    8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -162,7 +162,7 @@ EXPORT_SYMBOL(pci_find_slot);
  * time.
  */
 struct pci_dev *pci_find_device(unsigned int vendor, unsigned int device,
-				const struct pci_dev *from)
+				struct pci_dev *from)
 {
 	struct pci_dev *pdev;
 
@@ -263,7 +263,7 @@ static int match_pci_dev_by_id(struct de
  * this file.
  */
 static struct pci_dev *pci_get_dev_by_id(const struct pci_device_id *id,
-					 const struct pci_dev *from)
+					 struct pci_dev *from)
 {
 	struct device *dev;
 	struct device *dev_start = NULL;
@@ -303,7 +303,7 @@ static struct pci_dev *pci_get_dev_by_id
  */
 struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
 			       unsigned int ss_vendor, unsigned int ss_device,
-			       const struct pci_dev *from)
+			       struct pci_dev *from)
 {
 	struct pci_dev *pdev;
 	struct pci_device_id *id;
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -534,7 +534,7 @@ extern void pci_sort_breadthfirst(void);
 #ifdef CONFIG_PCI_LEGACY
 struct pci_dev __deprecated *pci_find_device(unsigned int vendor,
 					     unsigned int device,
-					     const struct pci_dev *from);
+					     struct pci_dev *from);
 struct pci_dev __deprecated *pci_find_slot(unsigned int bus,
 					   unsigned int devfn);
 #endif /* CONFIG_PCI_LEGACY */
@@ -550,7 +550,7 @@ struct pci_dev *pci_get_device(unsigned 
 				struct pci_dev *from);
 struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
 				unsigned int ss_vendor, unsigned int ss_device,
-				const struct pci_dev *from);
+				struct pci_dev *from);
 struct pci_dev *pci_get_slot(struct pci_bus *bus, unsigned int devfn);
 struct pci_dev *pci_get_bus_and_slot(unsigned int bus, unsigned int devfn);
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);
@@ -816,7 +816,7 @@ _PCI_NOP_ALL(write,)
 
 static inline struct pci_dev *pci_find_device(unsigned int vendor,
 					      unsigned int device,
-					      const struct pci_dev *from)
+					      struct pci_dev *from)
 {
 	return NULL;
 }
@@ -838,7 +838,7 @@ static inline struct pci_dev *pci_get_su
 					     unsigned int device,
 					     unsigned int ss_vendor,
 					     unsigned int ss_device,
-					     const struct pci_dev *from)
+					     struct pci_dev *from)
 {
 	return NULL;
 }
