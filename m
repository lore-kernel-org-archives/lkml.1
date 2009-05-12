Return-Path: <linux-kernel-owner+w=401wt.eu-S1759289AbZEMDQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289AbZEMDQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756422AbZEMDG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:29 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36240
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756120AbZEMDGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:12 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 06/16] xen: disable PAT
Date: Tue, 12 May 2009 14:28:28 -0700
Message-Id: <1242163718-2934-7-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242163718-2934-1-git-send-email-jeremy@goop.org>
References: <1242163718-2934-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Xen imposes a particular PAT layout on all paravirtual guests which
does not match the layout Linux would like to use.

Force PAT to be disabled until this is resolved.

[ Impact: disable PAT under Xen, due to incompatible configurations ]

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/pat.h |    5 +++++
 arch/x86/mm/pat.c          |    7 +------
 arch/x86/xen/enlighten.c   |    3 +++
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pat.h b/arch/x86/include/asm/pat.h
index 7af14e5..fe7be93 100644
--- a/arch/x86/include/asm/pat.h
+++ b/arch/x86/include/asm/pat.h
@@ -6,8 +6,13 @@
 
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
index e6718bb..5ba8d88 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -31,7 +31,7 @@
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_enabled = 1;
 
-static inline void pat_disable(const char *reason)
+void pat_disable(const char *reason)
 {
 	pat_enabled = 0;
 	printk(KERN_INFO "%s\n", reason);
@@ -43,11 +43,6 @@ static int __init nopat(char *str)
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
index 50580fc..89f47da 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -51,6 +51,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/reboot.h>
+#include <asm/pat.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -1085,6 +1086,8 @@ asmlinkage void __init xen_start_kernel(void)
 		add_preferred_console("hvc", 0, NULL);
 	}
 
+	pat_disable("PAT disabled on Xen");
+
 	xen_raw_console_write("about to get started...\n");
 
 	/* Start the world */
-- 
1.6.0.6

