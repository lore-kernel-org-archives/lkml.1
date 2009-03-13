Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbZCMQcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbZCMQcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759090AbZCMQan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:30:43 -0400
Received: from gw.goop.org ([64.81.55.164]:56776 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758843AbZCMQak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:30:40 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 06/15] xen: disable PAT
Date: Fri, 13 Mar 2009 09:29:47 -0700
Message-Id: <1236961796-13407-7-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236961796-13407-1-git-send-email-jeremy@goop.org>
References: <1236961796-13407-1-git-send-email-jeremy@goop.org>
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
index 2ed3715..ea1d6bb 100644
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

