Return-Path: <linux-kernel-owner+w=401wt.eu-S1764493AbZCTXkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764493AbZCTXkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763006AbZCTXZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:25:00 -0400
Received: from kroah.org ([198.145.64.141]:48866 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761670AbZCTXY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:29 2009
Message-Id: <20090320222929.372941874@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:51 -0700
From: Greg KH <gregkh@suse.de>
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
       Dave Airlie <airlied@linux.ie>
Subject: [patch 41/43] drm/i915: Dont print to dmesg when taking signal during object_pin.
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-don-t-print-to-dmesg-when-taking-signal-during-object_pin.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Anholt <eric@anholt.net>

commit f1acec933848219c402c165686677b1c307407f8 upstream.

This showed up in logs where people had a hung chip, so pinning was blocked
on the chip unpinning other buffers, and the X Server took its scheduler
signal during that time.

Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2029,7 +2029,8 @@ i915_gem_execbuffer(struct drm_device *d
 
 		/* error other than GTT full, or we've already tried again */
 		if (ret != -ENOMEM || pin_tries >= 1) {
-			DRM_ERROR("Failed to pin buffers %d\n", ret);
+			if (ret != -ERESTARTSYS)
+				DRM_ERROR("Failed to pin buffers %d\n", ret);
 			goto err;
 		}
 
@@ -2179,7 +2180,8 @@ i915_gem_object_pin(struct drm_gem_objec
 	if (obj_priv->gtt_space == NULL) {
 		ret = i915_gem_object_bind_to_gtt(obj, alignment);
 		if (ret != 0) {
-			DRM_ERROR("Failure to bind: %d", ret);
+			if (ret != -ERESTARTSYS)
+				DRM_ERROR("Failure to bind: %d", ret);
 			return ret;
 		}
 	}


