Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbZJBWhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbZJBWhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756356AbZJBWhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:37:42 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52184 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323AbZJBWhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:37:40 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/IVGhigcHFnnydBRGha1FV
Subject: [PATCH 1/8] omap: Fix incorrect 730 vs 850 detection
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sanjeev Premi <premi@ti.com>
Date: Fri, 02 Oct 2009 15:37:41 -0700
Message-ID: <20091002223740.11962.89469.stgit@localhost>
In-Reply-To: <20091002223510.11962.21751.stgit@localhost>
References: <20091002223510.11962.21751.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cd92204924fafbd5c7241dfd12ca3176d542e0c5 added
support for omap850. However, the patch accidentally
removed the wrong ifdef:

 #  define cpu_is_omap730()		1
 # endif
 #endif
+#else
+# if defined(CONFIG_ARCH_OMAP850)
+#  undef  cpu_is_omap850
+#  define cpu_is_omap850()		1
+# endif
+#endif

...

 void omap2_check_revision(void);

 #endif    /* defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3) */
-
-#endif

Instead of removing removing the #endif at the end of the file,
the #endif before #else should have been removed.

But we cannot have multiple #else statements as pointed out by
Alistair Buxton <a.j.buxton@gmail.com>. So the fix is to:

- remove the non-multi-omap special handling, as we need to
  detect between omap730 and omap850 anyways.

- add the missing #endif back to the end of the file

Reported-by: Sanjeev Premi <premi@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/include/mach/cpu.h |   37 ++++++++++++---------------------
 1 files changed, 14 insertions(+), 23 deletions(-)

diff --git a/arch/arm/plat-omap/include/mach/cpu.h b/arch/arm/plat-omap/include/mach/cpu.h
index 11e73d9..f129efb 100644
--- a/arch/arm/plat-omap/include/mach/cpu.h
+++ b/arch/arm/plat-omap/include/mach/cpu.h
@@ -303,32 +303,21 @@ IS_OMAP_TYPE(3430, 0x3430)
 #define cpu_is_omap2430()		0
 #define cpu_is_omap3430()		0
 
-#if defined(MULTI_OMAP1)
-# if defined(CONFIG_ARCH_OMAP730)
-#  undef  cpu_is_omap730
-#  define cpu_is_omap730()		is_omap730()
-# endif
-# if defined(CONFIG_ARCH_OMAP850)
-#  undef  cpu_is_omap850
-#  define cpu_is_omap850()		is_omap850()
-# endif
-#else
-# if defined(CONFIG_ARCH_OMAP730)
-#  undef  cpu_is_omap730
-#  define cpu_is_omap730()		1
-# endif
-#endif
-#else
-# if defined(CONFIG_ARCH_OMAP850)
-#  undef  cpu_is_omap850
-#  define cpu_is_omap850()		1
-# endif
-#endif
-
 /*
  * Whether we have MULTI_OMAP1 or not, we still need to distinguish
- * between 330 vs. 1510 and 1611B/5912 vs. 1710.
+ * between 730 vs 850, 330 vs. 1510 and 1611B/5912 vs. 1710.
  */
+
+#if defined(CONFIG_ARCH_OMAP730)
+# undef  cpu_is_omap730
+# define cpu_is_omap730()		is_omap730()
+#endif
+
+#if defined(CONFIG_ARCH_OMAP850)
+# undef  cpu_is_omap850
+# define cpu_is_omap850()		is_omap850()
+#endif
+
 #if defined(CONFIG_ARCH_OMAP15XX)
 # undef  cpu_is_omap310
 # undef  cpu_is_omap1510
@@ -433,3 +422,5 @@ IS_OMAP_TYPE(3430, 0x3430)
 
 int omap_chip_is(struct omap_chip_id oci);
 void omap2_check_revision(void);
+
+#endif

