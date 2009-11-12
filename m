Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbZKLNNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbZKLNNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 08:13:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZKLNNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 08:13:53 -0500
Received: from nox.protox.org ([88.191.38.29]:37265 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbZKLNNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 08:13:52 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Report vga connector is connected according to ddc_probe
Date: Thu, 12 Nov 2009 14:13:53 +0100
Message-Id: <1258031633-4914-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On broken EDID we were reporting vga connector to be disconnected
even if ddc probe did found a monitor. This patch report that the
connector is connected on such case. This allow drm to add a fail
safe mode (800x600 at the time of this patch) thus user can boot
and later add a mode which match its monitor capabilities.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_connectors.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 292b170..c928ccc 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -566,8 +566,9 @@ static enum drm_connector_status radeon_vga_detect(struct drm_connector *connect
 		radeon_i2c_do_lock(radeon_connector, 0);
 
 		if (!radeon_connector->edid) {
-			DRM_ERROR("DDC responded but not EDID found for %s\n",
-				  drm_get_connector_name(connector));
+			DRM_ERROR("%s: probed a monitor but no|invalid EDID\n",
+					drm_get_connector_name(connector));
+			ret = connector_status_connected;
 		} else {
 			radeon_connector->use_digital = !!(radeon_connector->edid->input & DRM_EDID_INPUT_DIGITAL);
 
@@ -720,8 +721,8 @@ static enum drm_connector_status radeon_dvi_detect(struct drm_connector *connect
 		radeon_i2c_do_lock(radeon_connector, 0);
 
 		if (!radeon_connector->edid) {
-			DRM_ERROR("DDC responded but not EDID found for %s\n",
-				  drm_get_connector_name(connector));
+			DRM_ERROR("%s: probed a monitor but no|invalid EDID\n",
+					drm_get_connector_name(connector));
 		} else {
 			radeon_connector->use_digital = !!(radeon_connector->edid->input & DRM_EDID_INPUT_DIGITAL);
 
-- 
1.6.5.2

