Return-Path: <linux-kernel-owner+w=401wt.eu-S1761977AbZDQOvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761977AbZDQOvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761652AbZDQOu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:50:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:40370 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761663AbZDQOu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:50:57 -0400
Date: Fri, 17 Apr 2009 14:49:26 GMT
From: tip-bot for Weidong Han <weidong.han@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, weidong.han@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       weidong.han@intel.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1239957736-6161-5-git-send-email-weidong.han@intel.com>
References: <1239957736-6161-5-git-send-email-weidong.han@intel.com>
Subject: [tip:x86/apic] x86, intr-remap: add option to disable interrupt remapping
Message-ID: <tip-52549a96faf1852128c2a1850b29197f2d41a281@git.kernel.org>
Git-Commit-ID: 52549a96faf1852128c2a1850b29197f2d41a281
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 17 Apr 2009 14:49:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52549a96faf1852128c2a1850b29197f2d41a281
Gitweb:     http://git.kernel.org/tip/52549a96faf1852128c2a1850b29197f2d41a281
Author:     Weidong Han <weidong.han@intel.com>
AuthorDate: Fri, 17 Apr 2009 16:42:15 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 17 Apr 2009 16:23:45 +0200

x86, intr-remap: add option to disable interrupt remapping

Add option "nointremap" to disable interrupt remapping.

[ Impact: add new boot option ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Weidong Han <weidong.han@intel.com>
Cc: iommu@lists.linux-foundation.org
Cc: dwmw2@infradead.org
Cc: allen.m.kay@intel.com
Cc: fenghua.yu@intel.com
LKML-Reference: <1239957736-6161-5-git-send-email-weidong.han@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/kernel-parameters.txt |    3 +++
 drivers/pci/intr_remapping.c        |   11 +++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 33989d2..843cb66 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1533,6 +1533,9 @@ and is between 256 and 4096 characters. It is defined in the file
 	noinitrd	[RAM] Tells the kernel not to load any configured
 			initial RAM disk.
 
+	nointremap	[X86-64, Intel-IOMMU] Do not enable interrupt
+			remapping.
+
 	nointroute	[IA-64]
 
 	nojitter	[IA64] Disables jitter checking for ITC timers.
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 5c21426..842039e 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -15,6 +15,14 @@ static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static int ir_ioapic_num;
 int intr_remapping_enabled;
 
+static int disable_intremap;
+static __init int setup_nointremap(char *str)
+{
+	disable_intremap = 1;
+	return 0;
+}
+early_param("nointremap", setup_nointremap);
+
 struct irq_2_iommu {
 	struct intel_iommu *iommu;
 	u16 irte_index;
@@ -506,6 +514,9 @@ int __init intr_remapping_supported(void)
 {
 	struct dmar_drhd_unit *drhd;
 
+	if (disable_intremap)
+		return 0;
+
 	for_each_drhd_unit(drhd) {
 		struct intel_iommu *iommu = drhd->iommu;
 
