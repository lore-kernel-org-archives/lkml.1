Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbZICVbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbZICVbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbZICVbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:31:45 -0400
Received: from claw.goop.org ([74.207.240.146]:36426 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481AbZICVbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:31:44 -0400
Message-ID: <4AA035C0.9070202@goop.org>
Date: Thu, 03 Sep 2009 14:31:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/i386: make sure stack-protector segment base is cache
 aligned
References: <4AA01893.6000507@goop.org> <4AA01D4F.1080707@gmail.com> <4AA029F8.2070002@goop.org> <4AA03016.8000904@gmail.com>
In-Reply-To: <4AA03016.8000904@gmail.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/09 14:07, Eric Dumazet wrote:
> I was referring to .data.percpu alignement requirements, not to false sharing.
>   

Yes, I know.  But the intent of DECLARE_PER_CPU_SHARED_ALIGNED is to
avoid false sharing, and so it does no alignment when CONFIG_SMP isn't
enabled.  We need alignment regardless.

> When we put a object with an align(64) requirement into a section, linker
> has to put this 2**6 alignment in resulting section.
>
> When several .o are linked together, linker has to take the biggest alignement,
> and has to put holes.
>
> Check .data.percpu size in vmlinux before and after your patch, to make sure
> it doesnt grow too much :)
>
> therefore, ____cacheline_aligned objects should be placed in
> .data.percpu.shared_aligned
>   

That section doesn't exist without SMP.  (Well,
PER_CPU_SHARED_ALIGNED_SECTION isn't defined.)

Anyway, this should sort it out.

    J

>From 69022dd952e65608afe33372e902b41cb94ff126 Mon Sep 17 00:00:00 2001
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Thu, 3 Sep 2009 14:17:27 -0700
Subject: [PATCH] x86/32: put aligned stack-canary in percpu shared_aligned section

Pack aligned things together into a special section to minimize padding
holes.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>

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
index e338b5c..1e8181c 100644
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


