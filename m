Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbZAEMy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbZAEMy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZAEMyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:54:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44636 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZAEMyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:54:46 -0500
Date: Mon, 5 Jan 2009 14:08:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       david@lang.hm, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: early exception error
Message-ID: <20090105130836.GN496@one.firstfloor.org>
References: <alpine.DEB.1.10.0812311110320.18334@asgard.lang.hm> <20081231183039.GE20882@localhost> <20081231195005.GT496@one.firstfloor.org> <alpine.DEB.1.10.0812311257060.18334@asgard.lang.hm> <20090101041727.GW496@one.firstfloor.org> <alpine.DEB.1.10.0812312212460.15026@asgard.lang.hm> <alpine.DEB.1.10.0901021014030.21408@asgard.lang.hm> <20090102172426.GB5372@localhost> <495E7FAD.6020305@shaw.ca> <20090105092619.GA3699@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105092619.GA3699@cmpxchg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 10:26:19AM +0100, Johannes Weiner wrote:
> On Fri, Jan 02, 2009 at 02:57:17PM -0600, Robert Hancock wrote:
> > Cyrill Gorcunov wrote:
> > >
> > >Here is a new picture if someone would like to jump into
> > >the bug handling
> > >
> > >	http://linux.lang.hm/linux/IMG00033.jpg
> > 
> > alloc_bootmem_core is a reasonably big function, it would be useful if 
> > we could track down what line it's blowing up on.. Can you try to find 
> > out what line that fault address (ffffffff8096452a in this crash) is on 
> > as described in Documentation/BUG-HUNTING, i.e. build with 
> > CONFIG_DEBUG_INFO enabled, run gdb on vmlinux and do:
> > 
> > l *0xffffffff8096452a
> 
> He has booted with bootmem debugging output.  Given that the bdebug()
> describing the request wasn't hit yet, it must be one of the BUG_ON()s
> (or bdata is NULL).

BUG_ONs with early exceptions are always a big annoyance.

I did an EARLY_BUG_ON() infrastructure some time ago, but ended up
not submitting it because the BUG_ONs I wanted it for originally
disappeared before submission.

It would probably be a good idea to convert the bootmem bugs over
to that.

-Andi

---


Add EARLY_BUG_ON infrastructure

EARLY_BUG_ON is larger than BUG_ON, but it works before traps_init
and always outputs the line number without having to decode
addresses from the early exception handler.

It always panics.

Shouldn't be used when multiple CPUs are active because it makes
no attempt to stop the others.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/bug.h     |   11 +++++++++++
 arch/x86/kernel/early_printk.c |    7 +++++++
 include/linux/bug.h            |    5 +++++
 3 files changed, 23 insertions(+)

Index: linux-2.6.28-test/arch/x86/include/asm/bug.h
===================================================================
--- linux-2.6.28-test.orig/arch/x86/include/asm/bug.h	2008-10-24 13:34:40.000000000 +0200
+++ linux-2.6.28-test/arch/x86/include/asm/bug.h	2009-01-05 13:47:02.000000000 +0100
@@ -33,6 +33,17 @@
 } while (0)
 #endif
 
+extern void early_bug(char *file, int line) __attribute__((noreturn));
+
+/* All BUG_ONs before console_init should be EARLY_BUG_ONs. */
+#define EARLY_BUG() early_bug(__FILE__, __LINE__)
+#define EARLY_BUG_ON(x) do { if (unlikely(!(x))) EARLY_BUG(); } while (0)
+
+#else
+
+#define EARLY_BUG() do {} while(0)
+#define EARLY_BUG_ON(x) do {} while(0)
+
 #endif /* !CONFIG_BUG */
 
 #include <asm-generic/bug.h>
Index: linux-2.6.28-test/arch/x86/kernel/early_printk.c
===================================================================
--- linux-2.6.28-test.orig/arch/x86/kernel/early_printk.c	2008-10-24 13:34:40.000000000 +0200
+++ linux-2.6.28-test/arch/x86/kernel/early_printk.c	2009-01-05 13:48:46.000000000 +0100
@@ -934,6 +934,13 @@
 	va_end(ap);
 }
 
+void early_bug(char *file, int line)
+{
+	early_printk("PANIC: Early BUG at %s:%d\n", file, line);
+	printk("PANIC: Early BUG at %s:%d\n", file, line);
+	for (;;)
+		cpu_relax();
+}
 
 static int __init setup_early_printk(char *buf)
 {
Index: linux-2.6.28-test/include/linux/bug.h
===================================================================
--- linux-2.6.28-test.orig/include/linux/bug.h	2008-07-05 14:11:02.000000000 +0200
+++ linux-2.6.28-test/include/linux/bug.h	2009-01-05 13:49:32.000000000 +0100
@@ -47,4 +47,9 @@
 static inline void module_bug_cleanup(struct module *mod) {}
 
 #endif	/* CONFIG_GENERIC_BUG */
+
+#ifndef EARLY_BUG_ON
+#define EARLY_BUG_ON(x) BUG_ON(x)
+#endif
+
 #endif	/* _LINUX_BUG_H */



