Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbZBRWfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbZBRWfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbZBRWbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:31:55 -0500
Received: from kroah.org ([198.145.64.141]:34709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757803AbZBRWby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:31:54 -0500
Date: Wed, 18 Feb 2009 14:29:01 -0800
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
Subject: [patch 03/36] Fix Intel IOMMU write-buffer flushing
Message-ID: <20090218222901.GD10668@kroah.com>
References: <20090218222447.432108614@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-intel-iommu-write-buffer-flushing.patch"
In-Reply-To: <20090218222841.GA10668@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit ca77fde8e62cecb2c0769052228d15b901367af8 upstream.

This is the cause of the DMA faults and disk corruption that people have
been seeing. Some chipsets neglect to report the RWBF "capability" --
the flag which says that we need to flush the chipset write-buffer when
changing the DMA page tables, to ensure that the change is visible to
the IOMMU.

Override that bit on the affected chipsets, and everything is happy
again.

Thanks to Chris and Bhavesh and others for helping to debug.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Tested-by: Chris Wright <chrisw@sous-sol.org>
Reviewed-by: Bhavesh Davda <bhavesh@vmware.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -527,7 +527,7 @@ static void iommu_flush_write_buffer(str
 	u32 val;
 	unsigned long flag;
 
-	if (!cap_rwbf(iommu->cap))
+	if (!rwbf_quirk && !cap_rwbf(iommu->cap))
 		return;
 	val = iommu->gcmd | DMA_GCMD_WBF;
 
@@ -1410,6 +1410,8 @@ static void domain_remove_dev_info(struc
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 }
 
+static int rwbf_quirk = 0;
+
 /*
  * find_domain
  * Note: we use struct pci_dev->dev.archdata.iommu stores the info
@@ -2453,3 +2455,12 @@ int __init intel_iommu_init(void)
 	return 0;
 }
 
+static void __devinit quirk_iommu_rwbf(struct pci_dev *dev)
+{
+	/* Mobile 4 Series Chipset neglects to set RWBF capability,
+	   but needs it */
+	printk(KERN_INFO "DMAR: Forcing write-buffer flush capability\n");
+	rwbf_quirk = 1;
+}
+
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x2a40, quirk_iommu_rwbf);

