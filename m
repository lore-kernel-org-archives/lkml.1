Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab0CJLDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:03:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59824 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab0CJLDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:03:14 -0500
Message-ID: <4B977BDB.2090204@cn.fujitsu.com>
Date: Wed, 10 Mar 2010 19:00:43 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] kvm: cleanup kvm trace
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does:

 - no need call tracepoint_synchronize_unregister() when kvm module
   is unloaded since ftrace can handle it

 - cleanup ftrace's macro

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c         |    1 -
 arch/x86/kvm/mmutrace.h    |    7 +++++--
 arch/x86/kvm/trace.h       |    7 +++++--
 arch/x86/kvm/x86.c         |    2 +-
 include/trace/events/kvm.h |    1 -
 virt/kvm/kvm_main.c        |    1 -
 6 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 741373e..d0f5e11 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -147,7 +147,6 @@ module_param(oos_shadow, bool, 0644);
 
 #include <trace/events/kvm.h>
 
-#undef TRACE_INCLUDE_FILE
 #define CREATE_TRACE_POINTS
 #include "mmutrace.h"
 
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 3e4a5c6..1fe956a 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -6,8 +6,6 @@
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvmmmu
-#define TRACE_INCLUDE_PATH .
-#define TRACE_INCLUDE_FILE mmutrace
 
 #define KVM_MMU_PAGE_FIELDS \
 	__field(__u64, gfn) \
@@ -216,5 +214,10 @@ TRACE_EVENT(
 
 #endif /* _TRACE_KVMMMU_H */
 
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE mmutrace
+
 /* This part must be outside protection */
 #include <trace/define_trace.h>
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 6ad30a2..e6e5e54 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -5,8 +5,6 @@
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
-#define TRACE_INCLUDE_PATH arch/x86/kvm
-#define TRACE_INCLUDE_FILE trace
 
 /*
  * Tracepoint for guest mode entry.
@@ -553,5 +551,10 @@ TRACE_EVENT(kvm_skinit,
 
 #endif /* _TRACE_KVM_H */
 
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH arch/x86/kvm
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
 /* This part must be outside protection */
 #include <trace/define_trace.h>
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e46282a..6db6fd2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -40,7 +40,7 @@
 #include <linux/user-return-notifier.h>
 #include <linux/srcu.h>
 #include <trace/events/kvm.h>
-#undef TRACE_INCLUDE_FILE
+
 #define CREATE_TRACE_POINTS
 #include "trace.h"
 
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index b17d49d..6dd3a51 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -5,7 +5,6 @@
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
-#define TRACE_INCLUDE_FILE kvm
 
 #if defined(__KVM_HAVE_IOAPIC)
 TRACE_EVENT(kvm_set_irq,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 548f925..c908096 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2272,7 +2272,6 @@ EXPORT_SYMBOL_GPL(kvm_init);
 
 void kvm_exit(void)
 {
-	tracepoint_synchronize_unregister();
 	kvm_exit_debug();
 	misc_deregister(&kvm_dev);
 	kmem_cache_destroy(kvm_vcpu_cache);
-- 
1.6.1.2

