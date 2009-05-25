Return-Path: <linux-kernel-owner+w=401wt.eu-S1752942AbZEYQUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbZEYQUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 12:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbZEYQU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 12:20:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38270 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbZEYQU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 12:20:26 -0400
Date: Mon, 25 May 2009 17:19:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090525161941.GA3667@n2100.arm.linux.org.uk>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525151724.GA14321@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 11:17:24AM -0400, Mathieu Desnoyers wrote:
> I realize I have not made myself clear, I apologise :
> 
> - as you say, cmpxchg_local, xchg_local, local atomic add return do not
>   need any memory barrier whatsoever, given they are cpu-local.

Presumably that's what we currently have using the generic versions.

> - cmpxchg, xchg and atomic add return need memory barriers on
>   architectures which can reorder the relative order in which memory
>   read/writes can be seen between CPUs, which seems to include recent
>   ARM architectures. Those barriers are currently missing on ARM.

cmpxchg is not implemented on SMP (yet) so we can ignore that.

However, xchg and atomic ops returning values are, and as you point out
are missing the necessary barriers.  So, here's a patch which adds the
necessary barriers both before and after these ops (as required by the
atomic ops doc.)

Does this satisfy your immediate concern?

diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index ee99723..4d3ad67 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -49,6 +49,8 @@ static inline int atomic_add_return(int i, atomic_t *v)
 	unsigned long tmp;
 	int result;
 
+	smp_mb();
+
 	__asm__ __volatile__("@ atomic_add_return\n"
 "1:	ldrex	%0, [%2]\n"
 "	add	%0, %0, %3\n"
@@ -59,6 +61,8 @@ static inline int atomic_add_return(int i, atomic_t *v)
 	: "r" (&v->counter), "Ir" (i)
 	: "cc");
 
+	smp_mb();
+
 	return result;
 }
 
@@ -67,6 +71,8 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 	unsigned long tmp;
 	int result;
 
+	smp_mb();
+
 	__asm__ __volatile__("@ atomic_sub_return\n"
 "1:	ldrex	%0, [%2]\n"
 "	sub	%0, %0, %3\n"
@@ -77,6 +83,8 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 	: "r" (&v->counter), "Ir" (i)
 	: "cc");
 
+	smp_mb();
+
 	return result;
 }
 
@@ -84,6 +92,8 @@ static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
 {
 	unsigned long oldval, res;
 
+	smp_mb();
+
 	do {
 		__asm__ __volatile__("@ atomic_cmpxchg\n"
 		"ldrex	%1, [%2]\n"
@@ -95,6 +105,8 @@ static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
 		    : "cc");
 	} while (res);
 
+	smp_mb();
+
 	return oldval;
 }
 
diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
index bd4dc8e..e9889c2 100644
--- a/arch/arm/include/asm/system.h
+++ b/arch/arm/include/asm/system.h
@@ -248,6 +248,8 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
 	unsigned int tmp;
 #endif
 
+	smp_mb();
+
 	switch (size) {
 #if __LINUX_ARM_ARCH__ >= 6
 	case 1:
@@ -258,7 +260,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
 		"	bne	1b"
 			: "=&r" (ret), "=&r" (tmp)
 			: "r" (x), "r" (ptr)
-			: "memory", "cc");
+			: "cc");
 		break;
 	case 4:
 		asm volatile("@	__xchg4\n"
@@ -268,7 +270,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
 		"	bne	1b"
 			: "=&r" (ret), "=&r" (tmp)
 			: "r" (x), "r" (ptr)
-			: "memory", "cc");
+			: "cc");
 		break;
 #elif defined(swp_is_buggy)
 #ifdef CONFIG_SMP
@@ -293,20 +295,21 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
 		"	swpb	%0, %1, [%2]"
 			: "=&r" (ret)
 			: "r" (x), "r" (ptr)
-			: "memory", "cc");
+			: "cc");
 		break;
 	case 4:
 		asm volatile("@	__xchg4\n"
 		"	swp	%0, %1, [%2]"
 			: "=&r" (ret)
 			: "r" (x), "r" (ptr)
-			: "memory", "cc");
+			: "cc");
 		break;
 #endif
 	default:
 		__bad_xchg(ptr, size), ret = 0;
 		break;
 	}
+	smp_mb();
 
 	return ret;
 }
