Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084Ab0AWAWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab0AWAWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407Ab0AWATA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:19:00 -0500
Received: from kroah.org ([198.145.64.141]:35086 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab0AWAS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:58 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:13 2010
Message-Id: <20100123001112.899585307@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:10:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>
Subject: [21/29] drm/i915: try another possible DDC bus for the SDVO device with multiple outputs
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit 7c3f0a2726fed78e0e0afe3b6fc3c1f5b298e447 upstream.

There exist multiple DDC buses for the SDVO cards with multiple outputs.
When we can't get the EDID by using the select DDC bus, we can try the other
possible DDC bus to see whether the EDID can be obtained.

https://bugs.freedesktop.org/show_bug.cgi?id=23842

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Tested-by: Sebastien Caty <sebastien.caty@mrnf.gouv.qc.ca>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_sdvo.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1638,6 +1638,32 @@ intel_sdvo_hdmi_sink_detect(struct drm_c
 	edid = drm_get_edid(&intel_output->base,
 			    intel_output->ddc_bus);
 
+	/* This is only applied to SDVO cards with multiple outputs */
+	if (edid == NULL && intel_sdvo_multifunc_encoder(intel_output)) {
+		uint8_t saved_ddc, temp_ddc;
+		saved_ddc = sdvo_priv->ddc_bus;
+		temp_ddc = sdvo_priv->ddc_bus >> 1;
+		/*
+		 * Don't use the 1 as the argument of DDC bus switch to get
+		 * the EDID. It is used for SDVO SPD ROM.
+		 */
+		while(temp_ddc > 1) {
+			sdvo_priv->ddc_bus = temp_ddc;
+			edid = drm_get_edid(&intel_output->base,
+				intel_output->ddc_bus);
+			if (edid) {
+				/*
+				 * When we can get the EDID, maybe it is the
+				 * correct DDC bus. Update it.
+				 */
+				sdvo_priv->ddc_bus = temp_ddc;
+				break;
+			}
+			temp_ddc >>= 1;
+		}
+		if (edid == NULL)
+			sdvo_priv->ddc_bus = saved_ddc;
+	}
 	/* when there is no edid and no monitor is connected with VGA
 	 * port, try to use the CRT ddc to read the EDID for DVI-connector
 	 */


