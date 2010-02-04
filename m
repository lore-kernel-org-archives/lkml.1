Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0BDJjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:39:24 -0500
Received: from mga07.intel.com ([143.182.124.22]:39390 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753426Ab0BDJjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:39:22 -0500
Message-Id: <89k83a$756q97@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,403,1262592000"; 
   d="scan'208";a="240347431"
Date: Thu, 04 Feb 2010 09:39:17 +0000
To: Tejun Heo <tj@kernel.org>, Andy Isaacson <adi@hexapodia.org>
Subject: Re: [2.6.33-rc6-git regression] idr fix breaks Xorg
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20100204012837.GC538@hexapodia.org> <20100204075642.GA28286@hexapodia.org> <4B6A8278.8070001@kernel.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <4B6A8278.8070001@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Feb 2010 17:16:56 +0900, Tejun Heo <tj@kernel.org> wrote:
> Hello,
> 
> On 02/04/2010 04:56 PM, Andy Isaacson wrote:
> > 1265267921.568269 ioctl(8, 0xc020645e, 0x7fffe2196980) = -1 EBADF (Bad file descriptor)
> 
> Hmm... -EBADF?  I suppose it doesn't mean that the fd is invalid in
> this case but that the mapped object can't be found for some reason?
> Can anyone more familiar with the subsystem explain what's going on?

Correct, in this case we pass in an 'fd' via the ioctl that we wish to
mmap. idr is then used to translate that handle back to one of our buffer
objects, which is then prepared for mapping.

In this context, it is the immediate lookup of the handle following
allocation that is failing. The critical bit of code lives in
drivers/gpu/drm/drm_gem.c:

int
drm_gem_handle_create(struct drm_file *file_priv,
                       struct drm_gem_object *obj,
                       u32 *handlep)
{
        int     ret;

        /*
         * Get the user-visible handle using idr.
         */
again:
        /* ensure there is space available to allocate a handle */
        if (idr_pre_get(&file_priv->object_idr, GFP_KERNEL) == 0)
                return -ENOMEM;

        /* do the allocation under our spinlock */
        spin_lock(&file_priv->table_lock);
        ret = idr_get_new_above(&file_priv->object_idr, obj, 1, (int
*)handlep);
        spin_unlock(&file_priv->table_lock);
        if (ret == -EAGAIN)
                goto again;

        if (ret != 0)
                return ret;

        drm_gem_object_handle_reference(obj);
        return 0;
}

struct drm_gem_object *
drm_gem_object_lookup(struct drm_device *dev, struct drm_file *filp,
                      u32 handle)
{
        struct drm_gem_object *obj;

        spin_lock(&filp->table_lock);

        /* Check if we currently have a reference on the object */
        obj = idr_find(&filp->object_idr, handle);
        if (obj == NULL) {
                spin_unlock(&filp->table_lock);
                return NULL;
        }

        drm_gem_object_reference(obj);

        spin_unlock(&filp->table_lock);

        return obj;
}

Can you see any problems here?

> 
> > 1265267921.568649 write(2, "../../../libdrm/intel/intel_bufmgr_gem.c:637: Error mapping buffer 1073741824 (gen4 WM state): Bad file descriptor .\n", 117) = 117
> > 1265267921.569039 --- SIGSEGV (Segmentation fault) @ 0 (0) ---

This SEGV is just lazy error handling in the userspace driver; the
impossible just happened.
-ickle

-- 
Chris Wilson, Intel Open Source Technology Centre
