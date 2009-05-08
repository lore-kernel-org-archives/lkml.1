Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbZEHOEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbZEHOEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758110AbZEHOBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:01:34 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58272 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757913AbZEHOBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:01:33 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org
Subject: [PATCH 08/15] powerpc/cell: Extract duplicated IOPTE_* to <asm/iommu.h>
Date: Fri,  8 May 2009 16:01:17 +0200
Message-Id: <1241791284-11490-9-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241791284-11490-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-7-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1241791284-11490-8-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both arch/powerpc/platforms/cell/iommu.c and arch/powerpc/platforms/ps3/mm.c
contain the same Cell IOMMU page table entry definitions. Extract them and move
them to <asm/iommu.h>.
This also allows them to be used by drivers.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/include/asm/iommu.h        |   10 ++++++++++
 arch/powerpc/platforms/cell/iommu.c     |   10 ----------
 arch/powerpc/platforms/ps3/mm.c         |    1 +
 arch/powerpc/platforms/ps3/platform.h   |   10 ----------
 arch/powerpc/platforms/ps3/system-bus.c |    1 +
 5 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/include/asm/iommu.h b/arch/powerpc/include/asm/iommu.h
index 7464c0d..0b16e76 100644
--- a/arch/powerpc/include/asm/iommu.h
+++ b/arch/powerpc/include/asm/iommu.h
@@ -35,6 +35,16 @@
 #define IOMMU_PAGE_MASK       (~((1 << IOMMU_PAGE_SHIFT) - 1))
 #define IOMMU_PAGE_ALIGN(addr) _ALIGN_UP(addr, IOMMU_PAGE_SIZE)
 
+/* Cell page table entries */
+#define IOPTE_PP_W		0x8000000000000000ul /* protection: write */
+#define IOPTE_PP_R		0x4000000000000000ul /* protection: read */
+#define IOPTE_M			0x2000000000000000ul /* coherency required */
+#define IOPTE_SO_R		0x1000000000000000ul /* ordering: writes */
+#define IOPTE_SO_RW             0x1800000000000000ul /* ordering: r & w */
+#define IOPTE_RPN_Mask		0x07fffffffffff000ul /* RPN */
+#define IOPTE_H			0x0000000000000800ul /* cache hint */
+#define IOPTE_IOID_Mask		0x00000000000007fful /* ioid */
+
 /* Boot time flags */
 extern int iommu_is_off;
 extern int iommu_force_on;
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index bed4690..d85691c 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -100,16 +100,6 @@
 #define IOSTE_PS_1M		0x0000000000000005ul /*   - 1MB  */
 #define IOSTE_PS_16M		0x0000000000000007ul /*   - 16MB */
 
-/* Page table entries */
-#define IOPTE_PP_W		0x8000000000000000ul /* protection: write */
-#define IOPTE_PP_R		0x4000000000000000ul /* protection: read */
-#define IOPTE_M			0x2000000000000000ul /* coherency required */
-#define IOPTE_SO_R		0x1000000000000000ul /* ordering: writes */
-#define IOPTE_SO_RW             0x1800000000000000ul /* ordering: r & w */
-#define IOPTE_RPN_Mask		0x07fffffffffff000ul /* RPN */
-#define IOPTE_H			0x0000000000000800ul /* cache hint */
-#define IOPTE_IOID_Mask		0x00000000000007fful /* ioid */
-
 
 /* IOMMU sizing */
 #define IO_SEGMENT_SHIFT	28
diff --git a/arch/powerpc/platforms/ps3/mm.c b/arch/powerpc/platforms/ps3/mm.c
index 9a2b6d9..4f17e1d 100644
--- a/arch/powerpc/platforms/ps3/mm.c
+++ b/arch/powerpc/platforms/ps3/mm.c
@@ -24,6 +24,7 @@
 #include <linux/lmb.h>
 
 #include <asm/firmware.h>
+#include <asm/iommu.h>
 #include <asm/prom.h>
 #include <asm/udbg.h>
 #include <asm/lv1call.h>
diff --git a/arch/powerpc/platforms/ps3/platform.h b/arch/powerpc/platforms/ps3/platform.h
index 136aa06..9a196a8 100644
--- a/arch/powerpc/platforms/ps3/platform.h
+++ b/arch/powerpc/platforms/ps3/platform.h
@@ -232,14 +232,4 @@ int ps3_repository_read_spu_resource_id(unsigned int res_index,
 int ps3_repository_read_vuart_av_port(unsigned int *port);
 int ps3_repository_read_vuart_sysmgr_port(unsigned int *port);
 
-/* Page table entries */
-#define IOPTE_PP_W		0x8000000000000000ul /* protection: write */
-#define IOPTE_PP_R		0x4000000000000000ul /* protection: read */
-#define IOPTE_M			0x2000000000000000ul /* coherency required */
-#define IOPTE_SO_R		0x1000000000000000ul /* ordering: writes */
-#define IOPTE_SO_RW             0x1800000000000000ul /* ordering: r & w */
-#define IOPTE_RPN_Mask		0x07fffffffffff000ul /* RPN */
-#define IOPTE_H			0x0000000000000800ul /* cache hint */
-#define IOPTE_IOID_Mask		0x00000000000007fful /* ioid */
-
 #endif
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 9a73d02..6c655eb 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -27,6 +27,7 @@
 #include <asm/udbg.h>
 #include <asm/lv1call.h>
 #include <asm/firmware.h>
+#include <asm/iommu.h>
 
 #include "platform.h"
 
-- 
1.6.2.4

