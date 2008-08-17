Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbYHQTm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbYHQTm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbYHQTli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:41:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:15804 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYHQTlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MJWgTmJ3zbFP6UDXRup3dqXMoNRF14g1XMXZf+/Zc6rhaE1QByiJfuFP2o0PhkSoPa
         oSJTQ3Kg+yL+NulFhxoewgvoXfNhdvbfADrMB99yvD+Ui2Ub671Ixe45OohIT2ngr8Dv
         64S8RokzbiVysYb5ndfKNVH9k3FVVW8nH6siM=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 7/9] x86: apic - unify __setup_APIC_LVTT
Date: Sun, 17 Aug 2008 23:41:45 +0400
Message-Id: <3ef65d4fd53bf27437e5ad15ffd36bc75baed3d8.1219001352.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
References: <1219002107-21832-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <68106c6e85398a15b2a5d556764159541e1d66fe.1219001352.git.gorcunov@gmail.com>
References: <68106c6e85398a15b2a5d556764159541e1d66fe.1219001352.git.gorcunov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/apic_32.c |   10 +++++++---
 arch/x86/kernel/apic_64.c |   12 ++++++++----
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 3c1562a..65419c7 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -248,8 +248,12 @@ int lapic_get_maxlvt(void)
  * Local APIC timer
  */
 
-/* Clock divisor is set to 16 */
+/* Clock divisor */
+#ifdef CONFG_X86_64
+#define APIC_DIVISOR 1
+#else
 #define APIC_DIVISOR 16
+#endif
 
 /*
  * This function sets up the local APIC timer, with a timeout of
@@ -281,8 +285,8 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 	 */
 	tmp_value = apic_read(APIC_TDCR);
 	apic_write(APIC_TDCR,
-		   (tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
-		   APIC_TDR_DIV_16);
+		(tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
+		APIC_TDR_DIV_16);
 
 	if (!oneshot)
 		apic_write(APIC_TMICT, clocks / APIC_DIVISOR);
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index e03a76d..a814612 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -259,8 +259,12 @@ int lapic_get_maxlvt(void)
  * Local APIC timer
  */
 
-/* Clock divisor is set to 1 */
+/* Clock divisor */
+#ifdef CONFG_X86_64
 #define APIC_DIVISOR 1
+#else
+#define APIC_DIVISOR 16
+#endif
 
 /*
  * This function sets up the local APIC timer, with a timeout of
@@ -291,9 +295,9 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 	 * Divide PICLK by 16
 	 */
 	tmp_value = apic_read(APIC_TDCR);
-	apic_write(APIC_TDCR, (tmp_value
-				& ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE))
-				| APIC_TDR_DIV_16);
+	apic_write(APIC_TDCR,
+		(tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
+		APIC_TDR_DIV_16);
 
 	if (!oneshot)
 		apic_write(APIC_TMICT, clocks / APIC_DIVISOR);
-- 
1.6.0.rc1.34.g0fe8c

