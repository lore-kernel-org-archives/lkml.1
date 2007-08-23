Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbXHWTa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbXHWTa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 15:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXHWTaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 15:30:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43141 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755727AbXHWTaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 15:30:12 -0400
Date: Thu, 23 Aug 2007 12:30:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] SLUB: Avoid touching page struct when freeing to
 per cpu slab
In-Reply-To: <1187881558.6114.400.camel@twins>
Message-ID: <Pine.LNX.4.64.0708231229030.14478@schroedinger.engr.sgi.com>
References: <20070823064653.081843729@sgi.com>  <20070823064734.558994491@sgi.com>
 <1187881558.6114.400.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007, Peter Zijlstra wrote:

> On Wed, 2007-08-22 at 23:46 -0700, Christoph Lameter wrote:
> > plain text document attachment
> > (0008-SLUB-Avoid-touching-page-struct-when-freeing-to-per.patch)
> > Set c->node to -1 if we allocate from a debug slab instead for SlabDebug
> > which requires access the page struct cacheline.
> 
> this relies on node_match() which will only ever return !1 when
> CONFIG_NUMA

Yup the later cmpxchg patches papered that over for awhile.

So we need to also check for -1 if !NUMA

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.23-rc3-mm1/mm/slub.c
===================================================================
--- linux-2.6.23-rc3-mm1.orig/mm/slub.c	2007-08-23 12:26:55.000000000 -0700
+++ linux-2.6.23-rc3-mm1/mm/slub.c	2007-08-23 12:28:07.000000000 -0700
@@ -1424,8 +1424,10 @@ static void flush_all(struct kmem_cache 
  */
 static inline int node_match(struct kmem_cache_cpu *c, int node)
 {
+	if (node == -1)
+		return 0;
 #ifdef CONFIG_NUMA
-	if (node != -1 && c->node != node)
+	if (c->node != node)
 		return 0;
 #endif
 	return 1;
