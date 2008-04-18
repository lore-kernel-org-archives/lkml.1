Return-Path: <linux-kernel-owner+w=401wt.eu-S1758567AbYDRHtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567AbYDRHtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 03:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYDRHs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 03:48:58 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:31465 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbYDRHs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 03:48:57 -0400
Date: Fri, 18 Apr 2008 03:48:56 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       akpm@linux-foundation.org
Subject: [PATCH 1/2] kallsyms: restructure print_fn_descriptor_symbol
Message-ID: <20080418074856.GC16276@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the function descriptor access from the print_symbol
call.

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
---
 include/linux/kallsyms.h |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 82de2fb..6734a3f 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -83,17 +83,21 @@ __attribute__((format(printf,1,2)));
 static inline void __check_printsym_format(const char *fmt, ...)
 {
 }
+
 /* ia64 and ppc64 use function descriptors, which contain the real address */
 #if defined(CONFIG_IA64) || defined(CONFIG_PPC64)
-#define print_fn_descriptor_symbol(fmt, addr)		\
-do {						\
-	unsigned long *__faddr = (unsigned long*) addr;		\
-	print_symbol(fmt, __faddr[0]);		\
-} while (0)
+#define get_func_addr(x)	({				\
+					unsigned long *addr =	\
+						(unsigned long *)x;	\
+					addr[0];		\
+				})
 #else
-#define print_fn_descriptor_symbol(fmt, addr) print_symbol(fmt, addr)
+#define get_func_addr(x)	x
 #endif
 
+#define print_fn_descriptor_symbol(fmt, addr)	\
+		print_symbol(fmt, get_func_addr(addr))
+
 static inline void print_symbol(const char *fmt, unsigned long addr)
 {
 	__check_printsym_format(fmt, "");
-- 
1.5.4.5

