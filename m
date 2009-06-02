Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZFBWqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZFBWqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbZFBWnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:43:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:21888 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbZFBWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:43:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nZzXPcrTEUlyW3eF62od/foFkO2rwolOUF+KzWxBjnUNmyEVXYJzYVdxARC9IXAgWi
         IfPakRSr684xAYa+3Rj72Mt/ZpM1vGfaZwHiPlRCYNq+jcT96UVV2Wdk0li9G9YMYalz
         QltZPwwhvI+EEGwcNV1u7GBWdTKm9ypjfo8O4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/12] hw-breakpoints: cleanup HW Breakpoint registers before kexec
Date: Wed,  3 Jun 2009 00:43:33 +0200
Message-Id: <1243982616-18212-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
References: <1243982616-18212-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: K.Prasad <prasad@linux.vnet.ibm.com>

This patch disables Hardware breakpoints before doing a 'kexec' on the machine
so that the cpu doesn't keep debug registers values which would be out of
sync for the new image.

Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/machine_kexec_32.c |    2 ++
 arch/x86/kernel/machine_kexec_64.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index c1c429d..c843f84 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -25,6 +25,7 @@
 #include <asm/desc.h>
 #include <asm/system.h>
 #include <asm/cacheflush.h>
+#include <asm/debugreg.h>
 
 static void set_idt(void *newidt, __u16 limit)
 {
@@ -202,6 +203,7 @@ void machine_kexec(struct kimage *image)
 
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
+	hw_breakpoint_disable();
 
 	if (image->preserve_context) {
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 84c3bf2..4a8bb82 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -18,6 +18,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
+#include <asm/debugreg.h>
 
 static int init_one_level2_page(struct kimage *image, pgd_t *pgd,
 				unsigned long addr)
@@ -282,6 +283,7 @@ void machine_kexec(struct kimage *image)
 
 	/* Interrupts aren't acceptable while we reboot */
 	local_irq_disable();
+	hw_breakpoint_disable();
 
 	if (image->preserve_context) {
 #ifdef CONFIG_X86_IO_APIC
-- 
1.6.2.3

