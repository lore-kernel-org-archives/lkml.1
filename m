Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbZAZGRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbZAZGRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZAZGPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:15:44 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:44602 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbZAZGPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:15:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CkUeGiwmUlRR7S46yQwfjsSUGGaK/hZdQKMzMB7CgPpykwbkrdzce5Gd5T+LTcZ+z2
         vnCnF20rS27cVlxNVEQdmdKxUq2IRPjf/Mcz6m1RcXw63wZFIVUHVEu2M1ZYDpBzfTNL
         EdLq484oKtf8BWbJ5KJ97K/DoKqKtg88pYTyQ=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] x86: Move this_cpu_offset
Date: Mon, 26 Jan 2009 01:15:27 -0500
Message-Id: <1232950532-22923-7-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
References: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Small cleanup

Define BOOT_PERCPU_OFFSET and use it for this_cpu_offset and
__per_cpu_offset initializers.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/setup_percpu.c |   15 ++++++++++-----
 arch/x86/kernel/smpcommon.c    |    7 -------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index f30ff69..36c2e81 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -25,15 +25,20 @@
 DEFINE_PER_CPU(int, cpu_number);
 EXPORT_PER_CPU_SYMBOL(cpu_number);
 
+#ifdef CONFIG_X86_64
+#define BOOT_PERCPU_OFFSET ((unsigned long)__per_cpu_load)
+#else
+#define BOOT_PERCPU_OFFSET 0
+#endif
+
+DEFINE_PER_CPU(unsigned long, this_cpu_off) = BOOT_PERCPU_OFFSET;
+EXPORT_PER_CPU_SYMBOL(this_cpu_off);
+
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 
-#ifdef CONFIG_X86_64
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
-	[0] = (unsigned long)__per_cpu_load,
+	[0] = BOOT_PERCPU_OFFSET,
 };
-#else
-unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
-#endif
 EXPORT_SYMBOL(__per_cpu_offset);
 
 /*
diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
index add36b4..5ec29a1 100644
--- a/arch/x86/kernel/smpcommon.c
+++ b/arch/x86/kernel/smpcommon.c
@@ -5,13 +5,6 @@
 #include <asm/smp.h>
 #include <asm/sections.h>
 
-#ifdef CONFIG_X86_64
-DEFINE_PER_CPU(unsigned long, this_cpu_off) = (unsigned long)__per_cpu_load;
-#else
-DEFINE_PER_CPU(unsigned long, this_cpu_off);
-#endif
-EXPORT_PER_CPU_SYMBOL(this_cpu_off);
-
 #ifdef CONFIG_X86_32
 /*
  * Initialize the CPU's GDT.  This is either the boot CPU doing itself
-- 
1.6.1

