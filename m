Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbZJBBxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbZJBBxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757186AbZJBBw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:52:58 -0400
Received: from kroah.org ([198.145.64.141]:33152 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968AbZJBBdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:14 2009
Message-Id: <20091002012414.861414965@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>
Subject: [056/136] drm/i915: Only destroy a constructed mmap offset
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-only-destroy-a-constructed-mmap-offset.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Chris Wilson <chris@chris-wilson.co.uk>

commit 7e61615857c6fb3afbcb43f5c4e97511a923f5a8 upstream.

drm_ht_remove_item() does not handle removing an absent item and the hlist
in particular is incorrectly initialised. The easy remedy is simply skip
calling i915_gem_free_mmap_offset() unless we have actually created the
offset and associated ht entry.

This also fixes the mishandling of a partially constructed offset which
leaves pointers initialized after freeing them along the
i915_gem_create_mmap_offset() error paths.

In particular this should fix the oops found here:
https://bugs.launchpad.net/ubuntu/+source/xserver-xorg-video-intel/+bug/415357/comments/8

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Eric Anholt <eric@anholt.net>

---
 drivers/gpu/drm/i915/i915_gem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3837,7 +3837,8 @@ void i915_gem_free_object(struct drm_gem
 
 	i915_gem_object_unbind(obj);
 
-	i915_gem_free_mmap_offset(obj);
+	if (obj_priv->mmap_offset)
+		i915_gem_free_mmap_offset(obj);
 
 	kfree(obj_priv->page_cpu_valid);
 	kfree(obj_priv->bit_17);


