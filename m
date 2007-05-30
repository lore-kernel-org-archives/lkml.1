Return-Path: <linux-kernel-owner+w=401wt.eu-S1759003AbXE3Vgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbXE3Vgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755765AbXE3VgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:36:25 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:28176 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbXE3VgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:36:24 -0400
Date: Wed, 30 May 2007 14:34:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3 -mm] slub: use lib/hexdump
Message-Id: <20070530143451.f4a844bc.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<46540DB2.5000605@googlemail.com>
	<Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
	<4654AC94.6080601@googlemail.com>
	<20070523150122.f9946f37.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
	<20070523153730.e0e9e91d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
	<20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
	<20070524073131.GA17501@elte.hu>
	<Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>
	<20070524142908.f39f42ea.akpm@linux-foundation.org>
	<20070524145517.1f32cd94.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Convert slub error memory dump functions to use lib/hexdump routines.
Completely eliminate slub's print_section() function.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 mm/slub.c |   53 ++++++++++++-----------------------------------------
 1 file changed, 12 insertions(+), 41 deletions(-)

--- linux-2622-rc2mm1-slub.orig/mm/slub.c
+++ linux-2622-rc2mm1-slub/mm/slub.c
@@ -8,6 +8,7 @@
  * (C) 2007 SGI, Christoph Lameter <clameter@sgi.com>
  */
 
+#include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/bit_spinlock.h>
@@ -334,41 +335,6 @@ static int slub_debug;
 
 static char *slub_debug_slabs;
 
-/*
- * Object debugging
- */
-static void print_section(char *text, u8 *addr, unsigned int length)
-{
-	int i, offset;
-	int newline = 1;
-	char ascii[17];
-
-	ascii[16] = 0;
-
-	for (i = 0; i < length; i++) {
-		if (newline) {
-			printk(KERN_ERR "%10s 0x%p: ", text, addr + i);
-			newline = 0;
-		}
-		printk(" %02x", addr[i]);
-		offset = i % 16;
-		ascii[offset] = isgraph(addr[i]) ? addr[i] : '.';
-		if (offset == 15) {
-			printk(" %s\n",ascii);
-			newline = 1;
-		}
-	}
-	if (!newline) {
-		i %= 16;
-		while (i < 16) {
-			printk("   ");
-			ascii[i] = ' ';
-			i++;
-		}
-		printk(" %s\n", ascii);
-	}
-}
-
 static struct track *get_track(struct kmem_cache *s, void *object,
 	enum track_item alloc)
 {
@@ -425,8 +391,8 @@ static void print_trailer(struct kmem_ca
 	unsigned int off;	/* Offset of last byte */
 
 	if (s->flags & SLAB_RED_ZONE)
-		print_section("Redzone", p + s->objsize,
-			s->inuse - s->objsize);
+		print_hex_dump(KERN_ERR, "   Redzone ", DUMP_PREFIX_ADDRESS,
+			16, 1, p + s->objsize, s->inuse - s->objsize, 1);
 
 	printk(KERN_ERR "FreePointer 0x%p -> 0x%p\n",
 			p + s->offset,
@@ -445,7 +411,8 @@ static void print_trailer(struct kmem_ca
 
 	if (off != s->size)
 		/* Beginning of the filler is the free pointer */
-		print_section("Filler", p + off, s->size - off);
+		print_hex_dump(KERN_ERR, "    Filler ", DUMP_PREFIX_ADDRESS,
+			16, 1, p + off, s->size - off, 1);
 }
 
 static void object_err(struct kmem_cache *s, struct page *page,
@@ -458,8 +425,10 @@ static void object_err(struct kmem_cache
 	printk(KERN_ERR "    offset=%tu flags=0x%04lx inuse=%u freelist=0x%p\n",
 		object - addr, page->flags, page->inuse, page->freelist);
 	if (object > addr + 16)
-		print_section("Bytes b4", object - 16, 16);
-	print_section("Object", object, min(s->objsize, 128));
+		print_hex_dump(KERN_ERR, "  Bytes b4 ", DUMP_PREFIX_ADDRESS,
+			16, 1, object - 16, 16, 1);
+	print_hex_dump(KERN_ERR, "    Object ", DUMP_PREFIX_ADDRESS, 16, 1,
+		object, min(s->objsize, 128), 1);
 	print_trailer(s, object);
 	dump_stack();
 }
@@ -759,7 +728,9 @@ static void trace(struct kmem_cache *s, 
 			page->freelist);
 
 		if (!alloc)
-			print_section("Object", (void *)object, s->objsize);
+			print_hex_dump(KERN_ERR, "    Object ",
+				DUMP_PREFIX_ADDRESS, 16, 1,
+				(void *)object, s->objsize, 1);
 
 		dump_stack();
 	}
