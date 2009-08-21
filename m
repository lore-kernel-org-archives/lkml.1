Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbZHUPJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbZHUPJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 11:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbZHUPJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 11:09:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991AbZHUPJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 11:09:42 -0400
Message-ID: <4A8EB8A9.9000900@redhat.com>
Date: Fri, 21 Aug 2009 11:09:29 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add minimal support for software performance counters
 for ia64
References: <4A8C2290.3040707@redhat.com> <1250698351.8282.106.camel@twins> <4A8C4CAA.5070101@redhat.com> <1250708819.7154.5.camel@laptop> <4A8DBDDB.5080402@redhat.com> <20090821142514.GE11098@elte.hu>
In-Reply-To: <20090821142514.GE11098@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------060407090002040105020900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060407090002040105020900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> * William Cohen <wcohen@redhat.com> wrote:
> 
>> Peter Zijlstra wrote:
>>> On Wed, 2009-08-19 at 15:04 -0400, William Cohen wrote:
>>>> Peter Zijlstra wrote:
>>>>> On Wed, 2009-08-19 at 12:04 -0400, William Cohen wrote:
>>>>>> +#ifdef __ia64__
>>>>>> +#include "../../arch/ia64/include/asm/unistd.h"
>>>>>> +#define rmb()          asm volatile("" ::: "memory")
>>>>>> +#define cpu_relax()    asm volatile("" ::: "memory");
>>>>>> +#endif
>>>>> Surely the itanic has a real memory barrier? The kernel seems to use
>>>>> something along the lines of mf.
>>>>>
>>>>> Also, cpu_relax() seems to end up being asm volatile("hint @pause" :::
>>>>> "memory"), although we don't seem to have an actual user of cpu_relax()
>>>>> in perf atm.
>>>>>
>>>>>
>>>>>
>>>> Peter, thanks for the comment. I took a look at the rmb() and cpu_relax() code
>>>> in the kernel and revised the patch with the appropriate defines
>>> Looks good now, thanks!
>>>
>> When looking through the patch today I realized the new 
>> perf_counter.h was placed in include/asm-ia64. It should be placed 
>> in arch/ia64/include/asm/perf_counter.h.
> 
> mind sending out a v2 patch with all review feedback folded in, for 
> IA64 maintainers to ack if they like it?
> 
> Thanks,
> 
> 	Ingo

Hi Ingo,

The following is the revised patch with the corrected macros and the include
file in the correct place.

Signed-off-by: William Cohen <wcohen@redhat.com>

-Will

--------------060407090002040105020900
Content-Type: text/plain;
 name="perf_ia64c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf_ia64c.patch"

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 170042b..8471526 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -29,6 +29,7 @@ config IA64
 	select HAVE_KVM
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DMA_API_DEBUG
+	select HAVE_PERF_COUNTERS
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/ia64/include/asm/unistd.h b/arch/ia64/include/asm/unistd.h
index 5a5347f..f69d1c9 100644
--- a/arch/ia64/include/asm/unistd.h
+++ b/arch/ia64/include/asm/unistd.h
@@ -311,11 +311,12 @@
 #define __NR_preadv			1319
 #define __NR_pwritev			1320
 #define __NR_rt_tgsigqueueinfo		1321
+#define __NR_perf_counter_open		1322
 
 #ifdef __KERNEL__
 
 
-#define NR_syscalls			298 /* length of syscall table */
+#define NR_syscalls			299 /* length of syscall table */
 
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining about
diff --git a/arch/ia64/kernel/entry.S b/arch/ia64/kernel/entry.S
index d0e7d37..4cf88b0 100644
--- a/arch/ia64/kernel/entry.S
+++ b/arch/ia64/kernel/entry.S
@@ -1806,6 +1806,7 @@ sys_call_table:
 	data8 sys_preadv
 	data8 sys_pwritev			// 1320
 	data8 sys_rt_tgsigqueueinfo
+	data8 sys_perf_counter_open
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
 #endif /* __IA64_ASM_PARAVIRTUALIZED_NATIVE */
diff --git a/arch/ia64/include/asm/perf_counter.h b/arch/ia64/include/asm/perf_counter.h
new file mode 100644
index 0000000..cab4352
--- /dev/null
+++ b/arch/ia64/include/asm/perf_counter.h
@@ -0,0 +1,9 @@
+#ifndef __ASM_IA64_PERF_COUNTER_H
+#define __ASM_IA64_PERF_COUNTER_H
+
+/* IA64 only supports software counters through this interface. */
+static inline void set_perf_counter_pending(void) {}
+
+#define PERF_COUNTER_INDEX_OFFSET	0
+
+#endif /* __ASM_IA64_PERF_COUNTER_H */
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c481a51..69db3de 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -159,8 +159,10 @@ uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
 # If we're on a 64-bit kernel, use -m64
 ifndef NO_64BIT
-	ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
-	  M64 := -m64
+	ifeq ($(patsubst %ia64,%,$(uname_M)),$(uname_M))
+	  ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
+	    M64 := -m64
+	  endif
 	endif
 endif
 
@@ -169,9 +171,9 @@ endif
 #
 # Include saner warnings here, which can catch bugs:
 #
-EXTRA_WARNINGS = -Wcast-align -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement
+EXTRA_WARNINGS = -Wformat -Wformat-security -Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls -Wstack-protector -Wstrict-aliasing=3 -Wswitch-default -Wswitch-enum -Wno-system-headers -Wundef -Wvolatile-register-var -Wwrite-strings -Wbad-function-cast -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wstrict-prototypes -Wdeclaration-after-statement
 
-CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
+CFLAGS = $(M64) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 -fno-strict-aliasing $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index e5148e2..c849337 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -41,6 +41,12 @@
 #define cpu_relax()	asm volatile("" ::: "memory");
 #endif
 
+#ifdef __ia64__
+#include "../../arch/ia64/include/asm/unistd.h"
+#define rmb()		asm volatile("mf" ::: "memory")
+#define cpu_relax()	asm volatile("hint @pause" ::: "memory")
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>

--------------060407090002040105020900--
