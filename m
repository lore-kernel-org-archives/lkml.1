Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbZLUR5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbZLUR5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 12:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZLUR5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 12:57:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61157 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZLUR5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 12:57:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Mon, 21 Dec 2009 17:57:08 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.32-07504-g88194c9-dirty; KDE/4.3.2; x86_64; ; )
Cc: keithp@keithp.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
       linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net
References: <200912071830.14697.arnd@arndb.de> <20091217111359.54f4c518@jbarnes-piketon> <200912211606.43789.arnd@arndb.de>
In-Reply-To: <200912211606.43789.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912211757.08305.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/a8lDDhpM/CGqVih9mrbQGX3fXokQc/iunYXB
 S+En8tJAnWjUkuuJcs4G4sEdXr598n0o0M/T49CkKiZsP5LM9g
 ckjEDTqVcAkFfb8odYhGA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 December 2009 16:06:43 Arnd Bergmann wrote:
> 
> -       if (IS_G4X(dev)) {
> -               u16 gcfgc;
> -
> -               /* Adjust render clock... */
> -               pci_read_config_word(dev->pdev, GCFGC, &gcfgc);
> -
> -               /* Down to minimum... */
> -               gcfgc &= ~GM45_GC_RENDER_CLOCK_MASK;
> -               gcfgc |= GM45_GC_RENDER_CLOCK_266_MHZ;
> -
> -               pci_write_config_word(dev->pdev, GCFGC, gcfgc);
> -       } else if (IS_I965G(dev)) {
> +       if (IS_I965G(dev)) {
>                 u16 gcfgc;

This crashed again immediately, apparently because IS_I965G is a superset
of IS_G4X (that seems counterintuitive), but not it seems to run using
this modified version of the patch (half an hour so far).

	Arnd

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3783,7 +3783,7 @@ void intel_increase_renderclock(struct drm_device *dev, bool schedule)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 
-	if (IS_IRONLAKE(dev))
+	if (IS_IRONLAKE(dev) || IS_G4X(dev))
 		return;
 
 	if (!dev_priv->render_reclock_avail) {
@@ -3792,7 +3792,7 @@ void intel_increase_renderclock(struct drm_device *dev, bool schedule)
 	}
 
 	/* Restore render clock frequency to original value */
-	if (IS_G4X(dev) || IS_I9XX(dev))
+	if (IS_I9XX(dev))
 		pci_write_config_word(dev->pdev, GCFGC, dev_priv->orig_clock);
 	else if (IS_I85X(dev))
 		pci_write_config_word(dev->pdev, HPLLCC, dev_priv->orig_clock);
@@ -3808,7 +3808,7 @@ void intel_decrease_renderclock(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 
-	if (IS_IRONLAKE(dev))
+	if (IS_IRONLAKE(dev) || IS_G4X(dev))
 		return;
 
 	if (!dev_priv->render_reclock_avail) {
@@ -3816,16 +3816,7 @@ void intel_decrease_renderclock(struct drm_device *dev)
 		return;
 	}
 
-	if (IS_G4X(dev)) {
-		u16 gcfgc;
-
-		/* Adjust render clock... */
-		pci_read_config_word(dev->pdev, GCFGC, &gcfgc);
-
-		/* Down to minimum... */
-		gcfgc &= ~GM45_GC_RENDER_CLOCK_MASK;
-		gcfgc |= GM45_GC_RENDER_CLOCK_266_MHZ;
-	} else if (IS_I965G(dev)) {
+	if (IS_I965G(dev)) {
 		u16 gcfgc;
 
 		/* Adjust render clock... */
