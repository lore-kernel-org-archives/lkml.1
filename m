Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbYDNHuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbYDNHuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbYDNHuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:50:46 -0400
Received: from mail.queued.net ([207.210.101.209]:4881 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787AbYDNHup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:50:45 -0400
Date: Mon, 14 Apr 2008 03:52:49 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, info-linux@geode.amd.com,
       jordan.crouse@amd.com, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 2/3] gxfb/lxfb: detect framebuffer size using an MSR if VSA2
 isn't available
Message-ID: <20080414035249.52125ba6@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If there's no VSA2 (ie, if we're using tinybios or OpenFirmware), use
the GLIU's P2D Range Offset Descriptor to determine how much memory we
have available for the framebuffer.

Originally based on a patch by Jordan Crouse.  Tested with OpenFirmware;
Pascal informs me that tinybios has a stub that fills in P2D_RO0.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/geode/display_gx.c |   18 +++++++++++++++++-
 drivers/video/geode/lxfb_ops.c   |   16 ++++++++++++++++
 include/asm-x86/geode.h          |    2 ++
 3 files changed, 35 insertions(+), 1 deletions(-)

diff --git a/drivers/video/geode/display_gx.c b/drivers/video/geode/display_gx.c
index 1e82ecc..e759895 100644
--- a/drivers/video/geode/display_gx.c
+++ b/drivers/video/geode/display_gx.c
@@ -25,7 +25,23 @@ unsigned int gx_frame_buffer_size(void)
 {
 	unsigned int val;
 
-	/* FB size is reported by a virtual register */
+	if (!geode_has_vsa2()) {
+		uint32_t hi, lo;
+
+		/* The number of pages is (PMAX - PMIN)+1 */
+		rdmsr(MSR_GLIU_P2D_RO0, lo, hi);
+
+		/* PMAX */
+		val = ((hi & 0xff) << 12) | ((lo & 0xfff00000) >> 20);
+		/* PMIN */
+		val -= (lo & 0x000fffff);
+		val += 1;
+
+		/* The page size is 4k */
+		return (val << 12);
+	}
+
+	/* FB size can be obtained from the VSA II */
 	/* Virtual register class = 0x02 */
 	/* VG_MEM_SIZE(512Kb units) = 0x00 */
 
diff --git a/drivers/video/geode/lxfb_ops.c b/drivers/video/geode/lxfb_ops.c
index 51080db..becf285 100644
--- a/drivers/video/geode/lxfb_ops.c
+++ b/drivers/video/geode/lxfb_ops.c
@@ -279,6 +279,22 @@ unsigned int lx_framebuffer_size(void)
 {
 	unsigned int val;
 
+	if (!geode_has_vsa2()) {
+		uint32_t hi, lo;
+
+		/* The number of pages is (PMAX - PMIN)+1 */
+		rdmsr(MSR_GLIU_P2D_RO0, lo, hi);
+
+		/* PMAX */
+		val = ((hi & 0xff) << 12) | ((lo & 0xfff00000) >> 20);
+		/* PMIN */
+		val -= (lo & 0x000fffff);
+		val += 1;
+
+		/* The page size is 4k */
+		return (val << 12);
+	}
+
 	/* The frame buffer size is reported by a VSM in VSA II */
 	/* Virtual Register Class    = 0x02                     */
 	/* VG_MEM_SIZE (1MB units)   = 0x00                     */
diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
index 6c8a2a0..d5cc7bf 100644
--- a/include/asm-x86/geode.h
+++ b/include/asm-x86/geode.h
@@ -30,6 +30,8 @@ extern int geode_get_dev_base(unsigned int dev);
 
 /* MSRS */
 
+#define MSR_GLIU_P2D_RO0	0x10000029
+
 #define MSR_LX_GLD_MSR_CONFIG	0x48002001
 #define MSR_LX_MSR_PADSEL	0x48002011	/* NOT 0x48000011; the data
 						 * sheet has the wrong value */
-- 
1.5.4.4



-- 
Need a kernel or Debian developer?  Contact me, I'm looking for contracts.
