Return-Path: <linux-kernel-owner+w=401wt.eu-S933201AbZIDH6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201AbZIDH6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbZIDH6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:58:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:33446 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932510AbZIDH6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:58:32 -0400
Date: Fri, 4 Sep 2009 07:58:05 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eric.dumazet@gmail.com, jeremy.fitzhardinge@citrix.com, jeremy@goop.org,
       tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eric.dumazet@gmail.com, jeremy.fitzhardinge@citrix.com, jeremy@goop.org,
       tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AA035C0.9070202@goop.org>
References: <4AA035C0.9070202@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/i386: Put aligned stack-canary in percpu shared_aligned section
Message-ID: <tip-53f824520b6d84ca5b4a8fd71addc91dbf64357e@git.kernel.org>
Git-Commit-ID: 53f824520b6d84ca5b4a8fd71addc91dbf64357e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 04 Sep 2009 07:58:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53f824520b6d84ca5b4a8fd71addc91dbf64357e
Gitweb:     http://git.kernel.org/tip/53f824520b6d84ca5b4a8fd71addc91dbf64357e
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Thu, 3 Sep 2009 14:31:44 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Sep 2009 07:10:31 +0200

x86/i386: Put aligned stack-canary in percpu shared_aligned section

Pack aligned things together into a special section to minimize
padding holes.

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Tejun Heo <tj@kernel.org>
LKML-Reference: <4AA035C0.9070202@goop.org>
[ queued up in tip:x86/asm because it depends on this commit:
  x86/i386: Make sure stack-protector segment base is cache aligned ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/processor.h |    2 +-
 arch/x86/kernel/cpu/common.c     |    2 +-
 include/asm-generic/percpu.h     |    3 +++
 include/linux/percpu-defs.h      |    8 ++++++++
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index e597ecc..ac7e796 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -413,7 +413,7 @@ struct stack_canary {
 	char __pad[20];		/* canary at %gs:20 */
 	unsigned long canary;
 };
-DECLARE_PER_CPU(struct stack_canary, stack_canary) ____cacheline_aligned;
+DECLARE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
 #endif	/* X86_64 */
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7d84bc4..f23e236 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1043,7 +1043,7 @@ DEFINE_PER_CPU(struct orig_ist, orig_ist);
 #else	/* CONFIG_X86_64 */
 
 #ifdef CONFIG_CC_STACKPROTECTOR
-DEFINE_PER_CPU(struct stack_canary, stack_canary) ____cacheline_aligned;
+DEFINE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 #endif
 
 /* Make sure %fs and %gs are initialized properly in idle threads */
diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index aa00800..90079c3 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -81,14 +81,17 @@ extern void setup_per_cpu_areas(void);
 
 #ifdef MODULE
 #define PER_CPU_SHARED_ALIGNED_SECTION ""
+#define PER_CPU_ALIGNED_SECTION ""
 #else
 #define PER_CPU_SHARED_ALIGNED_SECTION ".shared_aligned"
+#define PER_CPU_ALIGNED_SECTION ".shared_aligned"
 #endif
 #define PER_CPU_FIRST_SECTION ".first"
 
 #else
 
 #define PER_CPU_SHARED_ALIGNED_SECTION ""
+#define PER_CPU_ALIGNED_SECTION ".shared_aligned"
 #define PER_CPU_FIRST_SECTION ""
 
 #endif
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 68438e1..3058cf9 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -66,6 +66,14 @@
 	DEFINE_PER_CPU_SECTION(type, name, PER_CPU_SHARED_ALIGNED_SECTION) \
 	____cacheline_aligned_in_smp
 
+#define DECLARE_PER_CPU_ALIGNED(type, name)				\
+	DECLARE_PER_CPU_SECTION(type, name, PER_CPU_ALIGNED_SECTION)	\
+	____cacheline_aligned
+
+#define DEFINE_PER_CPU_ALIGNED(type, name)				\
+	DEFINE_PER_CPU_SECTION(type, name, PER_CPU_ALIGNED_SECTION)	\
+	____cacheline_aligned
+
 /*
  * Declaration/definition used for per-CPU variables that must be page aligned.
  */
