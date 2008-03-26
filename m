Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbYCZU6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbYCZU6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYCZU6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:58:33 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:46032 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbYCZU6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:58:32 -0400
Date: Wed, 26 Mar 2008 23:58:28 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
Message-ID: <20080326205828.GA15225@jurassic.park.msu.ru>
References: <20080325201125.GD15330@elte.hu> <20080325202954.GA22007@elte.hu> <47E969E1.6080608@m3y3r.de> <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org> <20080326101450.GA9060@jurassic.park.msu.ru> <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com> <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org> <20080326203012.GB6249@us.ibm.com> <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 01:46:33PM -0700, Linus Torvalds wrote:
> Ahh, ok, so it was directly caused by simply not sizing and setting up the 
> bus resources properly.

Indeed.

This should prevent an oops in all cases.

Ivan.

---
PCI: improved sanity check for pdev_sort_resources()

Prevent potential oops with unsized PCI bridge resources.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 drivers/pci/setup-res.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 4be7ccf..fb57c8b 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -226,18 +226,17 @@ void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
 		if (r->flags & IORESOURCE_PCI_FIXED)
 			continue;
 
-		r_align = r->end - r->start;
-		
+		r_align = (i < PCI_BRIDGE_RESOURCES) ? r->end - r->start + 1 :
+						       r->start;
 		if (!(r->flags) || r->parent)
 			continue;
-		if (!r_align) {
+		if (r_align <= 1) {
 			printk(KERN_WARNING "PCI: Ignore bogus resource %d "
 				"[%llx:%llx] of %s\n",
 				i, (unsigned long long)r->start,
 				(unsigned long long)r->end, pci_name(dev));
 			continue;
 		}
-		r_align = (i < PCI_BRIDGE_RESOURCES) ? r_align + 1 : r->start;
 		for (list = head; ; list = list->next) {
 			resource_size_t align = 0;
 			struct resource_list *ln = list->next;
