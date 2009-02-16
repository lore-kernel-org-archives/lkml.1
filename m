Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbZBPXsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbZBPXsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZBPXqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:46:22 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:50808
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752807AbZBPXqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:46:18 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 07/19] xen: disable PAT
Date: Mon, 16 Feb 2009 15:46:00 -0800
Message-Id: <630b678d3259163fc237f673b6f2a4a5fa76ac25.1234826723.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <83b1377d81029933b769798dbe1ca134f6d365ae.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <edde7fdd064390d321bdafcfb993b28b4d2588b1.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <9fbd402b72d6c494f453ff86e071ac1b2658ece9.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f47f399029ba9035a14ae381b6ae504a5c5bd445.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f1402ed2345e1d654faa823afefa53fc4745e368.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <f0d2b3f946de1b3398c278c7a33069f670b78268.1234826723.git.jeremy.fitzhardinge@citrix.com>
 <83b1377d81029933b769798dbe1ca134f6d365ae.1234826723.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234826723.git.jeremy.fitzhardinge@citrix.com>
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

