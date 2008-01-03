Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbYACV2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbYACV2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYACV2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:28:41 -0500
Received: from mga06.intel.com ([134.134.136.21]:15475 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752195AbYACV2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:28:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,240,1196668800"; 
   d="scan'208";a="248526159"
Message-ID: <477D52ED.7000403@linux.intel.com>
Date: Thu, 03 Jan 2008 22:26:05 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mingo@elte.hu, akpm@linux-foundation.org, olof@lixom.net, mpm@selenic.com
Subject: [patch 1/2] move WARN_ON() out of line
Content-Type: multipart/mixed;
 boundary="------------040405010005000301070402"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040405010005000301070402
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Subject: move WARN_ON() out of line
From: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Olof Johansson <olof@lixom.net>
CC: Matt Meckall <mpm@selenic.com>

A quick grep shows that there are currently 1145 instances of WARN_ON
in the kernel. Currently, WARN_ON is pretty much entirely inlined,
which makes it hard to enhance it without growing the size of the kernel
(and getting Andrew rightfully unhappy).

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
  include/asm-generic/bug.h |    7 ++-----
  kernel/panic.c            |   14 ++++++++++++++
  2 files changed, 16 insertions(+), 5 deletions(-)

Index: linux-2.6.24-rc6/include/asm-generic/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-generic/bug.h
+++ linux-2.6.24-rc6/include/asm-generic/bug.h
@@ -32,11 +32,8 @@ struct bug_entry {
  #endif

  #ifndef __WARN
-#define __WARN() do {							\
-	printk("WARNING: at %s:%d %s()\n", __FILE__,			\
-		__LINE__, __FUNCTION__);				\
-	dump_stack();							\
-} while (0)
+extern void warn_on_slowpath(const char *file, const int line);
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
@@ -292,6 +293,19 @@ void oops_exit(void)
  		(unsigned long long)oops_id);
  }

+
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
+
  #ifdef CONFIG_CC_STACKPROTECTOR
  /*
   * Called when gcc's -fstack-protector feature is used, and

--------------040405010005000301070402
Content-Type: text/x-patch;
 name="out_of_line_WARN_ON.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="out_of_line_WARN_ON.patch"

Subject: move WARN_ON() out of line
From: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Olof Johansson <olof@lixom.net>
CC: Matt Meckall <mpm@selenic.com>

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
 include/asm-generic/bug.h |    7 ++-----
 kernel/panic.c            |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 5 deletions(-)

Index: linux-2.6.24-rc6/include/asm-generic/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-generic/bug.h
+++ linux-2.6.24-rc6/include/asm-generic/bug.h
@@ -32,11 +32,8 @@ struct bug_entry {
 #endif
 
 #ifndef __WARN
-#define __WARN() do {							\
-	printk("WARNING: at %s:%d %s()\n", __FILE__,			\
-		__LINE__, __FUNCTION__);				\
-	dump_stack();							\
-} while (0)
+extern void warn_on_slowpath(const char *file, const int line);
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
@@ -292,6 +293,19 @@ void oops_exit(void)
 		(unsigned long long)oops_id);
 }
 
+
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
+
 #ifdef CONFIG_CC_STACKPROTECTOR
 /*
  * Called when gcc's -fstack-protector feature is used, and

--------------040405010005000301070402--
