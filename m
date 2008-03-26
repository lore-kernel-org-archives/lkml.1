Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbYCZVoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbYCZVoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbYCZVoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:44:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755655AbYCZVoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:44:02 -0400
Date: Wed, 26 Mar 2008 14:41:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
cc: Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
In-Reply-To: <20080326205828.GA15225@jurassic.park.msu.ru>
Message-ID: <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org>
References: <20080325201125.GD15330@elte.hu> <20080325202954.GA22007@elte.hu> <47E969E1.6080608@m3y3r.de> <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org> <20080326101450.GA9060@jurassic.park.msu.ru> <20080326135458.GA27621@elte.hu>
 <20080326180701.GA6249@us.ibm.com> <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org> <20080326203012.GB6249@us.ibm.com> <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org> <20080326205828.GA15225@jurassic.park.msu.ru>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 26 Mar 2008, Ivan Kokshaysky wrote:
>
> PCI: improved sanity check for pdev_sort_resources()
...
> -		if (!r_align) {
> +		if (r_align <= 1) {

Hmm. This makes the code look totally nonsensical.

It seems to come from the fact that we had a very odd way to check bogus 
resources (namely "start == end"), but your code makes it _really_ hard to 
see what is going on.

In fact, I think the old code was buggy too, because we actually *do* have 
single-byte resources where start == end, as showb by google:

	PCI: Ignore bogus resource 1 [3f6:3f6] of Symphony Labs SL82c105
	PCI: Ignore bogus resource 3 [376:376] of Symphony Labs SL82c105

where that resource actually looks valid, and should have a single byte 
alignment! Admittedly I think it was created with a quirk (can you get 
that kind of resource from actually _probing_ a PCI device?) but I do 
think that a single-byte resource is valid.

So I wonder if we shouldn't just make this a bit more readable and also a 
bit more explicit with something like the appended..

NOTE! This will also consider a bridge resource at 0 to be an invalid 
resource (since now the alignment will be zero), which is a bit odd and 
makes me worry a bit. I wouldn't be surprised if some non-PC architectures 
have PCI bridges at zero. But maybe they should be (or already are?) 
marked IORESOURCE_PCI_FIXED?

Ben - the obvious "odd PCI bus resources" architecture would be POWER. Any 
commentary?

		Linus

---
 drivers/pci/setup-res.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 4be7ccf..048ed77 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -211,6 +211,20 @@ int pci_assign_resource_fixed(struct pci_dev *dev, int resno)
 EXPORT_SYMBOL_GPL(pci_assign_resource_fixed);
 #endif
 
+static inline resource_size_t get_resource_alignment(int resno, struct resource *r)
+{
+	resource_size_t start = r->start, end = r->end;
+	resource_size_t alignment = 0;
+
+	/* End == start == 0 - invalid resource */
+	if (end && start <= end) {
+		alignment = end - start - 1;
+		if (resno >= PCI_BRIDGE_RESOURCES)
+			alignment = start;
+	}
+	return alignment;
+}
+
 /* Sort resources by alignment */
 void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 {
@@ -226,10 +240,10 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 		if (r->flags & IORESOURCE_PCI_FIXED)
 			continue;
 
-		r_align = r->end - r->start;
-		
-		if (!(r->flags) || r->parent)
+		if (!r->flags || r->parent)
 			continue;
+
+		r_align = get_resource_alignment(i, r);
 		if (!r_align) {
 			printk(KERN_WARNING "PCI: Ignore bogus resource %d "
 				"[%llx:%llx] of %s\n",
@@ -237,7 +251,6 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 				(unsigned long long)r->end, pci_name(dev));
 			continue;
 		}
-		r_align = (i < PCI_BRIDGE_RESOURCES) ? r_align + 1 : r->start;
 		for (list = head; ; list = list->next) {
 			resource_size_t align = 0;
 			struct resource_list *ln = list->next;
