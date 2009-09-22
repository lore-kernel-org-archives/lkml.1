Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbZIVO1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbZIVO1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbZIVO1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:27:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:54426 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbZIVO1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:27:01 -0400
Date: Tue, 22 Sep 2009 14:26:23 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       davem@davemloft.net, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       davem@davemloft.net, akpm@linux-foundation.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/printk] printk: Remove ratelimit.h from kernel.h
Message-ID: <tip-3fff4c42bd0a89869a0eb1e7874cc06ffa4aa0f5@git.kernel.org>
Git-Commit-ID: 3fff4c42bd0a89869a0eb1e7874cc06ffa4aa0f5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 14:26:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3fff4c42bd0a89869a0eb1e7874cc06ffa4aa0f5
Gitweb:     http://git.kernel.org/tip/3fff4c42bd0a89869a0eb1e7874cc06ffa4aa0f5
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 22 Sep 2009 16:18:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 16:18:09 +0200

printk: Remove ratelimit.h from kernel.h

Decouple kernel.h from ratelimit.h: the global declaration of
printk's ratelimit_state is not needed, and it leads to messy
circular dependencies due to ratelimit.h's (new) adding of a
spinlock_types.h include.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David S. Miller <davem@davemloft.net>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/kernel.h     |    2 --
 include/linux/net.h        |    1 +
 kernel/printk.c            |    1 +
 kernel/sysctl.c            |    3 +++
 lib/ratelimit.c            |    2 +-
 net/core/sysctl_net_core.c |    2 ++
 net/core/utils.c           |    2 ++
 7 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2b5b1e0..3305f33 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -15,7 +15,6 @@
 #include <linux/bitops.h>
 #include <linux/log2.h>
 #include <linux/typecheck.h>
-#include <linux/ratelimit.h>
 #include <linux/dynamic_debug.h>
 #include <asm/byteorder.h>
 #include <asm/bug.h>
@@ -241,7 +240,6 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 asmlinkage int printk(const char * fmt, ...)
 	__attribute__ ((format (printf, 1, 2))) __cold;
 
-extern struct ratelimit_state printk_ratelimit_state;
 extern int printk_ratelimit(void);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
diff --git a/include/linux/net.h b/include/linux/net.h
index 9040a10..df20f68 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -358,6 +358,7 @@ static const struct proto_ops name##_ops = {			\
 
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
+#include <linux/ratelimit.h>
 extern struct ratelimit_state net_ratelimit_state;
 #endif
 
diff --git a/kernel/printk.c b/kernel/printk.c
index 602033a..b997c89 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
 #include <linux/kexec.h>
+#include <linux/ratelimit.h>
 
 #include <asm/uaccess.h>
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 1a631ba..6c37048 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -37,6 +37,7 @@
 #include <linux/sysrq.h>
 #include <linux/highuid.h>
 #include <linux/writeback.h>
+#include <linux/ratelimit.h>
 #include <linux/hugetlb.h>
 #include <linux/initrd.h>
 #include <linux/key.h>
@@ -155,6 +156,8 @@ extern int no_unaligned_warning;
 extern int unaligned_dump_stack;
 #endif
 
+extern struct ratelimit_state printk_ratelimit_state;
+
 #ifdef CONFIG_RT_MUTEXES
 extern int max_lock_depth;
 #endif
diff --git a/lib/ratelimit.c b/lib/ratelimit.c
index 69bfcac..5551731 100644
--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -9,7 +9,7 @@
  * This file is released under the GPLv2.
  */
 
-#include <linux/kernel.h>
+#include <linux/ratelimit.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
 
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 7db1de0..887c03c 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -10,7 +10,9 @@
 #include <linux/module.h>
 #include <linux/socket.h>
 #include <linux/netdevice.h>
+#include <linux/ratelimit.h>
 #include <linux/init.h>
+
 #include <net/ip.h>
 #include <net/sock.h>
 
diff --git a/net/core/utils.c b/net/core/utils.c
index 83221ae..8382502 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -24,6 +24,8 @@
 #include <linux/types.h>
 #include <linux/percpu.h>
 #include <linux/init.h>
+#include <linux/ratelimit.h>
+
 #include <net/sock.h>
 
 #include <asm/byteorder.h>
