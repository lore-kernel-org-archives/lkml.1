Return-Path: <linux-kernel-owner+w=401wt.eu-S1761487AbXJaWEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761487AbXJaWEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbXJaWBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:01:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760525AbXJaWBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:01:14 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 11/16] turn priviled operation into a macro in head_64.S
Date: Wed, 31 Oct 2007 16:14:56 -0300
Message-Id: <11938581612389-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11938581562552-git-send-email-gcosta@redhat.com>
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com> <11938581242810-git-send-email-gcosta@redhat.com> <1193858130443-git-send-email-gcosta@redhat.com> <11938581351064-git-send-email-gcosta@redhat.com> <11938581403478-git-send-email-gcosta@redhat.com> <11938581451804-git-send-email-gcosta@redhat.com> <11938581512730-git-send-email-gcosta@redhat.com> <11938581562552-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

under paravirt, read cr2 cannot be issued directly anymore.
So wrap it in a macro, defined to the operation itself in case
paravirt is off, but to something else if we have paravirt
in the game

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/head_64.S |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index b6167fe..c31b1c9 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -19,6 +19,13 @@
 #include <asm/msr.h>
 #include <asm/cache.h>
 
+#ifdef CONFIG_PARAVIRT
+#include <asm/asm-offsets.h>
+#include <asm/paravirt.h>
+#else
+#define GET_CR2_INTO_RCX movq %cr2, %rcx
+#endif
+
 /* we are not able to switch in one step to the final KERNEL ADRESS SPACE
  * because we need identity-mapped pages.
  *
@@ -267,7 +274,7 @@ ENTRY(early_idt_handler)
 	xorl %eax,%eax
 	movq 8(%rsp),%rsi	# get rip
 	movq (%rsp),%rdx
-	movq %cr2,%rcx
+	GET_CR2_INTO_RCX
 	leaq early_idt_msg(%rip),%rdi
 	call early_printk
 	cmpl $2,early_recursion_flag(%rip)
-- 
1.4.4.2

