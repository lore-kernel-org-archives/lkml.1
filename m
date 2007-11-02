Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbXKBPoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbXKBPoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758951AbXKBPng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:43:36 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49690 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758907AbXKBPnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:43:33 -0400
Date: Fri, 2 Nov 2007 16:43:10 +0100
From: Adrian Bunk <bunk@kernel.org>
To: rusty@rustcorp.com.au
Cc: lguest@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] lguest: make async_hcall() static
Message-ID: <20071102154310.GI30287@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

async_hcall() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/lguest/boot.c         |   26 +++++++++++++-------------
 include/asm-x86/lguest_hcall.h |    3 ---
 2 files changed, 13 insertions(+), 16 deletions(-)

7b280cbbeeeb4c37a031b9cda257bc3bccf39173 
diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index a55b090..e6023b8 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -113,17 +113,6 @@ static void lguest_leave_lazy_mode(void)
 	hcall(LHCALL_FLUSH_ASYNC, 0, 0, 0);
 }
 
-static void lazy_hcall(unsigned long call,
-		       unsigned long arg1,
-		       unsigned long arg2,
-		       unsigned long arg3)
-{
-	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE)
-		hcall(call, arg1, arg2, arg3);
-	else
-		async_hcall(call, arg1, arg2, arg3);
-}
-
 /* async_hcall() is pretty simple: I'm quite proud of it really.  We have a
  * ring buffer of stored hypercalls which the Host will run though next time we
  * do a normal hypercall.  Each entry in the ring has 4 slots for the hypercall
@@ -134,8 +123,8 @@ static void lazy_hcall(unsigned long call,
  * full and we just make the hypercall directly.  This has the nice side
  * effect of causing the Host to run all the stored calls in the ring buffer
  * which empties it for next time! */
-void async_hcall(unsigned long call,
-		 unsigned long arg1, unsigned long arg2, unsigned long arg3)
+static void async_hcall(unsigned long call, unsigned long arg1,
+			unsigned long arg2, unsigned long arg3)
 {
 	/* Note: This code assumes we're uniprocessor. */
 	static unsigned int next_call;
@@ -161,6 +150,17 @@ void async_hcall(unsigned long call,
 	}
 	local_irq_restore(flags);
 }
+
+static void lazy_hcall(unsigned long call,
+		       unsigned long arg1,
+		       unsigned long arg2,
+		       unsigned long arg3)
+{
+	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_NONE)
+		hcall(call, arg1, arg2, arg3);
+	else
+		async_hcall(call, arg1, arg2, arg3);
+}
 /*:*/
 
 /*G:033
diff --git a/include/asm-x86/lguest_hcall.h b/include/asm-x86/lguest_hcall.h
index 9c5092b..2091779 100644
--- a/include/asm-x86/lguest_hcall.h
+++ b/include/asm-x86/lguest_hcall.h
@@ -54,9 +54,6 @@ hcall(unsigned long call,
 }
 /*:*/
 
-void async_hcall(unsigned long call,
-		 unsigned long arg1, unsigned long arg2, unsigned long arg3);
-
 /* Can't use our min() macro here: needs to be a constant */
 #define LGUEST_IRQS (NR_IRQS < 32 ? NR_IRQS: 32)
 

