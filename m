Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbYGIX20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbYGIX20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 19:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbYGIX2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 19:28:18 -0400
Received: from sh.osrg.net ([192.16.179.4]:35055 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbYGIX2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 19:28:17 -0400
Date: Thu, 10 Jul 2008 08:27:49 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] replace CONFIG_IOMMU with CONFIG_GART_IOMMU in iommu.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080709085230.GA6267@elte.hu>
References: <20080709162913H.tomof@acm.org>
	<20080709085230.GA6267@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080710082753T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008 10:52:30 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > Should be CONFIG_GART_IOMMU instead of CONFIG_IOMMU here?
> > 
> > Hmm, looks like it would be nice to have more cleanups of iommu.h and 
> > gart.h.
> > 
> > This is against tip/master.
> 
> applied to tip/x86/core, thanks!
> 
> agreed about the cleanups. We are willing to test RFC patches :-)

Ok, how about this?

If you are fine with the intention of this, then I'll send the
follow-up cleanups.

Note that iommu.h includes some gart things that everyone needs. If
you like, I'll rename gart.h gart_priv.h (or something) and move the
gart stuff in iommu.h to gart.h.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] x86: remove duplications in iommu.h and gart.h

This remove lots of duplications in iommu.h and gart.h.

The end result of this patch is:

- iommu.h is a header file for everyone related with IOMMUs.

- gart.h is the private header file. Only pci-gart_64.c and its
friends include it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/asm-x86/gart.h  |   34 ++++------------------------------
 include/asm-x86/iommu.h |   29 +++++++++++++++++------------
 2 files changed, 21 insertions(+), 42 deletions(-)

diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
index 417f76e..33b9aee 100644
--- a/include/asm-x86/gart.h
+++ b/include/asm-x86/gart.h
@@ -1,40 +1,14 @@
-#ifndef _ASM_X8664_IOMMU_H
-#define _ASM_X8664_IOMMU_H 1
+#ifndef _ASM_X8664_GART_H
+#define _ASM_X8664_GART_H 1
 
 #include <asm/e820.h>
+#include <asm/iommu.h>
 
-extern void pci_iommu_shutdown(void);
-extern void no_iommu_init(void);
-extern int force_iommu, no_iommu;
-extern int iommu_detected;
-extern int agp_amd64_init(void);
-#ifdef CONFIG_GART_IOMMU
-extern void gart_iommu_init(void);
-extern void gart_iommu_shutdown(void);
-extern void __init gart_parse_options(char *);
-extern void early_gart_iommu_check(void);
-extern void gart_iommu_hole_init(void);
 extern void set_up_gart_resume(u32, u32);
+
 extern int fallback_aper_order;
 extern int fallback_aper_force;
-extern int gart_iommu_aperture;
-extern int gart_iommu_aperture_allowed;
-extern int gart_iommu_aperture_disabled;
 extern int fix_aperture;
-#else
-#define gart_iommu_aperture		0
-#define gart_iommu_aperture_allowed	0
-#define gart_iommu_aperture_disabled	1
-
-static inline void early_gart_iommu_check(void)
-{
-}
-
-static inline void gart_iommu_shutdown(void)
-{
-}
-
-#endif
 
 /* PTE bits. */
 #define GPTE_VALID	1
diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
index cb7e989..068c9a4 100644
--- a/include/asm-x86/iommu.h
+++ b/include/asm-x86/iommu.h
@@ -1,29 +1,34 @@
-#ifndef _ASM_X8664_GART_H
-#define _ASM_X8664_GART_H 1
+#ifndef _ASM_X8664_IOMMU_H
+#define _ASM_X8664_IOMMU_H 1
 
 extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
+
 #ifdef CONFIG_GART_IOMMU
+extern int gart_iommu_aperture;
+extern int gart_iommu_aperture_allowed;
+extern int gart_iommu_aperture_disabled;
+
+extern void early_gart_iommu_check(void);
 extern void gart_iommu_init(void);
 extern void gart_iommu_shutdown(void);
 extern void __init gart_parse_options(char *);
-extern void iommu_hole_init(void);
-extern int fallback_aper_order;
-extern int fallback_aper_force;
-extern int iommu_aperture;
-extern int iommu_aperture_allowed;
-extern int iommu_aperture_disabled;
-extern int fix_aperture;
+extern void gart_iommu_hole_init(void);
+
 #else
-#define iommu_aperture 0
-#define iommu_aperture_allowed 0
+#define gart_iommu_aperture            0
+#define gart_iommu_aperture_allowed    0
+#define gart_iommu_aperture_disabled   1
 
-static inline void gart_iommu_shutdown(void)
+static inline void early_gart_iommu_check(void)
 {
 }
 
+static inline void gart_iommu_shutdown(void)
+{
+}
 #endif
 
 #endif
-- 
1.5.5.GIT

