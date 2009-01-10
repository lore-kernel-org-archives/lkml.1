Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZAJXu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZAJXu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZAJXuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:50:20 -0500
Received: from mga10.intel.com ([192.55.52.92]:16247 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778AbZAJXuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:50:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,246,1231142400"; 
   d="scan'208";a="421302201"
Subject: Re: [git pull] drm
From: Richard Purdie <rpurdie@linux.intel.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <21d7e9970901101504w2c21ca22t9106770c4ada696c@mail.gmail.com>
References: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie>
	 <1231513655.5317.30.camel@dax.rpnet.com>
	 <1231524232.5317.43.camel@dax.rpnet.com>
	 <1231550011.5317.72.camel@dax.rpnet.com>
	 <21d7e9970901091804x61e2ba3cofd37d536df2d48b3@mail.gmail.com>
	 <1231581491.5330.8.camel@dax.rpnet.com>
	 <21d7e9970901101504w2c21ca22t9106770c4ada696c@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 23:51:00 +0000
Message-Id: <1231631460.5330.25.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 09:04 +1000, Dave Airlie wrote:
> On Sat, Jan 10, 2009 at 7:58 PM, Richard Purdie <rpurdie@linux.intel.com> wrote:
> > I have a question though, where in the i915 driver is
> > master_priv->sarea_priv assigned a value? or master_priv->sarea for that
> > matter? As far as I can tell those pointers are never assigned values?
> > Is there a drm_getsarea() call missing?
> >
> > Perhaps my patch fixes things since sarea and sarea_priv are given a
> > value?
> >
> 
> Does the attached patch work?

If its fixed to compile, it fixes the problem. I don't know if your
making this against some other tree or it was just a typo so I've
attached the fixed version that worked for me below.

> Somehow this code was tested on DRI2 which needs no sarea, and we missed the bit
> to setup the DRI1 sarea, this patch should dtrt.

Makes sense, thanks.


[PATCH] drm/i915: setup sarea properly in master_priv

If we are running DRI1 userspace, we really need to set the sarea up
properly.

Signed-off-by: Richard Purdie <rpurdie@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 62a4bf7..868f574 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -177,6 +177,14 @@ static int i915_initialize(struct drm_device * dev, drm_i915_init_t * init)
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
 
+	master_priv->sarea = drm_getsarea(dev);
+	if (master_priv->sarea) {
+		master_priv->sarea_priv = (drm_i915_sarea_t *)
+			((u8 *)master_priv->sarea->handle + init->sarea_priv_offset);
+	} else {
+		DRM_DEBUG("sarea not found assuming DRI2 userspace\n");
+	}
+
 	if (init->ring_size != 0) {
 		if (dev_priv->ring.ring_obj != NULL) {
 			i915_dma_cleanup(dev);

