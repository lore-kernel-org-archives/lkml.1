Return-Path: <linux-kernel-owner+w=401wt.eu-S1757824AbYKMTr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbYKMTr5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbYKMTem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:42 -0500
Received: from gw.goop.org ([64.81.55.164]:34426 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428AbYKMTeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:17 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 26 of 38] xen: forcibly disable PAT support
X-Mercurial-Node: 5e0d410e482fd53786aa899f1dd80b747315061f
Message-Id: <5e0d410e482fd53786aa.1226603424@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Xen imposes a particular PAT layout on all paravirtual guests which
does not match the layout Linux would like to use.

Force PAT to be disabled until this is resolved.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/x86/include/asm/pat.h |    4 ++--
 arch/x86/xen/enlighten.c   |    3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pat.h b/arch/x86/include/asm/pat.h
--- a/arch/x86/include/asm/pat.h
+++ b/arch/x86/include/asm/pat.h
@@ -6,9 +6,11 @@
 #ifdef CONFIG_X86_PAT
 extern int pat_enabled;
 extern void validate_pat_support(struct cpuinfo_x86 *c);
+extern void pat_disable(char *reason);
 #else
 static const int pat_enabled;
 static inline void validate_pat_support(struct cpuinfo_x86 *c) { }
+static inline void pat_disable(char *reason) { }
 #endif
 
 extern void pat_init(void);
@@ -17,6 +19,4 @@
 		unsigned long req_type, unsigned long *ret_type);
 extern int free_memtype(u64 start, u64 end);
 
-extern void pat_disable(char *reason);
-
 #endif /* _ASM_X86_PAT_H */
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -48,6 +48,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/reboot.h>
+#include <asm/pat.h>
 
 #include "xen-ops.h"
 #include "mmu.h"
@@ -1743,6 +1744,8 @@
 		add_preferred_console("hvc", 0, NULL);
 	}
 
+	pat_disable("PAT disabled on Xen");
+
 	xen_raw_console_write("about to get started...\n");
 
 	/* Start the world */


