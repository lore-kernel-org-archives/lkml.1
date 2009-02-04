Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZBDSl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZBDSl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbZBDShN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:13 -0500
Received: from kroah.org ([198.145.64.141]:51006 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758326AbZBDShI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:08 -0500
Date: Wed, 4 Feb 2009 10:34:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Mahoney <jeffm@suse.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [patch 11/33] kmalloc: return NULL instead of link failure
Message-ID: <20090204183437.GL13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kmalloc-return-null-instead-of-link-failure.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit 1cf3eb2ff6b0844c678f2f48d0053b9d12b7da67 upstream.

The SLAB kmalloc with a constant value isn't consistent with the other
implementations because it bails out with __you_cannot_kmalloc_that_much
rather than returning NULL and properly allowing the caller to fall back
to vmalloc or take other action.  This doesn't happen with a non-constant
value or with SLOB or SLUB.

Starting with 2.6.28, I've been seeing build failures on s390x.  This is
due to init_section_page_cgroup trying to allocate 2.5MB when the max size
for a kmalloc on s390x is 2MB.

It's failing because the value is constant.  The workarounds at the call
size are ugly and the caller shouldn't have to change behavior depending
on what the backend of the API is.

So, this patch eliminates the link failure and returns NULL like the other
implementations.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/slab_def.h |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -43,10 +43,7 @@ static inline void *kmalloc(size_t size,
 			i++;
 #include <linux/kmalloc_sizes.h>
 #undef CACHE
-		{
-			extern void __you_cannot_kmalloc_that_much(void);
-			__you_cannot_kmalloc_that_much();
-		}
+		return NULL;
 found:
 #ifdef CONFIG_ZONE_DMA
 		if (flags & GFP_DMA)
@@ -77,10 +74,7 @@ static inline void *kmalloc_node(size_t 
 			i++;
 #include <linux/kmalloc_sizes.h>
 #undef CACHE
-		{
-			extern void __you_cannot_kmalloc_that_much(void);
-			__you_cannot_kmalloc_that_much();
-		}
+		return NULL;
 found:
 #ifdef CONFIG_ZONE_DMA
 		if (flags & GFP_DMA)

