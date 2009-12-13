Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbZLMMTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbZLMMTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 07:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZLMMTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 07:19:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62333 "HELO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753009AbZLMMTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 07:19:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Airlie <airlied@redhat.com>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Sun, 13 Dec 2009 12:18:24 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.32-06486-g053fe57-dirty; KDE/4.3.2; x86_64; ; )
Cc: Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, keithp@keithp.com, eric@anholt.net,
       jbarnes@virtuousgeek.org, Daniel Vetter <daniel.vetter@ffwll.ch>
References: <200912071830.14697.arnd@arndb.de> <200912090007.45545.arnd@arndb.de> <1260337087.3658.1.camel@t60prh>
In-Reply-To: <1260337087.3658.1.camel@t60prh>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912131218.24426.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18b/SmNoFtoJ9TT+pdGRLHuc8586KeAw71DsxP
 GK/ivETlYlqXXVTCFXoqBjZBNTSaQZAbJsr3dEXKAUkup6ro/1
 n3VjPyj2RH5G9oHdNdU6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 December 2009 05:38:07 Dave Airlie wrote:
> On Wed, 2009-12-09 at 00:07 +0100, Arnd Bergmann wrote:
> > On Tuesday 08 December 2009, Dave Airlie wrote:
> > > > 
> > > > Sorry for blaming the wrong patch, especially if it already caused a lot 
> > > > of work. I'll try blaming ec2a4c3fdc8 "drm/i915: get the bridge device
> > > > once" now, that is the next-best candidate that my bisection pointed to,
> > > > but I'll do more rigorous testing.
> > 
> > It just crashed again with both 620f378 and ec2a4c3fdc8 reverted as well, 
> > after about an hour of uptime.
> > 
> ...
> 
> regression since 2.6.31 by the looks of it, bisection has found two
> false positives so far.

I did a more thorough bisection this time, which points to c05422d52ee6b
"drm/i915: remove open-coded drm_mode_object_find". The system crashed
within minutes with 2.6.32-git and with c05422d52ee6b, but stayed up
for 12 hours on identical kernels with this one reverted:

>  From c05422d52ee6b4cff8b63eab1a7351780518fc5e Mon Sep 17 00:00:00 2001
>  From: Daniel Vetter <daniel.vetter@ffwll.ch>
>  Date: Tue, 11 Aug 2009 16:05:30 +0200
>  Subject: [PATCH] drm/i915: remove open-coded drm_mode_object_find
>
>  And clean up a small whitespace goof-up in the same function, while
>  I was looking at it.
>
>  Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>  Signed-off-by: Eric Anholt <eric@anholt.net>

Given that my last bisection went wrong and I can't prove why this
patch is bad, I'd of course like to see some insight about what
could go wrong here, but at least reverting it should not be able
to cause any harm.

---

[PATCH] drm/i915: revert c05422d52 "remove open-coded drm_mode_object_find"

The patch was meant as a cleanup, but apparently caused random hangs
on my machine.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Eric Anholt <eric@anholt.net>

diff --git b/drivers/gpu/drm/i915/intel_display.c a/drivers/gpu/drm/i915/intel_display.c
index f0f38f5..35e8619 100644
--- b/drivers/gpu/drm/i915/intel_display.c
+++ a/drivers/gpu/drm/i915/intel_display.c
@@ -3557,26 +3557,30 @@ int intel_get_pipe_from_crtc_id(struct drm_device *dev, void *data,
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct drm_i915_get_pipe_from_crtc_id *pipe_from_crtc_id = data;
-	struct drm_mode_object *drmmode_obj;
-	struct intel_crtc *crtc;
+	struct drm_crtc *crtc = NULL;
+	int pipe = -1;
 
 	if (!dev_priv) {
 		DRM_ERROR("called with no initialization\n");
 		return -EINVAL;
 	}
 
-	drmmode_obj = drm_mode_object_find(dev, pipe_from_crtc_id->crtc_id,
-			DRM_MODE_OBJECT_CRTC);
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+		struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
+		if (crtc->base.id == pipe_from_crtc_id->crtc_id) {
+			pipe = intel_crtc->pipe;
+			break;
+		}
+	}
 
-	if (!drmmode_obj) {
+	if (pipe == -1) {
 		DRM_ERROR("no such CRTC id\n");
 		return -EINVAL;
 	}
 
-	crtc = to_intel_crtc(obj_to_crtc(drmmode_obj));
-	pipe_from_crtc_id->pipe = crtc->pipe;
+	pipe_from_crtc_id->pipe = pipe;
 
-	return 0;
+	return 0;
 }
 
 struct drm_crtc *intel_get_crtc_from_pipe(struct drm_device *dev, int pipe)
