Return-Path: <linux-kernel-owner+w=401wt.eu-S1762699AbXERGxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762699AbXERGxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbXERGw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:52:56 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60825 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbXERGwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:52:55 -0400
Date: Fri, 18 May 2007 08:53:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 06/14] kbuild: introduce __init_refok/__initdata_refok to supress section mismatch warnings
Message-ID: <20070518065352.GF12284@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518064126.GA12193@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9ea9840b8258e81ea88548bc22b2cb2871e2b1c4 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 17 May 2007 20:14:48 +0200
Subject: [PATCH 06/14] kbuild: introduce __init_refok/__initdata_refok to supress section mismatch warnings

Throughout the kernel there are a few legitimite references
to init or exit sections. Most of these are covered by the
patterns included in modpost but a few nees special attention.
To avoid hardcoding a lot of function names in modpost introduce
a marker so relevant function/data can be marked.
When modpost see a reference to a init/exit function from
a function/data marked no warning will be issued.

Idea from: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/asm-generic/vmlinux.lds.h |    6 ++++--
 include/linux/init.h              |   13 +++++++++++++
 scripts/mod/modpost.c             |   11 +++++++++++
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 52e2d69..8307b1b 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -11,7 +11,8 @@
 
 /* .data section */
 #define DATA_DATA							\
-	*(.data)
+	*(.data)							\
+	*(.data.init.refok)
 
 #define RODATA								\
 	. = ALIGN(4096);						\
@@ -147,7 +148,8 @@
  * during second ld run in second ld pass when generating System.map */
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
-		*(.text)
+		*(.text)						\
+		*(.text.init.refok)
 
 /* sched.text is aling to function alignment to secure we have same
  * address even at second ld pass when generating System.map */
diff --git a/include/linux/init.h b/include/linux/init.h
index e007ae4..c39f3d3 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -45,6 +45,19 @@
 #define __exitdata	__attribute__ ((__section__(".exit.data")))
 #define __exit_call	__attribute_used__ __attribute__ ((__section__ (".exitcall.exit")))
 
+/* modpost check for section mismatches during the kernel build.
+ * A section mismatch happens when there are references from a
+ * code or data section to an init section (both code or data).
+ * The init sections are (for most archs) discarded by the kernel
+ * when early init has completed so all such references are potential bugs.
+ * For exit sections the same issue exists.
+ * The follwoing markers are used for the cases where the reference to
+ * the init/exit section (code or data) is valid and will teach modpost
+ * not to issue a warning.
+ * The markers follow same syntax rules as __init / __initdata. */
+#define __init_refok     noinline __attribute__ ((__section__ (".text.init.refok")))
+#define __initdata_refok          __attribute__ ((__section__ (".data.init.refok")))
+
 #ifdef MODULE
 #define __exit		__attribute__ ((__section__(".exit.text")))
 #else
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index b394629..f4d9edf 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -583,6 +583,12 @@ static int strrcmp(const char *s, const char *sub)
 
 /**
  * Whitelist to allow certain references to pass with no warning.
+ *
+ * Pattern 0:
+ *   Do not warn if funtion/data are marked with __init_refok/__initdata_refok.
+ *   The pattern is identified by:
+ *   fromsec = .text.init.refok | .data.init.refok
+ *
  * Pattern 1:
  *   If a module parameter is declared __initdata and permissions=0
  *   then this is legal despite the warning generated.
@@ -686,6 +692,11 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		NULL
 	};
 
+	/* Check for pattern 0 */
+	if ((strcmp(fromsec, ".text.init.refok") == 0) ||
+	    (strcmp(fromsec, ".data.init.refok") == 0))
+		return 1;
+
 	/* Check for pattern 1 */
 	if (strcmp(tosec, ".init.data") != 0)
 		f1 = 0;
-- 
1.5.1.rc3.20.gaa453

