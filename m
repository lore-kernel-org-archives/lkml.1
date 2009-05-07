Return-Path: <linux-kernel-owner+w=401wt.eu-S1762678AbZEGS6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678AbZEGS6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761685AbZEGS5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:57:33 -0400
Received: from gw.goop.org ([64.81.55.164]:40221 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761598AbZEGS5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:57:32 -0400
Message-ID: <4A032EDF.9080502@goop.org>
Date: Thu, 07 May 2009 11:56:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH 1/5] xen/x86-64: fix breakpoints and hardware watchpoints
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Native x86-64 uses the IST mechanism to run int3 and debug traps on
an alternative stack.  Xen does not do this, and so the frames were
being misinterpreted by the ptrace code.  This change special-cases
these two exceptions by using Xen variants which run on the normal
kernel stack properly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/traps.h |    2 ++
 arch/x86/kernel/entry_64.S   |    4 ++++
 arch/x86/xen/enlighten.c     |   17 ++++++++++++++++-
 3 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0d53425..d696185 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -13,6 +13,8 @@ asmlinkage void divide_error(void);
 asmlinkage void debug(void);
 asmlinkage void nmi(void);
 asmlinkage void int3(void);
+asmlinkage void xen_debug(void);
+asmlinkage void xen_int3(void);
 asmlinkage void overflow(void);
 asmlinkage void bounds(void);
 asmlinkage void invalid_op(void);
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 38946c6..acd74c3 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1378,6 +1378,10 @@ END(xen_failsafe_callback)
 
 paranoidzeroentry_ist debug do_debug DEBUG_STACK
 paranoidzeroentry_ist int3 do_int3 DEBUG_STACK
+#ifdef CONFIG_XEN
+zeroentry xen_debug do_debug
+zeroentry xen_int3 do_int3
+#endif
 paranoiderrorentry stack_segment do_stack_segment
 errorentry general_protection do_general_protection
 errorentry page_fault do_page_fault
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index f09e8c3..cb49f57 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -20,6 +20,7 @@
 #include <linux/delay.h>
 #include <linux/start_kernel.h>
 #include <linux/sched.h>
+#include <linux/kprobes.h>
 #include <linux/bootmem.h>
 #include <linux/module.h>
 #include <linux/mm.h>
@@ -44,6 +45,7 @@
 #include <asm/processor.h>
 #include <asm/proto.h>
 #include <asm/msr-index.h>
+#include <asm/traps.h>
 #include <asm/setup.h>
 #include <asm/desc.h>
 #include <asm/pgtable.h>
@@ -428,11 +430,24 @@ static void xen_write_ldt_entry(struct desc_struct *dt, int entrynum,
 static int cvt_gate_to_trap(int vector, const gate_desc *val,
 			    struct trap_info *info)
 {
+	unsigned long addr;
+
 	if (val->type != GATE_TRAP && val->type != GATE_INTERRUPT)
 		return 0;
 
 	info->vector = vector;
-	info->address = gate_offset(*val);
+
+	addr = gate_offset(*val);
+#ifdef CONFIG_X86_64
+	if (addr == (unsigned long)debug)
+		addr = (unsigned long)xen_debug;
+	else if (addr == (unsigned long)int3)
+		addr = (unsigned long)xen_int3;
+	else
+		WARN_ON(val->ist != 0);
+#endif	/* CONFIG_X86_64 */
+	info->address = addr;
+
 	info->cs = gate_segment(*val);
 	info->flags = val->dpl;
 	/* interrupt gates clear IF */
-- 
1.6.0.6



