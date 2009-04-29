Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbZD2Hsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbZD2Hsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbZD2Hpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:45:32 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57932 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbZD2HpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:45:22 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 03/13] x86, vmlinux.lds: unify PHDRS
Date: Wed, 29 Apr 2009 09:47:19 +0200
Message-Id: <1240991249-27117-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20090429073510.GA26386@uranus.ravnborg.org>
References: <20090429073510.GA26386@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PHDRS are not equal for the two - so
use ifdefs to cover up for that.

On the assumption that they may become equal the ifdef
is inside the PHDRS definiton.

No functional changes.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/kernel/vmlinux.lds.S    |   13 +++++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |    5 -----
 arch/x86/kernel/vmlinux_64.lds.S |   11 -----------
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 9fa77bc..fef1d8d 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -35,6 +35,19 @@ ENTRY(phys_startup_64)
 jiffies_64 = jiffies;
 #endif
 
+PHDRS {
+	text PT_LOAD FLAGS(5);          /* R_E */
+	data PT_LOAD FLAGS(7);          /* RWE */
+#ifdef CONFIG_X86_64
+	user PT_LOAD FLAGS(7);          /* RWE */
+	data.init PT_LOAD FLAGS(7);     /* RWE */
+#ifdef CONFIG_SMP
+	percpu PT_LOAD FLAGS(7);        /* RWE */
+#endif
+	data.init2 PT_LOAD FLAGS(7);    /* RWE */
+#endif
+	note PT_NOTE FLAGS(0);          /* ___ */
+}
 
 #ifdef CONFIG_X86_32
 # include "vmlinux_32.lds.S"
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 4c985fc..4fd40dc 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -1,8 +1,3 @@
-PHDRS {
-	text PT_LOAD FLAGS(5);		/* R_E */
-	data PT_LOAD FLAGS(7);		/* RWE */
-	note PT_NOTE FLAGS(0);		/* ___ */
-}
 SECTIONS
 {
 	. = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 7f1cc3d..6e7cbee 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -1,14 +1,3 @@
-PHDRS {
-	text PT_LOAD FLAGS(5);		/* R_E */
-	data PT_LOAD FLAGS(7);		/* RWE */
-	user PT_LOAD FLAGS(7);		/* RWE */
-	data.init PT_LOAD FLAGS(7);	/* RWE */
-#ifdef CONFIG_SMP
-	percpu PT_LOAD FLAGS(7);	/* RWE */
-#endif
-	data.init2 PT_LOAD FLAGS(7);	/* RWE */
-	note PT_NOTE FLAGS(0);		/* ___ */
-}
 SECTIONS
 {
 	. = __START_KERNEL;
-- 
1.6.0.6

