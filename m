Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbYI2P6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbYI2P6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYI2P6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:58:06 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:27586 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYI2P6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:58:05 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts in quirk_system_pci_resources()
Date: Mon, 29 Sep 2008 09:57:58 -0600
User-Agent: KMail/1.9.9
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Rene Herman <rene.herman@keyaccess.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Adam Belay <abelay@mit.edu>, Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>
References: <200809290953.56565.bjorn.helgaas@hp.com>
In-Reply-To: <200809290953.56565.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809290957.59813.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

quirk_system_pci_resources() checks PNP motherboard resource for
conflicts with PCI device BARs.  When doing this, we should ignore
disabled PCI BARs, because they often contain zero and look like
they would conflict with legacy devices at low addresses.
    
This patch addresses this regression from 2.6.26:
    http://bugzilla.kernel.org/show_bug.cgi?id=11550
    
Thanks to Frans Pop for reporting this issue and testing the fixes.
    
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Tested-by: Frans Pop <elendil@planet.nl>

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 0bdf9b8..ef5ed99 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -247,6 +247,9 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
 			unsigned int type;
 
+			if (!pci_resource_enabled(pdev, i))
+				continue;
+
 			type = pci_resource_flags(pdev, i) &
 					(IORESOURCE_IO | IORESOURCE_MEM);
 			if (!type || pci_resource_len(pdev, i) == 0)
