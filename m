Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYAFDOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYAFDOc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 22:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbYAFDNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 22:13:50 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57763 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbYAFDNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 22:13:49 -0500
Date: Sat, 5 Jan 2008 19:09:59 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, olof@lixom.net, mingo@elte.hu,
       mpm@selenic.com
Subject: [patch 2/5] move WARN_ON() out of line
Message-ID: <20080105190959.1880f1c4@laptopd505.fenrus.org>
In-Reply-To: <20080105190713.73745ec6@laptopd505.fenrus.org>
References: <20080105190713.73745ec6@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: move WARN_ON() out of line
From: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Olof Johansson <olof@lixom.net>
Acked-by: Matt Meckall <mpm@selenic.com>

A quick grep shows that there are currently 1145 instances of WARN_ON
in the kernel. Currently, WARN_ON is pretty much entirely inlined,
which makes it hard to enhance it without growing the size of the kernel
(and getting Andrew unhappy).

This patch build on top of Olof's patch that introduces __WARN,
and places the slowpath out of line. It also uses Ingo's suggestion
to not use __FUNCTION__ but to use kallsyms to do the lookup;
this saves a ton of extra space since gcc doesn't need to store the function
string twice now:

3936367  833603  624736 5394706  525112 vmlinux.before
3917508  833603  624736 5375847  520767 vmlinux-slowpath

15Kb savings...

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>


---
 include/asm-generic/bug.h |   10 +++++-----
 kernel/panic.c            |   15 +++++++++++++++
 2 files changed, 20 insertions(+), 5 deletions(-)

Index: linux-2.6.24-rc6/include/asm-generic/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-generic/bug.h
+++ linux-2.6.24-rc6/include/asm-generic/bug.h
@@ -32,11 +32,11 @@ struct bug_entry {
 #endif
 
 #ifndef __WARN
-#define __WARN() do {							\
-	printk("WARNING: at %s:%d %s()\n", __FILE__,			\
-		__LINE__, __FUNCTION__);				\
-	dump_stack();							\
-} while (0)
+#ifndef __ASSEMBLY__
+extern void warn_on_slowpath(const char *file, const int line);
+#define WANT_WARN_ON_SLOWPATH
+#endif
+#define __WARN() warn_on_slowpath(__FILE__, __LINE__)
 #endif
 
 #ifndef WARN_ON
Index: linux-2.6.24-rc6/kernel/panic.c
===================================================================
--- linux-2.6.24-rc6.orig/kernel/panic.c
+++ linux-2.6.24-rc6/kernel/panic.c
@@ -20,6 +20,7 @@
 #include <linux/kexec.h>
 #include <linux/debug_locks.h>
 #include <linux/random.h>
+#include <linux/kallsyms.h>
 
 int panic_on_oops;
 int tainted;
@@ -292,6 +293,20 @@ void oops_exit(void)
 		(unsigned long long)oops_id);
 }
 
+#ifdef WANT_WARN_ON_SLOWPATH
+void warn_on_slowpath(const char *file, int line)
+{
+	char function[KSYM_SYMBOL_LEN];
+	unsigned long caller = (unsigned long) __builtin_return_address(0);
+
+	sprint_symbol(function, caller);
+	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
+		line, function);
+	dump_stack();
+}
+EXPORT_SYMBOL(warn_on_slowpath);
+#endif
+
 #ifdef CONFIG_CC_STACKPROTECTOR
 /*
  * Called when gcc's -fstack-protector feature is used, and


--
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
