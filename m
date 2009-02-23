Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZBWQiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZBWQiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZBWQh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:37:59 -0500
Received: from smtp-out.google.com ([216.239.33.17]:55866 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZBWQh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:37:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=m5YKfrgHgaGJkc4bFc1286stnNPhC6W3u3euk/JEiE3ycH7MxaqRlFnoPv/cLog9l
	R6ouEhCHok+YMcU/975rw==
Date: Mon, 23 Feb 2009 08:37:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] slub: move min_partial to struct kmem_cach
In-Reply-To: <alpine.DEB.1.10.0902231119390.22276@qirst.com>
Message-ID: <alpine.DEB.2.00.0902230835120.24379@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0902221710430.26165@chino.kir.corp.google.com> <alpine.DEB.1.10.0902231108200.22276@qirst.com> <alpine.DEB.2.00.0902230821510.23216@chino.kir.corp.google.com> <alpine.DEB.1.10.0902231119390.22276@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009, Christoph Lameter wrote:

> > The second patch in this series as a /sys/kernel/slab/cache/min_partial
> > tunable that uses calculate_min_partial() to enforce a sane range, so
> > while it may not actually be doing any calculations, the ilog2() is
> > appropriately placed in kmem_cache_open().  We don't want to be taking the
> > log of the user's min_partial value.
> 
> Then Rename the function to set_min_partial()?
> 

I don't have any strong opinions as to the specific name, so I'll leave 
this up to Pekka.  set_min_partial(), to me, seems to indicate that 
s->min_partial will unconditionally set to the value passed, which isn't 
necessarily true.


slub: rename calculate_min_partial() to set_min_partial()

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2170,7 +2170,7 @@ static int init_kmem_cache_nodes(struct kmem_cache *s, gfp_t gfpflags)
 }
 #endif
 
-static void calculate_min_partial(struct kmem_cache *s, unsigned long min)
+static void set_min_partial(struct kmem_cache *s, unsigned long min)
 {
 	if (min < MIN_PARTIAL)
 		min = MIN_PARTIAL;
@@ -2321,7 +2321,7 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
 	 * The larger the object size is, the more pages we want on the partial
 	 * list to avoid pounding the page allocator excessively.
 	 */
-	calculate_min_partial(s, ilog2(s->size));
+	set_min_partial(s, ilog2(s->size));
 	s->refcount = 1;
 #ifdef CONFIG_NUMA
 	s->remote_node_defrag_ratio = 1000;
@@ -3854,7 +3854,7 @@ static ssize_t min_partial_store(struct kmem_cache *s, const char *buf,
 	if (err)
 		return err;
 
-	calculate_min_partial(s, min);
+	set_min_partial(s, min);
 	return length;
 }
 SLAB_ATTR(min_partial);
