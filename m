Return-Path: <linux-kernel-owner+w=401wt.eu-S1758958AbXHQXWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbXHQXWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 19:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756199AbXHQXWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 19:22:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39023 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756167AbXHQXWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 19:22:13 -0400
Date: Fri, 17 Aug 2007 16:22:09 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Satyam Sharma <satyam@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
In-Reply-To: <84144f020708171442x52b18722k2971ceef96d3e72@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708171621260.12644@schroedinger.engr.sgi.com>
References: <46C233CB.9000602@am.sony.com>  <1187132149.2618.2.camel@laptopd505.fenrus.org>
  <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in> 
 <20070817112253.e6a7cb33.akpm@linux-foundation.org> 
 <alpine.LFD.0.999.0708180011570.3666@enigma.security.iitk.ac.in> 
 <Pine.LNX.4.64.0708171413190.9635@schroedinger.engr.sgi.com>
 <84144f020708171442x52b18722k2971ceef96d3e72@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2007, Pekka Enberg wrote:

> Agreed, especially as we have real zero-sized objects returned from
> kmalloc() et al now.



Slab allocators: Fail if ksize is called with a NULL parameter

A NULL pointer means that the object was not allocated. One cannot
determine the size of an object that has not been allocated. Currently
we return 0 but we really should BUG() on attempts to determine the size
of something nonexistent.

krealloc() interprets NULL to mean a zero sized object. Handle that
separately in krealloc().

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6/mm/slab.c
===================================================================
--- linux-2.6.orig/mm/slab.c	2007-08-17 16:17:41.000000000 -0700
+++ linux-2.6/mm/slab.c	2007-08-17 16:18:15.000000000 -0700
@@ -4436,7 +4436,8 @@ const struct seq_operations slabstats_op
  */
 size_t ksize(const void *objp)
 {
-	if (unlikely(ZERO_OR_NULL_PTR(objp)))
+	BUG_ON(!objp);
+	if (unlikely(objp == ZERO_SIZE_PTR))
 		return 0;
 
 	return obj_size(virt_to_cache(objp));
Index: linux-2.6/mm/slob.c
===================================================================
--- linux-2.6.orig/mm/slob.c	2007-08-17 16:18:19.000000000 -0700
+++ linux-2.6/mm/slob.c	2007-08-17 16:18:40.000000000 -0700
@@ -484,7 +484,8 @@ size_t ksize(const void *block)
 {
 	struct slob_page *sp;
 
-	if (ZERO_OR_NULL_PTR(block))
+	BUG_ON(!block);
+	if (block == ZERO_SIZE_PTR)
 		return 0;
 
 	sp = (struct slob_page *)virt_to_page(block);
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-08-17 16:16:36.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-08-17 16:17:36.000000000 -0700
@@ -2426,7 +2426,8 @@ size_t ksize(const void *object)
 	struct page *page;
 	struct kmem_cache *s;
 
-	if (ZERO_OR_NULL_PTR(object))
+	BUG_ON(!object);
+	if (object == ZERO_SIZE_PTR)
 		return 0;
 
 	page = get_object_page(object);
Index: linux-2.6/mm/util.c
===================================================================
--- linux-2.6.orig/mm/util.c	2007-08-17 16:16:29.000000000 -0700
+++ linux-2.6/mm/util.c	2007-08-17 16:16:32.000000000 -0700
@@ -81,14 +81,16 @@ EXPORT_SYMBOL(kmemdup);
 void *krealloc(const void *p, size_t new_size, gfp_t flags)
 {
 	void *ret;
-	size_t ks;
+	size_t ks = 0;
 
 	if (unlikely(!new_size)) {
 		kfree(p);
 		return ZERO_SIZE_PTR;
 	}
 
-	ks = ksize(p);
+	if (p)
+		ks = ksize(p);
+
 	if (ks >= new_size)
 		return (void *)p;
 
 
