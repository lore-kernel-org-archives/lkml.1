Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbZCWSMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbZCWSMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760336AbZCWSKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:10:16 -0400
Received: from adsl-69-107-72-54.dsl.pltn13.pacbell.net ([69.107.72.54]:60880
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760454AbZCWSKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:10:08 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 06/15] xen: disable PAT
Date: Mon, 23 Mar 2009 11:09:50 -0700
Message-Id: <1237831799-6568-7-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <49C45238.7050007@zytor.com>
References: <49C45238.7050007@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Impact: disable PAT under Xen

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
index 2cd07b9..d434a4e 100644
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
index 640339e..4d2a4df 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
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
index 19af31b..731c096 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -48,6 +48,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/reboot.h>
+#include <asm/pat.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -1029,6 +1030,8 @@ asmlinkage void __init xen_start_kernel(void)
 		add_preferred_console("hvc", 0, NULL);
 	}
 
+	pat_disable("PAT disabled on Xen");
+
 	xen_raw_console_write("about to get started...\n");
 
 	/* Start the world */
-- 
1.6.0.6

