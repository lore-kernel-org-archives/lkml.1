Return-Path: <linux-kernel-owner+w=401wt.eu-S932587AbZKFWXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbZKFWXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932561AbZKFWXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:20 -0500
Received: from kroah.org ([198.145.64.141]:57015 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932565AbZKFWXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:18 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:47 2009
Message-Id: <20091106221547.857126995@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [66/99] x86/amd-iommu: Workaround for erratum 63
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=x86-amd-iommu-workaround-for-erratum-63.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Joerg Roedel <joerg.roedel@amd.com>

commit c5cca146aa03e1f60fb179df65f0dbaf17bc64ed upstream.

There is an erratum for IOMMU hardware which documents
undefined behavior when forwarding SMI requests from
peripherals and the DTE of that peripheral has a sysmgt
value of 01b. This problem caused weird IO_PAGE_FAULTS in my
case.
This patch implements the suggested workaround for that
erratum into the AMD IOMMU driver.  The erratum is
documented with number 63.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/amd_iommu.h |    1 +
 arch/x86/kernel/amd_iommu.c      |    2 ++
 arch/x86/kernel/amd_iommu_init.c |   22 ++++++++++++++++++++++
 3 files changed, 25 insertions(+)

--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -30,6 +30,7 @@ extern irqreturn_t amd_iommu_int_handler
 extern void amd_iommu_flush_all_domains(void);
 extern void amd_iommu_flush_all_devices(void);
 extern void amd_iommu_shutdown(void);
+extern void amd_iommu_apply_erratum_63(u16 devid);
 #else
 static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1112,6 +1112,8 @@ static void __detach_device(struct prote
 	amd_iommu_dev_table[devid].data[1] = 0;
 	amd_iommu_dev_table[devid].data[2] = 0;
 
+	amd_iommu_apply_erratum_63(devid);
+
 	/* decrease reference counter */
 	domain->dev_cnt -= 1;
 
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -509,6 +509,26 @@ static void set_dev_entry_bit(u16 devid,
 	amd_iommu_dev_table[devid].data[i] |= (1 << _bit);
 }
 
+static int get_dev_entry_bit(u16 devid, u8 bit)
+{
+	int i = (bit >> 5) & 0x07;
+	int _bit = bit & 0x1f;
+
+	return (amd_iommu_dev_table[devid].data[i] & (1 << _bit)) >> _bit;
+}
+
+
+void amd_iommu_apply_erratum_63(u16 devid)
+{
+	int sysmgt;
+
+	sysmgt = get_dev_entry_bit(devid, DEV_ENTRY_SYSMGT1) |
+		 (get_dev_entry_bit(devid, DEV_ENTRY_SYSMGT2) << 1);
+
+	if (sysmgt == 0x01)
+		set_dev_entry_bit(devid, DEV_ENTRY_IW);
+}
+
 /* Writes the specific IOMMU for a device into the rlookup table */
 static void __init set_iommu_for_device(struct amd_iommu *iommu, u16 devid)
 {
@@ -537,6 +557,8 @@ static void __init set_dev_entry_from_ac
 	if (flags & ACPI_DEVFLAG_LINT1)
 		set_dev_entry_bit(devid, DEV_ENTRY_LINT1_PASS);
 
+	amd_iommu_apply_erratum_63(devid);
+
 	set_iommu_for_device(iommu, devid);
 }
 


