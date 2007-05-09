Return-Path: <linux-kernel-owner+w=401wt.eu-S1033867AbXEIDSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033867AbXEIDSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 23:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbXEIDSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 23:18:12 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:39652 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030314AbXEIDSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 23:18:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=ox+/NWAnIqjyaWuCMsAJk7Kz5SWAcJTBiR0epK1nPi/BxyzisXLxpqUylpQ7/5DgWluemGPyxRN+UL7RFCjI21onOIpEDxzJc+8zLeItwuRTIpRt1A1RTRGz5XOKSi1wivMFHOXr/ZTWec6KHkoc1WEJjIlc1GGyhY9YGvWKu6Y=  ;
X-YMail-OSG: mg4l2RMVM1nyVxHfRYr978l.8qDZZlKI5U.mpIuUwbTGvHkI8HSq.7FYkxqLyCXIH0NPQtZN36CIEziG6UwcmQiWMp9UUcBdlN_lDuN7kpuA_Hjq8ms-
Message-ID: <46413D6A.6000502@yahoo.com.au>
Date: Wed, 09 May 2007 13:18:02 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: David Miller <davem@davemloft.net>, clameter@sgi.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
References: <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com> <20070509012725.GZ11115@waste.org> <Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com> <20070508.185141.85412154.davem@davemloft.net> <46412BB5.1060605@yahoo.com.au> <20070509025634.GC11115@waste.org>
In-Reply-To: <20070509025634.GC11115@waste.org>
Content-Type: multipart/mixed;
 boundary="------------020703040002050000040903"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020703040002050000040903
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Matt Mackall wrote:
> On Wed, May 09, 2007 at 12:02:29PM +1000, Nick Piggin wrote:
> 
>>BTW, we _really_ should be doing RCU properly in slob, because you
>>technically can't noop RCU on UP (even though the current users may be
>>safe...).
> 
> 
> Thanks. Hugh was pretty convinced it was unneeded:
> 
> http://marc.info/?l=linux-mm&m=116413907023393&w=2
> 
> And since I didn't care much about the SMP case, I didn't pursue it.

Sure the anonvma cache is OK on UP, but I'm just saying that in the
general case, you cannot noop RCU on UP systems.

SLAB_DESTROY_BY_RCU is quite a nice way to mitigate some RCU freeing
overheads for small objects, so I'd expect it may see wider use in
future. Maybe all those users would be fine too, but it's a bit nasty
to have already tricky RCU semantics deviate...


> This almost looks reasonable. I think HW_ALIGN | RCU is going to make
> it break though:
> 
> 
>>+	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU))
>>+		b += sizeof(struct slob_rcu);
>>+
> 
> 
> That could be dealt with by putting the slob_rcu at the end of the
> object and having the RCU helper function use ->size to work backward
> to the actual pointer.

Sure, OK.


>> void kmem_cache_free(struct kmem_cache *c, void *b)
>> {
>> 	if (c->dtor)
>> 		c->dtor(b, c, 0);
> 
> 
> I think if we want RCU to actually work, we want to run ->dtor in
> __kmem_cache_free?

Yeah, thinko... thanks.


>>-	if (c->size < PAGE_SIZE)
>>-		slob_free(b, c->size);
>>-	else
>>-		free_pages((unsigned long)b, find_order(c->size));
>>+	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
>>+		struct slob_rcu *slob_rcu;
>>+		b -= sizeof(struct slob_rcu);
>>+		slob_rcu = b;
>>+		slob_rcu->size = c->size;
> 
> 
> Which means just store c in the header^Wfooter, then we can retrieve the size
> and the dtor in the RCU helper.

OK, updated patch (about-to-be-tested) attached.

-- 
SUSE Labs, Novell Inc.

--------------020703040002050000040903
Content-Type: text/plain;
 name="slob-add-rcu.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="slob-add-rcu.patch"

Index: linux-2.6/mm/slob.c
===================================================================
--- linux-2.6.orig/mm/slob.c	2007-04-12 14:35:11.000000000 +1000
+++ linux-2.6/mm/slob.c	2007-05-09 11:01:09.000000000 +1000
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
+	struct kmem_cache *c;
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
+			/* leave room for rcu footer at the end of object */
+			c->size += sizeof(struct slob_rcu);
+		}
+		c->flags = flags;
 		c->ctor = ctor;
 		c->dtor = dtor;
 		/* ignore alignment unless it's forced */
@@ -281,9 +293,9 @@
 {
 	void *b;
 
-	if (c->size < PAGE_SIZE)
+	if (c->size < PAGE_SIZE) {
 		b = slob_alloc(c->size, flags, c->align);
-	else
+	} else
 		b = (void *)__get_free_pages(flags, find_order(c->size));
 
 	if (c->ctor)
@@ -303,7 +315,7 @@
 }
 EXPORT_SYMBOL(kmem_cache_zalloc);
 
-void kmem_cache_free(struct kmem_cache *c, void *b)
+static void __kmem_cache_free(struct kmem_cache *c, void *b)
 {
 	if (c->dtor)
 		c->dtor(b, c, 0);
@@ -313,6 +325,25 @@
 	else
 		free_pages((unsigned long)b, find_order(c->size));
 }
+
+static void kmem_rcu_free(struct rcu_head *head)
+{
+	struct slob_rcu *slob_rcu = (struct slob_rcu *)head;
+	void *b = (void *)slob_rcu - slob_rcu->c->size;
+
+	__kmem_cache_free(b, slob_rcu->c);
+}
+
+void kmem_cache_free(struct kmem_cache *c, void *b)
+{
+	if (unlikely(c->flags & SLAB_DESTROY_BY_RCU)) {
+		struct slob_rcu *slob_rcu;
+		slob_rcu = b + c->size;;
+		slob_rcu->c = c;
+		call_rcu(&slob_rcu->rcu_head, kmem_rcu_free);
+	} else
+		__kmem_cache_free(b, c);
+}
 EXPORT_SYMBOL(kmem_cache_free);
 
 unsigned int kmem_cache_size(struct kmem_cache *c)
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

--------------020703040002050000040903--
