Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbZC3DCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbZC3DCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 23:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756286AbZC3DBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 23:01:52 -0400
Received: from gw.goop.org ([64.81.55.164]:50459 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbZC3DBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 23:01:51 -0400
Message-ID: <49D0361C.3060901@goop.org>
Date: Sun, 29 Mar 2009 20:01:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bryan Donlan <bdonlan@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xensource.com
Subject: Re: Bug: ptrace issues under x86_64 Xen kernel 2.6.29
References: <3e8340490903252341u55abbc3aree9afc1b0a7703e6@mail.gmail.com>
In-Reply-To: <3e8340490903252341u55abbc3aree9afc1b0a7703e6@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Donlan wrote:
> Using 2.6.29 or 2.6.28 as a 64-bit Xen domU, a number of ptrace()
> users seem to have issues with unexpected breakpoints. ltrace and gdb
> both seem to be affected, under both 64-bit and 32-bit userspace.
> 32-bit kernels do not seem to be affected. Typical symptoms look like:
>   

It looks like this is because the kernel sets up int3 (breakpoint) and 
debug (watchpoints, etc) to be on a separate debug stack in the tss.  
Xen doesn't do this (and doesn't appear to have a mechanism to do so), 
so I guess the on-stack format isn't what the kernel expects.  Does the 
patch below work?

    J

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Sun, 29 Mar 2009 19:56:29 -0700
Subject: [PATCH] xen/x86-64: fix breakpoints and hardware watchpoints

Native x86-64 uses the IST mechanism to run int3 and debug traps on
an alternative stack.  Xen does not do this, and so the frames were
being misinterpreted by the ptrace code.  This change special-cases
these two exceptions by using Xen variants which run on the normal
kernel stack properly.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

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
index 3f129d9..6cde382 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1383,6 +1383,10 @@ END(xen_failsafe_callback)
 
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
index 02b169e..f98124f 100644
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
@@ -435,11 +437,24 @@ static void xen_write_ldt_entry(struct desc_struct *dt, int entrynum,
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


