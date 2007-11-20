Return-Path: <linux-kernel-owner+w=401wt.eu-S1761459AbXKTVmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761459AbXKTVmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 16:42:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbXKTVm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 16:42:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57638 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173AbXKTVm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 16:42:28 -0500
Date: Tue, 20 Nov 2007 13:41:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45 Build Failure  - macro
 CONFIG_THREAD_ORDER not defined
Message-Id: <20071120134120.745bd5b4.akpm@linux-foundation.org>
In-Reply-To: <47434F2E.6080007@linux.vnet.ibm.com>
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
	<47434F2E.6080007@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 02:48:38 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> The kernel build fails, with randconfig
> 
>   CC      arch/x86/kernel/asm-offsets.s
> In file included from include/asm/thread_info.h:4,
>                  from include/linux/thread_info.h:21,
>                  from include/linux/preempt.h:9,
>                  from include/linux/spinlock.h:49,
>                  from include/linux/seqlock.h:29,
>                  from include/linux/time.h:8,
>                  from include/linux/stat.h:60,
>                  from include/linux/module.h:10,
>                  from include/linux/crypto.h:21,
>                  from arch/x86/kernel/asm-offsets_64.c:7,
>                  from arch/x86/kernel/asm-offsets.c:4:
> include/asm/thread_info_64.h: In function ___current_thread_info___:
> include/asm/thread_info_64.h:63: error: ___CONFIG_THREAD_ORDER___ undeclared (first use in this function)
> include/asm/thread_info_64.h:63: error: (Each undeclared identifier is reported only once
> include/asm/thread_info_64.h:63: error: for each function it appears in.)
> include/asm/thread_info_64.h: In function ___stack_thread_info___:
> include/asm/thread_info_64.h:71: error: ___CONFIG_THREAD_ORDER___ undeclared (first use in this function)
> In file included from arch/x86/kernel/asm-offsets_64.c:8,
>                  from arch/x86/kernel/asm-offsets.c:4:
> include/linux/sched.h: At top level:
> include/linux/sched.h:1527: error: ___CONFIG_THREAD_ORDER___ undeclared here (not in a function)
> make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
> 
> The patch git-x86.patch introduces CONFIG_THREAD_ORDER undefined macro, instead of THREAD_ORDER.

hrm.  I suppose this will get us going:

diff -puN include/asm-x86/page_64.h~git-x86-thread_order-borkage include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h~git-x86-thread_order-borkage
+++ a/include/asm-x86/page_64.h
@@ -9,7 +9,7 @@
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 #define PHYSICAL_PAGE_MASK	(~(PAGE_SIZE-1) & __PHYSICAL_MASK)
 
-#define THREAD_SIZE  (PAGE_SIZE << CONFIG_THREAD_ORDER)
+#define THREAD_SIZE  (PAGE_SIZE << THREAD_ORDER)
 #define CURRENT_MASK (~(THREAD_SIZE-1))
 
 #define EXCEPTION_STACK_ORDER 0
diff -puN include/asm-x86/thread_info_64.h~git-x86-thread_order-borkage include/asm-x86/thread_info_64.h
--- a/include/asm-x86/thread_info_64.h~git-x86-thread_order-borkage
+++ a/include/asm-x86/thread_info_64.h
@@ -80,9 +80,9 @@ static inline struct thread_info *stack_
 #endif
 
 #define alloc_thread_info(tsk) \
-	((struct thread_info *) __get_free_pages(THREAD_FLAGS, CONFIG_THREAD_ORDER))
+	((struct thread_info *) __get_free_pages(THREAD_FLAGS, THREAD_ORDER))
 
-#define free_thread_info(ti) free_pages((unsigned long) (ti), CONFIG_THREAD_ORDER)
+#define free_thread_info(ti) free_pages((unsigned long) (ti), THREAD_ORDER)
 
 #else /* !__ASSEMBLY__ */
 
_

