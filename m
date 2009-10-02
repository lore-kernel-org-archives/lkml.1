Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbZJBBim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbZJBBim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932126AbZJBBik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:38:40 -0400
Received: from kroah.org ([198.145.64.141]:33571 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756913AbZJBBeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:26 2009
Message-Id: <20091002012426.595293794@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chris Wilson <chris@chris-wilson.co.uk>
Subject: [124/136] drm/i915: Handle ERESTARTSYS during page fault
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-handle-erestartsys-during-page-fault.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Chris Wilson <chris@chris-wilson.co.uk>

commit c715089f49844260f1eeae8e3b55af9468ba1325 upstream.

During a page fault and rebinding the buffer there exists a window for a
signal to arrive during the i915_wait_request() and trigger a
ERESTARTSYS. This used to be handled by returning SIGBUS and thereby
killing the application. Try 'cairo-perf-trace & cairo-test-suite' and
watch X go boom!

The solution as suggested by H. Peter Anvin is to simply return NOPAGE and
leave the higher layers to spot we did not fill the page and resubmit
the page fault.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
[anholt: Mostly squash it with another commit]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem.c |   29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1151,26 +1151,21 @@ int i915_gem_fault(struct vm_area_struct
 	mutex_lock(&dev->struct_mutex);
 	if (!obj_priv->gtt_space) {
 		ret = i915_gem_object_bind_to_gtt(obj, obj_priv->gtt_alignment);
-		if (ret) {
-			mutex_unlock(&dev->struct_mutex);
-			return VM_FAULT_SIGBUS;
-		}
+		if (ret)
+			goto unlock;
+
 		list_add_tail(&obj_priv->list, &dev_priv->mm.inactive_list);
 
 		ret = i915_gem_object_set_to_gtt_domain(obj, write);
-		if (ret) {
-			mutex_unlock(&dev->struct_mutex);
-			return VM_FAULT_SIGBUS;
-		}
+		if (ret)
+			goto unlock;
 	}
 
 	/* Need a new fence register? */
 	if (obj_priv->tiling_mode != I915_TILING_NONE) {
 		ret = i915_gem_object_get_fence_reg(obj);
-		if (ret) {
-			mutex_unlock(&dev->struct_mutex);
-			return VM_FAULT_SIGBUS;
-		}
+		if (ret)
+			goto unlock;
 	}
 
 	pfn = ((dev->agp->base + obj_priv->gtt_offset) >> PAGE_SHIFT) +
@@ -1178,18 +1173,18 @@ int i915_gem_fault(struct vm_area_struct
 
 	/* Finally, remap it using the new GTT offset */
 	ret = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
-
+unlock:
 	mutex_unlock(&dev->struct_mutex);
 
 	switch (ret) {
+	case 0:
+	case -ERESTARTSYS:
+		return VM_FAULT_NOPAGE;
 	case -ENOMEM:
 	case -EAGAIN:
 		return VM_FAULT_OOM;
-	case -EFAULT:
-	case -EINVAL:
-		return VM_FAULT_SIGBUS;
 	default:
-		return VM_FAULT_NOPAGE;
+		return VM_FAULT_SIGBUS;
 	}
 }
 


