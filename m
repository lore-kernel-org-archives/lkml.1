Return-Path: <linux-kernel-owner+w=401wt.eu-S1751424Ab0AHFSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab0AHFSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 00:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123Ab0AHFSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 00:18:52 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52300 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab0AHFSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 00:18:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=obkqenMRUDAcN+PAr8zEjxDD/py4614z7s3G69vWOiuFUvWeLXKHSQYAU4rRw0sN0c
         qp5gsm8+3GVxfRexsnhLkrQUc/g/oOhCzDDzh1qV0Otd5xTZ7XIEVdw9axsZRfCfHn5X
         PQ8J0//bfeH8+RPlZX6tXbEMKHf0UxtZ3qm/Y=
Date: Fri, 8 Jan 2010 06:18:48 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Yi <yi.li@analog.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] Ftrace: irqsoff tracer may cause stack overflow
Message-ID: <20100108051847.GB5468@nowhere>
References: <1262925925.27700.15.camel@adam-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262925925.27700.15.camel@adam-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 12:45:25PM +0800, Li Yi wrote:
> "irqsoff" tracer may cause stack overflow on architectures using
> asm-generic/atomic.h, due to recursive invoking of, e.g.
> trace_hardirqs_off().
> 
> trace_hardirqs_off() -> start_critical_timing() -> atomic_inc() ->
> atomic_add_return() -> local_irq_save() -> trace_hardirqs_off()
> 
> Signed-off-by: Yi Li <yi.li@analog.com>



Good catch!

However, may be we should keep the local_irq_save there
and have __raw_atomic_* versions only for tracing.

It's better to keep track of most irq disabled sites.

Why not something like the following (untested):


diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index c99c64d..ffc6772 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -17,6 +17,14 @@
 #error not SMP safe
 #endif
 
+#ifdef __ATOMIC_NEED_RAW_IRQ_SAVE
+#define __atomic_op_irq_save(f)		raw_local_irq_save(f)
+#define __atomic_op_irq_restore(f)	raw_local_irq_restore(f)
+#else
+#define __atomic_op_irq_save(f)		local_irq_save(f)
+#define __atomic_op_irq_restore(f)	local_irq_restore(f)
+#endif
+
 /*
  * Atomic operations that C can't guarantee us.  Useful for
  * resource counting etc..
@@ -60,11 +68,11 @@ static inline int atomic_add_return(int i, atomic_t *v)
 	unsigned long flags;
 	int temp;
 
-	local_irq_save(flags);
+	__atomic_op_irq_save(flags);
 	temp = v->counter;
 	temp += i;
 	v->counter = temp;
-	local_irq_restore(flags);
+	__atomic_op_irq_restore(flags);
 
 	return temp;
 }
@@ -82,11 +90,11 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 	unsigned long flags;
 	int temp;
 
-	local_irq_save(flags);
+	__atomic_op_irq_save(flags);
 	temp = v->counter;
 	temp -= i;
 	v->counter = temp;
-	local_irq_restore(flags);
+	__atomic_op_irq_restore(flags);
 
 	return temp;
 }
@@ -139,9 +147,9 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 	unsigned long flags;
 
 	mask = ~mask;
-	local_irq_save(flags);
+	__atomic_op_irq_save(flags);
 	*addr &= mask;
-	local_irq_restore(flags);
+	__atomic_op_irq_restore(flags);
 }
 
 #define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 2974bc7..6bcb1d1 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -9,6 +9,9 @@
  *  Copyright (C) 2004-2006 Ingo Molnar
  *  Copyright (C) 2004 William Lee Irwin III
  */
+
+#define __ATOMIC_NEED_RAW_IRQ_SAVE
+
 #include <linux/kallsyms.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>


