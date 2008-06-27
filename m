Return-Path: <linux-kernel-owner+w=401wt.eu-S1761949AbYF0TET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761949AbYF0TET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 15:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYF0TEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 15:04:09 -0400
Received: from gw.goop.org ([64.81.55.164]:48210 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbYF0TEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 15:04:08 -0400
Message-ID: <486539A3.3030102@goop.org>
Date: Fri, 27 Jun 2008 12:04:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
 64-bit Xen support
References: <patchbomb.1214367536@localhost> <20080625084253.GA11524@elte.hu> <20080625152212.GA3442@elte.hu> <4862A6A9.1030109@goop.org> <20080626105722.GA12640@elte.hu> <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org> <20080627160333.GA27072@elte.hu>
In-Reply-To: <20080627160333.GA27072@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> this problem still reproduces.
>
> i've pushed out all fixes into tip/x86/xen-64bit. That branch combined 
> with the config above still reproduces the build failure above.
>   

Subject: x86_64: fix non-paravirt compilation

Make sure SWAPGS and PARAVIRT_ADJUST_EXCEPTION_FRAME are properly
defined when CONFIG_PARAVIRT is off.

Fixes Ingo's build failure:
arch/x86/kernel/entry_64.S: Assembler messages:
arch/x86/kernel/entry_64.S:1201: Error: invalid character '_' in mnemonic
arch/x86/kernel/entry_64.S:1205: Error: invalid character '_' in mnemonic
arch/x86/kernel/entry_64.S:1209: Error: invalid character '_' in mnemonic
arch/x86/kernel/entry_64.S:1213: Error: invalid character '_' in mnemonic

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/irqflags.h  |   22 +++++++++++++---------
 include/asm-x86/processor.h |    3 ---
 2 files changed, 13 insertions(+), 12 deletions(-)

===================================================================
--- a/include/asm-x86/irqflags.h
+++ b/include/asm-x86/irqflags.h
@@ -167,7 +167,20 @@
 #define INTERRUPT_RETURN_NMI_SAFE	NATIVE_INTERRUPT_RETURN_NMI_SAFE
 
 #ifdef CONFIG_X86_64
+#define SWAPGS	swapgs
+/*
+ * Currently paravirt can't handle swapgs nicely when we
+ * don't have a stack we can rely on (such as a user space
+ * stack).  So we either find a way around these or just fault
+ * and emulate if a guest tries to call swapgs directly.
+ *
+ * Either way, this is a good way to document that we don't
+ * have a reliable stack. x86_64 only.
+ */
 #define SWAPGS_UNSAFE_STACK	swapgs
+
+#define PARAVIRT_ADJUST_EXCEPTION_FRAME	/*  */
+
 #define INTERRUPT_RETURN	iretq
 #define USERGS_SYSRET64				\
 	swapgs;					\
@@ -233,15 +246,6 @@
 #else
 
 #ifdef CONFIG_X86_64
-/*
- * Currently paravirt can't handle swapgs nicely when we
- * don't have a stack we can rely on (such as a user space
- * stack).  So we either find a way around these or just fault
- * and emulate if a guest tries to call swapgs directly.
- *
- * Either way, this is a good way to document that we don't
- * have a reliable stack. x86_64 only.
- */
 #define ARCH_LOCKDEP_SYS_EXIT		call lockdep_sys_exit_thunk
 #define ARCH_LOCKDEP_SYS_EXIT_IRQ	\
 	TRACE_IRQS_ON; \
===================================================================
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -541,9 +541,6 @@
 }
 
 #define set_iopl_mask native_set_iopl_mask
-#define SWAPGS	swapgs
-
-#define PARAVIRT_ADJUST_EXCEPTION_FRAME	/*  */
 #endif /* CONFIG_PARAVIRT */
 
 /*



