Return-Path: <linux-kernel-owner+w=401wt.eu-S935639AbZAPOXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935639AbZAPOXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbZAPOW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:22:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51825 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbZAPOWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:22:54 -0500
Date: Fri, 16 Jan 2009 15:22:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Cc: hugh@veritas.com
Subject: [PATCH] Use early clobbers in usercopy*.c
Message-ID: <20090116142211.GA31576@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 229689f6f129334446e48e777d12cbf365745283
Author: Andi Kleen <ak@linux.intel.com>
Date:   Wed Jan 14 07:50:57 2009 +0100

    Use early clobbers in usercopy*.c
    
    Hugh Dickins noticed that strncpy_from_user() was miscompiled
    in some circumstances with gcc 4.3.
    
    Thanks to Hugh's excellent analysis it was easy to track down.
    
    Hugh writes:
    
    Try building an x86_64 defconfig 2.6.29-rc1 kernel tree,
    except not quite defconfig, switch CONFIG_PREEMPT_NONE=y
    and CONFIG_PREEMPT_VOLUNTARY off (because it expands a
    might_fault() there, which hides the issue): using a
    gcc 4.3.2 (I've checked both openSUSE 11.1 and Fedora 10).
    
    It generates the following:
    
    0000000000000000 <__strncpy_from_user>:
       0:   48 89 d1                mov    %rdx,%rcx
       3:   48 85 c9                test   %rcx,%rcx
       6:   74 0e                   je     16 <__strncpy_from_user+0x16>
       8:   ac                      lods   %ds:(%rsi),%al
       9:   aa                      stos   %al,%es:(%rdi)
       a:   84 c0                   test   %al,%al
       c:   74 05                   je     13 <__strncpy_from_user+0x13>
       e:   48 ff c9                dec    %rcx
      11:   75 f5                   jne    8 <__strncpy_from_user+0x8>
      13:   48 29 c9                sub    %rcx,%rcx
      16:   48 89 c8                mov    %rcx,%rax
      19:   c3                      retq
    
    Observe that "sub %rcx,%rcx; mov %rcx,%rax", whereas gcc 4.2.1
    (and many other configs) say "sub %rcx,%rdx; mov %rdx,%rax".
    Isn't it returning 0 when it ought to be returning strlen?
    
    AK:
    
    The asm constraints for the strncpy_from_user() result were missing an
    early clobber, which tells gcc that the last output arguments
    are written before all input arguments are read.
    
    I also added some more early clobbers in the rest of the file.
    
    And indeed 32bit usercopy.c had the same problem in some places.
    Fixed there too.

    Stable candidate
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 4a20b2f..7c8ca91 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -56,7 +56,7 @@ do {									   \
 		"	jmp 2b\n"					   \
 		".previous\n"						   \
 		_ASM_EXTABLE(0b,3b)					   \
-		: "=d"(res), "=c"(count), "=&a" (__d0), "=&S" (__d1),	   \
+		: "=&d"(res), "=&c"(count), "=&a" (__d0), "=&S" (__d1),	   \
 		  "=&D" (__d2)						   \
 		: "i"(-EFAULT), "0"(count), "1"(count), "3"(src), "4"(dst) \
 		: "memory");						   \
@@ -218,7 +218,7 @@ long strnlen_user(const char __user *s, long n)
 		"	.align 4\n"
 		"	.long 0b,2b\n"
 		".previous"
-		:"=r" (n), "=D" (s), "=a" (res), "=c" (tmp)
+		:"=&r" (n), "=&D" (s), "=&a" (res), "=&c" (tmp)
 		:"0" (n), "1" (s), "2" (0), "3" (mask)
 		:"cc");
 	return res & mask;
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 64d6c84..ec13cb5 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -32,7 +32,7 @@ do {									   \
 		"	jmp 2b\n"					   \
 		".previous\n"						   \
 		_ASM_EXTABLE(0b,3b)					   \
-		: "=r"(res), "=c"(count), "=&a" (__d0), "=&S" (__d1),	   \
+		: "=&r"(res), "=&c"(count), "=&a" (__d0), "=&S" (__d1),	   \
 		  "=&D" (__d2)						   \
 		: "i"(-EFAULT), "0"(count), "1"(count), "3"(src), "4"(dst) \
 		: "memory");						   \
@@ -86,7 +86,7 @@ unsigned long __clear_user(void __user *addr, unsigned long size)
 		".previous\n"
 		_ASM_EXTABLE(0b,3b)
 		_ASM_EXTABLE(1b,2b)
-		: [size8] "=c"(size), [dst] "=&D" (__d0)
+		: [size8] "=&c"(size), [dst] "=&D" (__d0)
 		: [size1] "r"(size & 7), "[size8]" (size / 8), "[dst]"(addr),
 		  [zero] "r" (0UL), [eight] "r" (8UL));
 	return size;
