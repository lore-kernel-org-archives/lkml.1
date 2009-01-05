Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbZAEJ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbZAEJ0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZAEJ0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:26:38 -0500
Received: from cmpxchg.org ([85.214.51.133]:52446 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbZAEJ0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:26:37 -0500
Date: Mon, 5 Jan 2009 10:26:19 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, david@lang.hm,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: early exception error
Message-ID: <20090105092619.GA3699@cmpxchg.org>
References: <20081231093803.GA20882@localhost> <alpine.DEB.1.10.0812311110320.18334@asgard.lang.hm> <20081231183039.GE20882@localhost> <20081231195005.GT496@one.firstfloor.org> <alpine.DEB.1.10.0812311257060.18334@asgard.lang.hm> <20090101041727.GW496@one.firstfloor.org> <alpine.DEB.1.10.0812312212460.15026@asgard.lang.hm> <alpine.DEB.1.10.0901021014030.21408@asgard.lang.hm> <20090102172426.GB5372@localhost> <495E7FAD.6020305@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495E7FAD.6020305@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 02:57:17PM -0600, Robert Hancock wrote:
> Cyrill Gorcunov wrote:
> >
> >Here is a new picture if someone would like to jump into
> >the bug handling
> >
> >	http://linux.lang.hm/linux/IMG00033.jpg
> 
> alloc_bootmem_core is a reasonably big function, it would be useful if 
> we could track down what line it's blowing up on.. Can you try to find 
> out what line that fault address (ffffffff8096452a in this crash) is on 
> as described in Documentation/BUG-HUNTING, i.e. build with 
> CONFIG_DEBUG_INFO enabled, run gdb on vmlinux and do:
> 
> l *0xffffffff8096452a

He has booted with bootmem debugging output.  Given that the bdebug()
describing the request wasn't hit yet, it must be one of the BUG_ON()s
(or bdata is NULL).

If you can find out the line with gdb, this would be great.

Besides that it might be useful to move the bdebug() before the
BUG_ON()s.  With the line info available, the expressions that trigger
a bug are pretty unambiguous, but since we would print the parameters
anyway we can as well do so before a possible panic to quickly deduce
what went wrong without decoding.

	Hannes

---
Subject: bootmem: print request details before BUG_ON(them)

Moving the request details print-out before the sanity checks that
might panic() enables us to analyse invalid requests without having
access to the line information of the stack dump.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---

diff --git a/mm/bootmem.c b/mm/bootmem.c
index ac5a891..51a0ccf 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -435,6 +435,10 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 	unsigned long fallback = 0;
 	unsigned long min, max, start, sidx, midx, step;
 
+	bdebug("nid=%td size=%lx [%lu pages] align=%lx goal=%lx limit=%lx\n",
+		bdata - bootmem_node_data, size, PAGE_ALIGN(size) >> PAGE_SHIFT,
+		align, goal, limit);
+
 	BUG_ON(!size);
 	BUG_ON(align & (align - 1));
 	BUG_ON(limit && goal + size > limit);
@@ -442,10 +446,6 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
 	if (!bdata->node_bootmem_map)
 		return NULL;
 
-	bdebug("nid=%td size=%lx [%lu pages] align=%lx goal=%lx limit=%lx\n",
-		bdata - bootmem_node_data, size, PAGE_ALIGN(size) >> PAGE_SHIFT,
-		align, goal, limit);
-
 	min = bdata->node_min_pfn;
 	max = bdata->node_low_pfn;
 
