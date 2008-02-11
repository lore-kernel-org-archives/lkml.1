Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbYBKWdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbYBKWdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758294AbYBKWdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:33:04 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50004 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbYBKWdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:33:02 -0500
Date: Tue, 12 Feb 2008 00:32:59 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: mpm@selenic.com
cc: jdike@addtoit.com, blaisorblade@yahoo.it, clameter@sgi.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] slob: fix linking for user mode linux
Message-ID: <Pine.LNX.4.64.0802120032160.27876@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

UML has some header magic that expects a non-inline __kmalloc() function to be
available. Fixes the following link time errors:

arch/um/drivers/built-in.o: In function `kmalloc':
/home/penberg/linux-2.6/arch/um/include/um_malloc.h:14: undefined reference to `__kmalloc'
/home/penberg/linux-2.6/arch/um/include/um_malloc.h:14: undefined reference to `__kmalloc'
/home/penberg/linux-2.6/arch/um/include/um_malloc.h:14: undefined reference to `__kmalloc'
/home/penberg/linux-2.6/arch/um/include/um_malloc.h:14: undefined reference to `__kmalloc'
/home/penberg/linux-2.6/arch/um/include/um_malloc.h:14: undefined reference to `__kmalloc'
arch/um/drivers/built-in.o:/home/penberg/linux-2.6/arch/um/include/um_malloc.h:14: more undefined references to `__kmalloc' follow

Cc: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
Matt, does this look ok to you? Can we merge it via Christoph's tree?

 include/linux/slob_def.h |    5 +----
 mm/slob.c                |    6 ++++++
 2 files changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/slob_def.h
===================================================================
--- linux-2.6.orig/include/linux/slob_def.h	2008-01-12 01:00:37.000000000 +0200
+++ linux-2.6/include/linux/slob_def.h	2008-02-12 00:27:38.000000000 +0200
@@ -28,9 +28,6 @@
 	return __kmalloc_node(size, flags, -1);
 }
 
-static inline void *__kmalloc(size_t size, gfp_t flags)
-{
-	return kmalloc(size, flags);
-}
+extern void *__kmalloc(size_t size, gfp_t flags);
 
 #endif /* __LINUX_SLOB_DEF_H */
Index: linux-2.6/mm/slob.c
===================================================================
--- linux-2.6.orig/mm/slob.c	2008-02-11 23:47:19.000000000 +0200
+++ linux-2.6/mm/slob.c	2008-02-12 00:27:38.000000000 +0200
@@ -486,6 +486,12 @@
 }
 EXPORT_SYMBOL(__kmalloc_node);
 
+void *__kmalloc(size_t size, gfp_t gfp)
+{
+	return __kmalloc_node(size, gfp, -1);
+}
+EXPORT_SYMBOL(__kmalloc);
+
 void kfree(const void *block)
 {
 	struct slob_page *sp;
