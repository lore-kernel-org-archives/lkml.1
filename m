Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbXD3KjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbXD3KjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965570AbXD3Kas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:30:48 -0400
Received: from mx1.suse.de ([195.135.220.2]:51272 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbXD3K2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:34 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, plasmaroo@gentoo.org, ak@suse.de, mpm@selenic.com,
       ink@jurassic.park.msu.ru, rth@twiddle.net, rmk@arm.linux.org.uk,
       spyro@f2s.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [22/40] x86: deflate stack usage in lib/inflate.c
Message-Id: <20070430102756.35300151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
inflate_fixed and huft_build together use around 2.7k of stack.  When
using 4k stacks, I saw stack overflows from interrupts arriving while
unpacking the root initrd:

do_IRQ: stack overflow: 384
 [<c0106b64>] show_trace_log_lvl+0x1a/0x30
 [<c01075e6>] show_trace+0x12/0x14
 [<c010763f>] dump_stack+0x16/0x18
 [<c0107ca4>] do_IRQ+0x6d/0xd9
 [<c010202b>] xen_evtchn_do_upcall+0x6e/0xa2
 [<c0106781>] xen_hypervisor_callback+0x25/0x2c
 [<c010116c>] xen_restore_fl+0x27/0x29
 [<c0330f63>] _spin_unlock_irqrestore+0x4a/0x50
 [<c0117aab>] change_page_attr+0x577/0x584
 [<c0117b45>] kernel_map_pages+0x8d/0xb4
 [<c016a314>] cache_alloc_refill+0x53f/0x632
 [<c016a6c2>] __kmalloc+0xc1/0x10d
 [<c0463d34>] malloc+0x10/0x12
 [<c04641c1>] huft_build+0x2a7/0x5fa
 [<c04645a5>] inflate_fixed+0x91/0x136
 [<c04657e2>] unpack_to_rootfs+0x5f2/0x8c1
 [<c0465acf>] populate_rootfs+0x1e/0xe4

(This was under Xen, but there's no reason it couldn't happen on bare
  hardware.)

This patch mallocs the local variables, thereby reducing the stack
usage to sane levels.

Also, up the heap size for the kernel decompressor to deal with the
extra allocation.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Tim Yamin <plasmaroo@gentoo.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ian Molton <spyro@f2s.com>

---
 arch/alpha/boot/misc.c             |    2 -
 arch/arm/boot/compressed/misc.c    |    2 -
 arch/arm26/boot/compressed/misc.c  |    2 -
 arch/i386/boot/compressed/misc.c   |    2 -
 arch/x86_64/boot/compressed/misc.c |    2 -
 lib/inflate.c                      |   66 +++++++++++++++++++++++++++----------
 6 files changed, 54 insertions(+), 22 deletions(-)

===================================================================
Index: linux/arch/alpha/boot/misc.c
===================================================================
--- linux.orig/arch/alpha/boot/misc.c
+++ linux/arch/alpha/boot/misc.c
@@ -98,7 +98,7 @@ extern int end;
 static ulg free_mem_ptr;
 static ulg free_mem_ptr_end;
 
-#define HEAP_SIZE 0x2000
+#define HEAP_SIZE 0x3000
 
 #include "../../../lib/inflate.c"
 
Index: linux/arch/arm/boot/compressed/misc.c
===================================================================
--- linux.orig/arch/arm/boot/compressed/misc.c
+++ linux/arch/arm/boot/compressed/misc.c
@@ -239,7 +239,7 @@ extern int end;
 static ulg free_mem_ptr;
 static ulg free_mem_ptr_end;
 
-#define HEAP_SIZE 0x2000
+#define HEAP_SIZE 0x3000
 
 #include "../../../../lib/inflate.c"
 
Index: linux/arch/arm26/boot/compressed/misc.c
===================================================================
--- linux.orig/arch/arm26/boot/compressed/misc.c
+++ linux/arch/arm26/boot/compressed/misc.c
@@ -182,7 +182,7 @@ extern int end;
 static ulg free_mem_ptr;
 static ulg free_mem_ptr_end;
 
-#define HEAP_SIZE 0x2000
+#define HEAP_SIZE 0x3000
 
 #include "../../../../lib/inflate.c"
 
Index: linux/arch/i386/boot/compressed/misc.c
===================================================================
--- linux.orig/arch/i386/boot/compressed/misc.c
+++ linux/arch/i386/boot/compressed/misc.c
@@ -189,7 +189,7 @@ static void putstr(const char *);
 static unsigned long free_mem_ptr;
 static unsigned long free_mem_end_ptr;
 
-#define HEAP_SIZE             0x3000
+#define HEAP_SIZE             0x4000
 
 static char *vidmem = (char *)0xb8000;
 static int vidport;
Index: linux/arch/x86_64/boot/compressed/misc.c
===================================================================
--- linux.orig/arch/x86_64/boot/compressed/misc.c
+++ linux/arch/x86_64/boot/compressed/misc.c
@@ -189,7 +189,7 @@ static void putstr(const char *);
 static long free_mem_ptr;
 static long free_mem_end_ptr;
 
-#define HEAP_SIZE             0x6000
+#define HEAP_SIZE             0x7000
 
 static char *vidmem = (char *)0xb8000;
 static int vidport;
Index: linux/lib/inflate.c
===================================================================
--- linux.orig/lib/inflate.c
+++ linux/lib/inflate.c
@@ -292,7 +292,6 @@ STATIC int INIT huft_build(
    oversubscribed set of lengths), and three if not enough memory. */
 {
   unsigned a;                   /* counter for codes of length k */
-  unsigned c[BMAX+1];           /* bit length count table */
   unsigned f;                   /* i repeats in table every f entries */
   int g;                        /* maximum code length */
   int h;                        /* table level */
@@ -303,18 +302,33 @@ STATIC int INIT huft_build(
   register unsigned *p;         /* pointer into c[], b[], or v[] */
   register struct huft *q;      /* points to current table */
   struct huft r;                /* table entry for structure assignment */
-  struct huft *u[BMAX];         /* table stack */
-  unsigned v[N_MAX];            /* values in order of bit length */
   register int w;               /* bits before this table == (l * h) */
-  unsigned x[BMAX+1];           /* bit offsets, then code stack */
   unsigned *xp;                 /* pointer into x */
   int y;                        /* number of dummy codes added */
   unsigned z;                   /* number of entries in current table */
+  struct {
+    unsigned c[BMAX+1];           /* bit length count table */
+    struct huft *u[BMAX];         /* table stack */
+    unsigned v[N_MAX];            /* values in order of bit length */
+    unsigned x[BMAX+1];           /* bit offsets, then code stack */
+  } *stk;
+  unsigned *c, *v, *x;
+  struct huft **u;
+  int ret;
 
 DEBG("huft1 ");
 
+  stk = malloc(sizeof(*stk));
+  if (stk == NULL)
+    return 3;			/* out of memory */
+
+  c = stk->c;
+  v = stk->v;
+  x = stk->x;
+  u = stk->u;
+
   /* Generate counts for each bit length */
-  memzero(c, sizeof(c));
+  memzero(stk->c, sizeof(stk->c));
   p = b;  i = n;
   do {
     Tracecv(*p, (stderr, (n-i >= ' ' && n-i <= '~' ? "%c %d\n" : "0x%x %d\n"), 
@@ -326,7 +340,8 @@ DEBG("huft1 ");
   {
     *t = (struct huft *)NULL;
     *m = 0;
-    return 2;
+    ret = 2;
+    goto out;
   }
 
 DEBG("huft2 ");
@@ -351,10 +366,14 @@ DEBG("huft3 ");
 
   /* Adjust last length count to fill out codes, if needed */
   for (y = 1 << j; j < i; j++, y <<= 1)
-    if ((y -= c[j]) < 0)
-      return 2;                 /* bad input: more codes than bits */
-  if ((y -= c[i]) < 0)
-    return 2;
+    if ((y -= c[j]) < 0) {
+      ret = 2;                 /* bad input: more codes than bits */
+      goto out;
+    }
+  if ((y -= c[i]) < 0) {
+    ret = 2;
+    goto out;
+  }
   c[i] += y;
 
 DEBG("huft4 ");
@@ -428,7 +447,8 @@ DEBG1("3 ");
         {
           if (h)
             huft_free(u[0]);
-          return 3;             /* not enough memory */
+          ret = 3;             /* not enough memory */
+	  goto out;
         }
 DEBG1("4 ");
         hufts += z + 1;         /* track memory usage */
@@ -492,7 +512,11 @@ DEBG("h6f ");
 DEBG("huft7 ");
 
   /* Return true (1) if we were given an incomplete table */
-  return y != 0 && g != 1;
+  ret = y != 0 && g != 1;
+
+  out:
+  free(stk);
+  return ret;
 }
 
 
@@ -705,10 +729,14 @@ STATIC int noinline INIT inflate_fixed(v
   struct huft *td;      /* distance code table */
   int bl;               /* lookup bits for tl */
   int bd;               /* lookup bits for td */
-  unsigned l[288];      /* length list for huft_build */
+  unsigned *l;          /* length list for huft_build */
 
 DEBG("<fix");
 
+  l = malloc(sizeof(*l) * 288);
+  if (l == NULL)
+    return 3;			/* out of memory */
+
   /* set up literal table */
   for (i = 0; i < 144; i++)
     l[i] = 8;
@@ -719,9 +747,10 @@ DEBG("<fix");
   for (; i < 288; i++)          /* make a complete, but wrong code set */
     l[i] = 8;
   bl = 7;
-  if ((i = huft_build(l, 288, 257, cplens, cplext, &tl, &bl)) != 0)
+  if ((i = huft_build(l, 288, 257, cplens, cplext, &tl, &bl)) != 0) {
+    free(l);
     return i;
-
+  }
 
   /* set up distance table */
   for (i = 0; i < 30; i++)      /* make an incomplete code set */
@@ -730,6 +759,7 @@ DEBG("<fix");
   if ((i = huft_build(l, 30, 0, cpdist, cpdext, &td, &bd)) > 1)
   {
     huft_free(tl);
+    free(l);
 
     DEBG(">");
     return i;
@@ -737,11 +767,13 @@ DEBG("<fix");
 
 
   /* decompress until an end-of-block code */
-  if (inflate_codes(tl, td, bl, bd))
+  if (inflate_codes(tl, td, bl, bd)) {
+    free(l);
     return 1;
-
+  }
 
   /* free the decoding tables, return */
+  free(l);
   huft_free(tl);
   huft_free(td);
   return 0;
