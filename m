Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbZIVD4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbZIVD4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 23:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZIVD4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 23:56:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51896 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbZIVD4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 23:56:12 -0400
Date: Tue, 22 Sep 2009 04:56:17 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Ingo Molnar <mingo@elte.hu>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [origin tree build failure] [PATCH] Re: [git pull] drm tree.
In-Reply-To: <20090921161207.GA9741@elte.hu>
Message-ID: <alpine.DEB.2.00.0909220450440.7648@skynet.skynet.ie>
References: <alpine.DEB.2.00.0909210610200.26881@skynet.skynet.ie> <20090921161207.GA9741@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
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
> Review of the code suggests that i915 has a similar dependency problem - 
> i fixed that too.

The way it should work is VGA ARB should be enabled on any platforms we
have PCI unless EMBEDDED turns it off, since arbitration of VGA isn't 
reliant on a drm device, I'm not sure what Kconfig magic this would 
require, and where it would need to be. This patch should at least allow
builds to work until I figure out any Kconfig magic.

>From 8a874578cbf8b07b988e666c15fa0ba767f3c1cb Mon Sep 17 00:00:00 2001
From: Dave Airlie <airlied@redhat.com>
Date: Tue, 22 Sep 2009 13:53:00 +1000
Subject: [PATCH] vgaarb: wrap the client register API so we can disable VGA ARB.

This provides an dummy register function so everything builds
if VGA arb is turned off.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 include/linux/vgaarb.h |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index e81c64a..b0feb79 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -41,7 +41,7 @@
  *     interrupts at any time.
  */
 extern void vga_set_legacy_decoding(struct pci_dev *pdev,
-									unsigned int decodes);
+				    unsigned int decodes);
 
 /**
  *     vga_get         - acquire & locks VGA resources
@@ -193,8 +193,17 @@ static inline int vga_conflicts(struct pci_dev *p1, struct pci_dev *p2)
  * They driver will get a callback when VGA arbitration is first used
  * by userspace since we some older X servers have issues.
  */
+#if defined(CONFIG_VGA_ARB)
 int vga_client_register(struct pci_dev *pdev, void *cookie,
 			void (*irq_set_state)(void *cookie, bool state),
 			unsigned int (*set_vga_decode)(void *cookie, bool state));
+#else
+static inline int vga_client_register(struct pci_dev *pdev, void *cookie,
+				      void (*irq_set_state)(void *cookie, bool state),
+				      unsigned int (*set_vga_decode)(void *cookie, bool state));
+{
+	return 0;
+}
+#endif
 
 #endif /* LINUX_VGA_H */
-- 
1.6.0.6

