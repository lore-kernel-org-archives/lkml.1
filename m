Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbZBDSja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbZBDSja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758312AbZBDShG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:06 -0500
Received: from kroah.org ([198.145.64.141]:50948 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758280AbZBDShD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:03 -0500
Date: Wed, 4 Feb 2009 10:34:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 06/33] x86: use early clobbers in usercopy*.c
Message-ID: <20090204183427.GG13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-use-early-clobbers-in-usercopy-.c.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andi Kleen <andi@firstfloor.org>

commit e0a96129db574d6365e3439d16d88517c437ab33 upstream.

Impact: fix rare (but currently harmless) miscompile with certain configs and gcc versions

Hugh Dickins noticed that strncpy_from_user() was miscompiled
in some circumstances with gcc 4.3.

Thanks to Hugh's excellent analysis it was easy to track down.

Hugh writes:

> Try building an x86_64 defconfig 2.6.29-rc1 kernel tree,
> except not quite defconfig, switch CONFIG_PREEMPT_NONE=y
> and CONFIG_PREEMPT_VOLUNTARY off (because it expands a
> might_fault() there, which hides the issue): using a
> gcc 4.3.2 (I've checked both openSUSE 11.1 and Fedora 10).
>
> It generates the following:
>
> 0000000000000000 <__strncpy_from_user>:
>    0:   48 89 d1                mov    %rdx,%rcx
>    3:   48 85 c9                test   %rcx,%rcx
>    6:   74 0e                   je     16 <__strncpy_from_user+0x16>
>    8:   ac                      lods   %ds:(%rsi),%al
>    9:   aa                      stos   %al,%es:(%rdi)
>    a:   84 c0                   test   %al,%al
>    c:   74 05                   je     13 <__strncpy_from_user+0x13>
>    e:   48 ff c9                dec    %rcx
>   11:   75 f5                   jne    8 <__strncpy_from_user+0x8>
>   13:   48 29 c9                sub    %rcx,%rcx
>   16:   48 89 c8                mov    %rcx,%rax
>   19:   c3                      retq
>
> Observe that "sub %rcx,%rcx; mov %rcx,%rax", whereas gcc 4.2.1
> (and many other configs) say "sub %rcx,%rdx; mov %rdx,%rax".
> Isn't it returning 0 when it ought to be returning strlen?

The asm constraints for the strncpy_from_user() result were missing an
early clobber, which tells gcc that the last output arguments
are written before all input arguments are read.

Also add more early clobbers in the rest of the file and fix 32-bit
usercopy.c in the same way.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
[ since this API is rarely used and no in-kernel user relies on a 'len'
  return value (they only rely on negative return values) this miscompile
  was never noticed in the field. But it's worth fixing it nevertheless. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/lib/usercopy_32.c |    4 ++--
 arch/x86/lib/usercopy_64.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

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
@@ -218,7 +218,7 @@ long strnlen_user(const char __user *s, 
 		"	.align 4\n"
 		"	.long 0b,2b\n"
 		".previous"
-		:"=r" (n), "=D" (s), "=a" (res), "=c" (tmp)
+		:"=&r" (n), "=&D" (s), "=&a" (res), "=&c" (tmp)
 		:"0" (n), "1" (s), "2" (0), "3" (mask)
 		:"cc");
 	return res & mask;
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
@@ -86,7 +86,7 @@ unsigned long __clear_user(void __user *
 		".previous\n"
 		_ASM_EXTABLE(0b,3b)
 		_ASM_EXTABLE(1b,2b)
-		: [size8] "=c"(size), [dst] "=&D" (__d0)
+		: [size8] "=&c"(size), [dst] "=&D" (__d0)
 		: [size1] "r"(size & 7), "[size8]" (size / 8), "[dst]"(addr),
 		  [zero] "r" (0UL), [eight] "r" (8UL));
 	return size;

