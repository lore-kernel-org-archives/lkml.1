Return-Path: <linux-kernel-owner+w=401wt.eu-S1764564AbXHONAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764564AbXHONAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761404AbXHOMzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:55:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761918AbXHOMzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:55:10 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 22/25][V3] turn priviled operation into a macro
Date: Wed, 15 Aug 2007 09:49:42 -0300
Message-Id: <1187182438167-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11871824292046-git-send-email-gcosta@redhat.com>
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com> <11871822163867-git-send-email-gcosta@redhat.com> <11871822244170-git-send-email-gcosta@redhat.com> <11871822342754-git-send-email-gcosta@redhat.com> <11871822421713-git-send-email-gcosta@redhat.com> <1187182253740-git-send-email-gcosta@redhat.com> <1187182268408-git-send-email-gcosta@redhat.com> <1187182282913-git-send-email-gcosta@redhat.com> <11871822951747-git-send-email-gcosta@redhat.com> <11871823042011-git-send-email-gcosta@redhat.com> <11871823151789-git-send-email-gcosta@redhat.com> <11871823273810-git-send-email-gcosta@redhat.com> <11871823373106-git-send-email-gcosta@redhat.com> <11871823673236-git-send-email-gcosta@redhat.com> <11871823782610-git-send-email-gcosta@redhat.com> <11871823892519-git-send-email-gcosta@redhat.com> <11871823991803-git-send-email-gcosta@redhat.com> <11871824081337-git-send-email-!
 gcosta@redhat.com> <11871824192375-git-send-email-gcosta@redhat.com> <11871824292046-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

under paravirt, read cr2 cannot be issued directly anymore.
So wrap it in a macro, defined to the operation itself in case
paravirt is off, but to something else if we have paravirt
in the game

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/kernel/head.S |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/kernel/head.S b/arch/x86_64/kernel/head.S
index e89abcd..1bb6c55 100644
--- a/arch/x86_64/kernel/head.S
+++ b/arch/x86_64/kernel/head.S
@@ -18,6 +18,12 @@
 #include <asm/page.h>
 #include <asm/msr.h>
 #include <asm/cache.h>
+#ifdef CONFIG_PARAVIRT
+#include <asm/asm-offsets.h>
+#include <asm/paravirt.h>
+#else
+#define GET_CR2_INTO_RCX mov %cr2, %rcx
+#endif
 
 /* we are not able to switch in one step to the final KERNEL ADRESS SPACE
  * because we need identity-mapped pages.
@@ -267,7 +273,9 @@ ENTRY(early_idt_handler)
 	xorl %eax,%eax
 	movq 8(%rsp),%rsi	# get rip
 	movq (%rsp),%rdx
-	movq %cr2,%rcx
+	/* When PARAVIRT is on, this operation may clobber rax. It is
+	  something safe to do, because we've just zeroed rax. */
+	GET_CR2_INTO_RCX
 	leaq early_idt_msg(%rip),%rdi
 	call early_printk
 	cmpl $2,early_recursion_flag(%rip)
-- 
1.4.4.2

