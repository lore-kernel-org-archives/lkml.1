Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664Ab0AEAme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab0AEAme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434Ab0AEAm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:42:28 -0500
Received: from kroah.org ([198.145.64.141]:42385 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451Ab0AEAf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:56 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Zhao Yakui <yakui.zhao@intel.com>,
       Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 73/97] drm: disable all the possible outputs/crtcs before entering KMS mode
Date: Mon,  4 Jan 2010 16:33:26 -0800
Message-Id: <1262651630-7354-73-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Yakui <yakui.zhao@intel.com>

commit b16d9acbdb97452d1418420e069acf7381ef10bb upstream.

Sometimes we will use a crtc for integerated LVDS, which is different with
that assigned by BIOS. If we want to get flicker-free transitions,
then we could read out the current state for it and set our current state
accordingly.

But it is true that if we aren't reading current state out, we do need
to turn everything off before modesetting.  Otherwise the clocks can get very
angry and we get things worse than a flicker at boot.
In fact we also do the similar thing in UMS mode. We will disable all the
possible outputs/crtcs for the first modesetting.

So we disable all the possible outputs/crtcs before entering the KMS mode.
Before we configure connector/encoder/crtc, the function of
drm_helper_disable_unused_function can disable all the possible outputs/crtcs.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Reviewed-by: Eric Anholt <eric@anholt.net>
Reviewed-by: Rafal Milecki <zajec5@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/drm_crtc_helper.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index bbfd110..afed886 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -1020,6 +1020,9 @@ bool drm_helper_initial_config(struct drm_device *dev)
 {
 	int count = 0;
 
+	/* disable all the possible outputs/crtcs before entering KMS mode */
+	drm_helper_disable_unused_functions(dev);
+
 	drm_fb_helper_parse_command_line(dev);
 
 	count = drm_helper_probe_connector_modes(dev,
-- 
1.6.6

