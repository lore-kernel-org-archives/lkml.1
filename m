Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935260Ab0CMA3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:29:14 -0500
Received: from kroah.org ([198.145.64.141]:32810 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935036Ab0CMAVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:00 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:14 2010
Message-Id: <20100313001514.152987883@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>
Subject: [patch 103/123] drm/i915: Use a dmi quirk to skip a broken SDVO TV output.
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit 6070a4a928f8c92b9fae7d6717ebbb05f425d6b2 upstream.

This IBM system has a multi-function SDVO card that reports both VGA
and TV, but the system has no TV connector.  The TV connector always
reported as connected, which would lead to poor modesetting choices.

https://bugs.freedesktop.org/show_bug.cgi?id=25787

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Tested-by: Vance <liangghv@sg.ibm.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_sdvo.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -35,6 +35,7 @@
 #include "i915_drm.h"
 #include "i915_drv.h"
 #include "intel_sdvo_regs.h"
+#include <linux/dmi.h>
 
 static char *tv_format_names[] = {
 	"NTSC_M"   , "NTSC_J"  , "NTSC_443",
@@ -2283,6 +2284,25 @@ intel_sdvo_get_slave_addr(struct drm_dev
 		return 0x72;
 }
 
+static int intel_sdvo_bad_tv_callback(const struct dmi_system_id *id)
+{
+	DRM_DEBUG_KMS("Ignoring bad SDVO TV connector for %s\n", id->ident);
+	return 1;
+}
+
+static struct dmi_system_id intel_sdvo_bad_tv[] = {
+	{
+		.callback = intel_sdvo_bad_tv_callback,
+		.ident = "IntelG45/ICH10R/DME1737",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "IBM CORPORATION"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "4800784"),
+		},
+	},
+
+	{ }	/* terminating entry */
+};
+
 static bool
 intel_sdvo_output_setup(struct intel_output *intel_output, uint16_t flags)
 {
@@ -2323,7 +2343,8 @@ intel_sdvo_output_setup(struct intel_out
 					(1 << INTEL_SDVO_NON_TV_CLONE_BIT) |
 					(1 << INTEL_ANALOG_CLONE_BIT);
 		}
-	} else if (flags & SDVO_OUTPUT_SVID0) {
+	} else if ((flags & SDVO_OUTPUT_SVID0) &&
+		   !dmi_check_system(intel_sdvo_bad_tv)) {
 
 		sdvo_priv->controlled_output = SDVO_OUTPUT_SVID0;
 		encoder->encoder_type = DRM_MODE_ENCODER_TVDAC;


