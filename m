Return-Path: <linux-kernel-owner+w=401wt.eu-S933405AbXF2Pdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405AbXF2Pdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763529AbXF2Pdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:33:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:26978 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758652AbXF2Pdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:33:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,475,1175497200"; 
   d="scan'208";a="262624166"
Date: Fri, 29 Jun 2007 08:28:58 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: "Li, Shaohua" <shaohua.li@intel.com>
Cc: Robert Hancock <hancockr@shaw.ca>, Zan Lynx <zlynx@acm.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Raj, Ashok" <ashok.raj@intel.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Subject: Re: 2.6.22-rc6-mm1 Intel DMAR crash on AMD x86_64
Message-ID: <20070629152858.GA27995@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <46845943.7050005@shaw.ca> <FC1D1B23302A22499C60C967336B2AE0016F7529@pdsmsx411.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FC1D1B23302A22499C60C967336B2AE0016F7529@pdsmsx411.ccr.corp.intel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 06:14:27PM -0700, Li, Shaohua wrote:
> 
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-
> >rc6/2.6.22-rc6-mm1/
> >>
> >>> +intel-iommu-dmar-detection-and-parsing-logic.patch
[..]
> >
> >I took a picture of it, looks like the backtrace is:
> >
> >NULL pointer dereference at 024
> >EIP:dmar_table_init+0x11
> >intel_iommu_init+0x30
> >pci_iommu_init+0xe
> >kernel_init+0x16e
> >
> >Presumably something is NULL in dmar_table_init that wasn't expected to
> >be.. I would guess it likely crashes on any system without an Intel
> >IOMMU in it.
Yup, that is correct.

> How about something like below?
> 
> 
> int __init dmar_table_init(void)
> {
> +	if (!dmar_tbl)
> +		return -ENODEV;
> 	parse_dmar_table();
why not check for NULL in the function where it touched?
Also when there are no DMAR devices we need the below
printk on the console.

> 	if (list_empty(&dmar_drhd_units)) {
> 		printk(KERN_ERR PREFIX "No DMAR devices found\n");
> 		return -ENODEV;
> 	}
> 	return 0;
> }

Here is the revised patch of the above.
Andrew, please add this fix to
+intel-iommu-dmar-detection-and-parsing-logic.patch
------------------------------------------------

Check for dmar_tbl pointer as this can be NULL on 
systems with no Intel VT-d support.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

---
 drivers/pci/dmar.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm2/drivers/pci/dmar.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/pci/dmar.c	2007-06-29 07:43:43.000000000 -0700
+++ linux-2.6.22-rc4-mm2/drivers/pci/dmar.c	2007-06-29 07:46:25.000000000 -0700
@@ -260,6 +260,8 @@
 	int ret = 0;
 
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
+	if (!dmar)
+		return -ENODEV;
 
 	if (!dmar->width) {
 		printk (KERN_WARNING PREFIX "Zero: Invalid DMAR haw\n");
@@ -301,7 +303,7 @@
 
 	parse_dmar_table();
 	if (list_empty(&dmar_drhd_units)) {
-		printk(KERN_ERR PREFIX "No DMAR devices found\n");
+		printk(KERN_INFO PREFIX "No DMAR devices found\n");
 		return -ENODEV;
 	}
 	return 0;
