Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbYBCMMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbYBCMMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 07:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760493AbYBCMMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 07:12:42 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:24445 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760181AbYBCMMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 07:12:40 -0500
Date: Sun, 3 Feb 2008 13:12:38 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Bastian Blank <bastian@waldi.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix ext4 bitops
Message-ID: <20080203121238.GD18211@osiris.ibm.com>
References: <20080201200208.GA28274@wavehammer.waldi.eu.org> <20080201122257.9524c2bb.akpm@linux-foundation.org> <20080201210404.GA31271@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201210404.GA31271@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 10:04:04PM +0100, Bastian Blank wrote:
> On Fri, Feb 01, 2008 at 12:22:57PM -0800, Andrew Morton wrote:
> > On Fri, 1 Feb 2008 21:02:08 +0100
> > Bastian Blank <bastian@waldi.eu.org> wrote:
> > 
> > > Fix ext4 bitops.
> > 
> > This is incomplete.  Please tell us what was "fixed".
> > 
> > If it was a build error then please quote the compile error output in the
> > changelog, as well as the usual description of what the problem is, and how
> > it was fixed.
> 
> | fs/ext4/mballoc.c: In function 'ext4_mb_generate_buddy':
> | fs/ext4/mballoc.c:954: error: implicit declaration of function 'generic_find_next_le_bit'
> 
> The s390 specific bitops uses parts of the generic implementation.
> Include the correct header.

That doesn't work:

fs/built-in.o: In function `ext4_mb_release_inode_pa':
mballoc.c:(.text+0x95a8a): undefined reference to `generic_find_next_le_bit'
fs/built-in.o: In function `ext4_mb_init_cache':
mballoc.c:(.text+0x967ea): undefined reference to `generic_find_next_le_bit'

This still needs generic_find_next_le_bit which comes
from lib/find_next_bit.c. That one doesn't get built on s390 since we
don't set GENERIC_FIND_NEXT_BIT.
Currently we have the lengthly patch below queued.

Subject: [PATCH] Implement ext2_find_next_bit.

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fixes this compile error:

fs/ext4/mballoc.c:
	In function 'ext4_mb_generate_buddy':
fs/ext4/mballoc.c:954:
	error: implicit declaration of function 'generic_find_next_le_bit'

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-s390/bitops.h |  130 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 128 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/include/asm-s390/bitops.h linux-2.6-patched/include/asm-s390/bitops.h
--- linux-2.6/include/asm-s390/bitops.h	2008-02-01 12:29:03.000000000 +0100
+++ linux-2.6-patched/include/asm-s390/bitops.h	2008-02-01 12:31:39.000000000 +0100
@@ -772,8 +772,6 @@ static inline int sched_find_first_bit(u
 	test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
 #define ext2_test_bit(nr, addr)      \
 	test_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
 
 #ifndef __s390x__
 
@@ -820,6 +818,48 @@ ext2_find_first_zero_bit(void *vaddr, un
         return (res < size) ? res : size;
 }
 
+static inline int __ext2_find_first_bit(void *vaddr, unsigned int size)
+{
+	typedef struct { long _[__BITOPS_WORDS(size)]; } addrtype;
+	unsigned long cmp, count;
+	unsigned int res;
+
+	if (!size)
+		return 0;
+	asm volatile(
+		"	lhi	%1,0\n"
+		"	lr	%2,%3\n"
+		"	lhi	%0,0\n"
+		"	ahi	%2,31\n"
+		"	srl	%2,5\n"
+		"0:	cl	%1,0(%0,%4)\n"
+		"	jne	1f\n"
+		"	ahi	%0,4\n"
+		"	brct	%2,0b\n"
+		"	lr	%0,%3\n"
+		"	j	4f\n"
+		"1:	l	%2,0(%0,%4)\n"
+		"	sll	%0,3\n"
+		"	ahi	%0,24\n"
+		"	lhi	%1,0xff\n"
+		"	tmh	%2,0xffff\n"
+		"	jnz	2f\n"
+		"	ahi	%0,-16\n"
+		"	srl	%2,16\n"
+		"2:	tml	%2,0xff00\n"
+		"	jnz	3f\n"
+		"	ahi	%0,-8\n"
+		"	srl	%2,8\n"
+		"3:	nr	%2,%1\n"
+		"	ic	%2,0(%2,%5)\n"
+		"	alr	%0,%2\n"
+		"4:"
+		: "=&a" (res), "=&d" (cmp), "=&a" (count)
+		: "a" (size), "a" (vaddr), "a" (&_sb_findmap),
+		  "m" (*(addrtype *) vaddr) : "cc");
+	return (res < size) ? res : size;
+}
+
 #else /* __s390x__ */
 
 static inline unsigned long
@@ -867,6 +907,51 @@ ext2_find_first_zero_bit(void *vaddr, un
         return (res < size) ? res : size;
 }
 
+static inline unsigned long __ext2_find_first_bit(void *vaddr,
+						  unsigned long size)
+{
+	typedef struct { long _[__BITOPS_WORDS(size)]; } addrtype;
+	unsigned long res, cmp, count;
+
+	if (!size)
+		return 0;
+	asm volatile(
+		"	lghi	%1,0\n"
+		"	lgr	%2,%3\n"
+		"	lghi	%0,0\n"
+		"	aghi	%2,63\n"
+		"	srlg	%2,%2,6\n"
+		"0:	clg	%1,0(%0,%4)\n"
+		"	jne	1f\n"
+		"	aghi	%0,8\n"
+		"	brct	%2,0b\n"
+		"	lgr	%0,%3\n"
+		"	j	5f\n"
+		"1:	cl	%1,0(%0,%4)\n"
+		"	jne	2f\n"
+		"	aghi	%0,4\n"
+		"2:	l	%2,0(%0,%4)\n"
+		"	sllg	%0,%0,3\n"
+		"	aghi	%0,24\n"
+		"	lghi	%1,0xff\n"
+		"	tmlh	%2,0xffff\n"
+		"	jnz	3f\n"
+		"	aghi	%0,-16\n"
+		"	srl	%2,16\n"
+		"3:	tmll	%2,0xff00\n"
+		"	jnz	4f\n"
+		"	aghi	%0,-8\n"
+		"	srl	%2,8\n"
+		"4:	ngr	%2,%1\n"
+		"	ic	%2,0(%2,%5)\n"
+		"	algr	%0,%2\n"
+		"5:"
+		: "=&a" (res), "=&d" (cmp), "=&a" (count)
+		: "a" (size), "a" (vaddr), "a" (&_sb_findmap),
+		  "m" (*(addrtype *) vaddr) : "cc");
+	return (res < size) ? res : size;
+}
+
 #endif /* __s390x__ */
 
 static inline int
@@ -910,6 +995,47 @@ ext2_find_next_zero_bit(void *vaddr, uns
 	return offset + ext2_find_first_zero_bit(p, size);
 }
 
+static inline unsigned long ext2_find_next_bit(void *vaddr, unsigned long size,
+					       unsigned long offset)
+{
+	unsigned long *addr = vaddr, *p;
+	unsigned long word, bit, set;
+
+	if (offset >= size)
+		return size;
+	bit = offset & (__BITOPS_WORDSIZE - 1);
+	offset -= bit;
+	size -= offset;
+	p = addr + offset / __BITOPS_WORDSIZE;
+	if (bit) {
+#ifndef __s390x__
+		asm volatile(
+			"	ic	%0,0(%1)\n"
+			"	icm	%0,2,1(%1)\n"
+			"	icm	%0,4,2(%1)\n"
+			"	icm	%0,8,3(%1)"
+			: "=&a" (word) : "a" (p), "m" (*p) : "cc");
+#else
+		asm volatile(
+			"	lrvg	%0,%1"
+			: "=a" (word) : "m" (*p) );
+#endif
+		/*
+		 * s390 version of __ffs returns __BITOPS_WORDSIZE
+		 * if no one bit is present in the word.
+		 */
+		set = __ffs(word >> bit) + bit;
+		if (set >= size)
+			return size + offset;
+		if (set < __BITOPS_WORDSIZE)
+			return set + offset;
+		offset += __BITOPS_WORDSIZE;
+		size -= __BITOPS_WORDSIZE;
+		p++;
+	}
+	return offset + __ext2_find_first_bit(p, size);
+}
+
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
