Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZGFTUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZGFTUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZGFTUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:20:46 -0400
Received: from vpn.pathscale.com ([198.186.3.75]:38924 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753297AbZGFTUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:20:46 -0400
X-Greylist: delayed 825 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2009 15:20:46 EDT
From: John Gregor <john.gregor@qlogic.com>
To: linux-kernel@vger.kernel.org
Cc: John Gregor <johng@diamond.mv.qlogic.com>,
       Ralph Campbell <ralph.campbell@qlogic.com>,
       John Gregor <john.gregor@qlogic.com>
Subject: [PATCH] x86_64/__iowrite32_copy: don't use string move for PIO writes
Date: Mon,  6 Jul 2009 12:07:04 -0700
Message-Id: <1246907224-22758-1-git-send-email-john.gregor@qlogic.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Gregor <johng@diamond.mv.qlogic.com>

Some processors can write the same word more than once if the movs
instruction is used. This version uses normal memory move instructions
and gets the same performance since the speed is limited by PCIe and
write combining.

Signed-off-by: Ralph Campbell <ralph.campbell@qlogic.com>
Signed-off-by: John Gregor <john.gregor@qlogic.com>
---
 arch/x86/lib/iomap_copy_64.S |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/iomap_copy_64.S b/arch/x86/lib/iomap_copy_64.S
index 05a95e7..344b00e 100644
--- a/arch/x86/lib/iomap_copy_64.S
+++ b/arch/x86/lib/iomap_copy_64.S
@@ -1,4 +1,5 @@
 /*
+ * Copyright 2009 QLogic Corporation.  All rights reserved.
  * Copyright 2006 PathScale, Inc.  All Rights Reserved.
  *
  * This file is free software; you can redistribute it and/or modify
@@ -23,8 +24,23 @@
  */
 ENTRY(__iowrite32_copy)
 	CFI_STARTPROC
-	movl %edx,%ecx
-	rep movsd
+	movl    %edx, %ecx
+	andl    $-2, %edx
+	je      .L2
+	leaq    (%rsi,%rdx,4), %rdx
+.L1:
+	movq    (%rsi), %rax
+	addq    $8, %rsi
+	movq    %rax, (%rdi)
+	addq    $8, %rdi
+	cmpq    %rsi, %rdx
+	ja      .L1
+.L2:
+	bt      $0, %ecx
+	jae     .L4
+	movl    (%rsi), %eax
+	movl    %eax, (%rdi)
+.L4:
 	ret
 	CFI_ENDPROC
 ENDPROC(__iowrite32_copy)
-- 
1.6.0.6

