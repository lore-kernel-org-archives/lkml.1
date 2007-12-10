Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbXLJSBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbXLJSBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 13:01:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbXLJSA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 13:00:57 -0500
Received: from [198.99.130.12] ([198.99.130.12]:55196 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbXLJSA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 13:00:56 -0500
Date: Mon, 10 Dec 2007 13:00:09 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 5/5] UML - use barrier() instead of mb()
Message-ID: <20071210180009.GA9333@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

signals_enabled and pending have requirements on the order in which
they are modified.  This used to be done by declaring them volatile
and putting an mb() where the ordering requirements were in effect.

After getting a better (I hope) understanding of how to do this
correctly, the volatile declarations are gone and the mb()'s replaced
by barrier()'s.

One of the mb()'s was deleted because I see no problematic writes that
could be re-ordered past that point.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/os-Linux/signal.c |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

Index: linux-2.6-git/arch/um/os-Linux/signal.c
===================================================================
--- linux-2.6-git.orig/arch/um/os-Linux/signal.c	2007-12-07 16:53:18.000000000 -0500
+++ linux-2.6-git/arch/um/os-Linux/signal.c	2007-12-07 17:37:10.000000000 -0500
@@ -15,6 +15,9 @@
 #include "sysdep/sigcontext.h"
 #include "user.h"
 
+/* Copied from linux/compiler-gcc.h since we can't include it directly */
+#define barrier() __asm__ __volatile__("": : :"memory")
+
 /*
  * These are the asynchronous signals.  SIGPROF is excluded because we want to
  * be able to profile all of UML, not just the non-critical sections.  If
@@ -27,13 +30,8 @@
 #define SIGVTALRM_BIT 1
 #define SIGVTALRM_MASK (1 << SIGVTALRM_BIT)
 
-/*
- * These are used by both the signal handlers and
- * block/unblock_signals.  I don't want modifications cached in a
- * register - they must go straight to memory.
- */
-static volatile int signals_enabled = 1;
-static volatile int pending = 0;
+static int signals_enabled;
+static unsigned int pending;
 
 void sig_handler(int sig, struct sigcontext *sc)
 {
@@ -198,7 +196,7 @@ void block_signals(void)
 	 * This might matter if gcc figures out how to inline this and
 	 * decides to shuffle this code into the caller.
 	 */
-	mb();
+	barrier();
 }
 
 void unblock_signals(void)
@@ -224,21 +222,11 @@ void unblock_signals(void)
 		 * Setting signals_enabled and reading pending must
 		 * happen in this order.
 		 */
-		mb();
+		barrier();
 
 		save_pending = pending;
-		if (save_pending == 0) {
-			/*
-			 * This must return with signals enabled, so
-			 * this barrier ensures that writes are
-			 * flushed out before the return.  This might
-			 * matter if gcc figures out how to inline
-			 * this (unlikely, given its size) and decides
-			 * to shuffle this code into the caller.
-			 */
-			mb();
+		if (save_pending == 0)
 			return;
-		}
 
 		pending = 0;
 
