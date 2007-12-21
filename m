Return-Path: <linux-kernel-owner+w=401wt.eu-S1760225AbXLUXyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760225AbXLUXyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 18:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbXLUXyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 18:54:36 -0500
Received: from relay1.sgi.com ([192.48.171.29]:47620 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755112AbXLUXyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 18:54:36 -0500
Date: Fri, 21 Dec 2007 15:54:32 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <20071221231728.GA28008@elte.hu>
Message-ID: <Pine.LNX.4.64.0712211552180.27290@schroedinger.engr.sgi.com>
References: <1197049846.1645.68.camel@localhost.localdomain>
 <20071211143336.GA17866@elte.hu> <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com>
 <20071221120908.GA15926@elte.hu> <84144f020712210944q3e0539f8vd8a249f69d456dc7@mail.gmail.com>
 <Pine.LNX.4.64.0712211412040.3795@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0712211435250.3795@schroedinger.engr.sgi.com>
 <alpine.LFD.0.9999.0712211449320.21557@woody.linux-foundation.org>
 <20071221231728.GA28008@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2007, Ingo Molnar wrote:

> and the regression seems to be largely fixed! Not only is the hackbench 
> one fixed, but mmap shows an above-noise improvement as well.
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

Well lets use the version attached to this patch. It turns out that it is 
not important to increase the number of partial slabs. Just putting the 
slab onto the tail of the list does it.
 
> And i hereby nominate Pekka as SLUB/SLAB co-maintainer and spokesperson 
> ;-)

He is already the co-maintainer of the slab allocators. See the 
MAINTAINERS file.



SLUB: Improve hackbench speed

Increase the mininum number of partial slabs to keep around and put
partial slabs to the end of the partial queue so that they can add
more objects.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-12-21 14:30:11.096324462 -0800
+++ linux-2.6/mm/slub.c	2007-12-21 15:10:17.611022381 -0800
@@ -1611,12 +1611,12 @@ checks_ok:
 		goto slab_empty;
 
 	/*
-	 * Objects left in the slab. If it
-	 * was not on the partial list before
-	 * then add it.
+	 * Objects left in the slab. If it was not on the partial list before
+	 * then add it. Add it to the end since there is only a single object
+	 * which would make slab_alloc inefficient.
 	 */
 	if (unlikely(!prior))
-		add_partial(get_node(s, page_to_nid(page)), page);
+		add_partial_tail(get_node(s, page_to_nid(page)), page);
 
 out_unlock:
 	slab_unlock(page);
