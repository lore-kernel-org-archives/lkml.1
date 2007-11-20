Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbXKTAZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbXKTAZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbXKTAZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:25:16 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbXKTAZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:25:14 -0500
Date: Mon, 19 Nov 2007 19:24:59 -0500
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Use CR0 defines.
Message-ID: <20071120002459.GA11042@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have definitions of the CR0 bits in processor-flags.h
Use them instead of hardcoded values in various places.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 205fd5b..93d25a7 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -11,6 +11,7 @@
 #include <linux/utsname.h>
 #include <asm/bugs.h>
 #include <asm/processor.h>
+#include <asm/processor-flags.h>
 #include <asm/i387.h>
 #include <asm/msr.h>
 #include <asm/paravirt.h>
@@ -35,7 +36,7 @@ __setup("mca-pentium", mca_pentium);
 static int __init no_387(char *s)
 {
 	boot_cpu_data.hard_math = 0;
-	write_cr0(0xE | read_cr0());
+	write_cr0(X86_CR0_TS|X86_CR0_EM|X86_CR0_MP| read_cr0());
 	return 1;
 }
 
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 88d66fb..404a6a2 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -5,6 +5,7 @@
 #include <asm/dma.h>
 #include <asm/io.h>
 #include <asm/processor-cyrix.h>
+#include <asm/processor-flags.h>
 #include <asm/timer.h>
 #include <asm/pci-direct.h>
 #include <asm/tsc.h>
@@ -126,15 +127,12 @@ static void __cpuinit set_cx86_reorder(void)
 
 static void __cpuinit set_cx86_memwb(void)
 {
-	u32 cr0;
-
 	printk(KERN_INFO "Enable Memory-Write-back mode on Cyrix/NSC processor.\n");
 
 	/* CCR2 bit 2: unlock NW bit */
 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) & ~0x04);
 	/* set 'Not Write-through' */
-	cr0 = 0x20000000;
-	write_cr0(read_cr0() | cr0);
+	write_cr0(read_cr0() | X86_CR0_NW);
 	/* CCR2 bit 2: lock NW bit and set WT1 */
 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x14 );
 }
diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index 9964be3..8e139c7 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -4,6 +4,7 @@
 #include <asm/msr.h>
 #include <asm/io.h>
 #include <asm/processor-cyrix.h>
+#include <asm/processor-flags.h>
 #include "mtrr.h"
 
 int arr3_protected;
@@ -142,7 +143,7 @@ static void prepare_set(void)
 
 	/*  Disable and flush caches. Note that wbinvd flushes the TLBs as
 	    a side-effect  */
-	cr0 = read_cr0() | 0x40000000;
+	cr0 = read_cr0() | X86_CR0_CD;
 	wbinvd();
 	write_cr0(cr0);
 	wbinvd();
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 992f08d..f3b74cc 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -9,6 +9,7 @@
 #include <asm/msr.h>
 #include <asm/system.h>
 #include <asm/cpufeature.h>
+#include <asm/processor-flags.h>
 #include <asm/tlbflush.h>
 #include "mtrr.h"
 
@@ -350,7 +351,7 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
 	spin_lock(&set_atomicity_lock);
 
 	/*  Enter the no-fill (CD=1, NW=0) cache mode and flush caches. */
-	cr0 = read_cr0() | 0x40000000;	/* set CD flag */
+	cr0 = read_cr0() | X86_CR0_CD;
 	write_cr0(cr0);
 	wbinvd();
 
diff --git a/arch/x86/kernel/cpu/mtrr/state.c b/arch/x86/kernel/cpu/mtrr/state.c
index 49e20c2..9f8ba92 100644
--- a/arch/x86/kernel/cpu/mtrr/state.c
+++ b/arch/x86/kernel/cpu/mtrr/state.c
@@ -4,6 +4,7 @@
 #include <asm/mtrr.h>
 #include <asm/msr.h>
 #include <asm/processor-cyrix.h>
+#include <asm/processor-flags.h>
 #include "mtrr.h"
 
 
@@ -25,7 +26,7 @@ void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 
 		/*  Disable and flush caches. Note that wbinvd flushes the TLBs as
 		    a side-effect  */
-		cr0 = read_cr0() | 0x40000000;
+		cr0 = read_cr0() | X86_CR0_CD;
 		wbinvd();
 		write_cr0(cr0);
 		wbinvd();

-- 
http://www.codemonkey.org.uk
