Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZBGRlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZBGRlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 12:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbZBGRlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 12:41:14 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:36445 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbZBGRlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 12:41:13 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, pavel@suse.cz, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Brian Gerst <brgerst@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/1] x86_64: fix early_gdt_descr_base mangling
Date: Sat,  7 Feb 2009 18:40:02 +0100
Message-Id: <1234028402-4747-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8c7e58e690ae60ab4215b025f433ed4af261e103
(x86: rework __per_cpu_load adjustments)
has broken resume on my machine. On every secondary_startup_64 invocation,
it adds initial_gs to early_gdt_descr_base.

Fix it by initializing it to per_cpu__gdt_page and adding to it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/head_64.S |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index a0a2b5c..dadca8d 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -215,7 +215,8 @@ ENTRY(secondary_startup_64)
 	movq	initial_gs(%rip), %rax
 	cmpl	$0, per_cpu__cpu_number(%rax)
 	jne	1f
-	addq	%rax, early_gdt_descr_base(%rip)
+	addq	$per_cpu__gdt_page, %rax
+	movq	%rax, early_gdt_descr_base(%rip)
 1:
 #endif
 	/*
@@ -425,7 +426,7 @@ NEXT_PAGE(level2_spare_pgt)
 early_gdt_descr:
 	.word	GDT_ENTRIES*8-1
 early_gdt_descr_base:
-	.quad	per_cpu__gdt_page
+	.quad	0
 
 ENTRY(phys_base)
 	/* This must match the first entry in level2_kernel_pgt */
-- 
1.6.1.2

