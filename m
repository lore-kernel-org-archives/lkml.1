Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbZLUQH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbZLUQH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbZLUQH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:07:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60040 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602AbZLUQH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:07:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when ..."
Date: Mon, 21 Dec 2009 16:06:43 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.32-07504-g88194c9-dirty; KDE/4.3.2; x86_64; ; )
Cc: keithp@keithp.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
       linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net
References: <200912071830.14697.arnd@arndb.de> <200912171852.02906.arnd@arndb.de> <20091217111359.54f4c518@jbarnes-piketon>
In-Reply-To: <20091217111359.54f4c518@jbarnes-piketon>
MIME-Version: 1.0
Message-Id: <200912211606.43789.arnd@arndb.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18OS37mWrEeOMYDw1T0B1Z/JkZgu8a5rih+uMf
 WHygU9jwdFDokHzPbsBKQksH7JDzWDIT0/ksr+qcyD7IKSeSZO
 InD7L057a+EpvC78r05cA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 December 2009 19:13:59 Jesse Barnes wrote:
> Another patch to try...

The machine has been working fine for almost two days with this.

> -
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

Interestingly, I could not even find GCFGC in the public documentation,
but it also doesn't seem to be what it was in older chips.

The value in there is 0x0025, which does not make any sense whatsoever
according to the definitions in the header file. Writing
GM45_GC_RENDER_CLOCK_266_MHZ in there manually does not seem to have an
effect either, the machine does not crash and the value still remains
at 0x0025.

I tried "while true ; do sudo setpci -s 00:02.1 f0.W=0028 ; done".

I'll try the patch below next, not touching the register at all.

> -/* Note that no increase function is needed for this - increase_renderclock()
> - *  will also rewrite these bits
> - */
> -void intel_decrease_displayclock(struct drm_device *dev)
> -{
> -       if (IS_IRONLAKE(dev))
> -               return;
> -
> -       if (IS_I945G(dev) || IS_I945GM(dev) || IS_I915G(dev) ||
> -           IS_I915GM(dev)) {
> -               u16 gcfgc;
> -
> -               /* Adjust render clock... */
> -               pci_read_config_word(dev->pdev, GCFGC, &gcfgc);
> -
> -               /* Down to minimum... */
> -               gcfgc &= ~0xf0;
> -               gcfgc |= 0x80;
> -
> -               pci_write_config_word(dev->pdev, GCFGC, gcfgc);
> -       }
> -}

This does not do anything on G4X, right? I actually put this function
back in (still doesn't crash), but then I noticed that the registers
are not accessed at all on my machine in this function.

	Arnd

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3792,7 +3792,7 @@ void intel_increase_renderclock(struct drm_device *dev, bool schedule)
 	}
 
 	/* Restore render clock frequency to original value */
-	if (IS_G4X(dev) || IS_I9XX(dev))
+	if (IS_I9XX(dev))
 		pci_write_config_word(dev->pdev, GCFGC, dev_priv->orig_clock);
 	else if (IS_I85X(dev))
 		pci_write_config_word(dev->pdev, HPLLCC, dev_priv->orig_clock);
@@ -3816,18 +3816,7 @@ void intel_decrease_renderclock(struct drm_device *dev)
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
-
-		pci_write_config_word(dev->pdev, GCFGC, gcfgc);
-	} else if (IS_I965G(dev)) {
+	if (IS_I965G(dev)) {
 		u16 gcfgc;
 
 		/* Adjust render clock... */
