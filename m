Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbYGASuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbYGASuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYGASuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:50:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:18584 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbYGASuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:50:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Nnl31kyfj4s5kC5Fo4G2k+oHpncd9O9KBVrsWUZyvvIs+WmSZ75Di/+LxcmQfPqBR6
         Jio+5oq0Pg8Sw8UWaDpC1YXwR34J1+1fKkebNG4dxUJNJuVUiYDg9JGtMEW3CMl0Rx7C
         0IdCNELl/vxjaV5JixW/lVH3RfbDvxyJIuNoI=
Message-ID: <486A7C19.5080905@gmail.com>
Date: Wed, 02 Jul 2008 00:18:57 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>
CC: Alexander Beregalov <a.beregalov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, sparclinux@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: next-0630: sparc64: build failed
References: <a4423d670807010825t7ea2eb44oda3f08dc007c40a2@mail.gmail.com> <20080701154648.GA31057@elte.hu>
In-Reply-To: <20080701154648.GA31057@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>     Alexander Beregalov reported this build failure:
>     
>     $ make CROSS_COMPILE=sparc64-unknown-linux-gnu- image modules && sudo
>     make modules_install
>       CHK     include/linux/version.h
>       CHK     include/linux/utsrelease.h
>       CALL    scripts/checksyscalls.sh
>       CHK     include/linux/compile.h
>     dnsdomainname: Unknown host
>       CC      arch/sparc64/kernel/sparc64_ksyms.o
>     arch/sparc64/kernel/sparc64_ksyms.c:116: error: '_mcount' undeclared
>     here (not in a function)
>     cc1: warnings being treated as errors
>     arch/sparc64/kernel/sparc64_ksyms.c:116: error: type defaults to 'int'
>     in declaration of '_mcount'
>     
>     And bisected it back to:
>     
>     | commit 395a59d0f8e86bb39cd700c3d185d30c670bb958
>     | Author: Abhishek Sagar <sagar.abhishek@gmail.com>
>     | Date:   Sat Jun 21 23:47:27 2008 +0530
>     |
>     |     ftrace: store mcount address in rec->ip
>     
>     the mcount prototype is only available under CONFIG_FTRACE,
>     extend it to CONFIG_MCOUNT as well.
>     
>     Reported-and-bisected-by: Alexander Beregalov <a.beregalov@gmail.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>

Hi Ingo/David,

CONFIG_MCOUNT currently controls the compilation with -pg flag and the export
of _mcount. But with ftrace, the former is redundant and the latter should be
made unconditional since _mcount is always defined. In which case, does the
inlined patch (untested) make sense? It should solve the build failure as well.

[for tip/master]

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---
sparc64: get rid of CONFIG_MCOUNT

There are two possible (not necessarily exclusive) uses of the _mcount call:
1. To do stack usage debugging.
2. Function tracing.

Both have separate CONFIG_* options and don't require an alias such as
CONFIG_MCOUNT.

diff --git a/arch/sparc64/Kconfig.debug b/arch/sparc64/Kconfig.debug
index d6d32d1..6065be7 100644
--- a/arch/sparc64/Kconfig.debug
+++ b/arch/sparc64/Kconfig.debug
@@ -31,11 +31,6 @@ config DEBUG_PAGEALLOC
 	  This results in a large slowdown, but helps to find certain types
 	  of memory corruptions.
 
-config MCOUNT
-	bool
-	depends on STACK_DEBUG || FTRACE
-	default y
-
 config FRAME_POINTER
 	bool
 	depends on MCOUNT
diff --git a/arch/sparc64/Makefile b/arch/sparc64/Makefile
index 4b8f2b0..c182e5c 100644
--- a/arch/sparc64/Makefile
+++ b/arch/sparc64/Makefile
@@ -19,8 +19,10 @@ KBUILD_CFLAGS += -m64 -pipe -mno-fpu -mcpu=ultrasparc -mcmodel=medlow \
 KBUILD_CFLAGS += $(call cc-option,-mtune=ultrasparc3)
 KBUILD_AFLAGS += -m64 -mcpu=ultrasparc -Wa,--undeclared-regs
 
-ifeq ($(CONFIG_MCOUNT),y)
-  KBUILD_CFLAGS += -pg
+ifneq ($(CONFIG_FTRACE),y)
+ifeq ($(CONFIG_STACK_DEBUG),y)
+KBUILD_CFLAGS += -pg
+endif
 endif
 
 head-y := arch/sparc64/kernel/head.o arch/sparc64/kernel/init_task.o
diff --git a/arch/sparc64/kernel/sparc64_ksyms.c b/arch/sparc64/kernel/sparc64_ksyms.c
index b80d982..13c243c 100644
--- a/arch/sparc64/kernel/sparc64_ksyms.c
+++ b/arch/sparc64/kernel/sparc64_ksyms.c
@@ -112,10 +112,7 @@ EXPORT_SYMBOL(__write_trylock);
 EXPORT_SYMBOL(smp_call_function);
 #endif /* CONFIG_SMP */
 
-#if defined(CONFIG_MCOUNT)
 EXPORT_SYMBOL(_mcount);
-#endif
-
 EXPORT_SYMBOL(sparc64_get_clock_tick);
 
 /* RW semaphores */
diff --git a/include/asm-sparc64/ftrace.h b/include/asm-sparc64/ftrace.h
index f76a40a..51036c3 100644
--- a/include/asm-sparc64/ftrace.h
+++ b/include/asm-sparc64/ftrace.h
@@ -4,11 +4,10 @@
 #ifdef CONFIG_FTRACE
 #define MCOUNT_ADDR		((long)(_mcount))
 #define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
+#endif
 
 #ifndef __ASSEMBLY__
 extern void _mcount(void);
 #endif
 
-#endif
-
 #endif /* _ASM_SPARC64_FTRACE */
