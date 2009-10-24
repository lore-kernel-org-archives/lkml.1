Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZJXB0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZJXB0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZJXB0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:26:47 -0400
Received: from sous-sol.org ([216.99.217.87]:37214 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751705AbZJXB0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:26:47 -0400
Date: Fri, 23 Oct 2009 18:26:06 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Weidong Han <weidong.han@intel.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] intr-remap: allow disabling source id checking
Message-ID: <20091024012606.GB14926@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow users to disable source id checking.  This is really a debugging aid
for broken BIOS setups.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 Documentation/kernel-parameters.txt |    7 +++++++
 drivers/pci/intr_remapping.c        |   20 ++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6fa7292..344256c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -982,6 +982,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			result in a hardware IOTLB flush operation as opposed
 			to batching them for performance.
 
+	intremap=	[X86-64, Intel-IOMMU]
+			Format: { on (default) | off | nosid }
+			on	enable Interrupt Remapping (default) 
+			off	disable Interrupt Remapping
+			nosid	disable Source ID checking
+
 	inttest=	[IA64]
 
 	iomem=		Disable strict checking of access to MMIO memory
@@ -1691,6 +1697,7 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	nointremap	[X86-64, Intel-IOMMU] Do not enable interrupt
 			remapping.
+			[Deprecated - use intremap=off]
 
 	nointroute	[IA-64]
 
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 0ed78a7..136bb6e 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -18,6 +18,8 @@ static int ir_ioapic_num;
 int intr_remapping_enabled;
 
 static int disable_intremap;
+static int disable_sourceid_checking;
+
 static __init int setup_nointremap(char *str)
 {
 	disable_intremap = 1;
@@ -25,6 +27,22 @@ static __init int setup_nointremap(char *str)
 }
 early_param("nointremap", setup_nointremap);
 
+static __init int setup_intremap(char *str)
+{
+	if (!str)
+		return -EINVAL;
+		
+	if (!strncmp(str, "on", 2))
+		disable_intremap = 0;
+	else if (!strncmp(str, "off", 3))
+		disable_intremap = 1;
+	else if (!strncmp(str, "nosid", 5))
+		disable_sourceid_checking = 1;
+
+	return 0;
+}
+early_param("intremap", setup_intremap);
+
 struct irq_2_iommu {
 	struct intel_iommu *iommu;
 	u16 irte_index;
@@ -440,6 +458,8 @@ int free_irte(int irq)
 static void set_irte_sid(struct irte *irte, unsigned int svt,
 			 unsigned int sq, unsigned int sid)
 {
+	if (disable_sourceid_checking)
+		svt = SVT_NO_VERIFY;
 	irte->svt = svt;
 	irte->sq = sq;
 	irte->sid = sid;
