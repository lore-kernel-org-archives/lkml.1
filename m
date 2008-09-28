Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbYI1Qch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbYI1Qch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 12:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbYI1Qc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 12:32:29 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42795 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbYI1Qc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 12:32:28 -0400
Date: Sun, 28 Sep 2008 10:32:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-pci@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Fixing drivers/pci/search.c compilation warning.
Message-ID: <20080928163211.GR27204@parisc-linux.org>
References: <b9df5fa10809280816u23ef3021k7eee287a237b72ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10809280816u23ef3021k7eee287a237b72ae@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 09:16:45PM +0600, Rakib Mullick wrote:
> drivers/pci/search.c: In function `pci_get_dev_by_id':
> drivers/pci/search.c:284: warning: passing arg 1 of `pci_dev_put'
> discards qualifiers from pointer target type
> 
> The following patch removes the above compilation warning.
> Thanks.

Yes, but this compilation warning is pointing to a real problem.
We've told the compiler that the pci_dev is const (ie we won't modify
it), but pci_dev_put() is most assuredly going to modify and potentially
can even free the struct pci_dev.

In looking at this, I found another bug in the pci_find_device()
rewrite.  pci_get_subsys() will put the reference to 'from' (if
non-NULL), but the reference was already put by pci_find_device(),
so I suspect the reference count ends up going zero very quickly.
We can fix this by calling pci_dev_get() before calling
pci_get_subsys(), but then we also have to drop the const from
pci_find_device()'s argument.

Jesse, how does this patch look?  I think it's worth including in -rc
since it fixes a refcounting bug (admittedly one only triggered by
drivers using the deprecated pci_find_device() interface).

---

Subject: [PCI] Fix reference counting bug

pci_get_subsys() will decrement the reference count of the device that
it starts searching from.  Unfortunately, the pci_find_device() interface 
will already have decremented the reference count of the device earlier,
so the device will end up losing all reference counts and be freed.

We can fix this by incrementing the reference count of the device to
start searching from before calling pci_get_subsys().  Unfortunately,
this means we have to lose the 'const' on the arguments of several
functions.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 3b3b5f1..5af8bd5 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -162,10 +162,11 @@ EXPORT_SYMBOL(pci_find_slot);
  * time.
  */
 struct pci_dev *pci_find_device(unsigned int vendor, unsigned int device,
-				const struct pci_dev *from)
+				struct pci_dev *from)
 {
 	struct pci_dev *pdev;
 
+	pci_dev_get(from);
 	pdev = pci_get_subsys(vendor, device, PCI_ANY_ID, PCI_ANY_ID, from);
 	pci_dev_put(pdev);
 	return pdev;
@@ -263,19 +264,15 @@ static int match_pci_dev_by_id(struct device *dev, void *data)
  * this file.
  */
 static struct pci_dev *pci_get_dev_by_id(const struct pci_device_id *id,
-					 const struct pci_dev *from)
+					 struct pci_dev *from)
 {
 	struct device *dev;
 	struct device *dev_start = NULL;
 	struct pci_dev *pdev = NULL;
 
 	WARN_ON(in_interrupt());
-	if (from) {
-		/* FIXME
-		 * take the cast off, when bus_find_device is made const.
-		 */
-		dev_start = (struct device *)&from->dev;
-	}
+	if (from)
+		dev_start = &from->dev;
 	dev = bus_find_device(&pci_bus_type, dev_start, (void *)id,
 			      match_pci_dev_by_id);
 	if (dev)
@@ -303,7 +300,7 @@ static struct pci_dev *pci_get_dev_by_id(const struct pci_device_id *id,
  */
 struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
 			       unsigned int ss_vendor, unsigned int ss_device,
-			       const struct pci_dev *from)
+			       struct pci_dev *from)
 {
 	struct pci_dev *pdev;
 	struct pci_device_id *id;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a27293a..b8a04c4 100644
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
@@ -550,7 +550,7 @@ struct pci_dev *pci_get_device(unsigned int vendor, unsigned int device,
 				struct pci_dev *from);
 struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
 				unsigned int ss_vendor, unsigned int ss_device,
-				const struct pci_dev *from);
+				struct pci_dev *from);
 struct pci_dev *pci_get_slot(struct pci_bus *bus, unsigned int devfn);
 struct pci_dev *pci_get_bus_and_slot(unsigned int bus, unsigned int devfn);
 struct pci_dev *pci_get_class(unsigned int class, struct pci_dev *from);



-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
