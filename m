Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbZFUVjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbZFUVjl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 17:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZFUVje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 17:39:34 -0400
Received: from ev1s-66-98-244-53.theplanet.com ([66.98.244.53]:2571 "EHLO
	relay.fireflyinternet.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751774AbZFUVjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 17:39:33 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Jun 2009 17:39:33 EDT
Subject: Re: [git pull] drm: previous pull req + 1.
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
In-Reply-To: <1245595658.4805.17.camel@localhost>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <1245542690.6104.6.camel@localhost>
	 <alpine.LFD.2.01.0906201741290.3119@localhost.localdomain>
	 <1245595658.4805.17.camel@localhost>
Content-Type: text/plain
Date: Sun, 21 Jun 2009 22:24:16 +0100
Message-Id: <1245619456.4937.35.camel@tiger>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-21 at 17:47 +0300, Maxim Levitsky wrote:
> > 52dc7d32b88156248167864f77a9026abe27b432 is first bad commit
> > commit 52dc7d32b88156248167864f77a9026abe27b432
> > Author: Chris Wilson <chris@chris-wilson.co.uk>
> > Date:   Sat Jun 6 09:46:01 2009 +0100

The error here seems to be my presumption that only the i915 was using
fences for GPU access. (In hindsight, it seems obvious that we do not
know why the fence was allocated for the object and so if it has
outstanding rendering, we must assume that it is using a fence for a
rendering op.)

To confirm, please can you try:

diff --git a/drivers/gpu/drm/i915/i915_gem.c
b/drivers/gpu/drm/i915/i915_gem.c
index fd2b8bd..0735518 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2347,7 +2347,7 @@ i915_gem_object_put_fence_reg(struct
drm_gem_object *obj)
         * therefore we must wait for any outstanding access to complete
         * before clearing the fence.
         */
-       if (!IS_I965G(dev)) {
+       if (1) {
                int ret;
 
                i915_gem_object_flush_gpu_write_domain(obj);

(I'm travelling tomorrow, so if this does turn out to be the fault, I'd
appreciate it if someone wrote it up as a complete patch.)

> However I can't reproduce the situation I have earlier, maybe I have changed some settings, don't know.
> Now, the bad behavior (and I reproduced it many times, is that GE shows incorrect textures 
> (like they are divided in tiny interlaced rows, one row ok, other contain image from other part of world), only few textures are such
> it seems logical that this is related to tiling.

What you describe is exactly the artefact you would see when you access
a tiled texture using linear addressing. Pretty conclusive evidence that
we do need to flush outstanding GPU access.

> Also, if I maximize it, it hangs. This seems to be a separate bug introduced by these series.

It does seem like a separate bug. Hopefully, we can get a better handle
on it after we fix this obnoxious tiling issue.
-ickle

