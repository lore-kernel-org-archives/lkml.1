Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbZDOSgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbZDOSgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 14:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZDOSgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 14:36:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60228 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbZDOSgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 14:36:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/5] MN10300: Stop gcc from generating uninitialised variable
	warnings after BUG()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 15 Apr 2009 19:34:51 +0100
Message-ID: <20090415183451.11029.87805.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090415183441.11029.30619.stgit@warthog.procyon.org.uk>
References: <20090415183441.11029.30619.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop gcc from generating uninitialised variable warnings after BUG().  The
problem is that MN10300's implementation of BUG() invokes system call 15 which
doesn't return - but there's no way to tell the compiler that and also emit the
bug table element with the correct file and line data.

So instead, we make the do...while wrapper in _debug_bug_trap() an endless loop
from which there's no escape.

Also, while we're at it, (1) get rid of _debug_bug_trap() and just implement
directly as BUG(), and (2) make the implementation of BUG() contingent on
CONFIG_BUG=y.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/bug.h |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)


diff --git a/arch/mn10300/include/asm/bug.h b/arch/mn10300/include/asm/bug.h
index 4fcf338..aa6a388 100644
--- a/arch/mn10300/include/asm/bug.h
+++ b/arch/mn10300/include/asm/bug.h
@@ -11,10 +11,12 @@
 #ifndef _ASM_BUG_H
 #define _ASM_BUG_H
 
+#ifdef CONFIG_BUG
+
 /*
  * Tell the user there is some problem.
  */
-#define _debug_bug_trap()					\
+#define BUG()							\
 do {								\
 	asm volatile(						\
 		"	syscall 15			\n"	\
@@ -25,11 +27,11 @@ do {								\
 		:						\
 		: "i"(__FILE__), "i"(__LINE__)			\
 		);						\
-} while (0)
-
-#define BUG() _debug_bug_trap()
+} while (1)
 
 #define HAVE_ARCH_BUG
+#endif /* CONFIG_BUG */
+
 #include <asm-generic/bug.h>
 
 #endif /* _ASM_BUG_H */

