Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbZEEOBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbZEEOBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 10:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZEEOBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 10:01:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47145 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZEEOBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 10:01:22 -0400
To: dri-devel@lists.sourceforge.net
Subject: [PATCH resend] drm: ignore LVDS on intel graphics systems that lie about having it
Cc: linux-kernel@vger.kernel.org, xorg-devel@lists.x.org, notting@redhat.com,
       Eric Anholt <eric@anholt.net>
Content-Disposition: inline
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
Date: Tue, 5 May 2009 10:00:25 -0400
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200905051000.26701.jarod@redhat.com>
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

Signed-off-by: Jarod Wilson <jarod@redhat.com>
Tested-by: Bill Nottingham <notting@redhat.com>

Resending at Jesse Barnes' request:
> > > The 2D driver has a similar set of quirks, but since we started
> > > that list we've found that the VBIOS should contain a pretty
> > > reliable table indicating which outputs are available, including
> > > LVDS.  I think if we can figure out how to parse it reliably
> > > (accounting for VBIOS versioning and structure size changes) we
> > > shouldn't need this patch. If we can't get that done in time for
> > > 2.6.30 though I'm all for including this.
> > 
> > Sounds like a plan to me. Either way, would this patch still make
> > sense for submission to the 2.6.29.x stable series? I've already
> > tacked it onto the Fedora 2.6.29 kernel builds, fwiw.
> 
> Yeah would be fine for 2.6.29 as far as I'm concerned, but there's an
> "upstream first" policy for the stable series that might get in the
> way...

Ok we've failed on this one, so we should go ahead an add the LVDS
quirk.  Can you resend this to Eric so it gets into 2.6.30-final?

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
