Return-Path: <linux-kernel-owner+w=401wt.eu-S1946531AbXD3Rnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946531AbXD3Rnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031574AbXD3Rnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:43:35 -0400
Received: from holomorphy.com ([66.93.40.71]:56421 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031573AbXD3Rnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:43:33 -0400
Date: Mon, 30 Apr 2007 10:40:47 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Chinner <dgc@sgi.com>, Zan Lynx <zlynx@acm.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [1/6] make stack size configurable (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430174047.GD19966@holomorphy.com>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070430173819.GC19966@holomorphy.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 10:38:19AM -0700, William Lee Irwin III wrote:
> Here's what I did for i386 for someone concerned about blowing the stack.

Make more stack sizes configurable, adding options for deeper stacks.
This is largely for differential diagnosis in cases where stack overflows
are suspected of silently corrupting memory or causing other problems not
detected immediately.

Signed-off-by: William Irwin <wli@holomorphy.com>


Index: stack-paranoia/arch/i386/Kconfig.debug
===================================================================
--- stack-paranoia.orig/arch/i386/Kconfig.debug	2007-04-30 10:26:15.863869853 -0700
+++ stack-paranoia/arch/i386/Kconfig.debug	2007-04-30 10:31:43.878562345 -0700
@@ -56,6 +56,10 @@
 	  portion of the kernel code won't be covered by a 2MB TLB anymore.
 	  If in doubt, say "N".
 
+choice
+	prompt "Stack size"
+	default 8KSTACKS
+
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on DEBUG_KERNEL
@@ -66,6 +70,37 @@
 	  on the VM subsystem for higher order allocations. This option
 	  will also use IRQ stacks to compensate for the reduced stackspace.
 
+config 8KSTACKS
+	bool "Use 8KB for kernel stacks"
+	help
+	  If you say Y here, the kernel will use its standard stacksize.
+
+config 16KSTACKS
+	bool "Use 16KB for kernel stacks"
+	help
+	  If you say Y here, the kernel will use a 16KB stacksize.
+	  This impedes running more threads on a system and also increases
+	  the pressure on the VM subsystem for higher order allocations.
+	  This option will also use IRQ stacks to for additional safety.
+
+config 32KSTACKS
+	bool "Use 32KB for kernel stacks"
+	help
+	  If you say Y here, the kernel will use a 32KB stacksize.
+	  This impedes running more threads on a system and also increases
+	  the pressure on the VM subsystem for higher order allocations.
+	  This option will also use IRQ stacks to for additional safety.
+
+config 64KSTACKS
+	bool "Use 64KB for kernel stacks"
+	help
+	  If you say Y here, the kernel will use a 64KB stacksize.
+	  This impedes running more threads on a system and also increases
+	  the pressure on the VM subsystem for higher order allocations.
+	  This option will also use IRQ stacks to for additional safety.
+
+endchoice
+
 config X86_FIND_SMP_CONFIG
 	bool
 	depends on X86_LOCAL_APIC || X86_VOYAGER
Index: stack-paranoia/include/asm-i386/module.h
===================================================================
--- stack-paranoia.orig/include/asm-i386/module.h	2007-04-30 10:26:31.992788987 -0700
+++ stack-paranoia/include/asm-i386/module.h	2007-04-30 10:31:43.882562573 -0700
@@ -64,8 +64,14 @@
 
 #ifdef CONFIG_4KSTACKS
 #define MODULE_STACKSIZE "4KSTACKS "
-#else
-#define MODULE_STACKSIZE ""
+#elif defined(CONFIG_8KSTACKS)
+#define MODULE_STACKSIZE "8KSTACKS "
+#elif defined(CONFIG_16KSTACKS)
+#define MODULE_STACKSIZE "16KSTACKS "
+#elif defined(CONFIG_32KSTACKS)
+#define MODULE_STACKSIZE "32KSTACKS "
+#elif defined(CONFIG_64KSTACKS)
+#define MODULE_STACKSIZE "64KSTACKS "
 #endif
 
 #define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY MODULE_STACKSIZE
Index: stack-paranoia/include/asm-i386/thread_info.h
===================================================================
--- stack-paranoia.orig/include/asm-i386/thread_info.h	2007-04-30 10:26:32.104795370 -0700
+++ stack-paranoia/include/asm-i386/thread_info.h	2007-04-30 10:31:43.882562573 -0700
@@ -54,9 +54,17 @@
 
 #define PREEMPT_ACTIVE		0x10000000
 #ifdef CONFIG_4KSTACKS
-#define THREAD_SIZE            (4096)
-#else
+#define THREAD_SIZE		(4096)
+#elif defined(CONFIG_8KSTACKS)
 #define THREAD_SIZE		(8192)
+#elif defined(CONFIG_16KSTACKS)
+#define THREAD_SIZE		(16384)
+#elif defined(CONFIG_32KSTACKS)
+#define THREAD_SIZE		(32768)
+#elif defined(CONFIG_64KSTACKS)
+#define THREAD_SIZE		(65536)
+#else
+#error stack size unconfigured
 #endif
 
 #define STACK_WARN             (THREAD_SIZE/8)
