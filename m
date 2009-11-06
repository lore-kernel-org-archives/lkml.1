Return-Path: <linux-kernel-owner+w=401wt.eu-S1760472AbZKFWeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472AbZKFWeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760203AbZKFWeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:34:14 -0500
Received: from kroah.org ([198.145.64.141]:56932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760204AbZKFWXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:09 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:46 2009
Message-Id: <20091106221546.450155859@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [56/99] drm/i915: fix to setup display reference clock control on Ironlake
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-fix-to-setup-display-reference-clock-control-on-ironlake.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit c038e51e841581cc3fb9a76e5e16331331e9c85c upstream.

For new stepping of PCH, the display reference clock
is fully under driver's control. This one trys to setup
all needed reference clock for different outputs. Older
stepping of PCH chipset should be ignoring this.

This fixes output failure issue on newer PCH which requires
driver to take control of reference clock enabling.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h      |    4 +--
 drivers/gpu/drm/i915/intel_display.c |   40 +++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1990,11 +1990,11 @@
 #define  DREF_CPU_SOURCE_OUTPUT_MASK		(3<<13)
 #define  DREF_SSC_SOURCE_DISABLE                (0<<11)
 #define  DREF_SSC_SOURCE_ENABLE                 (2<<11)
-#define  DREF_SSC_SOURCE_MASK			(2<<11)
+#define  DREF_SSC_SOURCE_MASK			(3<<11)
 #define  DREF_NONSPREAD_SOURCE_DISABLE          (0<<9)
 #define  DREF_NONSPREAD_CK505_ENABLE		(1<<9)
 #define  DREF_NONSPREAD_SOURCE_ENABLE           (2<<9)
-#define  DREF_NONSPREAD_SOURCE_MASK		(2<<9)
+#define  DREF_NONSPREAD_SOURCE_MASK		(3<<9)
 #define  DREF_SUPERSPREAD_SOURCE_DISABLE        (0<<7)
 #define  DREF_SUPERSPREAD_SOURCE_ENABLE         (2<<7)
 #define  DREF_SSC4_DOWNSPREAD                   (0<<6)
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2442,6 +2442,46 @@ static int intel_crtc_mode_set(struct dr
 				  link_bw, &m_n);
 	}
 
+	/* Ironlake: try to setup display ref clock before DPLL
+	 * enabling. This is only under driver's control after
+	 * PCH B stepping, previous chipset stepping should be
+	 * ignoring this setting.
+	 */
+	if (IS_IGDNG(dev)) {
+		temp = I915_READ(PCH_DREF_CONTROL);
+		/* Always enable nonspread source */
+		temp &= ~DREF_NONSPREAD_SOURCE_MASK;
+		temp |= DREF_NONSPREAD_SOURCE_ENABLE;
+		I915_WRITE(PCH_DREF_CONTROL, temp);
+		POSTING_READ(PCH_DREF_CONTROL);
+
+		temp &= ~DREF_SSC_SOURCE_MASK;
+		temp |= DREF_SSC_SOURCE_ENABLE;
+		I915_WRITE(PCH_DREF_CONTROL, temp);
+		POSTING_READ(PCH_DREF_CONTROL);
+
+		udelay(200);
+
+		if (is_edp) {
+			if (dev_priv->lvds_use_ssc) {
+				temp |= DREF_SSC1_ENABLE;
+				I915_WRITE(PCH_DREF_CONTROL, temp);
+				POSTING_READ(PCH_DREF_CONTROL);
+
+				udelay(200);
+
+				temp &= ~DREF_CPU_SOURCE_OUTPUT_MASK;
+				temp |= DREF_CPU_SOURCE_OUTPUT_DOWNSPREAD;
+				I915_WRITE(PCH_DREF_CONTROL, temp);
+				POSTING_READ(PCH_DREF_CONTROL);
+			} else {
+				temp |= DREF_CPU_SOURCE_OUTPUT_NONSPREAD;
+				I915_WRITE(PCH_DREF_CONTROL, temp);
+				POSTING_READ(PCH_DREF_CONTROL);
+			}
+		}
+	}
+
 	if (IS_IGD(dev))
 		fp = (1 << clock.n) << 16 | clock.m1 << 8 | clock.m2;
 	else


