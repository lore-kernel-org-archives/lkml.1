Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbZDFOL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbZDFOL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 10:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZDFOLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 10:11:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47605 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbZDFOLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:11:49 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: dri-devel@lists.sourceforge.net
Subject: [PATCH] drm: ignore LVDS on intel graphics systems that lie about having it
Date: Mon, 6 Apr 2009 10:11:25 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-170.2.56.fc10.x86_64; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, xorg-devel@lists.x.org, notting@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904061011.26389.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a number of small form factor desktop systems with Intel mobile
graphics chips that lie and say they have an LVDS. With kernel mode-setting,
this becomes a problem, and makes native resolution boot go haywire -- for
example, my Dell Studio Hybrid, hooked to a 1920x1080 display claims to
have a 1024x768 LVDS, and the resulting graphical boot on the 1920x1080
display uses only the top left 1024x768, and auto-configured X will end
up only 1024x768 as well. With this change, graphical boot and X
both do 1920x1080 as expected.

Note that we're simply embracing and extending the early bail-out code
in place for the Mac Mini here. The xorg intel driver uses pci subsystem
device and vendor id for matching, while we're using dmi lookups here.
The MSI addition is courtesy of and tested by Bill Nottingham.

One minor issue... Current Fedora rawhide, video playback using Xv makes
X go off into the weeds with this patch added, but that's a bug elsewhere,
still confident this patch DTRT.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Tested-by: Bill Nottingham <notting@redhat.com>

---
 drivers/gpu/drm/i915/intel_lvds.c |   46 ++++++++++++++++++++++++++++++------
 1 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 6619f26..4d64686 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -384,7 +384,51 @@ static const struct drm_encoder_funcs intel_lvds_enc_funcs = {
 	.destroy = intel_lvds_enc_destroy,
 };
 
+static int __init intel_no_lvds_dmi_callback(const struct dmi_system_id *id)
+{
+	DRM_DEBUG("Skipping LVDS initialization for %s\n", id->ident);
+	return 1;
+}
 
+/* These systems claim to have LVDS, but really don't */
+static const struct dmi_system_id __initdata intel_no_lvds[] = {
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Apple Mac Mini (Core series)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini1,1"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Apple Mac Mini (Core 2 series)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini2,1"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "MSI IM-945GSE-A",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MSI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "A9830IMS"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Dell Studio Hybrid",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Studio Hybrid 140g"),
+		},
+	},
+
+	/* FIXME: add a check for the Aopen Mini PC */
+
+	{ }	/* terminating entry */
+};
 
 /**
  * intel_lvds_init - setup LVDS connectors on this device
@@ -404,15 +440,9 @@ void intel_lvds_init(struct drm_device *dev)
 	u32 lvds;
 	int pipe;
 
-	/* Blacklist machines that we know falsely report LVDS. */
-	/* FIXME: add a check for the Aopen Mini PC */
-
-	/* Apple Mac Mini Core Duo and Mac Mini Core 2 Duo */
-	if(dmi_match(DMI_PRODUCT_NAME, "Macmini1,1") ||
-	   dmi_match(DMI_PRODUCT_NAME, "Macmini2,1")) {
-		DRM_DEBUG("Skipping LVDS initialization for Apple Mac Mini\n");
+	/* Skip init on machines we know falsely report LVDS */
+	if (dmi_check_system(intel_no_lvds))
 		return;
-	}
 
 	intel_output = kzalloc(sizeof(struct intel_output), GFP_KERNEL);
 	if (!intel_output) {

-- 
Jarod Wilson
jarod@redhat.com
