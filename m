Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbYIEPiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbYIEPiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 11:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbYIEPin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 11:38:43 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:55637 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbYIEPim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 11:38:42 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
Date: Fri, 5 Sep 2008 11:38:19 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <andi-suse@firstfloor.org>
References: <200808311422.12525.linux@sandersweb.net> <20080831122751.72afafb5@infradead.org> <alpine.LFD.1.10.0808311237290.12958@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808311237290.12958@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200809051138.20615.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Aug 2008, David Sanders wrote:
> I recently discovered that x86 kernels won't boot under Virtual PC.On Sun, 
31 Aug 2008, David Sanders wrote:

On Sunday 31 August 2008 15:39, Linus Torvalds wrote:
> Well, it could be that Virtual PC raises a #UD exception in the virtual
> machine. In user space, that would just cause the kernel to kill the poor
> innocent victim. But when the kernel gets a #UD exception on what it
> expects to be a nop, it just won't work.

Sorry about the confusion. I was just learning git and applied a couple 
patches wrong that lead me to believe I had not found the answer, when in 
fact I had.  The problem is the multibyte NOP instructions introduced into 
the kernel in 2007.  For 2.6.24-rc1 reverting the patch (32c464f5) corrects 
the problem.  But then of course we cannot use these instructions as we would 
like.  I propose the following patch which adds a boot-time parameter to not 
use these multibyte NOPs in systems that are unprepared to deal with them.  
The patch disables a optimization used in one place by commenting out some 
lines in nop.h.  Please comment.

    x86: Fix to multibyte NOPs breaking Virtual PC (win)

    To be applied to linux-2.6.27-rc5.

    Signed-off-by: David Sanders <linux@sandersweb.net>

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 2763cb3..6a63e78 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -58,6 +58,15 @@ static int __init setup_noreplace_paravirt(char *str)
 __setup("noreplace-paravirt", setup_noreplace_paravirt);
 #endif
 
+static int intel_legacy_nops = 0;
+
+static int __init setup_intel_legacy_nops(char *str)
+{
+	intel_legacy_nops = 1;
+	return 1;
+}
+__setup("intel-legacy-nops", setup_intel_legacy_nops);
+
 #define DPRINTK(fmt, args...) if (debug_alternative) \
 	printk(KERN_DEBUG fmt, args)
 
@@ -165,13 +174,14 @@ static const struct nop {
 const unsigned char *const *find_nop_table(void)
 {
 	const unsigned char *const *noptable = intel_nops;
-	int i;
+	int i = 0;
 
-	for (i = 0; noptypes[i].cpuid >= 0; i++) {
+	while (noptypes[i].cpuid >= 0 && !intel_legacy_nops) {
 		if (boot_cpu_has(noptypes[i].cpuid)) {
 			noptable = noptypes[i].noptable;
 			break;
 		}
+		i++;
 	}
 	return noptable;
 }
diff --git a/include/asm-x86/nops.h b/include/asm-x86/nops.h
index ad0bedd..a6f0571 100644
--- a/include/asm-x86/nops.h
+++ b/include/asm-x86/nops.h
@@ -84,7 +84,7 @@
 #define ASM_NOP6 K7_NOP6
 #define ASM_NOP7 K7_NOP7
 #define ASM_NOP8 K7_NOP8
-#elif defined(CONFIG_X86_P6_NOP)
+/* #elif defined(CONFIG_X86_P6_NOP)
 #define ASM_NOP1 P6_NOP1
 #define ASM_NOP2 P6_NOP2
 #define ASM_NOP3 P6_NOP3
@@ -93,6 +93,7 @@
 #define ASM_NOP6 P6_NOP6
 #define ASM_NOP7 P6_NOP7
 #define ASM_NOP8 P6_NOP8
+*/
 #elif defined(CONFIG_X86_64)
 #define ASM_NOP1 K8_NOP1
 #define ASM_NOP2 K8_NOP2
