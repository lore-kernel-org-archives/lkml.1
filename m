Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbYKUB1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbYKUB1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 20:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752158AbYKUB1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 20:27:10 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:37440 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYKUB1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 20:27:09 -0500
Message-ID: <49260E4C.8080500@caviumnetworks.com>
Date: Thu, 20 Nov 2008 17:26:36 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mips <linux-mips@linux-mips.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS: Make BUG() __noreturn.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Nov 2008 01:26:36.0849 (UTC) FILETIME=[3247BA10:01C94B78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIPS: Make BUG() __noreturn.

Often we do things like put BUG() in the default clause of a case
statement.  Since it was not declared __noreturn, this could sometimes
lead to bogus compiler warnings that variables were used
uninitialized.

There is a small problem in that we have to put a magic while(1); loop to
fool GCC into really thinking it is noreturn.  This makes the new
BUG() function 3 instructions long instead of just 1, but I think it
is worth it as it is now unnecessary to do extra work to silence the
'used uninitialized' warnings.

I also re-wrote BUG_ON so that if it is given a constant condition, it
just does BUG() instead of loading a constant value in to a register
and testing it.


Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 arch/mips/include/asm/bug.h |   29 ++++++++++++++++++++---------
 1 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/mips/include/asm/bug.h b/arch/mips/include/asm/bug.h
index 7eb63de..08ea468 100644
--- a/arch/mips/include/asm/bug.h
+++ b/arch/mips/include/asm/bug.h
@@ -7,20 +7,31 @@
 
 #include <asm/break.h>
 
-#define BUG()								\
-do {									\
-	__asm__ __volatile__("break %0" : : "i" (BRK_BUG));		\
-} while (0)
+static inline void __noreturn BUG(void)
+{
+	__asm__ __volatile__("break %0" : : "i" (BRK_BUG));
+	/* Fool GCC into thinking the function doesn't return. */
+	while (1)
+		;
+}
 
 #define HAVE_ARCH_BUG
 
 #if (_MIPS_ISA > _MIPS_ISA_MIPS1)
 
-#define BUG_ON(condition)						\
-do {									\
-	__asm__ __volatile__("tne $0, %0, %1"				\
-			     : : "r" (condition), "i" (BRK_BUG));	\
-} while (0)
+static inline void  __BUG_ON(unsigned long condition)
+{
+	if (__builtin_constant_p(condition)) {
+		if (condition)
+			BUG();
+		else
+			return;
+	}
+	__asm__ __volatile__("tne $0, %0, %1"
+			     : : "r" (condition), "i" (BRK_BUG));
+}
+
+#define BUG_ON(C) __BUG_ON((unsigned long)(C))
 
 #define HAVE_ARCH_BUG_ON
 
