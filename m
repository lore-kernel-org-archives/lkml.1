Return-Path: <linux-kernel-owner+w=401wt.eu-S936252AbZLQEHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936252AbZLQEHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936233AbZLQEGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:06:00 -0500
Received: from kroah.org ([198.145.64.141]:52305 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936217AbZLQEF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:58 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:02 2009
Message-Id: <20091217035702.052247918@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [147/151] intel-iommu: Fix oops with intel_iommu=igfx_off
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Woodhouse <David.Woodhouse@intel.com>

commit 44cd613c0e4cd93079ea2a93aa06649d8ca0830a upstream.

The hotplug notifier will call find_domain() to see if the device in
question has been assigned an IOMMU domain. However, this should never
be called for devices with a "dummy" domain, such as graphics devices
when intel_iommu=igfx_off is set and the corresponding IOMMU isn't even
initialised. If you do that, it'll oops as it dereferences the (-1)
pointer.

The notifier function should check iommu_no_mapping() for the
device before doing anything else.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3238,6 +3238,9 @@ static int device_notifier(struct notifi
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct dmar_domain *domain;
 
+	if (iommu_no_mapping(dev))
+		return 0;
+
 	domain = find_domain(pdev);
 	if (!domain)
 		return 0;


