Return-Path: <linux-kernel-owner+w=401wt.eu-S969598AbXEICCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969598AbXEICCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966151AbXEICCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:02:45 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:28269 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754787AbXEICCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:02:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=R+rRBkEduubvzDvl5mYq0y47t4oypaZm3QqdjQMCUCzOlDnB/qFxONVcYhKQs4WwgVOFhIrP1KcU9J2IXc+U6tSVdU4tpa7wkIPFbry5+Oq6evgk5u1aQVLFgHVX3zcYbp8b4pf5gMCU0+B7xJ8YvNW9bsdRYsIP2+/Sjhmdel4=  ;
Message-ID: <46412BB5.1060605@yahoo.com.au>
Date: Wed, 09 May 2007 12:02:29 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: clameter@sgi.com, mpm@selenic.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
References: <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com>	<20070509012725.GZ11115@waste.org>	<Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com> <20070508.185141.85412154.davem@davemloft.net>
In-Reply-To: <20070508.185141.85412154.davem@davemloft.net>
Content-Type: multipart/mixed;
 boundary="------------040802010603040706030405"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040802010603040706030405
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

David Miller wrote:
> From: Christoph Lameter <clameter@sgi.com>
> Date: Tue, 8 May 2007 18:32:35 -0700 (PDT)
> 
> 
>>That SLUB cannot do. And I do not believe you. SLOB must have some way to 
>>distinguish the objects and their sizes since kfree does not include size 
>>information. You can mix slabs of different size on the same page without 
>>metadata. Magic?
>>
>>So how does kfree then know how to free the object? There must be some way 
>>where you get the metainformation. What is the point of your 8 byte 
>>metadata that keeps getting inserted? That does not consume memory on a 
>>page?
> 
> 
> SLOB uses metadata, but that metadata seemingly only needs to be
> uptodate in freed objects.
> 
> SLOB seems to look at the descriptor in the previous blob to figure
> out how big the being-freed blob is.  That's actually kind of clever
> :-)

You know how big the being-freed blob is because the kmem cache structure
contains that. The free metadata is just needed for free area management.

BTW, we _really_ should be doing RCU properly in slob, because you
technically can't noop RCU on UP (even though the current users may be
safe...).

Patch attached to do that.

-- 
SUSE Labs, Novell Inc.

--------------040802010603040706030405
Content-Type: text/plain;
 name="slob-add-rcu.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slob-add-rcu.patch"

Index: linux-2.6/mm/slob.c
===================================================================
--- linux-2.6.orig/mm/slob.c	2007-04-12 14:35:11.000000000 +1000
+++ linux-2.6/mm/slob.c	2007-05-09 09:22:33.000000000 +1000
@@ -35,6 +35,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/timer.h>
+#include <linux/rcupdate.h>
 
 struct slob_block {
 	int units;
@@ -53,6 +54,11 @@
 };
 typedef struct bigblock bigblock_t;
 
+struct slob_rcu {
+	struct rcu_head rcu_head;
+	int size;
+};
+
 static slob_t arena = { .next = &arena, .units = 1 };
 static slob_t *slobfree = &arena;
 static bigblock_t *bigblocks;
@@ -242,6 +248,7 @@
 
 struct kmem_cache {
 	unsigned int size, align;
+	unsigned long flags;
 	const char *name;
 	void (*ctor)(void *, struct kmem_cache *, unsigned long);
 	void (*dtor)(void *, struct kmem_cache *, unsigned long);
@@ -259,6 +266,11 @@
 	if (c) {
 		c->name = name;
 		c->size = size;
+		if (flags & SLAB_DESTROY_BY_RCU) {
+			/* leave room for rcu header at the start of object */
+			c->size += sizeof(struct slob_rcu);
+		}
+		c->flags = flags;
 		c->ctor = ctor;
 		c->dtor = dtor;
 		/* ignore alignment unless it's forced */
@@ -281,11 +293,14 @@
 {
 	void *b;
 
-	if (c->size < PAGE_SIZE)
+	if (c->size < PAGE_SIZE) {
 		b = slob_alloc(c->size, flags, c->align);
-	else
+	} else
 		b = (void *)__get_free_pages(flags, find_order(c->size));
 
+	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU))
+		b += sizeof(struct slob_rcu);
+
 	if (c->ctor)
 		c->ctor(b, c, SLAB_CTOR_CONSTRUCTOR);
 
@@ -303,15 +318,34 @@
 }
 EXPORT_SYMBOL(kmem_cache_zalloc);
 
+static void __kmem_cache_free(void *b, int size)
+{
+	if (size < PAGE_SIZE)
+		slob_free(b, size);
+	else
+		free_pages((unsigned long)b, find_order(size));
+}
+
+static void kmem_rcu_free(struct rcu_head *head)
+{
+	struct slob_rcu *slob_rcu = (struct slob_rcu *)head;
+
+	__kmem_cache_free(head, slob_rcu->size);
+}
+
 void kmem_cache_free(struct kmem_cache *c, void *b)
 {
 	if (c->dtor)
 		c->dtor(b, c, 0);
 
-	if (c->size < PAGE_SIZE)
-		slob_free(b, c->size);
-	else
-		free_pages((unsigned long)b, find_order(c->size));
+	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
+		struct slob_rcu *slob_rcu;
+		b -= sizeof(struct slob_rcu);
+		slob_rcu = b;
+		slob_rcu->size = c->size;
+		call_rcu(&slob_rcu->rcu_head, kmem_rcu_free);
+	} else
+		__kmem_cache_free(b, c->size);
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig	2007-04-12 14:35:11.000000000 +1000
+++ linux-2.6/init/Kconfig	2007-05-09 09:11:14.000000000 +1000
@@ -476,7 +476,7 @@
 
 config SLAB
 	default y
-	bool "Use full SLAB allocator" if (EMBEDDED && !SMP && !SPARSEMEM)
+	bool "Use full SLAB allocator" if (EMBEDDED && !SPARSEMEM)
 	help
 	  Disabling this replaces the advanced SLAB allocator and
 	  kmalloc support with the drastically simpler SLOB allocator.

--------------040802010603040706030405--
