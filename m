Return-Path: <linux-kernel-owner+w=401wt.eu-S1762845AbXEUSZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762845AbXEUSZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 14:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbXEUSZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 14:25:42 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:41020 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756400AbXEUSZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 14:25:41 -0400
Date: Mon, 21 May 2007 11:25:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Oliver Xymoron <oxymoron@waste.org>, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <Pine.LNX.4.64.0705211835140.26666@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0705211121570.26794@schroedinger.engr.sgi.com>
References: <20070520133505.46147.qmail@web52609.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0705210917280.25871@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705211835140.26666@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Hugh Dickins wrote:

> Yes, sounded the same to me too: I couldn't reproduce it or see anything
> wrong in the code back then.  But Srihari's info about CONFIG_DEBUG_SLUB
> off has helped a lot: I was then able to reproduce it on my x86_64, and
> after a lot of staring at the code, the problem became obvious...

Right. The #ifdef CONFIG_SLUB_DEBUG is at the wrong location. The best fix
is to moving the #ifdef otherwise the size is still wrong for the 
ctor case.


SLUB Debug: Fix object size calculation

The object size calculation is wrong if !CONFIG_SLUB_DEBUG because
the #ifdef CONFIG_SLUB_DEBUG is now switching off the size adjustments
for DESTROY_BY_RCU and ctor.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-05-21 11:21:36.000000000 -0700
+++ slub/mm/slub.c	2007-05-21 11:21:49.000000000 -0700
@@ -1943,7 +1943,6 @@ static int calculate_sizes(struct kmem_c
 	 */
 	s->inuse = size;
 
-#ifdef CONFIG_SLUB_DEBUG
 	if (((flags & (SLAB_DESTROY_BY_RCU | SLAB_POISON)) ||
 		s->ctor)) {
 		/*
@@ -1958,6 +1957,7 @@ static int calculate_sizes(struct kmem_c
 		size += sizeof(void *);
 	}
 
+#ifdef CONFIG_SLUB_DEBUG
 	if (flags & SLAB_STORE_USER)
 		/*
 		 * Need to store information about allocs and frees after
