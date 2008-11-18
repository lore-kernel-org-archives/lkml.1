Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbYKRPno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbYKRPno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 10:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYKRPng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 10:43:36 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:46899 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYKRPnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 10:43:35 -0500
X-BigFish: VPS-19(z21eW5edJz4015Mzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KAJD07-04-1DO-01
Date: Tue, 18 Nov 2008 16:43:22 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] AMD IOMMU updates for 2.6.28-rc5
Message-ID: <20081118154322.GX13394@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 18 Nov 2008 15:43:22.0885 (UTC) FILETIME=[636D1350:01C94994]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry for resend, forgot to add the mailing lists)

Hi Ingo,


The following changes since commit 4e14e833ac3b97a4aa8803eea49f899adc5bb5f4:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../sfrench/cifs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu-fixes-2.6.28

Joerg Roedel (4):
      AMD IOMMU: add parameter to disable device isolation
      AMD IOMMU: enable device isolation per default
      AMD IOMMU: fix fullflush comparison length
      AMD IOMMU: check for next_bit also in unmapped area

 Documentation/kernel-parameters.txt |    4 +++-
 arch/x86/kernel/amd_iommu.c         |    2 +-
 arch/x86/kernel/amd_iommu_init.c    |    6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

As the most important change these patches enable device isolation per
default. Tests have shown that there are drivers which have bugs and do
double-freeing of DMA memory. This can lead to data corruption with a
hardware IOMMU when multiple devices share the same protection domain.
Therefore device isolation should be enabled by default.
The full diff of these changes is appended. Please pull.

Thanks,

Joerg

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9fa6508..f2e1e7f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -294,7 +294,9 @@ and is between 256 and 4096 characters. It is defined in the file
 			Possible values are:
 			isolate - enable device isolation (each device, as far
 			          as possible, will get its own protection
-			          domain)
+			          domain) [default]
+			share - put every device behind one IOMMU into the
+				same protection domain
 			fullflush - enable flushing of IO/TLB entries when
 				    they are unmapped. Otherwise they are
 				    flushed before they will be reused, which
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 331b318..e4899e0 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -537,7 +537,7 @@ static void dma_ops_free_addresses(struct dma_ops_domain *dom,
 	address >>= PAGE_SHIFT;
 	iommu_area_free(dom->bitmap, address, pages);
 
-	if (address + pages >= dom->next_bit)
+	if (address >= dom->next_bit)
 		dom->need_flush = true;
 }
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 0cdcda3..30ae270 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -121,7 +121,7 @@ u16 amd_iommu_last_bdf;			/* largest PCI device id we have
 LIST_HEAD(amd_iommu_unity_map);		/* a list of required unity mappings
 					   we find in ACPI */
 unsigned amd_iommu_aperture_order = 26; /* size of aperture in power of 2 */
-int amd_iommu_isolate;			/* if 1, device isolation is enabled */
+int amd_iommu_isolate = 1;		/* if 1, device isolation is enabled */
 bool amd_iommu_unmap_flush;		/* if true, flush on every unmap */
 
 LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
@@ -1213,7 +1213,9 @@ static int __init parse_amd_iommu_options(char *str)
 	for (; *str; ++str) {
 		if (strncmp(str, "isolate", 7) == 0)
 			amd_iommu_isolate = 1;
-		if (strncmp(str, "fullflush", 11) == 0)
+		if (strncmp(str, "share", 5) == 0)
+			amd_iommu_isolate = 0;
+		if (strncmp(str, "fullflush", 9) == 0)
 			amd_iommu_unmap_flush = true;
 	}
 
-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

