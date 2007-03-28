Return-Path: <linux-kernel-owner+w=401wt.eu-S933741AbXC1X1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741AbXC1X1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933847AbXC1X1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:27:18 -0400
Received: from mbox.ssc.unict.it ([151.97.230.9]:43412 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933741AbXC1X1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:27:17 -0400
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH][2.6.21] uml: fix unreasonably long udelay
To: Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Date: Thu, 29 Mar 2007 01:26:11 +0200
Message-ID: <20070328232558.28719.96929.stgit@americanbeauty.home.lan>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we have a confused udelay implementation.

* __const_udelay does not accept usecs but xloops in i386 and x86_64
* our implementation requires usecs as arg
* it gets a xloops count when called by asm/arch/delay.h

Bugs related to this (extremely long shutdown times) where reported by some
x86_64 users, especially using Device Mapper.

To hit this bug, a compile-time constant time parameter must be passed - that's
why UML seems to work most times.
Fix this with a simple udelay implementation.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 arch/um/sys-i386/delay.c   |   11 -----------
 arch/um/sys-x86_64/delay.c |   11 -----------
 include/asm-um/delay.h     |   17 ++++++++++++++---
 3 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/arch/um/sys-i386/delay.c b/arch/um/sys-i386/delay.c
index 2c11b97..d623e07 100644
--- a/arch/um/sys-i386/delay.c
+++ b/arch/um/sys-i386/delay.c
@@ -27,14 +27,3 @@ void __udelay(unsigned long usecs)
 }
 
 EXPORT_SYMBOL(__udelay);
-
-void __const_udelay(unsigned long usecs)
-{
-	int i, n;
-
-	n = (loops_per_jiffy * HZ * usecs) / MILLION;
-        for(i=0;i<n;i++)
-                cpu_relax();
-}
-
-EXPORT_SYMBOL(__const_udelay);
diff --git a/arch/um/sys-x86_64/delay.c b/arch/um/sys-x86_64/delay.c
index 137f444..dee5be6 100644
--- a/arch/um/sys-x86_64/delay.c
+++ b/arch/um/sys-x86_64/delay.c
@@ -28,14 +28,3 @@ void __udelay(unsigned long usecs)
 }
 
 EXPORT_SYMBOL(__udelay);
-
-void __const_udelay(unsigned long usecs)
-{
-	unsigned long i, n;
-
-	n = (loops_per_jiffy * HZ * usecs) / MILLION;
-        for(i=0;i<n;i++)
-                cpu_relax();
-}
-
-EXPORT_SYMBOL(__const_udelay);
diff --git a/include/asm-um/delay.h b/include/asm-um/delay.h
index 0985bda..c71e32b 100644
--- a/include/asm-um/delay.h
+++ b/include/asm-um/delay.h
@@ -1,9 +1,20 @@
 #ifndef __UM_DELAY_H
 #define __UM_DELAY_H
 
-#include "asm/arch/delay.h"
-#include "asm/archparam.h"
-
 #define MILLION 1000000
 
+/* Undefined on purpose */
+extern void __bad_udelay(void);
+
+extern void __udelay(unsigned long usecs);
+extern void __delay(unsigned long loops);
+
+#define udelay(n) ((__builtin_constant_p(n) && (n) > 20000) ? \
+	__bad_udelay() : __udelay(n))
+
+/* It appears that ndelay is not used at all for UML, and has never been
+ * implemented. */
+extern void __unimplemented_ndelay(void);
+#define ndelay(n) __unimplemented_ndelay()
+
 #endif



