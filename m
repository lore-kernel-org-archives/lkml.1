Return-Path: <linux-kernel-owner+w=401wt.eu-S1756336AbZGGHO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbZGGHO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 03:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbZGGHOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 03:14:19 -0400
Received: from smtp-out.google.com ([216.239.45.13]:25018 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbZGGHOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 03:14:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=p/1qaJTQdeLZMIwDJIrvlyXv6E7KHkkNNHR3LY7kCDiweeIhzK5YHrIoUDxbJ/hSm
	s45fcxoiqtnKl3q7NT6lw==
Date: Tue, 7 Jul 2009 00:14:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: [patch v2] slub: add option to disable higher order debugging
 slabs
In-Reply-To: <alpine.DEB.2.00.0907062252500.9699@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0907070013400.14978@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <1246374095.8014.28.camel@penberg-laptop> <alpine.DEB.1.10.0906301114450.3879@gentwo.org> <alpine.DEB.2.00.0906301248000.16312@chino.kir.corp.google.com> <alpine.DEB.1.10.0906301632570.22158@gentwo.org>
 <alpine.DEB.2.00.0906301413460.24397@chino.kir.corp.google.com> <alpine.DEB.1.10.0906301722280.17682@gentwo.org> <alpine.DEB.2.00.0906301445070.26290@chino.kir.corp.google.com> <84144f020906302253n2424d4a5k3aaf124838a041df@mail.gmail.com>
 <alpine.DEB.2.00.0907021016380.30890@chino.kir.corp.google.com> <84144f020907030023v2d09632bt13b6c25f96c0b803@mail.gmail.com> <alpine.DEB.2.00.0907062252500.9699@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When debugging is enabled, slub requires that additional metadata be
stored in slabs for certain options: SLAB_RED_ZONE, SLAB_POISON, and
SLAB_STORE_USER.

Consequently, it may require that the minimum possible slab order needed
to allocate a single object be greater when using these options.  The
most notable example is for objects that are PAGE_SIZE bytes in size.

Higher minimum slab orders may cause page allocation failures when oom or
under heavy fragmentation.

This patch adds a new slub_debug option, which disables debugging by
default for caches that would have resulted in higher minimum orders:

	slub_debug=O

When this option is used on systems with 4K pages, kmalloc-4096, for
example, will not have debugging enabled by default even if
CONFIG_SLUB_DEBUG_ON is defined because it would have resulted in a
order-1 minimum slab order.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---

 V1 -> V2: Removed spurious `goto out'.

 Documentation/vm/slub.txt |   10 ++++++++++
 mm/slub.c                 |   41 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 48 insertions(+), 3 deletions(-)

diff --git a/Documentation/vm/slub.txt b/Documentation/vm/slub.txt
--- a/Documentation/vm/slub.txt
+++ b/Documentation/vm/slub.txt
@@ -41,6 +41,8 @@ Possible debug options are
 	P		Poisoning (object and padding)
 	U		User tracking (free and alloc)
 	T		Trace (please only use on single slabs)
+	O		Switch debugging off for caches that would have
+			caused higher minimum slab orders
 	-		Switch all debugging off (useful if the kernel is
 			configured with CONFIG_SLUB_DEBUG_ON)
 
@@ -59,6 +61,14 @@ to the dentry cache with
 
 	slub_debug=F,dentry
 
+Debugging options may require the minimum possible slab order to increase as
+a result of storing the metadata (for example, caches with PAGE_SIZE object
+sizes).  This has a higher liklihood of resulting in slab allocation errors
+in low memory situations or if there's high fragmentation of memory.  To
+switch off debugging for such caches by default, use
+
+	slub_debug=O
+
 In case you forgot to enable debugging on the kernel command line: It is
 possible to enable debugging manually when the kernel is up. Look at the
 contents of:
diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -142,6 +142,13 @@
 				SLAB_POISON | SLAB_STORE_USER)
 
 /*
+ * Debugging flags that require metadata to be stored in the slab, up to
+ * DEBUG_SIZE in size.
+ */
+#define DEBUG_SIZE_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
+#define DEBUG_SIZE (3 * sizeof(void *) + 2 * sizeof(struct track))
+
+/*
  * Set of flags that will prevent slab merging
  */
 #define SLUB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
@@ -326,6 +333,7 @@ static int slub_debug;
 #endif
 
 static char *slub_debug_slabs;
+static int disable_higher_order_debug;
 
 /*
  * Object debugging
@@ -977,6 +985,15 @@ static int __init setup_slub_debug(char *str)
 		 */
 		goto check_slabs;
 
+	if (tolower(*str) == 'o') {
+		/*
+		 * Avoid enabling debugging on caches if its minimum order
+		 * would increase as a result.
+		 */
+		disable_higher_order_debug = 1;
+		goto out;
+	}
+
 	slub_debug = 0;
 	if (*str == '-')
 		/*
@@ -1023,13 +1040,27 @@ static unsigned long kmem_cache_flags(unsigned long objsize,
 	unsigned long flags, const char *name,
 	void (*ctor)(void *))
 {
+	int debug_flags = slub_debug;
+
 	/*
 	 * Enable debugging if selected on the kernel commandline.
 	 */
-	if (slub_debug && (!slub_debug_slabs ||
-	    strncmp(slub_debug_slabs, name, strlen(slub_debug_slabs)) == 0))
-			flags |= slub_debug;
+	if (debug_flags) {
+		if (slub_debug_slabs &&
+		    strncmp(slub_debug_slabs, name, strlen(slub_debug_slabs)))
+			goto out;
+
+		/*
+		 * Disable debugging that increases slab size if the minimum
+		 * slab order would have increased as a result.
+		 */
+		if (disable_higher_order_debug &&
+		    get_order(objsize + DEBUG_SIZE) > get_order(objsize))
+			debug_flags &= ~DEBUG_SIZE_FLAGS;
 
+		flags |= debug_flags;
+	}
+out:
 	return flags;
 }
 #else
@@ -1561,6 +1592,10 @@ slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
 		"default order: %d, min order: %d\n", s->name, s->objsize,
 		s->size, oo_order(s->oo), oo_order(s->min));
 
+	if (oo_order(s->min) > get_order(s->objsize))
+		printk(KERN_WARNING "  %s debugging increased min order, use "
+		       "slub_debug=O to disable.\n", s->name);
+
 	for_each_online_node(node) {
 		struct kmem_cache_node *n = get_node(s, node);
 		unsigned long nr_slabs;
