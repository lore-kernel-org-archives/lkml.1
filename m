Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbZD2JGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbZD2JGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbZD2JFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:05:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:60442 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbZD2JFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:05:22 -0400
Date: Wed, 29 Apr 2009 09:03:53 GMT
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240991249-27117-3-git-send-email-sam@ravnborg.org>
References: <1240991249-27117-3-git-send-email-sam@ravnborg.org>
Subject: [tip:x86/kbuild] x86, vmlinux.lds: unify PHDRS
Message-ID: <tip-afb8095a7eab32e5760613fa73d2f80a39cc45bf@git.kernel.org>
Git-Commit-ID: afb8095a7eab32e5760613fa73d2f80a39cc45bf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 09:03:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  afb8095a7eab32e5760613fa73d2f80a39cc45bf
Gitweb:     http://git.kernel.org/tip/afb8095a7eab32e5760613fa73d2f80a39cc45bf
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Wed, 29 Apr 2009 09:47:19 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 10:20:30 +0200

x86, vmlinux.lds: unify PHDRS

PHDRS are not equal for the two - so
use ifdefs to cover up for that.

On the assumption that they may become equal the ifdef
is inside the PHDRS definiton.

[ Impact: cleanup ]

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1240991249-27117-3-git-send-email-sam@ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmlinux.lds.S    |   13 +++++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |    5 -----
 arch/x86/kernel/vmlinux_64.lds.S |   11 -----------
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index d113642..1a1b303 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -40,6 +40,19 @@ ENTRY(phys_startup_64)
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
