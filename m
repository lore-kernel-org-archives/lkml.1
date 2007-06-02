Return-Path: <linux-kernel-owner+w=401wt.eu-S1760686AbXFBDGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686AbXFBDGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 23:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbXFBDG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 23:06:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34577 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754141AbXFBDG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 23:06:27 -0400
Date: Fri, 1 Jun 2007 20:06:25 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <alpine.LFD.0.98.0706011947030.3957@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706012005040.11202@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706011947030.3957@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Linus Torvalds wrote:

> So when I suggested the uglier
> 
> 	if ((unsigned long)x <= 16)
> 		return;
> 
> I really did mean to use that ugly cast.. Yours is prettier, but sadly, 
> yours is simply not safe: a signed comparison might end up making _all_ 
> kernel pointers trigger that test.

Maybe we can have a compromise? Lets at least keep the ZERO_SIZE_PTR
reference in there.


SLUB: Make sure that the comparision with ZERO_SIZE_PTR is unsigned

Signed-off-by: Christoph Lameter <clameter@sgi.com>


---
 mm/slub.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: slub/mm/slub.c
===================================================================
--- slub.orig/mm/slub.c	2007-06-01 20:00:56.000000000 -0700
+++ slub/mm/slub.c	2007-06-01 20:04:26.000000000 -0700
@@ -2338,7 +2338,13 @@ void kfree(const void *x)
 	struct kmem_cache *s;
 	struct page *page;
 
-	if (x <= ZERO_SIZE_PTR)
+	/*
+	 * This has to be an unsigned comparison. According to Linus
+	 * some gcc version tread a pointer as a signed entity. Then
+	 * this comparison would be true for all "negative" pointers
+	 * (which would cover the whole upper half of the address space).
+	 */
+	if ((unsigned long)x <= (unsigned long)ZERO_SIZE_PTR)
 		return;
 
 	page = virt_to_head_page(x);
