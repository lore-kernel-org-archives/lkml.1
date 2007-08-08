Return-Path: <linux-kernel-owner+w=401wt.eu-S1762172AbXHHHMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172AbXHHHMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759447AbXHHHIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:08:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759387AbXHHHIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:08:15 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 20/25] [PATCH] replace syscall_init
Date: Wed,  8 Aug 2007 01:19:07 -0300
Message-Id: <11865468321629-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11865468281860-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com> <1186546785346-git-send-email-gcosta@redhat.com> <1186546789356-git-send-email-gcosta@redhat.com> <11865467931543-git-send-email-gcosta@redhat.com> <11865467973510-git-send-email-gcosta@redhat.com> <11865468003673-git-send-email-gcosta@redhat.com> <11865468043920-git-send-email-gcosta@redhat.com> <118654680831-git-send-email-gcosta@redhat.com> <11865468122642-git-send-email-gcosta@redhat.com> <11865468162812-git-send-email-gcosta@redhat.com> <1186546820708-git-send-email-gcosta@redhat.com> <11865468243612-git-send-email-gcosta@redhat.com> <11865468281860-git-send-email-gc!
 osta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces syscall_init by x86_64_syscall_init.
The former will be later replaced by a paravirt replacement
in case paravirt is on

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/kernel/setup64.c |    8 +++++++-
 include/asm-x86_64/proto.h   |    3 +++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/kernel/setup64.c b/arch/x86_64/kernel/setup64.c
index 49f7342..723822c 100644
--- a/arch/x86_64/kernel/setup64.c
+++ b/arch/x86_64/kernel/setup64.c
@@ -153,7 +153,7 @@ __attribute__((section(".bss.page_aligned")));
 extern asmlinkage void ignore_sysret(void);
 
 /* May not be marked __init: used by software suspend */
-void syscall_init(void)
+void x86_64_syscall_init(void)
 {
 	/* 
 	 * LSTAR and STAR live in a bit strange symbiosis.
@@ -172,6 +172,12 @@ void syscall_init(void)
 	wrmsrl(MSR_SYSCALL_MASK, EF_TF|EF_DF|EF_IE|0x3000); 
 }
 
+/* Overriden in paravirt.c if CONFIG_PARAVIRT */
+void __attribute__((weak)) syscall_init(void)
+{
+	x86_64_syscall_init();
+}
+
 void __cpuinit check_efer(void)
 {
 	unsigned long efer;
diff --git a/include/asm-x86_64/proto.h b/include/asm-x86_64/proto.h
index 31f20ad..77ed2de 100644
--- a/include/asm-x86_64/proto.h
+++ b/include/asm-x86_64/proto.h
@@ -18,6 +18,9 @@ extern void init_memory_mapping(unsigned long start, unsigned long end);
 
 extern void system_call(void); 
 extern int kernel_syscall(void);
+#ifdef CONFIG_PARAVIRT
+extern void x86_64_syscall_init(void);
+#endif
 extern void syscall_init(void);
 
 extern void ia32_syscall(void);
-- 
1.4.4.2

