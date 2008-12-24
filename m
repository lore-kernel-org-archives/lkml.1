Return-Path: <linux-kernel-owner+w=401wt.eu-S1751807AbYLXWaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbYLXWaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 17:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYLXWaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 17:30:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:23339 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbYLXWaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 17:30:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hhGf6AzhewrXCiyYjvGTAUp0DciJ1I9H4+/UNKFlo80tggAdwEieY5q0JWlcH0Ct+J
         P4fB1WVZWNvhq8xLnRRbCwhyAnmxrX3+U/Jv+eYiFLvhY2J+lL1Jf2zf66z5hgrHHJux
         IvejMoW5XkWjK+dlys0X9IcmhHM3oHXbJHbA4=
Message-ID: <4952B7EA.8060100@gmail.com>
Date: Wed, 24 Dec 2008 23:30:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/ftrace: don't trace on early stage of a secondary
 cpu boot
References: <49524BD5.9010106@gmail.com> <alpine.DEB.1.10.0812241006010.30121@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0812241006010.30121@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Cool, so the CFLAGS_REMOVE solution worked.
> 
> I'm the last one to criticize someones language, especially when it is not 
> their native tongue. The closest language outside of English that I know 
> is German, and I would do horrible if I had to write this in German.


Me too. I can't imagine this. I studied more the german than the english language,
but I wouldn't dare send only one "Impact" line in german. It would be worst than my
english.


> 
> But since this is going to be a public record of what you changed, it 
> should be a bit more clear.

Of course. And thanks for these comments!


> On Wed, 24 Dec 2008, Frederic Weisbecker wrote:
> 
>> Impact: fix a crash/hard-reboot while enabling cpu on runtime
>>
>> On some archs, the boot of a secondary cpu can have an early fragile state.
>> On x86-64, the pda is not initialized on the first stage of a cpu boot but
> 
> s/on the first/in the first/
> 
>> it is needed to get the cpu number and the current task pointer. These datas
> 
> s/These datas are/This data is/
> 
>> are needed during tracing. As they were dereferenced at this stage, we got a
>> crash while turning on a cpu on runtime while tracing.
> 
> "we got a crash while tracing a cpu being enabled at runtime"
> 
>> Some other archs like ia64 can have such kind of issue too.
>>
>> Changes on v2:
>>
>> We drop the previous solution of a per-arch called function to guess the current state
> 
> s/drop/dropped/
> 
>> of a cpu. That could make slow the tracing.
> 
> "That could slow down the tracing."
> 
>> This patch just drop the -pg flag on arch/x86/kernel/cpu/common.c where
> 
> "This patch removes the -pg flag..."
> 
>> live the low level cpu boot functions, and on start_secondary() and a helper
> 
> "where the low level cpu boot functions exist"
> 
> s/, and on/, on/
> 
>> function used at this stage.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Again, I'm still impressed by your ability to communicate in a language 
> other than your own. And perhaps my corrections are incorrect too ;-)
> 
> Acked-by: Steven Rostedt <srostedt@redhat.com>
> 
> -- Steve

Thanks. Note that french people like me are silently cheating with the english language.
We have a lot of similar words and we can survive while mumbling english, even with only few
basis, but don't tell anyone, it's a secret ;-)
 
I applied your comments, see the patch below.
Thanks again.
--

From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v3] tracing/ftrace: don't trace on early stage of secondary cpu boot

Impact: fix a crash/hard-reboot while enabling cpu on runtime

On some archs, the boot of a secondary cpu can have an early fragile state.
On x86-64, the pda is not initialized on the first stage of a cpu boot but
it is needed to get the cpu number and the current task pointer. This data
is needed during tracing. As they were dereferenced at this stage, we got a
crash while tracing a cpu being enabled at runtime.

Some other archs like ia64 can have such kind of issue too.

Changes on v2:

We dropped the previous solution of a per-arch called function to guess the current state
of a cpu. That could slow down the tracing.
This patch removes the -pg flag on arch/x86/kernel/cpu/common.c where
the low level cpu boot functions exist, on start_secondary() and a helper
function used at this stage.

Changes on v3:

Fix my evil english in the v2 (Thanks Steven).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/include/asm/msr.h   |    3 ++-
 arch/x86/kernel/cpu/Makefile |    5 +++++
 arch/x86/kernel/smpboot.c    |    2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 4640ddd..638bf62 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -85,7 +85,8 @@ static inline void native_write_msr(unsigned int msr,
 	asm volatile("wrmsr" : : "c" (msr), "a"(low), "d" (high) : "memory");
 }
 
-static inline int native_write_msr_safe(unsigned int msr,
+/* Can be uninlined because referenced by paravirt */
+notrace static inline int native_write_msr_safe(unsigned int msr,
 					unsigned low, unsigned high)
 {
 	int err;
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index fc99173..c381330 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -2,6 +2,11 @@
 # Makefile for x86-compatible CPU details, features and quirks
 #
 
+# Don't trace early stages of a secondary CPU boot
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_common.o = -pg
+endif
+
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
 obj-y			+= vmware.o hypervisor.o
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b1d571b..31869bf 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -282,7 +282,7 @@ static int __cpuinitdata unsafe_smp;
 /*
  * Activate a secondary processor.
  */
-static void __cpuinit start_secondary(void *unused)
+notrace static void __cpuinit start_secondary(void *unused)
 {
 	/*
 	 * Don't put *anything* before cpu_init(), SMP booting is too
-- 
1.6.0.4


