Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab0BSRRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:17:01 -0500
Received: from kroah.org ([198.145.64.141]:57408 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab0BSRAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:17 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:35 2010
Message-Id: <20100219163235.192149478@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: [19/93] drm/i915: handle FBC and self-refresh better
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit ee25df2bc379728c45d81e04cf87984db1425edf upstream.

On 945, we need to avoid entering self-refresh if the compressor is
busy, or we may cause display FIFO underruns leading to ugly flicker.

Fixes fdo bug #24314, kernel bug #15043.

Tested-by: Alexander Lam <lambchop468@gmail.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Tested-by: Julien Cristau <jcristau@debian.org> (fd.o #25371)
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h      |    1 +
 drivers/gpu/drm/i915/intel_display.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -329,6 +329,7 @@
 #define   FBC_CTL_PERIODIC	(1<<30)
 #define   FBC_CTL_INTERVAL_SHIFT (16)
 #define   FBC_CTL_UNCOMPRESSIBLE (1<<14)
+#define   FBC_C3_IDLE		(1<<13)
 #define   FBC_CTL_STRIDE_SHIFT	(5)
 #define   FBC_CTL_FENCENO	(1<<0)
 #define FBC_COMMAND		0x0320c
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -988,6 +988,8 @@ static void i8xx_enable_fbc(struct drm_c
 
 	/* enable it... */
 	fbc_ctl = FBC_CTL_EN | FBC_CTL_PERIODIC;
+	if (IS_I945GM(dev))
+		fbc_ctl |= FBC_C3_IDLE; /* 945 needs special SR handling */
 	fbc_ctl |= (dev_priv->cfb_pitch & 0xff) << FBC_CTL_STRIDE_SHIFT;
 	fbc_ctl |= (interval & 0x2fff) << FBC_CTL_INTERVAL_SHIFT;
 	if (obj_priv->tiling_mode != I915_TILING_NONE)


