Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbZGABTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbZGABTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761625AbZGAAgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:36:05 -0400
Received: from kroah.org ([198.145.64.141]:60778 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761623AbZGAAgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:36:03 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:46 2009
Message-Id: <20090701002445.747864187@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       Jie Luo <clotho67@gmail.com>
Subject: [patch 107/108] drm/i915: correct suspend/resume ordering
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-correct-suspend-resume-ordering.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 9e06dd39f2b6d7e35981e0d7aded618686b32ccb upstream.

We need to save register state *after* idling GEM, clearing the ring,
and uninstalling the IRQ handler, or we might end up saving bogus
fence regs, for one.  Our restore ordering should already be correct,
since we do GEM, ring and IRQ init after restoring the last register
state, which prevents us from clobbering things.

I put this together to potentially address a bug, but I haven't heard
back if it fixes it yet.  However I think it stands on its own, so I'm
sending it in.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Cc: Jie Luo <clotho67@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -67,8 +67,6 @@ static int i915_suspend(struct drm_devic
 
 	pci_save_state(dev->pdev);
 
-	i915_save_state(dev);
-
 	/* If KMS is active, we do the leavevt stuff here */
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
 		if (i915_gem_idle(dev))
@@ -77,6 +75,8 @@ static int i915_suspend(struct drm_devic
 		drm_irq_uninstall(dev);
 	}
 
+	i915_save_state(dev);
+
 	intel_opregion_free(dev, 1);
 
 	if (state.event == PM_EVENT_SUSPEND) {


