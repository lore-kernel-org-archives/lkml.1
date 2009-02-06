Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZBFXWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZBFXWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 18:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbZBFXWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 18:22:10 -0500
Received: from outbound-mail-130.bluehost.com ([67.222.38.30]:53668 "HELO
	outbound-mail-130.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751780AbZBFXWI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 18:22:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=DrOxWsavs+uw7HR4J+1szgY17L3cCWfVodWbKu8+quIk4bBl+xrwrLyHECF9q6vxMvCacf+yqs9+O/JXDM7g7TQ2bavUYOvuBjSRzdYRh279E4fCymW/yXuOTl26xgRe;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Thomas =?iso-8859-15?q?Hellstr=F6m?= <thomas@shipmail.org>
Subject: Re: Gem GTT mmaps..
Date: Fri, 6 Feb 2009 15:22:05 -0800
User-Agent: KMail/1.9.10
Cc: Eric Anholt <eric@anholt.net>, DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <498A1760.7010108@shipmail.org> <200902061424.02906.jbarnes@virtuousgeek.org> <498CBC3B.6010609@shipmail.org>
In-Reply-To: <498CBC3B.6010609@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200902061522.05877.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 6, 2009 2:39 pm Thomas Hellström wrote:
> Jesse Barnes wrote:
> > On Friday, February 6, 2009 1:35 pm Thomas Hellström wrote:
> >> Jesse Barnes wrote:
> >>> On Thursday, February 5, 2009 10:37 am Jesse Barnes wrote:
> >>>> So if we leave the lookup reference around from the GTT mapping ioctl,
> >>>> that would take care of new mappings.  And if we added/removed
> >>>> references at VM open/close time, we should be covered for fork.  But
> >>>> is it ok to add a new unref in the finish ioctl for GTT mapped
> >>>> objects?  I don't think so, because we don't know for sure if the
> >>>> caller was the one that created the new fake offset (which would be
> >>>> one way of detecting whether it was GTT mapped). Seems like we need a
> >>>> new unmap ioctl?  Or we could put the mapping ref/unref in libdrm,
> >>>> where it would be tracked on a per-process basis...
> >>>
> >>> Ah but maybe we should just tear down the fake offset at unmap time;
> >>> then we'd be able to use it as an existence test for the mapping and
> >>> get the refcounting right.  The last thing I thought of was whether
> >>> we'd be ok in a map_gtt -> crash case.  I *think* the vm_close code
> >>> will deal with that, if we do a deref there?
> >>
> >> Yes, an mmap() is always paired with a vm_close(), and the vm_close()
> >> also happens in a crash situation.
> >
> > This one should cover the cases you found.
> >   - ref at map time will keep the object around so fault shouldn't fail
> >   - additional threads will take their refs in vm_open/close
> >   - unmap will unref and remove mmap_offset allowing object to be freed
>
> Jesse,
>
> Yes, it looks OK to me.
> A short question, though, when is i915_gem_sw_finish_ioctl called? Is it
> possible that the client may still think its mmap offset is valid?

It's called at drm_bo_unmap time, but only if the swrast bit is set, so we'd
need to do that in libdrm as well.  So if the program is written properly it
shouldn't think the mapping is valid (we should probably set bo->virtual to
0 in unmap as well, to catch those errors).

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/libdrm/intel/intel_bufmgr_gem.c b/libdrm/intel/intel_bufmgr_gem.c
index f578a67..1ea4761 100644
--- a/libdrm/intel/intel_bufmgr_gem.c
+++ b/libdrm/intel/intel_bufmgr_gem.c
@@ -670,6 +670,7 @@ drm_intel_gem_bo_map_gtt(drm_intel_bo *bo)
        }
     }

+    bo_gem->swrast = 1;
     bo->virtual = bo_gem->virtual;

     DBG("bo_map: %d (%s) -> %p\n", bo_gem->gem_handle, bo_gem->name,
@@ -716,6 +717,8 @@ drm_intel_gem_bo_unmap(drm_intel_bo *bo)
        } while (ret == -1 && errno == EINTR);
        bo_gem->swrast = 0;
     }
+    bo_gem->virtual = NULL;
+    bo->virtual = NULL;
     pthread_mutex_unlock(&bufmgr_gem->lock);
     return 0;
 }
