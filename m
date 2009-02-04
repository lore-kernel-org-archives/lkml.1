Return-Path: <linux-kernel-owner+w=401wt.eu-S1760276AbZBDWht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276AbZBDWht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbZBDWhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:37:39 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:11181 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756473AbZBDWhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:37:38 -0500
X-IronPort-AV: E=Sophos;i="4.37,381,1231113600"; 
   d="scan'208";a="243101960"
From: Roland Dreier <rdreier@cisco.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>,
       drivers_video-dri@kernel-bugs.osdl.org
Subject: Re: [Bug #12491] i915 lockdep warning
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	<pWZw1SZjMCH.A.ciH.4vYiJB@chimera>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 04 Feb 2009 14:37:34 -0800
In-Reply-To: <pWZw1SZjMCH.A.ciH.4vYiJB@chimera> (Rafael J. Wysocki's message
	of "Wed, 4 Feb 2009 11:23:57 +0100 (CET)")
Message-ID: <adar62dltg1.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Feb 2009 22:37:35.0082 (UTC) FILETIME=[2CB5E4A0:01C98719]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12491
 > Subject		: i915 lockdep warning
 > Submitter	: Brandeburg, Jesse <jesse.brandeburg@intel.com>
 > Date		: 2009-01-13 23:17 (23 days old)
 > References	: http://marc.info/?l=linux-kernel&m=123188898423532&w=4

Looking at the code, it seems that the issue is that the DRM
struct_mutex must be taken inside mmap_sem (because struct_mutex is
taken in drm_vm_open(), which is called with mmap_sem already held), but
i915_gem_execbuffer() does a copy_to_user() while holding struct_mutex,
and if this copy faults, then the VM tries to acquire mmap_sem -- ie
lockdep identifies correctly a potential AB/BA deadlock.

I don't pretend to fully understand the DRM or GEM, but a possible fix
is below -- would be worth it to test and review, and get into 2.6.29 if
it is a correct fix:

---
i915: Fix potential AB-BA deadlock in i915_gem_execbuffer()

Lockdep warns that i915_gem_execbuffer() can trigger a page fault (which
takes mmap_sem) while holding dev->struct_mutex, while drm_vm_open()
(which is called with mmap_sem already held) takes dev->struct_mutex.
So this is a potential AB-BA deadlock.

The way that i915_gem_execbuffer() triggers a page fault is by doing
copy_to_user() when returning new buffer offsets back to userspace;
however there is no reason to hold the struct_mutex when doing this
copy, since what is being copied is a private array anyway.  So we can
fix the potential deadlock (and get rid of the lockdep warning) by
simply moving the copy_to_user() outside of where struct_mutex is held.

This fixes <http://bugzilla.kernel.org/show_bug.cgi?id=12491>.

Reported-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/gpu/drm/i915/i915_gem.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index debad5c..23aad8c 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2610,15 +2610,6 @@ i915_gem_execbuffer(struct drm_device *dev, void *data,
 
 	i915_verify_inactive(dev, __FILE__, __LINE__);
 
-	/* Copy the new buffer offsets back to the user's exec list. */
-	ret = copy_to_user((struct drm_i915_relocation_entry __user *)
-			   (uintptr_t) args->buffers_ptr,
-			   exec_list,
-			   sizeof(*exec_list) * args->buffer_count);
-	if (ret)
-		DRM_ERROR("failed to copy %d exec entries "
-			  "back to user (%d)\n",
-			   args->buffer_count, ret);
 err:
 	for (i = 0; i < pinned; i++)
 		i915_gem_object_unpin(object_list[i]);
@@ -2628,6 +2619,18 @@ err:
 
 	mutex_unlock(&dev->struct_mutex);
 
+	if (!ret) {
+		/* Copy the new buffer offsets back to the user's exec list. */
+		ret = copy_to_user((struct drm_i915_relocation_entry __user *)
+				   (uintptr_t) args->buffers_ptr,
+				   exec_list,
+				   sizeof(*exec_list) * args->buffer_count);
+		if (ret)
+			DRM_ERROR("failed to copy %d exec entries "
+				  "back to user (%d)\n",
+				  args->buffer_count, ret);
+	}
+
 pre_mutex_err:
 	drm_free(object_list, sizeof(*object_list) * args->buffer_count,
 		 DRM_MEM_DRIVER);
