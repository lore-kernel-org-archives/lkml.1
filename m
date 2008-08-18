Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbYHRQqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbYHRQqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbYHRQpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:45:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31998 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbYHRQps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:45:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=elV0LUSbpiLcX0bLvRupJn2ng+cdrRnDl92kTPsF4vIBt/OR+JhxlS3GX+pHGqG8FZ
         1ZHDuQFjn8XuVM7FjiuUFDBb5ETBBJvgunsmSZ/AGJ6ajITC/oUaSGvx+zECCjVjJKnY
         xPGl1pGQ0EqQVueC8m7Sgwk3pkls8Pq5Io6QM=
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH 04/15] x86: apic - unify lapic_shutdown
Date: Mon, 18 Aug 2008 20:45:52 +0400
Message-Id: <a4b7c856ac5d5d1c57fd43524d97a1c4503ee594.1219073223.git.gorcunov@gmail.com>
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
 arch/x86/kernel/apic_32.c |    9 ++++++---
 arch/x86/kernel/apic_64.c |   14 +++++++++++++-
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 13c4b79..d4efe86 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -838,10 +838,13 @@ void lapic_shutdown(void)
 
 	local_irq_save(flags);
 
-	if (enabled_via_apicbase)
-		disable_local_APIC();
-	else
+#ifdef CONFIG_X86_32
+	if (!enabled_via_apicbase)
 		clear_local_APIC();
+	else
+#endif
+		disable_local_APIC();
+
 
 	local_irq_restore(flags);
 }
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 4fb903b..4880654 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -707,6 +707,12 @@ void disable_local_APIC(void)
 #endif
 }
 
+/*
+ * If Linux enabled the LAPIC against the BIOS default disable it down before
+ * re-entering the BIOS on shutdown.  Otherwise the BIOS may get confused and
+ * not power-off.  Additionally clear all LVT entries before disable_local_APIC
+ * for the case where Linux didn't enable the LAPIC.
+ */
 void lapic_shutdown(void)
 {
 	unsigned long flags;
@@ -716,7 +722,13 @@ void lapic_shutdown(void)
 
 	local_irq_save(flags);
 
-	disable_local_APIC();
+#ifdef CONFIG_X86_32
+	if (!enabled_via_apicbase)
+		clear_local_APIC();
+	else
+#endif
+		disable_local_APIC();
+
 
 	local_irq_restore(flags);
 }
-- 
1.6.0.rc1.34.g0fe8c

