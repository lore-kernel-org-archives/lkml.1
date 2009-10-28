Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbZJ1Ufn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbZJ1Ufn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 16:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZJ1Ufm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 16:35:42 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:29641 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZJ1Ufl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 16:35:41 -0400
Subject: Re: [PATCH 4/5] intel-iommu: Reinstate RMRRs if a device is
 removed from passthrough domain
From: Alex Williamson <alex.williamson@hp.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <1256746015.5937.128.camel@bling>
References: <20091026232401.9646.90540.stgit@nehalem.aw>
	 <20091026232514.9646.58322.stgit@nehalem.aw>
	 <1256631324.9814.14.camel@macbook.infradead.org>
	 <1256658632.5937.7.camel@bling>
	 <1256740619.9814.141.camel@macbook.infradead.org>
	 <1256746015.5937.128.camel@bling>
Content-Type: text/plain; charset="UTF-8"
Organization: HP OSLO R&D
Date: Wed, 28 Oct 2009 14:35:42 -0600
Message-ID: <1256762142.5937.151.camel@bling>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 10:06 -0600, Alex Williamson wrote:
> On Wed, 2009-10-28 at 14:36 +0000, David Woodhouse wrote:
> > On Tue, 2009-10-27 at 09:50 -0600, Alex Williamson wrote:
> > > 
> > > Yes, good point.  I'm not seeing any convenient ways to setup a new
> > > domain for a device while it's still a member of the si_domain.  It
> > > looks like I'd need to extract parts of the get_valid_domain_for_dev()
> > > path and ignore any bits about using the already existing domain.
> > 
> > That seems like a sane plan. That code wants cleaning up anyway, and
> > factoring out the 'make new domain' part of get_valid_domain_for_dev()
> > should be simple enough.
> 
> Ok, I'll work on something along those lines.  FWIW, even though I sent
> these as a series, each one stands on it's own.  While I think
> reinstating RMRRs is the right thing to do, I don't know of any devices
> that break with the current model (the device I know of with the
> interesting RMRR usage shouldn't be demoted from the si_domain).  So
> please consider pushing patches 2, 3 & 5 upstream (particularly 2).

On IRC David brought up that VT-d requires a context entry to be marked
not present before it can be changed, making a seamless transition for
devices with RMRRs impossible.  This really makes devices with RMRRs
difficult to deal with, and I'm not sure what we can do with them other
than warn when we might hit problems and prevent them from being moved
to a VM domain.  The patch below does that, though I fear we may be
tweaking what devices we white-list for a while.  Comments?  Thanks,

Alex

commit db9778445a5347a817263db60bfb432f235411ba
Author: Alex Williamson <alex.williamson@hp.com>
Date:   Wed Oct 28 14:10:56 2009 -0600

    intel-iommu: warn/prevent operations on devices with RMRRs
    
    RMRRs throw a wrench in our ability to change VT-d domain mapping since
    they may be used for side-band platform purposes and we cannot switch
    domain mappings seamlessly.  RMRRs for USB devices are typical, but
    anything else is likely suspect.  Provide a warning when such devices
    are removed from an identity map and prevent them from being assigned
    to a VM.
    
    Signed-off-by: Alex Williamson <alex.williamson@hp.com>

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index aa19d75..45f3485 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -49,6 +49,7 @@
 
 #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
 #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
+#define IS_USB_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_SERIAL_USB)
 #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
 
 #define IOAPIC_RANGE_START	(0xfee00000)
@@ -2517,6 +2518,25 @@ static int iommu_dummy(struct pci_dev *pdev)
 	return pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO;
 }
 
+static int device_has_rmrr(struct pci_dev *pdev)
+{
+	struct dmar_rmrr_unit *rmrr;
+	int i;
+
+	/*
+	 * USB devices do typically have RMRRs for DOS
+	 * compatibility, but can typically be ignored.
+	 */
+	if (IS_USB_DEVICE(pdev))
+		return 0;
+
+	for_each_rmrr_units(rmrr)
+		for (i = 0; i < rmrr->devices_cnt; i++)
+			if (pdev == rmrr->devices[i])
+				return 1;
+	return 0;
+}
+
 /* Check if the pdev needs to go through non-identity map and unmap process.*/
 static int iommu_no_mapping(struct device *dev)
 {
@@ -2546,6 +2566,13 @@ static int iommu_no_mapping(struct device *dev)
 			domain_remove_one_dev_info(si_domain, pdev);
 			printk(KERN_INFO "%s uses non-identity mapping\n",
 			       pci_name(pdev));
+
+			if (device_has_rmrr(pdev))
+				printk(KERN_WARNING
+				       "IOMMU: Warning RMRRs for %s not mapped\n",
+				       pci_name(pdev));
+
+
 			return 0;
 		}
 	} else {
@@ -3544,6 +3571,13 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 	int addr_width;
 	u64 end;
 
+	if (device_has_rmrr(pdev)) {
+		printk(KERN_WARNING
+		       "IOMMU: Device %s requires RMRRs, cannot be attached\n",
+		       pci_name(pdev));
+		return -EBUSY;
+	}
+	
 	/* normally pdev is not mapped */
 	if (unlikely(domain_context_mapped(pdev))) {
 		struct dmar_domain *old_domain;



