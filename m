Return-Path: <linux-kernel-owner+w=401wt.eu-S1758742AbYFYEn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbYFYEn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbYFYEhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:34 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37449 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754991AbYFYEhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:21 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 34 of 36] x86_64: swapgs pvop with a user-stack can never be
	called
X-Mercurial-Node: 7c78d7b7c5205b0eba2ab0bca305c935ffa36125
Message-Id: <7c78d7b7c5205b0eba2a.1214367570@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:30 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's never safe to call a swapgs pvop when the user stack is current -
it must be inline replaced.  Rather than making a call, the
SWAPGS_UNSAFE_STACK pvop always just puts "swapgs" as a placeholder,
which must either be replaced inline or trap'n'emulated (somehow).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-x86/irqflags.h |    2 +-
 include/asm-x86/paravirt.h |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/asm-x86/irqflags.h b/include/asm-x86/irqflags.h
--- a/include/asm-x86/irqflags.h
+++ b/include/asm-x86/irqflags.h
@@ -167,6 +167,7 @@
 #define INTERRUPT_RETURN_NMI_SAFE	NATIVE_INTERRUPT_RETURN_NMI_SAFE
 
 #ifdef CONFIG_X86_64
+#define SWAPGS_UNSAFE_STACK	swapgs
 #define INTERRUPT_RETURN	iretq
 #define USERGS_SYSRET64				\
 	swapgs;					\
@@ -241,7 +242,6 @@
  * Either way, this is a good way to document that we don't
  * have a reliable stack. x86_64 only.
  */
-#define SWAPGS_UNSAFE_STACK	swapgs
 #define ARCH_LOCKDEP_SYS_EXIT		call lockdep_sys_exit_thunk
 #define ARCH_LOCKDEP_SYS_EXIT_IRQ	\
 	TRACE_IRQS_ON; \
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -1529,6 +1529,16 @@
 
 
 #else	/* !CONFIG_X86_32 */
+
+/*
+ * If swapgs is used while the userspace stack is still current,
+ * there's no way to call a pvop.  The PV replacement *must* be
+ * inlined, or the swapgs instruction must be trapped and emulated.
+ */
+#define SWAPGS_UNSAFE_STACK						\
+	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_swapgs), CLBR_NONE,	\
+		  swapgs)
+
 #define SWAPGS								\
 	PARA_SITE(PARA_PATCH(pv_cpu_ops, PV_CPU_swapgs), CLBR_NONE,	\
 		  PV_SAVE_REGS;						\


