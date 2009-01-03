Return-Path: <linux-kernel-owner+w=401wt.eu-S1760418AbZACW5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418AbZACW5F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 17:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759988AbZACW4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 17:56:54 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:58043 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759967AbZACW4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 17:56:53 -0500
X-BigFish: VPS-56(z21eW5edJz1432R98dR1447R1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KCX3PW-04-1QI-01
Date: Sat, 3 Jan 2009 23:56:27 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Joerg Roedel <joro@8bytes.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       avi@redhat.com, mingo@redhat.com, dwmw2@infradead.org,
       weidong.han@intel.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [GIT PULL] various IOMMU updates for 2.6.29
Message-ID: <20090103225627.GA21841@amd.com>
References: <20090103173130.GB6103@amd.com> <20090103220611.GA4389@elte.hu> <20090103221135.GA14298@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090103221135.GA14298@8bytes.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 03 Jan 2009 22:56:28.0229 (UTC) FILETIME=[82E66750:01C96DF6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 11:11:35PM +0100, Joerg Roedel wrote:
> >   drivers/built-in.o: In function `alloc_iommu':
> >   : undefined reference to `iommu_calculate_agaw'
> > 
> 
> thanks for the report. I will look at it.
> 

Ok, this patch fixes the build problem. It should be safe but I can't
test this because I don't have any VT-d hardware. David, is this patch
ok?

commit c9740e758a5b024235429461540b7e5aabc21cc6
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Sat Jan 3 23:46:21 2009 +0100

    intel-iommu: fix build error with INTR_REMAP=y and DMAR=n
    
    Impact: build fix (set agaw for iommu only if DMAR enabled)
    
    This fix should be safe since iommu->agaw is only used in intel-iommu.c.
    And this file is only compiled with DMAR=y.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index f5a662a..2b4162d 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -491,7 +491,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 	int map_size;
 	u32 ver;
 	static int iommu_allocated = 0;
-	int agaw;
+	int agaw = 0;
 
 	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
 	if (!iommu)
@@ -507,6 +507,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 	iommu->cap = dmar_readq(iommu->reg + DMAR_CAP_REG);
 	iommu->ecap = dmar_readq(iommu->reg + DMAR_ECAP_REG);
 
+#ifdef CONFIG_DMAR
 	agaw = iommu_calculate_agaw(iommu);
 	if (agaw < 0) {
 		printk(KERN_ERR
@@ -514,6 +515,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 			iommu->seq_id);
 		goto error;
 	}
+#endif
 	iommu->agaw = agaw;
 
 	/* the registers might be more than one page */

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

