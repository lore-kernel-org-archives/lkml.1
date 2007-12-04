Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbXLDUyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbXLDUyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbXLDUyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:54:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:56711 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbXLDUyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:54:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C9yhi6lX08dVur62MUs61JuauAO3+avra8k07uHK/U0r6ttiB0O+rZpIesPhc0orF122UQ8MQ/E+vnZPrZJF6r9UxF5oj9egbctsw9CD5YGw5T/nFKDTfHAWMyJPAsaV2BX2uBrf5fl02tgEDKRige1WFVcY2QGdF1XwHCAQ8ek=
Subject: [RFC PATCH] x86: Unify include/asm-x86/linkage_[32|64].h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 12:53:49 -0800
Message-Id: <1196801629.10408.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding LKML to CC

Remove definitions of FASTCALL/fastcall from linkage_32 as compiled with
-regparm=3 by default since 2.6.20 and should no longer be needed.

CONFIG X86_64 and CONFIG_X86_ALIGNMENT_16 are mutually exclusive as found
in Kconfig.cpu so it should be fine to test them separately.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
I'm not sure if the definition of asmlinkage and prevent_tail_call can be
omitted as well and let the linux/linkage.h version get picked up instead.

Smarter people than I will have to figure that out.
 include/asm-x86/linkage.h    |   21 ++++++++++++++++++---
 include/asm-x86/linkage_32.h |   15 ---------------
 include/asm-x86/linkage_64.h |    6 ------
 3 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/include/asm-x86/linkage.h b/include/asm-x86/linkage.h
index 94b257f..5a4c959 100644
--- a/include/asm-x86/linkage.h
+++ b/include/asm-x86/linkage.h
@@ -1,5 +1,20 @@
+#ifndef __ASM_LINKAGE_H
+#define __ASM_LINKAGE_H
+
+#ifdef CONFIG_X86_64
+#define __ALIGN .p2align 4,,15
+#define __ALIGN_STR ".p2align 4,,15"
+#endif
+
 #ifdef CONFIG_X86_32
-# include "linkage_32.h"
-#else
-# include "linkage_64.h"
+#define asmlinkage CPP_ASMLINKAGE __attribute__((regparm(0)))
+#define prevent_tail_call(ret) __asm__ ("" : "=r" (ret) : "0" (ret))
+#endif
+
+#ifdef CONFIG_X86_ALIGNMENT_16
+#define __ALIGN .align 16,0x90
+#define __ALIGN_STR ".align 16,0x90"
+#endif
+
 #endif
+
diff --git a/include/asm-x86/linkage_32.h b/include/asm-x86/linkage_32.h
deleted file mode 100644
index f4a6eba..0000000
--- a/include/asm-x86/linkage_32.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef __ASM_LINKAGE_H
-#define __ASM_LINKAGE_H
-
-#define asmlinkage CPP_ASMLINKAGE __attribute__((regparm(0)))
-#define FASTCALL(x)	x __attribute__((regparm(3)))
-#define fastcall	__attribute__((regparm(3)))
-
-#define prevent_tail_call(ret) __asm__ ("" : "=r" (ret) : "0" (ret))
-
-#ifdef CONFIG_X86_ALIGNMENT_16
-#define __ALIGN .align 16,0x90
-#define __ALIGN_STR ".align 16,0x90"
-#endif
-
-#endif
diff --git a/include/asm-x86/linkage_64.h b/include/asm-x86/linkage_64.h
deleted file mode 100644
index b5f39d0..0000000
--- a/include/asm-x86/linkage_64.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_LINKAGE_H
-#define __ASM_LINKAGE_H
-
-#define __ALIGN .p2align 4,,15
-
-#endif
-- 
1.5.3.7.2094.gff6c



