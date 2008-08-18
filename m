Return-Path: <linux-kernel-owner+w=401wt.eu-S1756771AbYHRQtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbYHRQtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYHRQp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:45:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:27999 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbYHRQpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Jm2/tO5d9UeNPC1JMyQYs38VlbfMpo1ZGNUALfvFbTdfA8htw/rz6tJ5wxIii60nCX
         LWtK54q9lyVyUkcBS+6fJNHYwmzord4+dk2rWdZD0ivj0bXIZHhNMSxDirwpH27eCRtW
         qtyJf6/I09+KFRBA+pUanDFTqe8+ezSAiC4YA=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 07/15] x86: apic - unify __setup_APIC_LVTT
Date: Mon, 18 Aug 2008 20:45:55 +0400
Message-Id: <b434c97cf52240b94c8ddc2563ee1cd2c8dfa234.1219073223.git.gorcunov@gmail.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c
In-Reply-To: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
References: <1219077963-22883-1-git-send-email-gorcunov@gmail.com>
In-Reply-To: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
References: <8d555f8d496693d05b9e0836f18f62b1adb313c8.1219073223.git.gorcunov@gmail.com>
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
index d74abf7..fe57db9 100644
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

