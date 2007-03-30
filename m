Return-Path: <linux-kernel-owner+w=401wt.eu-S933187AbXC3Dlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbXC3Dlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 23:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbXC3Dlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 23:41:55 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:35254 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbXC3Dly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 23:41:54 -0400
X-IronPort-AV: i="4.14,350,1170651600"; 
   d="scan'208"; a="25880166:sNHT27849703"
Subject: [PATCH] nommu arch dont zero the anonymous mapping by adding
	UNINITIALIZE flag
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 30 Mar 2007 11:42:51 +0800
Message-Id: <1175226172.15391.66.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On architectures with MMU, malloc takes about the same speed,
indepentant of malloc size, while on the Blackfin (NOMMU), as the malloc
size increases, the time that malloc consumes grows....

This small application, which does a bunch of mallocs, and times them
with gettimeofday():

=============================================
#include <stdio.h>
#include <unistd.h>
#include <sys/time.h>


int main(int argc, char* argv[]) {
  unsigned int i, * j, k, a, t1, t2, max, ave, min;
  struct timeval tim1, tim2;

  k = 4 ;
  for (i = 0; i <= 16*1024 ; i+=k ) {
        max = 0;
        ave = 0;
        min = 0xFFFFFFFF;
        for (a = 0; a < 128 ; a ++ ) {
                gettimeofday(&tim2, NULL);
                j = (int *)malloc (i*1024);
                gettimeofday(&tim1, NULL);
                free (j);
                t1 =   (tim1.tv_sec-tim2.tv_sec) * 1000000 + tim1.tv_usec-tim2.tv_usec;
                if ( max < t1 ) max = t1;
                if ( min > t1 ) min = t1;
                ave = ave + t1;
        }
        printf("%05ik : 0x%08x  %06i %06i %06i\n", i, j, min, ave/128, max);
        k = 1024;
        if ( i < 1024 ) k = 128;
        if ( i < 128 ) k = 4;
  }

  return 0;
};
===========================================

Summary is, when I run the app "time test", 

on x86:
real    0m0.066s
user    0m0.008s
sys     0m0.058s

on Blackfin:
real    3m 37.69s
user    0m 0.04s
sys     3m 37.58s


when run on x86, it produces the below output - indicating that it is
pretty constant: (min of arouns 2uS, aver of 3, and max of 30-15)

00000k : 0x0804a008  000002 000003 000030
00004k : 0x0804a008  000002 000003 000011
00008k : 0x0804a008  000002 000002 000007
00012k : 0x0804a008  000002 000003 000012
00016k : 0x0804a008  000002 000002 000008
00020k : 0x0804a008  000002 000002 000011
00024k : 0x0804a008  000002 000002 000009
00028k : 0x0804a008  000002 000002 000007
00032k : 0x0804a008  000002 000002 000007
00036k : 0x0804a008  000002 000003 000017
00040k : 0x0804a008  000002 000003 000015
00044k : 0x0804a008  000002 000002 000009
00048k : 0x0804a008  000002 000002 000011
00052k : 0x0804a008  000002 000003 000017
00056k : 0x0804a008  000002 000002 000009
00060k : 0x0804a008  000002 000002 000012
00064k : 0x0804a008  000002 000003 000014
00068k : 0x0804a008  000002 000003 000011
00072k : 0x0804a008  000002 000002 000009
00076k : 0x0804a008  000002 000003 000016
00080k : 0x0804a008  000002 000003 000013
00084k : 0x0804a008  000002 000002 000009
00088k : 0x0804a008  000002 000003 000018
00092k : 0x0804a008  000002 000003 000017
00096k : 0x0804a008  000002 000003 000012
00100k : 0x0804a008  000002 000003 000014
00104k : 0x0804a008  000002 000003 000012
00108k : 0x0804a008  000002 000002 000009
00112k : 0x0804a008  000002 000002 000011
00116k : 0x0804a008  000002 000002 000008
00120k : 0x0804a008  000002 000002 000009
00124k : 0x0804a008  000002 000002 000011
00128k : 0x0804a008  000002 000003 000011
00256k : 0x40150008  000006 000007 000019
00384k : 0x40150008  000006 000007 000019
00512k : 0x40150008  000006 000007 000018
00640k : 0x40150008  000006 000007 000019
00768k : 0x40150008  000007 000007 000013
00896k : 0x40150008  000006 000007 000013
01024k : 0x40150008  000006 000007 000019
02048k : 0x40150008  000006 000007 000018
03072k : 0x40150008  000006 000007 000013
04096k : 0x40150008  000006 000007 000012
05120k : 0x40150008  000006 000007 000018
06144k : 0x40150008  000006 000007 000015
07168k : 0x40150008  000006 000007 000014
08192k : 0x40150008  000006 000007 000017
09216k : 0x40150008  000006 000007 000010
10240k : 0x40150008  000006 000007 000015
11264k : 0x40150008  000006 000007 000012
12288k : 0x40150008  000006 000007 000012
13312k : 0x40150008  000006 000007 000019
14336k : 0x40150008  000006 000007 000019
15360k : 0x40150008  000006 000007 000010
16384k : 0x40150008  000006 000007 000019

When compiled with bfin-uclinux-gcc -Wl,-elf2flt -O3 ./test.c -o ./test

On blackfin, the time increases, as the malloc size increases.

00000k : 0x00000000  000005 000005 000011
00004k : 0x002e4000  000034 000035 000089
00008k : 0x0300c000  000056 000059 000136
00012k : 0x00284000  000081 000083 000189
00016k : 0x00284000  000113 000116 000180
00020k : 0x034c0000  000140 000143 000286
00024k : 0x034c0000  000162 000165 000220
00028k : 0x034c0000  000188 000191 000239
00032k : 0x034c0000  000221 000225 000301
00036k : 0x03010000  000288 000295 000460
00040k : 0x03010000  000360 000367 000516
00044k : 0x03010000  000424 000433 000563
00048k : 0x03010000  000495 000502 000556
00052k : 0x03010000  000565 000575 000645
00056k : 0x03010000  000637 000647 000699
00060k : 0x03010000  000706 000715 000769
00064k : 0x03010000  000772 000781 000874
00068k : 0x002c0000  000819 000828 000885
00072k : 0x002c0000  000866 000874 000930
00076k : 0x002c0000  000912 000921 000977
00080k : 0x002c0000  000959 000968 001023
00084k : 0x002c0000  001005 001017 001163
00088k : 0x002c0000  001052 001062 001152
00092k : 0x002c0000  001099 001112 001471
00096k : 0x002c0000  001145 001156 001210
00100k : 0x002c0000  001192 001204 001287
00104k : 0x002c0000  001238 001251 001339
00108k : 0x002c0000  001285 001299 001441
00112k : 0x002c0000  001331 001345 001397
00116k : 0x002c0000  001378 001392 001443
00120k : 0x002c0000  001425 001439 001521
00124k : 0x002c0000  001471 001486 001534
00128k : 0x002c0000  001518 001533 001580
00256k : 0x03040000  003011 003040 003163
00384k : 0x03080000  004536 004546 004874
00512k : 0x03080000  006027 006046 006174
00640k : 0x00300000  007520 007552 007850
00768k : 0x00300000  009038 009050 009178
00896k : 0x00300000  010529 010556 010886
01024k : 0x00300000  012046 012057 012354
02048k : 0x03200000  024056 024073 024347
03072k : 0x00400000  036069 036098 036531
04096k : 0x00400000  048081 048106 048327
05120k : 0x00800000  060094 060140 061698
06144k : 0x00800000  072104 072144 072352
07168k : 0x00800000  084113 084155 084369
08192k : 0x00800000  096126 096179 096829
09216k : 0x02000000  108144 108221 111188
10240k : 0x02000000  120157 120198 120487
11264k : 0x02000000  132163 132215 132490
12288k : 0x02000000  144174 144230 144450
13312k : 0x02000000  156185 156245 156592
14336k : 0x02000000  168195 168257 168627
15360k : 0x02000000  180206 180295 181205
16384k : 0x02000000  192217 192285 192573

It takes lots of time in malloc()->mmap()->
do_mmap_private()->memset(). When malloc a big area, memset() the area
to zero makes the performance very bad.

Here is a patch for this and libc malloc() should be modified too.

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-arm/mman.h      |    2 ++
 include/asm-blackfin/mman.h |    2 +-
 include/asm-frv/mman.h      |    2 ++
 include/asm-m68k/mman.h     |    2 ++
 include/asm-sh/mman.h       |    2 ++
 include/linux/mm.h          |    2 ++
 mm/nommu.c                  |    6 +++++-
 7 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/asm-arm/mman.h b/include/asm-arm/mman.h
index 54570d2..ea868e1 100644
--- a/include/asm-arm/mman.h
+++ b/include/asm-arm/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) page tables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_UNINITIALIZE 0x4000000	/* For anonymous mmap, memory could
+					   be uninitialized. */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/include/asm-blackfin/mman.h b/include/asm-blackfin/mman.h
index 4d504f9..052906c 100644
--- a/include/asm-blackfin/mman.h
+++ b/include/asm-blackfin/mman.h
@@ -23,7 +23,7 @@
 #define MAP_POPULATE	0x8000	/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000	/* do not block on IO */
 #define MAP_UNINITIALIZE 0x4000000  /* For anonymous mmap, memory could
-                                    be uninitialized. */
+				       be uninitialized. */
 
 #define MS_ASYNC	1	/* sync memory asynchronously */
 #define MS_INVALIDATE	2	/* invalidate the caches */
diff --git a/include/asm-frv/mman.h b/include/asm-frv/mman.h
index b4371e9..0fc8c72 100644
--- a/include/asm-frv/mman.h
+++ b/include/asm-frv/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_UNINITIALIZE 0x4000000	/* For anonymous mmap, memory could
+					   be uninitialized. */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/include/asm-m68k/mman.h b/include/asm-m68k/mman.h
index 1626d37..8a77c12 100644
--- a/include/asm-m68k/mman.h
+++ b/include/asm-m68k/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_UNINITIALIZE 0x4000000	/* For anonymous mmap, memory could
+					   be uninitialized. */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/include/asm-sh/mman.h b/include/asm-sh/mman.h
index 156eb02..867e360 100644
--- a/include/asm-sh/mman.h
+++ b/include/asm-sh/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) page tables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_UNINITIALIZE 0x4000000	/* For anonymous mmap, memory could
+					   be uninitialized. */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index bcea993..82bfde3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -171,6 +171,8 @@ extern int do_mprotect(unsigned long start, size_t len, unsigned long prot);
 #define VM_MAPPED_COPY	0x01000000	/* T if mapped copy of data (nommu mmap) */
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
 #define VM_ALWAYSDUMP	0x04000000	/* Always include in core dumps */
+#define VM_UNINITIALIZE	0x08000000	/* For anonymous mmap, memory could
+					   be uninitialized. */
 
 #define VM_CAN_INVALIDATE 0x08000000	/* The mapping may be invalidated,
 					 * eg. truncate or invalidate_inode_*.
diff --git a/mm/nommu.c b/mm/nommu.c
index 2d0a82f..cfcb960 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -680,6 +680,9 @@ static unsigned long determine_vm_flags(struct file *file,
 #endif
 		vm_flags &= ~VM_MAYSHARE;
 
+	if (flags & MAP_UNINITIALIZE)
+		vm_flags |= VM_UNINITIALIZE;
+
 	return vm_flags;
 }
 
@@ -766,7 +769,8 @@ static int do_mmap_private(struct vm_area_struct *vma, unsigned long len)
 
 	} else {
 		/* if it's an anonymous mapping, then just clear it */
-		memset(base, 0, len);
+		if (!(vma->vm_flags & VM_UNINITIALIZE))
+			memset(base, 0, len);
 	}
 
 	return 0;
-- 
1.5.0.5

