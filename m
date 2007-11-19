Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbXKSWBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbXKSWBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbXKSWBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:01:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbXKSWBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:01:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 01/18] x86 vDSO: generate vdso-syms.lds
In-Reply-To: Roland McGrath's message of  Monday, 19 November 2007 13:59:43 -0800 <20071119215944.01B7C26F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
X-Shopping-List: (1) Transoceanic commendations
   (2) Recalcitrant stimulating fruit
   (3) Chic mispronunciations
   (4) Heterogeneous miraculous destroyer yies
Message-Id: <20071119220116.7EA4426F8BE@magilla.localdomain>
Date: Mon, 19 Nov 2007 14:01:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds a new way of extracting symbols from the built vDSO image.
This is much simpler and less fragile than using ld -R; it removes the
need to control the DSO layout quite so exactly.  I was clearly unduly
distracted by clever ld uses when I did the original vDSO implementation.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/vdso/Makefile   |   14 ++++++++++++++
 arch/x86/vdso/vdso.lds.S |   10 ++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index e7bff0f..d8200ad 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -55,6 +55,20 @@ SYSCFLAGS_vdso-syms.o = -r -d
 $(obj)/vdso-syms.o: $(src)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,syscall)
 
+targets += vdso-syms.lds
+obj-y += vdso-syms.lds
+
+#
+# Match symbols in the DSO that look like VDSO*; produce a file of constants.
+#
+sed-vdsosym := -e 's/^00*/0/' \
+	-e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$$/\2 = 0x\1;/p'
+quiet_cmd_vdsosym = VDSOSYM $@
+      cmd_vdsosym = $(NM) $< | sed -n $(sed-vdsosym) | LC_ALL=C sort > $@
+
+$(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
+	$(call if_changed,vdsosym)
+
 quiet_cmd_vdso_install = INSTALL $@
       cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
 vdso.so:
diff --git a/arch/x86/vdso/vdso.lds.S b/arch/x86/vdso/vdso.lds.S
index 667d324..d40d0e9 100644
--- a/arch/x86/vdso/vdso.lds.S
+++ b/arch/x86/vdso/vdso.lds.S
@@ -8,6 +8,16 @@
 
 #define VDSO_PRELINK 0xffffffffff700000
 
+/*
+ * Symbols we define here called VDSO* get their values into vdso-syms.lds
+ * and become visible to the kernel itself.
+ */
+VDSO64_PRELINK = VDSO_PRELINK;
+
+#define VEXTERN(x)	VDSO64_ ## x = vdso_ ## x;
+#include "vextern.h"
+#undef	VEXTERN
+
 SECTIONS
 {
   . = VDSO_PRELINK + SIZEOF_HEADERS;
