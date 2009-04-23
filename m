Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZDWH1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZDWH1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZDWH1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:27:02 -0400
Received: from sous-sol.org ([216.99.217.87]:48069 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754097AbZDWH1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:27:00 -0400
Message-Id: <20090423072242.771252535@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:20:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
       Zhao Yakui <yakui.zhao@intel.com>
Subject: [patch 017/100] drm/i915: Sync crt hotplug detection with intel video driver
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=drm-i915-sync-crt-hotplug-detection-with-intel-video-driver.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Zhao Yakui <yakui.zhao@intel.com>

upstream commit: 771cb081354161eea21534ba58e5cc1a2db94a25

This covers:
Use long crt hotplug activation time on GM45.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/gpu/drm/i915/i915_reg.h  |   16 +++++++++++++
 drivers/gpu/drm/i915/intel_crt.c |   47 +++++++++++++++++++++++++++------------
 2 files changed, 49 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -629,6 +629,22 @@
 #define   TV_HOTPLUG_INT_EN			(1 << 18)
 #define   CRT_HOTPLUG_INT_EN			(1 << 9)
 #define   CRT_HOTPLUG_FORCE_DETECT		(1 << 3)
+#define CRT_HOTPLUG_ACTIVATION_PERIOD_32	(0 << 8)
+/* must use period 64 on GM45 according to docs */
+#define CRT_HOTPLUG_ACTIVATION_PERIOD_64	(1 << 8)
+#define CRT_HOTPLUG_DAC_ON_TIME_2M		(0 << 7)
+#define CRT_HOTPLUG_DAC_ON_TIME_4M		(1 << 7)
+#define CRT_HOTPLUG_VOLTAGE_COMPARE_40		(0 << 5)
+#define CRT_HOTPLUG_VOLTAGE_COMPARE_50		(1 << 5)
+#define CRT_HOTPLUG_VOLTAGE_COMPARE_60		(2 << 5)
+#define CRT_HOTPLUG_VOLTAGE_COMPARE_70		(3 << 5)
+#define CRT_HOTPLUG_VOLTAGE_COMPARE_MASK	(3 << 5)
+#define CRT_HOTPLUG_DETECT_DELAY_1G		(0 << 4)
+#define CRT_HOTPLUG_DETECT_DELAY_2G		(1 << 4)
+#define CRT_HOTPLUG_DETECT_VOLTAGE_325MV	(0 << 2)
+#define CRT_HOTPLUG_DETECT_VOLTAGE_475MV	(1 << 2)
+#define CRT_HOTPLUG_MASK			(0x3fc) /* Bits 9-2 */
+
 
 #define PORT_HOTPLUG_STAT	0x61114
 #define   HDMIB_HOTPLUG_INT_STATUS		(1 << 29)
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -133,20 +133,39 @@ static bool intel_crt_detect_hotplug(str
 {
 	struct drm_device *dev = connector->dev;
 	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 temp;
-
-	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
-
-	temp = I915_READ(PORT_HOTPLUG_EN);
-
-	I915_WRITE(PORT_HOTPLUG_EN,
-		   temp | CRT_HOTPLUG_FORCE_DETECT | (1 << 5));
-
-	do {
-		if (!(I915_READ(PORT_HOTPLUG_EN) & CRT_HOTPLUG_FORCE_DETECT))
-			break;
-		msleep(1);
-	} while (time_after(timeout, jiffies));
+	u32 hotplug_en;
+	int i, tries = 0;
+	/*
+	 * On 4 series desktop, CRT detect sequence need to be done twice
+	 * to get a reliable result.
+	 */
+
+	if (IS_G4X(dev) && !IS_GM45(dev))
+		tries = 2;
+	else
+		tries = 1;
+	hotplug_en = I915_READ(PORT_HOTPLUG_EN);
+	hotplug_en &= ~(CRT_HOTPLUG_MASK);
+	hotplug_en |= CRT_HOTPLUG_FORCE_DETECT;
+
+	if (IS_GM45(dev))
+		hotplug_en |= CRT_HOTPLUG_ACTIVATION_PERIOD_64;
+
+	hotplug_en |= CRT_HOTPLUG_VOLTAGE_COMPARE_50;
+
+	for (i = 0; i < tries ; i++) {
+		unsigned long timeout;
+		/* turn on the FORCE_DETECT */
+		I915_WRITE(PORT_HOTPLUG_EN, hotplug_en);
+		timeout = jiffies + msecs_to_jiffies(1000);
+		/* wait for FORCE_DETECT to go off */
+		do {
+			if (!(I915_READ(PORT_HOTPLUG_EN) &
+					CRT_HOTPLUG_FORCE_DETECT))
+				break;
+			msleep(1);
+		} while (time_after(timeout, jiffies));
+	}
 
 	if ((I915_READ(PORT_HOTPLUG_STAT) & CRT_HOTPLUG_MONITOR_MASK) ==
 	    CRT_HOTPLUG_MONITOR_COLOR)

