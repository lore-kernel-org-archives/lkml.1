Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbZBGBsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbZBGBsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 20:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbZBGBsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 20:48:12 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:31951 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbZBGBsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 20:48:11 -0500
X-IronPort-AV: E=Sophos;i="4.37,394,1231113600"; 
   d="scan'208";a="244665082"
From: Roland Dreier <rdreier@cisco.com>
To: "Brandeburg\, Jesse" <jesse.brandeburg@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "drivers_video-dri\@kernel-bugs.osdl.org" 
	<drivers_video-dri@kernel-bugs.osdl.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       intel-gfx@lists.freedesktop.org
Subject: Re: [Bug #12491] i915 lockdep warning
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	<pWZw1SZjMCH.A.ciH.4vYiJB@chimera> <adar62dltg1.fsf@cisco.com>
	<200902050203.40535.rjw@sisk.pl> <adar62bchfw.fsf@cisco.com>
	<F169D4F5E1F1974DBFAFABF47F60C10A1DFD867C@orsmsx507.amr.corp.intel.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 06 Feb 2009 17:48:09 -0800
In-Reply-To: <F169D4F5E1F1974DBFAFABF47F60C10A1DFD867C@orsmsx507.amr.corp.intel.com>
	(Jesse Brandeburg's message of "Fri, 6 Feb 2009 17:20:27 -0800")
Message-ID: <adabptfc90m.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Feb 2009 01:48:09.0788 (UTC) FILETIME=[21270FC0:01C988C6]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[intel-gfx CC added]

 > I tested this on my 965 based system that showed the issue and it seemed resolved, at least no warnings in dmesg.  Lockdep was confirmed to still be enabled.

 > I can mark the bug fixed in korg bugzilla too.

Probably we just want to add a comment saying the patch works -- the bug
should stay open until we get the fix upstream I guess.

 > Thank you Roland for looking into this, good work!

Thanks for testing!  Patch with updated changelog (including your
tested-by) below.  Jesse [Barnes] and/or Eric please review and apply:

---

i915: Fix potential AB-BA deadlock in i915_gem_execbuffer()

Lockdep warns that i915_gem_execbuffer() can trigger a page fault (which
takes mmap_sem) while holding dev->struct_mutex, while drm_vm_open()
(which is called with mmap_sem already held) takes dev->struct_mutex.
So this is a potential AB-BA deadlock.

The way that i915_gem_execbuffer() triggers a page fault is by doing
copy_to_user() when returning new buffer offsets back to userspace;
however there is no reason to hold the struct_mutex when doing this
copy, since what is being copied is the contents of an array private to
i915_gem_execbuffer() anyway.  So we can fix the potential deadlock (and
get rid of the lockdep warning) by simply moving the copy_to_user()
outside of where struct_mutex is held.

This fixes <http://bugzilla.kernel.org/show_bug.cgi?id=12491>.

Reported-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
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
