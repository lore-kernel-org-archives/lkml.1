Return-Path: <linux-kernel-owner+w=401wt.eu-S1760139AbZEFWP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139AbZEFWP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761562AbZEFVzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:10 -0400
Received: from kroah.org ([198.145.64.141]:57392 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761512AbZEFVzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:55:02 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:02 2009
Message-Id: <20090506214802.112079645@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Woodhouse <David.Woodhouse@intel.com>
Subject: [patch 49/58] intel-iommu: Fix device-to-iommu mapping for PCI-PCI bridges.
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=intel-iommu-fix-device-to-iommu-mapping-for-pci-pci-bridges.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

(cherry picked from commit 924b6231edfaf1e764ffb4f97ea382bf4facff58)

When the DMAR table identifies that a PCI-PCI bridge belongs to a given
IOMMU, that means that the bridge and all devices behind it should be
associated with the IOMMU. Not just the bridge itself.

This fixes the device_to_iommu() function accordingly.

(It's broken if you have the same PCI bus numbers in multiple domains,
but this function was always broken in that way; I'll be dealing with
that later).

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -447,11 +447,16 @@ static struct intel_iommu *device_to_iom
 		if (drhd->ignored)
 			continue;
 
-		for (i = 0; i < drhd->devices_cnt; i++)
+		for (i = 0; i < drhd->devices_cnt; i++) {
 			if (drhd->devices[i] &&
 			    drhd->devices[i]->bus->number == bus &&
 			    drhd->devices[i]->devfn == devfn)
 				return drhd->iommu;
+			if (drhd->devices[i]->subordinate &&
+			    drhd->devices[i]->subordinate->number <= bus &&
+			    drhd->devices[i]->subordinate->subordinate >= bus)
+				return drhd->iommu;
+		}
 
 		if (drhd->include_all)
 			return drhd->iommu;


