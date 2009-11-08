Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbZKHGBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbZKHGBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 01:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbZKHGBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 01:01:05 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:58588 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbZKHGBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 01:01:03 -0500
Date: Sun, 8 Nov 2009 01:00:58 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       cjb@laptop.org, deepak@laptop.org,
       Jordan Crouse <jordan@cosmicpenguin.net>
Subject: [PATCH 4/6] CS5535: move VSA2 checks into linux/cs5535.h
Message-ID: <20091108010058.4611c220@mycelium.queued.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 arch/x86/include/asm/geode.h     |   19 -------------------
 arch/x86/kernel/geode_32.c       |   22 ----------------------
 arch/x86/kernel/olpc.c           |    4 ++--
 drivers/video/geode/display_gx.c |    2 +-
 drivers/video/geode/lxfb_ops.c   |    2 +-
 include/linux/cs5535.h           |   32 ++++++++++++++++++++++++++++++++
 6 files changed, 36 insertions(+), 45 deletions(-)

diff --git a/arch/x86/include/asm/geode.h b/arch/x86/include/asm/geode.h
index 976b3f1..df1eaf8 100644
--- a/arch/x86/include/asm/geode.h
+++ b/arch/x86/include/asm/geode.h
@@ -95,16 +95,6 @@ extern int geode_get_dev_base(unsigned int dev);
 #define PM_AWKD			0x50
 #define PM_SSC			0x54
 
-/* VSA2 magic values */
-
-#define VSA_VRC_INDEX		0xAC1C
-#define VSA_VRC_DATA		0xAC1E
-#define VSA_VR_UNLOCK		0xFC53	/* unlock virtual register */
-#define VSA_VR_SIGNATURE	0x0003
-#define VSA_VR_MEM_SIZE		0x0200
-#define AMD_VSA_SIG		0x4132	/* signature is ascii 'VSA2' */
-#define GSW_VSA_SIG		0x534d  /* General Software signature */
-
 static inline u32 geode_gpio(unsigned int nr)
 {
 	BUG_ON(nr > 28);
@@ -148,15 +138,6 @@ static inline int is_geode(void)
 	return (is_geode_gx() || is_geode_lx());
 }
 
-#ifdef CONFIG_MGEODE_LX
-extern int geode_has_vsa2(void);
-#else
-static inline int geode_has_vsa2(void)
-{
-	return 0;
-}
-#endif
-
 static inline void geode_mfgpt_write(int timer, u16 reg, u16 value)
 {
 	u32 base = geode_get_dev_base(GEODE_DEV_MFGPT);
diff --git a/arch/x86/kernel/geode_32.c b/arch/x86/kernel/geode_32.c
index 9b08e85..9dad6ca 100644
--- a/arch/x86/kernel/geode_32.c
+++ b/arch/x86/kernel/geode_32.c
@@ -161,28 +161,6 @@ void geode_gpio_setup_event(unsigned int gpio, int pair, int pme)
 }
 EXPORT_SYMBOL_GPL(geode_gpio_setup_event);
 
-int geode_has_vsa2(void)
-{
-	static int has_vsa2 = -1;
-
-	if (has_vsa2 == -1) {
-		u16 val;
-
-		/*
-		 * The VSA has virtual registers that we can query for a
-		 * signature.
-		 */
-		outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
-		outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
-
-		val = inw(VSA_VRC_DATA);
-		has_vsa2 = (val == AMD_VSA_SIG || val == GSW_VSA_SIG);
-	}
-
-	return has_vsa2;
-}
-EXPORT_SYMBOL_GPL(geode_has_vsa2);
-
 static int __init geode_southbridge_init(void)
 {
 	if (!is_geode())
diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 4006c52..9d1d263 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -212,7 +212,7 @@ static int __init olpc_init(void)
 	unsigned char *romsig;
 
 	/* The ioremap check is dangerous; limit what we run it on */
-	if (!is_geode() || geode_has_vsa2())
+	if (!is_geode() || cs5535_has_vsa2())
 		return 0;
 
 	spin_lock_init(&ec_lock);
@@ -244,7 +244,7 @@ static int __init olpc_init(void)
 			(unsigned char *) &olpc_platform_info.ecver, 1);
 
 	/* check to see if the VSA exists */
-	if (geode_has_vsa2())
+	if (cs5535_has_vsa2())
 		olpc_platform_info.flags |= OLPC_F_VSA;
 
 	printk(KERN_INFO "OLPC board revision %s%X (EC=%x)\n",
diff --git a/drivers/video/geode/display_gx.c b/drivers/video/geode/display_gx.c
index e759895..3ddf055 100644
--- a/drivers/video/geode/display_gx.c
+++ b/drivers/video/geode/display_gx.c
@@ -25,7 +25,7 @@ unsigned int gx_frame_buffer_size(void)
 {
 	unsigned int val;
 
-	if (!geode_has_vsa2()) {
+	if (!cs5535_has_vsa2()) {
 		uint32_t hi, lo;
 
 		/* The number of pages is (PMAX - PMIN)+1 */
diff --git a/drivers/video/geode/lxfb_ops.c b/drivers/video/geode/lxfb_ops.c
index b1cd49c..fe1ee7c 100644
--- a/drivers/video/geode/lxfb_ops.c
+++ b/drivers/video/geode/lxfb_ops.c
@@ -307,7 +307,7 @@ unsigned int lx_framebuffer_size(void)
 {
 	unsigned int val;
 
-	if (!geode_has_vsa2()) {
+	if (!cs5535_has_vsa2()) {
 		uint32_t hi, lo;
 
 		/* The number of pages is (PMAX - PMIN)+1 */
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index 39e93e8..eb34108 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -36,6 +36,38 @@
 #define LBAR_ACPI_SIZE		0x40
 #define LBAR_PMS_SIZE		0x80
 
+/* VSA2 magic values */
+#define VSA_VRC_INDEX		0xAC1C
+#define VSA_VRC_DATA		0xAC1E
+#define VSA_VR_UNLOCK		0xFC53  /* unlock virtual register */
+#define VSA_VR_SIGNATURE	0x0003
+#define VSA_VR_MEM_SIZE		0x0200
+#define AMD_VSA_SIG		0x4132  /* signature is ascii 'VSA2' */
+#define GSW_VSA_SIG		0x534d  /* General Software signature */
+
+#include <linux/io.h>
+
+static inline int cs5535_has_vsa2(void)
+{
+	static int has_vsa2 = -1;
+
+	if (has_vsa2 == -1) {
+		uint16_t val;
+
+		/*
+		 * The VSA has virtual registers that we can query for a
+		 * signature.
+		 */
+		outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
+		outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
+
+		val = inw(VSA_VRC_DATA);
+		has_vsa2 = (val == AMD_VSA_SIG || val == GSW_VSA_SIG);
+	}
+
+	return has_vsa2;
+}
+
 /* GPIOs */
 #define GPIO_OUTPUT_VAL		0x00
 #define GPIO_OUTPUT_ENABLE	0x04
-- 
1.5.6.5

