Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbZHQXMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbZHQXMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757830AbZHQXMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:12:40 -0400
Received: from sous-sol.org ([216.99.217.87]:46583 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753580AbZHQXMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:12:39 -0400
Date: Mon, 17 Aug 2009 16:11:56 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Faidon Liambotis <paravoid@debian.org>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       iommu@lists.linux-foundation.org,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [regression, bisected] fails to boot on Dell Optiplex 760 with
	VT-d enabled
Message-ID: <20090817231156.GJ24885@sequoia.sous-sol.org>
References: <4A89CB52.4030008@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A89CB52.4030008@debian.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Faidon Liambotis (paravoid@debian.org) wrote:
> I am experiencin a bug on an Dell Optiplex 760 with a configuration that
> has an Intel Core2 Q9550 CPU and with an up-to-date BIOS, version A03.
> 
> When "VT for Direct I/O" is enabled in the BIOS, v2.6.30 boots and works
> perfectly, while v2.6.31-rc1..rc6 fail (both of them x86-64).

AFAIK, this platform is broken when VT-d is enabled.
Can you add this patch to a broken kernel and retest?
Please boot with 'debug' on the kernel command line.

 drivers/pci/dmar.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 7b287cb..40f497b 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -631,6 +631,18 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 	}
 	iommu->cap = dmar_readq(iommu->reg + DMAR_CAP_REG);
 	iommu->ecap = dmar_readq(iommu->reg + DMAR_ECAP_REG);
+	ver = readl(iommu->reg + DMAR_VER_REG);
+	printk(KERN_DEBUG "IOMMU %llx: ver %d:%d cap %llx ecap %llx\n",
+		(unsigned long long)drhd->reg_base_addr,
+		DMAR_VER_MAJOR(ver), DMAR_VER_MINOR(ver),
+		(unsigned long long)iommu->cap,
+		(unsigned long long)iommu->ecap);
+
+	if (ver == (u32)-1 || iommu->cap == (u64)-1 || iommu->ecap == (u64)-1) {
+		printk(KERN_ERR "IOMMU: BIOS or hardware problem, disabling "
+			"VT-d\n");
+		goto error;
+	}
 
 #ifdef CONFIG_DMAR
 	agaw = iommu_calculate_agaw(iommu);
@@ -664,13 +676,6 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 		}
 	}
 
-	ver = readl(iommu->reg + DMAR_VER_REG);
-	pr_debug("IOMMU %llx: ver %d:%d cap %llx ecap %llx\n",
-		(unsigned long long)drhd->reg_base_addr,
-		DMAR_VER_MAJOR(ver), DMAR_VER_MINOR(ver),
-		(unsigned long long)iommu->cap,
-		(unsigned long long)iommu->ecap);
-
 	spin_lock_init(&iommu->register_lock);
 
 	drhd->iommu = iommu;
