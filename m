Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbZETXSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbZETXSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbZETXST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:18:19 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48688 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756766AbZETXSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:18:18 -0400
X-Sasl-enc: SsUdHtk9sxvrwKc67zECp6Cnp6d+ucvRxMZtCcHas51U 1242861498
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Jan Beulich <JBeulich@novell.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] i386, entry_32: remove page_fault microoptimization
Date: Thu, 21 May 2009 01:18:02 +0200
Message-Id: <1242861486-7255-5-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
References: <1242861486-7255-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A distinct pattern exists in the handler stubs for traps. The
pagefault handler has a microoptimization where the handler
falls through to the common handler code 'error_code'. This
adds a short jump to the pagefault handler and aligns the
error_code code.

No functional change intended.

impact: prepare for introduction of zeroentry/errorentry macros

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/entry_32.S |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 0e8ac16..3c04063 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1178,8 +1178,13 @@ ENTRY(page_fault)
 	RING0_EC_FRAME
 	pushl $do_page_fault
 	CFI_ADJUST_CFA_OFFSET 4
-	ALIGN
-error_code:
+	jmp error_code
+	CFI_ENDPROC
+END(page_fault)
+
+ENTRY(error_code)
+	RING0_EC_FRAME
+	CFI_ADJUST_CFA_OFFSET 4
 	/* the function address is in %gs's slot on the stack */
 	pushl %fs
 	CFI_ADJUST_CFA_OFFSET 4
@@ -1229,7 +1234,7 @@ error_code:
 	call *%edi
 	jmp ret_from_exception
 	CFI_ENDPROC
-END(page_fault)
+END(error_code)
 
 /*
  * Debug traps and NMI can happen at the one SYSENTER instruction
-- 
1.6.0.4

