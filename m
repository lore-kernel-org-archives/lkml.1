Return-Path: <linux-kernel-owner+w=401wt.eu-S1761046AbYACA7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046AbYACA7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbYACA7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:59:08 -0500
Received: from mga06.intel.com ([134.134.136.21]:35741 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754611AbYACA7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:59:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,237,1196668800"; 
   d="scan'208";a="248250776"
Message-ID: <477C32DA.5060905@linux.intel.com>
Date: Thu, 03 Jan 2008 01:56:58 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 1/3] move WARN_ON() out of line
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: move WARN_ON() out of line
From: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>

A quick grep shows that there are currently 1145 instances of WARN_ON
in the kernel. Currently, WARN_ON is pretty much entirely inlined,
which makes it hard to enhance it without growing the size of the kernel
(and getting Andrew unhappy).

This patch moves WARN_ON() out of line entirely. I've considered keeping
the test inline and moving only the slowpath out of line, but I decided
against that: an out of line test reduces the pressure on the CPUs
branch predictor logic and gives smaller code, while a function call
to a fixed location is quite fast. Likewise I've considered doing something
similar to BUG() (eg use a trapping instruction) but that's not really
better (it needs the test inline again and recovering from an invalid
instruction isn't quite fun).

The code size reduction of this patch was about 6.5Kb (on a distro style
.config):

    text	   data	    bss	    dec	    hex	filename
3096493	 293455	2760704	6150652	 5dd9fc	vmlinux.before
3090006	 293455	2760704	6144165	 5dc0a5	vmlinux.after

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
  include/asm-generic/bug.h |   13 ++++---------
  kernel/panic.c            |   13 +++++++++++++
  2 files changed, 17 insertions(+), 9 deletions(-)

Index: linux-2.6.24-rc6/include/asm-generic/bug.h
===================================================================
--- linux-2.6.24-rc6.orig/include/asm-generic/bug.h
+++ linux-2.6.24-rc6/include/asm-generic/bug.h
@@ -32,15 +32,10 @@ struct bug_entry {
  #endif

  #ifndef HAVE_ARCH_WARN_ON
-#define WARN_ON(condition) ({						\
-	int __ret_warn_on = !!(condition);				\
-	if (unlikely(__ret_warn_on)) {					\
-		printk("WARNING: at %s:%d %s()\n", __FILE__,		\
-			__LINE__, __FUNCTION__);			\
-		dump_stack();						\
-	}								\
-	unlikely(__ret_warn_on);					\
-})
+extern int do_warn_on(const unsigned long condition, const char *file,
+	const int line, const char *function);
+#define WARN_ON(condition) do_warn_on((unsigned long)(condition), __FILE__, \
+					 __LINE__, __FUNCTION__)
  #endif

  #else /* !CONFIG_BUG */
Index: linux-2.6.24-rc6/kernel/panic.c
===================================================================
--- linux-2.6.24-rc6.orig/kernel/panic.c
+++ linux-2.6.24-rc6/kernel/panic.c
@@ -20,6 +20,7 @@
  #include <linux/kexec.h>
  #include <linux/debug_locks.h>
  #include <linux/random.h>
+#include <asm/bug.h>

  int panic_on_oops;
  int tainted;
@@ -292,6 +293,18 @@ void oops_exit(void)
  		(unsigned long long)oops_id);
  }

+int do_warn_on(const unsigned long condition, const char *file,
+			const int line, const char *function)
+{
+	if (unlikely(condition)) {
+		printk(KERN_WARNING "WARNING: at %s:%d %s()\n",
+			__FILE__, __LINE__, __FUNCTION__);
+		dump_stack();
+	}
+	return !!condition;
+}
+EXPORT_SYMBOL(do_warn_on);
+
  #ifdef CONFIG_CC_STACKPROTECTOR
  /*
   * Called when gcc's -fstack-protector feature is used, and
