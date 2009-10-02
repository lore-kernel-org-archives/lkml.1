Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbZJBBdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbZJBBdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbZJBBdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:19 -0400
Received: from kroah.org ([198.145.64.141]:33172 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063AbZJBBdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:15 2009
Message-Id: <20091002012415.328780860@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [059/136] drm/i915: Check that the relocation points to within the target
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-check-that-the-relocation-points-to-within-the-target.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Chris Wilson <chris@chris-wilson.co.uk>

commit cd0b9fb400ba775737bdc3874c4cbee4047e66d8 upstream.

Eric noted a potential concern with the low bits not being strictly used
as part of the absolute offset (instead part of the command stream to the
GPU), but in practice that should not be an issue.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: Andy Whitcroft <apw@canonical.com>
Cc: Eric Anholt <eric@anholt.net>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3006,6 +3006,16 @@ i915_gem_object_pin_and_relocate(struct 
 			return -EINVAL;
 		}
 
+		if (reloc->delta >= target_obj->size) {
+			DRM_ERROR("Relocation beyond target object bounds: "
+				  "obj %p target %d delta %d size %d.\n",
+				  obj, reloc->target_handle,
+				  (int) reloc->delta, (int) target_obj->size);
+			drm_gem_object_unreference(target_obj);
+			i915_gem_object_unpin(obj);
+			return -EINVAL;
+		}
+
 		if (reloc->write_domain & I915_GEM_DOMAIN_CPU ||
 		    reloc->read_domains & I915_GEM_DOMAIN_CPU) {
 			DRM_ERROR("reloc with read/write CPU domains: "


