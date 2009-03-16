Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbZCPSHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbZCPSHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZCPSH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:07:27 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:59510 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZCPSH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:07:26 -0400
Date: Mon, 16 Mar 2009 19:01:32 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
Message-ID: <20090316190132.7965a49a@skybase>
In-Reply-To: <1236671631-9305-1-git-send-email-tj@kernel.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Tue, 10 Mar 2009 16:53:46 +0900
Tejun Heo <tj@kernel.org> wrote:

> The only differences are 1. there can be more space between percpu
> areas for each cpu to accomodate minimum allocation size and first
> chunk dynamic reserve and 2. dynamic percpu variables use the same
> address translation mechanism as static ones.
> 
> #1 shouldn't cause any trouble and #2 shouldn't too because the
> offsets for dynamic percpu variables are carried in full pointer-width
> variables, so as long as the calculations don't make wrong assumptions
> (should be masked by RELOC_HIDE), it should be okay, but if your arch
> has addressing limitations (alpha, s390), please take a second look.

We do have a problem with #2, the dynamic percpu patches currently
breaks s390. But the nice thing is that we can now get rid of the GOTENT
relocation for the percpu symbols. If the code is changed to use
RELOC_HIDE for the SHIFT_PERCPU_PTR define, everything works just fine.
Patch attached. Nice works guys.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

---
Subject: [PATCH] s390: percpu access.

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

With the dynamic percpu allocator there is no need anymore to play
tricks with the GOTENT relocation for the access to the percpu
symbols. A simple RELOC_HIDE gets the job done.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/include/asm/percpu.h |   26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff -urpN linux-next/arch/s390/include/asm/percpu.h linux-patched/arch/s390/include/asm/percpu.h
--- linux-next/arch/s390/include/asm/percpu.h	2009-03-16 18:53:47.000000000 +0100
+++ linux-patched/arch/s390/include/asm/percpu.h	2009-03-16 18:53:35.000000000 +0100
@@ -4,31 +4,7 @@
 #include <linux/compiler.h>
 #include <asm/lowcore.h>
 
-/*
- * s390 uses its own implementation for per cpu data, the offset of
- * the cpu local data area is cached in the cpu's lowcore memory.
- * For 64 bit module code s390 forces the use of a GOT slot for the
- * address of the per cpu variable. This is needed because the module
- * may be more than 4G above the per cpu area.
- */
-#if defined(__s390x__) && defined(MODULE)
-
-#define SHIFT_PERCPU_PTR(ptr,offset) (({			\
-	extern int simple_identifier_##var(void);	\
-	unsigned long *__ptr;				\
-	asm ( "larl %0, %1@GOTENT"		\
-	    : "=a" (__ptr) : "X" (ptr) );		\
-	(typeof(ptr))((*__ptr) + (offset));	}))
-
-#else
-
-#define SHIFT_PERCPU_PTR(ptr, offset) (({				\
-	extern int simple_identifier_##var(void);		\
-	unsigned long __ptr;					\
-	asm ( "" : "=a" (__ptr) : "0" (ptr) );			\
-	(typeof(ptr)) (__ptr + (offset)); }))
-
-#endif
+#define SHIFT_PERCPU_PTR(var, offset) RELOC_HIDE(&per_cpu_var(var), (offset))
 
 #define __my_cpu_offset S390_lowcore.percpu_offset
 
