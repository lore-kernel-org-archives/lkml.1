Return-Path: <linux-kernel-owner+w=401wt.eu-S935500AbZLGRaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935500AbZLGRaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935441AbZLGRaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:30:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63012 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935436AbZLGRaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:30:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Airlie <airlied@redhat.com>
Subject: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Mon, 7 Dec 2009 18:30:14 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912071830.14697.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+4y5DbztxbX/fP2LxnhJdtBTvC/BHv0SDJx66
 weuTnEt68a94gxFfxMWSnrg6m7CPfpfCLpiLQljRuGSZDeo14J
 1DReNHD2jaBJSKtx+gt5g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After upgrading one of my machines to 2.6.32, I saw hangs after one to thirty minutes after
booting, with random data written to parts of the frame buffer. I've bisected it down
to 620f37811d "drm: prune modes when output is disconnected.", which was merged
in 2.6.32-rc1. Connecting a serial console does not reveal any output at the time of
the crash.

The machine uses an Intel G45 chipset with the i915 kernel mode setting enabled.

I have no clue what that patch does or why reverting it fixes the problem but 2.6.32
with this revert applied has not shown these hangs yet.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---

--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -104,7 +104,8 @@ int drm_helper_probe_single_connector_modes(struct drm_connector *connector,
 	if (connector->status == connector_status_disconnected) {
 		DRM_DEBUG_KMS("%s is disconnected\n",
 			  drm_get_connector_name(connector));
-		goto prune;
+		/* TODO set EDID to NULL */
+		return 0;
 	}
 
 	count = (*connector_funcs->get_modes)(connector);
@@ -132,7 +133,6 @@ int drm_helper_probe_single_connector_modes(struct drm_connector *connector,
 								   mode);
 	}
 
-prune:
 	drm_mode_prune_invalid(dev, &connector->modes, true);
 
 	if (list_empty(&connector->modes))
