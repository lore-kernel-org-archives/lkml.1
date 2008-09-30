Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYI3JPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYI3JPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 05:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYI3JPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 05:15:07 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:41083 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYI3JPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 05:15:06 -0400
Message-ID: <48E1EF0E.8030006@keyaccess.nl>
Date: Tue, 30 Sep 2008 11:19:10 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Adam Belay <abelay@mit.edu>,
       Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts
 in quirk_system_pci_resources()
References: <200809290953.56565.bjorn.helgaas@hp.com> <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org> <48E11EFA.8010402@keyaccess.nl> <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------010409050903000604050405"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010409050903000604050405
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 29-09-08 21:13, Linus Torvalds wrote:
> 
> On Mon, 29 Sep 2008, Rene Herman wrote:
>> I believe the possible issue is that resources that do _not_ (seem to) start
>> at zero might also be disabled.
> 
> But that is irrelevant.
> 
> If we have registered them in the resource tree, then PnP must ignore 
> them.
> 
> The fact is, this is not about being enabled or disabled. This is about 
> the PnP tree containing resources that we already parsed from the PCI 
> stuff, and once we've seen them as PCI resources, there's not really 
> anything valuable in the PnP information.

Well, if you say so...

Just did the attached which might match that intention. Please do not 
consider this a submission as I've no idea if this is sensible nor if it 
actually helps Frans. Just for discussion. Anything here should arrive 
through Bjorn.

Rene.

--------------010409050903000604050405
Content-Type: text/plain;
 name="quirk_system_pci_resources.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="quirk_system_pci_resources.diff"

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 0bdf9b8..0824eed 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -230,7 +230,8 @@ static void quirk_ad1815_mpu_resources(struct pnp_dev *dev)
 static void quirk_system_pci_resources(struct pnp_dev *dev)
 {
 	struct pci_dev *pdev = NULL;
-	struct resource *res;
+	struct resource *pci_res;
+	struct resource *pnp_res;
 	resource_size_t pnp_start, pnp_end, pci_start, pci_end;
 	int i, j;
 
@@ -247,20 +248,29 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
 			unsigned int type;
 
-			type = pci_resource_flags(pdev, i) &
-					(IORESOURCE_IO | IORESOURCE_MEM);
-			if (!type || pci_resource_len(pdev, i) == 0)
+			pci_res = &pdev->resource[i];
+
+			/* have we been registered already? */
+			if (pci_res->parent)
+				continue;
+
+			pci_start = pci_res->start;
+			pci_end = pci_res->end;
+
+			if (pci_end < pci_start || !pci_end)
+				continue;
+
+			type = pci_res->flags & (IORESOURCE_IO | IORESOURCE_MEM);
+			if (!type)
 				continue;
 
-			pci_start = pci_resource_start(pdev, i);
-			pci_end = pci_resource_end(pdev, i);
 			for (j = 0;
-			     (res = pnp_get_resource(dev, type, j)); j++) {
-				if (res->start == 0 && res->end == 0)
-					continue;
+			     (pnp_res = pnp_get_resource(dev, type, j)); j++) {
+				pnp_start = pnp_res->start;
+				pnp_end = pnp_res->end;
 
-				pnp_start = res->start;
-				pnp_end = res->end;
+				if (pnp_end < pnp_start || !pnp_end)
+					continue;
 
 				/*
 				 * If the PNP region doesn't overlap the PCI
@@ -288,13 +298,13 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 				dev_warn(&dev->dev, "%s resource "
 					"(0x%llx-0x%llx) overlaps %s BAR %d "
 					"(0x%llx-0x%llx), disabling\n",
-					pnp_resource_type_name(res),
+					pnp_resource_type_name(pnp_res),
 					(unsigned long long) pnp_start,
 					(unsigned long long) pnp_end,
 					pci_name(pdev), i,
 					(unsigned long long) pci_start,
 					(unsigned long long) pci_end);
-				res->flags |= IORESOURCE_DISABLED;
+				pnp_res->flags |= IORESOURCE_DISABLED;
 			}
 		}
 	}

--------------010409050903000604050405--
