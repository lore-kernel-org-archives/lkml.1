Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbXHTSfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbXHTSfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 14:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbXHTSex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 14:34:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43289 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750796AbXHTSew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 14:34:52 -0400
Date: Mon, 20 Aug 2007 11:34:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: SLUB bug on sparc64
In-Reply-To: <20070817.221758.116352652.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0708201124140.25298@schroedinger.engr.sgi.com>
References: <20070817.221758.116352652.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007, David Miller wrote:

> When I force SLUB debugging on sparc64, it barfs on early bootup while
> making the sysfs nodes.  Removing the BUG()'s on the sysfs error
> returns, and adding some tracing I captured the log below.
> 
> BTW, I would recommending removing the BUG() calls, they serve only to
> force someone hitting them to edit them out and reboot which is
> absolutely pointless :-) This code can also often run before the
> console is first enabled, making analysis of the error return that
> much harder if it BUG()'s instead of trying to continue.

Not sure what BUG's you are talking about.

> The problem seems to be that both tsb_512KB and tsb_1MB are
> unmergeable, and so are the kmalloc caches of those sizes.  But the
> "unique name" created for the aliases are identical, always ":%d"
> where %d is the cache size, so the kobject_add() fails the second
> time around.

Well it seems that they are both mergeable since slabs larger than 64k * 
sizeof(void) are exempt from unmergeable processing and we get into issues 
because the merge policy is inconsistent for the larger slabs then.

Does this patch fix it?

Limit the maximum size of merged slab caches

We always switch off the debugging bits of slabs that are too large
for free pointer relocation. This means that we may create separate
caches even if slub_debug is set. Sysfs later thinks they are mergeable
and thus creates unique ids that may then clash.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-08-20 11:31:13.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-08-20 11:34:12.000000000 -0700
@@ -209,6 +209,7 @@ static inline void ClearSlabDebug(struct
  * The page->inuse field is 16 bit thus we have this limitation
  */
 #define MAX_OBJECTS_PER_SLAB 65535
+#define MAX_MERGE_SIZE (MAX_OBJECTS_PER_SLAB * sizeof(void))
 
 /* Internal SLUB flags */
 #define __OBJECT_POISON		0x80000000 /* Poison object */
@@ -1000,7 +1001,7 @@ static void kmem_cache_open_debug_check(
 	 * Debugging or ctor may create a need to move the free
 	 * pointer. Fail if this happens.
 	 */
-	if (s->objsize >= 65535 * sizeof(void *)) {
+	if (s->objsize >= MAX_MERGE_SIZE) {
 		BUG_ON(s->flags & (SLAB_RED_ZONE | SLAB_POISON |
 				SLAB_STORE_USER | SLAB_DESTROY_BY_RCU));
 		BUG_ON(s->ctor);
@@ -2649,6 +2650,12 @@ static int slab_unmergeable(struct kmem_
 	if (s->refcount < 0)
 		return 1;
 
+	/*
+	 * Or a slab that is too large for merging
+	 */
+	if (s->size >= MAX_MERGE_SIZE)
+		return 1;
+
 	return 0;
 }
 
@@ -2668,6 +2675,9 @@ static struct kmem_cache *find_mergeable
 	align = calculate_alignment(flags, align, size);
 	size = ALIGN(size, align);
 
+	if (size >= MAX_MERGE_SIZE)
+		return NULL;
+
 	list_for_each_entry(s, &slab_caches, list) {
 		if (slab_unmergeable(s))
 			continue;
