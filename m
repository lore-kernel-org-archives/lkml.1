Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbZG1Bas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbZG1Bas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 21:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbZG1Bar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 21:30:47 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4751 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbZG1Baq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 21:30:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ofdkMY9TG0jgaOPkddqSajVrDVMQVKxHMZYZ+LTd+f07YFAy7aeg5+K9a1fkWe2OP
	FTpQjnniUcisSSPKtv29w==
Date: Mon, 27 Jul 2009 18:30:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: [patch] slub: use size and objsize orders to disable debug flags
In-Reply-To: <alpine.DEB.2.00.0907271533070.23587@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0907271830010.7634@chino.kir.corp.google.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.Pi.BZObKB@chimera> <4A6CF220.7080605@lwfinger.net> <alpine.DEB.2.00.0907261722140.21259@chino.kir.corp.google.com> <84144f020907270008h2a985278of68e70ff1ee9265c@mail.gmail.com>
 <alpine.DEB.2.00.0907270227420.15760@chino.kir.corp.google.com> <alpine.DEB.1.10.0907271320130.13513@gentwo.org> <alpine.DEB.2.00.0907271113460.8408@chino.kir.corp.google.com> <alpine.DEB.1.10.0907271740090.27697@gentwo.org>
 <alpine.DEB.2.00.0907271533070.23587@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the masking of debugging flags which increase a cache's
min order due to metadata when `slub_debug=O' is used from
kmem_cache_flags() to kmem_cache_open().

Instead of defining the maximum metadata size increase in a preprocessor
macro, this approach uses the cache's ->size and ->objsize members to
determine if the min order increased due to debugging options.  If so,
the flags specified in the more appropriately named DEBUG_METADATA_FLAGS
are masked off.

This approach was suggested by Christoph Lameter
<cl@linux-foundation.org>.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c |   40 +++++++++++++++++++---------------------
 1 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -142,11 +142,11 @@
 				SLAB_POISON | SLAB_STORE_USER)
 
 /*
- * Debugging flags that require metadata to be stored in the slab, up to
- * DEBUG_SIZE in size.
+ * Debugging flags that require metadata to be stored in the slab.  These get
+ * disabled when slub_debug=O is used and a cache's min order increases with
+ * metadata.
  */
-#define DEBUG_SIZE_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
-#define DEBUG_SIZE (3 * sizeof(void *) + 2 * sizeof(struct track))
+#define DEBUG_METADATA_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
 
 /*
  * Set of flags that will prevent slab merging
@@ -1040,27 +1040,13 @@ static unsigned long kmem_cache_flags(unsigned long objsize,
 	unsigned long flags, const char *name,
 	void (*ctor)(void *))
 {
-	int debug_flags = slub_debug;
-
 	/*
 	 * Enable debugging if selected on the kernel commandline.
 	 */
-	if (debug_flags) {
-		if (slub_debug_slabs &&
-		    strncmp(slub_debug_slabs, name, strlen(slub_debug_slabs)))
-			goto out;
-
-		/*
-		 * Disable debugging that increases slab size if the minimum
-		 * slab order would have increased as a result.
-		 */
-		if (disable_higher_order_debug &&
-		    get_order(objsize + DEBUG_SIZE) > get_order(objsize))
-			debug_flags &= ~DEBUG_SIZE_FLAGS;
+	if (slub_debug && (!slub_debug_slabs ||
+		!strncmp(slub_debug_slabs, name, strlen(slub_debug_slabs))))
+		flags |= slub_debug;
 
-		flags |= debug_flags;
-	}
-out:
 	return flags;
 }
 #else
@@ -2488,6 +2474,18 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 
 	if (!calculate_sizes(s, -1))
 		goto error;
+	if (disable_higher_order_debug) {
+		/*
+		 * Disable debugging flags that store metadata if the min slab
+		 * order increased.
+		 */
+		if (get_order(s->size) > get_order(s->objsize)) {
+			s->flags &= ~DEBUG_METADATA_FLAGS;
+			s->offset = 0;
+			if (!calculate_sizes(s, -1))
+				goto error;
+		}
+	}
 
 	/*
 	 * The larger the object size is, the more pages we want on the partial
