Return-Path: <linux-kernel-owner+w=401wt.eu-S1757617AbXHHHNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617AbXHHHNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758928AbXHHHIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:08:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759987AbXHHHI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:08:28 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 22/25] [PATCH] turn priviled operation into a macro
Date: Wed,  8 Aug 2007 01:19:09 -0300
Message-Id: <11865468394005-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11865468362401-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com> <1186546785346-git-send-email-gcosta@redhat.com> <1186546789356-git-send-email-gcosta@redhat.com> <11865467931543-git-send-email-gcosta@redhat.com> <11865467973510-git-send-email-gcosta@redhat.com> <11865468003673-git-send-email-gcosta@redhat.com> <11865468043920-git-send-email-gcosta@redhat.com> <118654680831-git-send-email-gcosta@redhat.com> <11865468122642-git-send-email-gcosta@redhat.com> <11865468162812-git-send-email-gcosta@redhat.com> <1186546820708-git-send-email-gcosta@redhat.com> <11865468243612-git-send-email-gcosta@redhat.com> <11865468281860-git-send-email-gc!
 osta@redhat.com> <11865468321629-git-send-email-gcosta@redhat.com> <11865468362401-git-send-email-gcosta@redhat.com>
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

