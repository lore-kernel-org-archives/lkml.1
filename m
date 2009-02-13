Return-Path: <linux-kernel-owner+w=401wt.eu-S1752085AbZBMF1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbZBMF1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 00:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbZBMF1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 00:27:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:13499 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbZBMF1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 00:27:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,200,1233561600"; 
   d="scan'208";a="386486108"
Message-ID: <499504A6.3050107@intel.com>
Date: Fri, 13 Feb 2009 13:27:02 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/6] ATS capability support for Intel IOMMU
References: <1234443038-15437-1-git-send-email-yu.zhao@intel.com> <20090213034457.GM3624@parisc-linux.org>
In-Reply-To: <20090213034457.GM3624@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Feb 12, 2009 at 08:50:32PM +0800, Yu Zhao wrote:
>>   2, avoid using pci_find_ext_capability every time when reading ATS
>>      Invalidate Queue Depth (Matthew Wilcox)
> 
> er ... I didn't say it was a problem.  I said I couldn't tell if it was a
> problem.  There's no point in taking up an extra 4 bytes per pci_dev if
> it's not a performance problem.  How often do we query the queue depth?
> Is this something a device driver will call once per device and then
> remember for itself, or only use at setup?  Or is it something we call
> every millisecond?
> 

The query function is called only once per device in v2 patch series. The
queue depth is cached in a VT-d private data structure, and it's used when
device driver calls pci_unmap_single or pci_unmap_sg. My concern was that
packing everything into `pci_dev' would make it grows very fast. 

For v3, the queue depth is removed from the VT-d `device_domain_info'.
Instead, it's cached in `pci_dev', and the query function is called every
time when the queue depth is needed. It would be easier to write the
IOMMU-specific ATS code for AMD, IBM and other vendors' IOMMUs, if they
have same requirement as Intel's (needs to query the queue depth every
time when invalidating the IOMMU TLB cache inside the device). So it looks
having the queue depth in `pci_dev' is reasonable, but I'm not sure.

Following is the logics I used in v2.

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 261b6bd..a7ff7cb 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -240,6 +241,8 @@ struct device_domain_info {
 	struct list_head global; /* link to global list */
 	u8 bus;			/* PCI bus numer */
 	u8 devfn;		/* PCI devfn number */
+	int qdep;		/* invalidate queue depth */
+	struct intel_iommu *iommu; /* IOMMU used by this device */
 	struct pci_dev *dev; /* it's NULL for PCIE-to-PCI bridge */
 	struct dmar_domain *domain; /* pointer to domain */
 };

<snipped>

+	info->iommu = iommu;
+	info->qdep = pci_ats_qdep(info->dev);
+	if (!info->qdep)
+		return NULL;

<snipped>

+	list_for_each_entry(info, &domain->devices, link) {
+		if (!info->dev || !pci_ats_enabled(info->dev))
+			continue;
+
+		sid = info->bus << 8 | info->devfn;
+		rc = qi_flush_dev_iotlb(info->iommu, sid,
+					info->qdep, addr, mask);
+		if (rc)
+			printk(KERN_ERR "IOMMU: flush device IOTLB failed\n");
+	}
+	spin_unlock_irqrestore(&device_domain_lock, flags);
+}
