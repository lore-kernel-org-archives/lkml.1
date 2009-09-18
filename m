Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZIRPUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZIRPUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZIRPUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:20:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60694 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbZIRPUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:20:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Add MAP_HUGETLB for mmaping pseudo-anonymous huge page regions
Date: Fri, 18 Sep 2009 17:19:46 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-10-generic; KDE/4.3.1; x86_64; ; )
Cc: ebmunson@us.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, mtk.manpages@gmail.com,
       randy.dunlap@oracle.com, rth@twiddle.net, ink@jurassic.park.msu.ru
References: <cover.1251197514.git.ebmunson@us.ibm.com> <20090917154404.e1d3694e.akpm@linux-foundation.org> <20090917174616.f64123fb.akpm@linux-foundation.org>
In-Reply-To: <20090917174616.f64123fb.akpm@linux-foundation.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909181719.47240.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1974NQsR5UMmQgSKicSuW3DU0ZEh0MFN6WG7X2
 Np2EMpBYelOvMR55Cv9J7nnTy04LrBTwRv12bCVLDB1Zf0VU4C
 RUkhCDRNw6fg4M+qkjm6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a flag for mmap that will be used to request a huge
page region that will look like anonymous memory to user space.  This
is accomplished by using a file on the internal vfsmount.  MAP_HUGETLB
is a modifier of MAP_ANONYMOUS and so must be specified with it.  The
region will behave the same as a MAP_ANONYMOUS region using small pages.

The patch also adds the MAP_STACK flag, which was previously defined
only on some architectures but not on others. Since MAP_STACK is meant
to be a hint only, architectures can define it without assigning a
specific meaning to it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Eric B Munson <ebmunson@us.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org

---
On Friday 18 September 2009, Andrew Morton wrote:
> On Thu, 17 Sep 2009 15:44:04 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > mm/mmap.c: In function 'do_mmap_pgoff':
> > mm/mmap.c:953: error: 'MAP_HUGETLB' undeclared (first use in this function)
> 
> mips breaks as well.
> 
> I don't know how many other architectures broke.  I disabled the patches.

two: parisc and xtensa.

It's also done in a different way from the existing flags, which makes
it more likely to break again if someone tries to add another flag.

This patch is more along the lines of how I explained it could be done,
adding the MAP_HUGETLB (and MAP_STACK) flags to the existing lists in
a consistent way.

A logical next step would be to replace the mman.h files that are basically
copies of include/asm-generic/mman.h.

	Arnd <><
---
 arch/alpha/include/asm/mman.h   |    2 ++
 arch/arm/include/asm/mman.h     |    2 ++
 arch/avr32/include/asm/mman.h   |    2 ++
 arch/cris/include/asm/mman.h    |    2 ++
 arch/frv/include/asm/mman.h     |    2 ++
 arch/h8300/include/asm/mman.h   |    2 ++
 arch/ia64/include/asm/mman.h    |    2 ++
 arch/m32r/include/asm/mman.h    |    2 ++
 arch/m68k/include/asm/mman.h    |    2 ++
 arch/mips/include/asm/mman.h    |    2 ++
 arch/mn10300/include/asm/mman.h |    2 ++
 arch/parisc/include/asm/mman.h  |    2 ++
 arch/powerpc/include/asm/mman.h |    2 ++
 arch/s390/include/asm/mman.h    |    2 ++
 arch/sparc/include/asm/mman.h   |    2 ++
 arch/x86/include/asm/mman.h     |    1 +
 arch/xtensa/include/asm/mman.h  |    2 ++
 include/asm-generic/mman.h      |    1 +
 18 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/include/asm/mman.h b/arch/alpha/include/asm/mman.h
index 90d7c35..6e4d854 100644
--- a/arch/alpha/include/asm/mman.h
+++ b/arch/alpha/include/asm/mman.h
@@ -28,6 +28,8 @@
 #define MAP_NORESERVE	0x10000		/* don't check for reservations */
 #define MAP_POPULATE	0x20000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x40000		/* do not block on IO */
+#define MAP_STACK	0x80000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x100000	/* create a huge page mapping */
 
 #define MS_ASYNC	1		/* sync memory asynchronously */
 #define MS_SYNC		2		/* synchronous memory sync */
diff --git a/arch/arm/include/asm/mman.h b/arch/arm/include/asm/mman.h
index fc26976..6464d47 100644
--- a/arch/arm/include/asm/mman.h
+++ b/arch/arm/include/asm/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) page tables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/arch/avr32/include/asm/mman.h b/arch/avr32/include/asm/mman.h
index 9a92b15..38cea1b 100644
--- a/arch/avr32/include/asm/mman.h
+++ b/arch/avr32/include/asm/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) page tables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/arch/cris/include/asm/mman.h b/arch/cris/include/asm/mman.h
index b7f0afb..de6b903 100644
--- a/arch/cris/include/asm/mman.h
+++ b/arch/cris/include/asm/mman.h
@@ -12,6 +12,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/arch/frv/include/asm/mman.h b/arch/frv/include/asm/mman.h
index 58c1d11..1939343 100644
--- a/arch/frv/include/asm/mman.h
+++ b/arch/frv/include/asm/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/arch/h8300/include/asm/mman.h b/arch/h8300/include/asm/mman.h
index cf35f0a..eacacd0 100644
--- a/arch/h8300/include/asm/mman.h
+++ b/arch/h8300/include/asm/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/arch/ia64/include/asm/mman.h b/arch/ia64/include/asm/mman.h
index 48cf8b9..cf55884 100644
--- a/arch/ia64/include/asm/mman.h
+++ b/arch/ia64/include/asm/mman.h
@@ -18,6 +18,8 @@
 #define MAP_NORESERVE	0x04000		/* don't check for reservations */
 #define MAP_POPULATE	0x08000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/arch/m32r/include/asm/mman.h b/arch/m32r/include/asm/mman.h
index 04a5f40..d191089 100644
--- a/arch/m32r/include/asm/mman.h
+++ b/arch/m32r/include/asm/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/arch/m68k/include/asm/mman.h b/arch/m68k/include/asm/mman.h
index 9f5c4c4..c421fef 100644
--- a/arch/m68k/include/asm/mman.h
+++ b/arch/m68k/include/asm/mman.h
@@ -10,6 +10,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/arch/mips/include/asm/mman.h b/arch/mips/include/asm/mman.h
index e4d6f1f..1578166 100644
--- a/arch/mips/include/asm/mman.h
+++ b/arch/mips/include/asm/mman.h
@@ -46,6 +46,8 @@
 #define MAP_LOCKED	0x8000		/* pages are locked */
 #define MAP_POPULATE	0x10000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
+#define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x80000		/* create a huge page mapping */
 
 /*
  * Flags for msync
diff --git a/arch/mn10300/include/asm/mman.h b/arch/mn10300/include/asm/mman.h
index d04fac1..94611c3 100644
--- a/arch/mn10300/include/asm/mman.h
+++ b/arch/mn10300/include/asm/mman.h
@@ -21,6 +21,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/arch/parisc/include/asm/mman.h b/arch/parisc/include/asm/mman.h
index defe752..ce4b265 100644
--- a/arch/parisc/include/asm/mman.h
+++ b/arch/parisc/include/asm/mman.h
@@ -22,6 +22,8 @@
 #define MAP_GROWSDOWN	0x8000		/* stack-like segment */
 #define MAP_POPULATE	0x10000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
+#define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x80000		/* create a huge page mapping */
 
 #define MS_SYNC		1		/* synchronous memory sync */
 #define MS_ASYNC	2		/* sync memory asynchronously */
diff --git a/arch/powerpc/include/asm/mman.h b/arch/powerpc/include/asm/mman.h
index 7b1c498..d4a7f64 100644
--- a/arch/powerpc/include/asm/mman.h
+++ b/arch/powerpc/include/asm/mman.h
@@ -25,6 +25,8 @@
 
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #ifdef __KERNEL__
 #ifdef CONFIG_PPC64
diff --git a/arch/s390/include/asm/mman.h b/arch/s390/include/asm/mman.h
index f63fe7b..22714ca 100644
--- a/arch/s390/include/asm/mman.h
+++ b/arch/s390/include/asm/mman.h
@@ -18,6 +18,8 @@
 #define MAP_NORESERVE	0x4000		/* don't check for reservations */
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/arch/sparc/include/asm/mman.h b/arch/sparc/include/asm/mman.h
index 988192e..c3029ad 100644
--- a/arch/sparc/include/asm/mman.h
+++ b/arch/sparc/include/asm/mman.h
@@ -20,6 +20,8 @@
 
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
+#define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
diff --git a/arch/x86/include/asm/mman.h b/arch/x86/include/asm/mman.h
index 751af25..c719f36 100644
--- a/arch/x86/include/asm/mman.h
+++ b/arch/x86/include/asm/mman.h
@@ -13,6 +13,7 @@
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
diff --git a/arch/xtensa/include/asm/mman.h b/arch/xtensa/include/asm/mman.h
index 9b92620..f380d04 100644
--- a/arch/xtensa/include/asm/mman.h
+++ b/arch/xtensa/include/asm/mman.h
@@ -53,6 +53,8 @@
 #define MAP_LOCKED	0x8000		/* pages are locked */
 #define MAP_POPULATE	0x10000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x20000		/* do not block on IO */
+#define MAP_STACK	0x40000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x80000		/* create a huge page mapping */
 
 /*
  * Flags for msync
diff --git a/include/asm-generic/mman.h b/include/asm-generic/mman.h
index 7cab4de..32c8bd6 100644
--- a/include/asm-generic/mman.h
+++ b/include/asm-generic/mman.h
@@ -11,6 +11,7 @@
 #define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
 #define MAP_NONBLOCK	0x10000		/* do not block on IO */
 #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
+#define MAP_HUGETLB	0x40000		/* create a huge page mapping */
 
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
