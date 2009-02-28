Return-Path: <linux-kernel-owner+w=401wt.eu-S1762668AbZB1CDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762668AbZB1CDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 21:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757828AbZB1B7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:59:34 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:59182
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756453AbZB1B7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:59:30 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH] xen: disable PAT
Date: Fri, 27 Feb 2009 17:59:13 -0800
Message-Id: <1235786365-17744-8-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1235786365-17744-1-git-send-email-jeremy@goop.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Xen imposes a particular PAT layout on all paravirtual guests which
does not match the layout Linux would like to use.

Force PAT to be disabled until this is resolved.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/x86/include/asm/pat.h |    5 +++++
 arch/x86/mm/pat.c          |    5 -----
 arch/x86/xen/enlighten.c   |    3 +++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/pat.h b/arch/x86/include/asm/pat.h
index 9709fdf..d8be231 100644
--- a/arch/x86/include/asm/pat.h
+++ b/arch/x86/include/asm/pat.h
@@ -5,8 +5,13 @@
 
 #ifdef CONFIG_X86_PAT
 extern int pat_enabled;
+extern void pat_disable(const char *reason);
 #else
 static const int pat_enabled;
+static inline void pat_disable(const char *reason)
+{
+	(void)reason;
+}
 #endif
 
 extern void pat_init(void);
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 05f9aef..37df685 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -42,11 +42,6 @@ static int __init nopat(char *str)
 	return 0;
 }
 early_param("nopat", nopat);
-#else
-static inline void pat_disable(const char *reason)
-{
-	(void)reason;
-}
 #endif
 
 
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 468aa23..1b89d1c 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -48,6 +48,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/reboot.h>
+#include <asm/pat.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -986,6 +987,8 @@ asmlinkage void __init xen_start_kernel(void)
 		add_preferred_console("hvc", 0, NULL);
 	}
 
+	pat_disable("PAT disabled on Xen");
+
 	xen_raw_console_write("about to get started...\n");
 
 	/* Start the world */
-- 
1.6.0.6

