Return-Path: <linux-kernel-owner+w=401wt.eu-S1761840AbXKIVdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761840AbXKIVdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758787AbXKIV32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:29:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758777AbXKIV30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:29:26 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 19/24] turn priviled operation into a macro in head_64.S
Date: Fri,  9 Nov 2007 16:43:00 -0200
Message-Id: <1194633888761-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11946338832681-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <11946338212915-git-send-email-gcosta@redhat.com> <11946338263902-git-send-email-gcosta@redhat.com> <1194633831882-git-send-email-gcosta@redhat.com> <11946338361369-git-send-email-gcosta@redhat.com> <11946338413283-git-send-email-gcosta@redhat.com> <11946338473652-git-send-email-gcosta@redhat.com> <1194633852469-git-send-email-gcosta@redhat.com> <1194633857930-git-send-email-gcosta@redhat.com> <11946338621966-git-send-email-gcosta@redhat.com> <11946338683305-git-send-email-gcosta@redhat.com> <1194633873306-git-send-email-gcosta@redhat.com> <1194633878886-git-send-email-gcosta@redhat.com> <11946338832681-git-send-email-gcosta@redhat.com>
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

