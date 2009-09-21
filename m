Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbZIUQul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbZIUQul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbZIUQul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:50:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43364 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZIUQuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:50:40 -0400
Date: Mon, 21 Sep 2009 18:50:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] drm: Fix build failure in radeon and i915 drivers
Message-ID: <20090921165039.GA29050@elte.hu>
References: <alpine.DEB.2.00.0909210610200.26881@skynet.skynet.ie> <20090921161207.GA9741@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921161207.GA9741@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> there's a new build failure:
> 
> drivers/built-in.o: In function `drm_irq_uninstall':
> (.text+0xb719e): undefined reference to `vga_client_register'
> drivers/built-in.o: In function `drm_irq_install':
> (.text+0xb7309): undefined reference to `vga_client_register'
> drivers/built-in.o: In function `radeon_device_fini':
> (.text+0xe400f): undefined reference to `vga_client_register'
> drivers/built-in.o: In function `radeon_device_init':
> (.text+0xe455b): undefined reference to `vga_client_register'
> 
> with the attached config, introduced with upstream merge 44040f1.
> 
> At first sight it appears to be due to CONFIG_DRM_RADEON relying on 
> VGA_ARB facilities but this is not expressed in the Kconfig rules. The 
> patch below solves this - but this is just a quick patch, i have not 
> investigated any deeper.
> 
> Review of the code suggests that i915 has a similar dependency problem 
> - i fixed that too.

i've looked some more and drm_irq.o depends on vga-arb too so the patch 
below is the more complete fix IMHO.

	Ingo

------------------>
>From 0186c202fefd70291ef3b29e34543083d24f026d Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 21 Sep 2009 18:12:07 +0200
Subject: [PATCH] drm: Fix build failure in radeon and i915 drivers

this build failure:

drivers/built-in.o: In function `drm_irq_uninstall':
(.text+0xb719e): undefined reference to `vga_client_register'
drivers/built-in.o: In function `drm_irq_install':
(.text+0xb7309): undefined reference to `vga_client_register'
drivers/built-in.o: In function `radeon_device_fini':
(.text+0xe400f): undefined reference to `vga_client_register'
drivers/built-in.o: In function `radeon_device_init':
(.text+0xe455b): undefined reference to `vga_client_register'

got introduced with upstream merge 44040f1.

At first sight it appears to be due to CONFIG_DRM_RADEON relying on
VGA_ARB facilities but this is not expressed in the Kconfig rules.

drm_irq.o relies on it too - so the whole DRM facilities relies
on VGA_ARB. I've added a select to express this dependency.

VGA_ARB is not a simple option, it depends on PCI, so in theory
select is not safe - but this is a special case since DRM itself
depends on PCI too.

Cc: torvalds@linux-foundation.org
Cc: dri-devel@lists.sf.net
Cc: Dave Airlie <airlied@linux.ie>
LKML-Reference: <20090921161207.GA9741@elte.hu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/gpu/drm/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index e4d971c..6c54422 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -9,6 +9,7 @@ menuconfig DRM
 	depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG && MMU
 	select I2C
 	select I2C_ALGOBIT
+	select VGA_ARB
 	help
 	  Kernel-level support for the Direct Rendering Infrastructure (DRI)
 	  introduced in XFree86 4.0. If you say Y here, you need to select
