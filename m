Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668Ab0ANWj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab0ANWj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853Ab0ANWiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:38:22 -0500
Received: from kroah.org ([198.145.64.141]:60534 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606Ab0ANW20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:26 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/52] drm/i915: Update LVDS connector status when receiving ACPI LID event
Date: Thu, 14 Jan 2010 14:26:51 -0800
Message-Id: <1263508051-7868-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-11-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Yakui <yakui.zhao@intel.com>

commit a2565377a5c31e25c77c7cabaf6752abe9a2d83a upstream.

Dirk reports that nothing is displayed on LVDS when using ubuntu 9.1 after
close/reopen the LID. And I also reproduce this issue on another laptop.
After some tests and debug, it seems that it is related with that the
LVDS status is not updated in time in course of suspend/resume.

Now the LID state is used to check whether the LVDS is connected or
disconnected. And when the LID is closed, it means that the LVDS is
disconnected. When it is reopened, it means that the LVDS is connected.
At the same time on some distributions the LID event is also used to put
the system into suspend state. When the LID is closed, the system will enter
the suspend state. When the LID is reopened, the system will be resumed.

In such case when the LID is closed, user-space script will receive the LID
notification event and  detect the LVDS as disconnected. Then the system will
enter the suspended state. When the LID is reopened, the system will be
resumed. As the LVDS status is not updated in course of resume, it will cause
that the LVDS connector is marked as unused and disabled. After the resume is
finished,user-space script will try to configure the display mode for LVDS.
But unfortunately as the LVDS status is not updated in time and it is still
marked as disconnected, the LVDS and its corresponding CRTC will be disabled
again in the function of drm_helper_disable_unused_functions after changing
mode for LVDS.

So we had better check and update the status of LVDS connector after receiving
the LID notication event. Then after the system is resumed from suspended
state, we can set the display mode for LVDS correctly.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Reported-by:  Dirk Hohndel <hohndel@infradead.org>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/i915_drv.h   |    1 +
 drivers/gpu/drm/i915/intel_lvds.c |    9 +++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index ecbafd0..791fded 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -546,6 +546,7 @@ typedef struct drm_i915_private {
 	struct timer_list idle_timer;
 	bool busy;
 	u16 orig_clock;
+	struct drm_connector *int_lvds_connector;
 } drm_i915_private_t;
 
 /** driver private structure attached to each drm_gem_object */
diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 05598ae..0e0e4b4 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -679,7 +679,14 @@ static int intel_lid_notify(struct notifier_block *nb, unsigned long val,
 	struct drm_i915_private *dev_priv =
 		container_of(nb, struct drm_i915_private, lid_notifier);
 	struct drm_device *dev = dev_priv->dev;
+	struct drm_connector *connector = dev_priv->int_lvds_connector;
 
+	/*
+	 * check and update the status of LVDS connector after receiving
+	 * the LID nofication event.
+	 */
+	if (connector)
+		connector->status = connector->funcs->detect(connector);
 	if (!acpi_lid_open()) {
 		dev_priv->modeset_on_lid = 1;
 		return NOTIFY_OK;
@@ -1085,6 +1092,8 @@ out:
 		DRM_DEBUG("lid notifier registration failed\n");
 		dev_priv->lid_notifier.notifier_call = NULL;
 	}
+	/* keep the LVDS connector */
+	dev_priv->int_lvds_connector = connector;
 	drm_sysfs_connector_add(connector);
 	return;
 
-- 
1.6.6

