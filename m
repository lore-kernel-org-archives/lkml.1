Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbYH3GM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbYH3GM6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 02:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbYH3GMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 02:12:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbYH3GMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 02:12:48 -0400
Date: Fri, 29 Aug 2008 23:11:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <86802c440808292222r21886f88n29804d14eabb4606@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808292253100.3290@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>  <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>  <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
  <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>  <86802c440808291830t4547140dx9b12353649edd975@mail.gmail.com>  <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0808291954410.3300@nehalem.linux-foundation.org>
  <86802c440808292007t3588edfnef95b723320ff023@mail.gmail.com>  <alpine.LFD.1.10.0808292017440.5010@nehalem.linux-foundation.org> <86802c440808292222r21886f88n29804d14eabb4606@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Yinghai Lu wrote:
> 
> please check
> 
>   __request_region: conflict: (reserved) [dd000000, efffffff], res:
> (qla2xxx) [ddffc000, ddffffff]
> busy flag
> qla2xxx 0000:83:00.0: BAR 1: can't reserve mem region [0xddffc000-0xddffffff]

Ok, this is actually when the driver wants to reserve the BAR, and then it 
norices that there is an existing "reservation" there.

So yes, drivers will care - they literally will think that somebody else 
owns their resource if they have a BUSY resource inside of them. So this 
is a driver protecting against another driver.

The sad part is that it looks like it's entirely due to the PCI code 
trying to emulate an ISA driver model, and use a flat resource space - so 
it hits the upper resources first.

Does this patch make a difference? It actually removes a fair chunk of 
code, by just saying "we really don't care if the resource is IO or MEM, 
we just want to reserve space inside of it, regardless of type".

Untested - obviously.

		Linus

---
 drivers/pci/pci.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index c9884bb..a3de4fe 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1304,15 +1304,11 @@ pci_get_interrupt_pin(struct pci_dev *dev, struct pci_dev **bridge)
 void pci_release_region(struct pci_dev *pdev, int bar)
 {
 	struct pci_devres *dr;
+	struct resource *res = pdev->resource + bar;
 
 	if (pci_resource_len(pdev, bar) == 0)
 		return;
-	if (pci_resource_flags(pdev, bar) & IORESOURCE_IO)
-		release_region(pci_resource_start(pdev, bar),
-				pci_resource_len(pdev, bar));
-	else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM)
-		release_mem_region(pci_resource_start(pdev, bar),
-				pci_resource_len(pdev, bar));
+	__release_region(res, pci_resource_start(pdev, bar), pci_resource_len(pdev, bar));
 
 	dr = find_pci_dr(pdev);
 	if (dr)
@@ -1336,20 +1332,16 @@ void pci_release_region(struct pci_dev *pdev, int bar)
 int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
 {
 	struct pci_devres *dr;
+	struct resource *res = pdev->resource + bar;
 
 	if (pci_resource_len(pdev, bar) == 0)
 		return 0;
-		
-	if (pci_resource_flags(pdev, bar) & IORESOURCE_IO) {
-		if (!request_region(pci_resource_start(pdev, bar),
-			    pci_resource_len(pdev, bar), res_name))
-			goto err_out;
-	}
-	else if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
-		if (!request_mem_region(pci_resource_start(pdev, bar),
-				        pci_resource_len(pdev, bar), res_name))
-			goto err_out;
-	}
+
+	if (!res->parent)
+		goto err_out;
+
+	if (!__request_region(res, pci_resource_start(pdev, bar), pci_resource_len(pdev, bar), res_name))
+		goto err_out;
 
 	dr = find_pci_dr(pdev);
 	if (dr)
