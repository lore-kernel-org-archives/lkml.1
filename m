Return-Path: <linux-kernel-owner+w=401wt.eu-S1763982AbZCTXjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763982AbZCTXjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762612AbZCTXY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:58 -0400
Received: from kroah.org ([198.145.64.141]:48840 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760013AbZCTXY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:29 2009
Message-Id: <20090320222929.036450372@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>, Dave Airlie <airlied@linux.ie>
Subject: [patch 39/43] drm/i915: dont enable vblanks on disabled pipes
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-don-t-enable-vblanks-on-disabled-pipes.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 71e0ffa599f54058d9b8724b4b14d0486751681d upstream.

In some cases userland may be confused and try to wait on vblank events from
pipes that aren't actually enabled.  We shouldn't allow this, so return
-EINVAL if the pipe isn't on.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_irq.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -400,6 +400,12 @@ int i915_enable_vblank(struct drm_device
 {
 	drm_i915_private_t *dev_priv = (drm_i915_private_t *) dev->dev_private;
 	unsigned long irqflags;
+	int pipeconf_reg = (pipe == 0) ? PIPEACONF : PIPEBCONF;
+	u32 pipeconf;
+
+	pipeconf = I915_READ(pipeconf_reg);
+	if (!(pipeconf & PIPEACONF_ENABLE))
+		return -EINVAL;
 
 	spin_lock_irqsave(&dev_priv->user_irq_lock, irqflags);
 	if (IS_I965G(dev))


