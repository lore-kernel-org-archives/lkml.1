Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZD0K5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZD0K5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbZD0K5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:57:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59550 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbZD0K5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:57:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] FRV: Stop gcc from generating uninitialised variable
	warnings after BUG()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Mon, 27 Apr 2009 11:55:23 +0100
Message-ID: <20090427105522.26247.75354.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090427105517.26247.30840.stgit@warthog.procyon.org.uk>
References: <20090427105517.26247.30840.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop gcc from generating uninitialised variable warnings after BUG().  The
problem is that FRV's call into its gdbstub appears to return (if the function
is marked noreturn, then the compiler is under no obligation to pass it a
return address, and so GDB won't know where the bug happened).

To get around this, we make the do...while wrapper in _debug_bug_trap() an
endless loop from which there's no escape.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/include/asm/bug.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/arch/frv/include/asm/bug.h b/arch/frv/include/asm/bug.h
index 6b1b44d..2e05450 100644
--- a/arch/frv/include/asm/bug.h
+++ b/arch/frv/include/asm/bug.h
@@ -30,7 +30,7 @@ extern void __debug_bug_printk(const char *file, unsigned line);
 do {						\
 	__debug_bug_trap(signr);		\
 	asm volatile("nop");			\
-} while(0)
+} while(1)
 
 #define HAVE_ARCH_BUG
 #define BUG()					\
@@ -46,7 +46,8 @@ do {						\
 #define HAVE_ARCH_KGDB_BAD_PAGE
 #define kgdb_bad_page(page) do { kgdb_raise(SIGABRT); } while(0)
 #endif
-#endif
+
+#endif /* CONFIG_BUG */
 
 #include <asm-generic/bug.h>
 

