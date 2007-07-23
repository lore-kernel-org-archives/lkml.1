Return-Path: <linux-kernel-owner+w=401wt.eu-S936303AbXGWU7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936303AbXGWU7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934906AbXGWU7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:59:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34155 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936090AbXGWU7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:59:21 -0400
Date: Mon, 23 Jul 2007 13:59:20 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub crashes with recent -git
Message-ID: <20070723135920.01893968@schroedinger.engr.sgi.com>
In-Reply-To: <alpine.LFD.0.999.0707191324020.27249@woody.linux-foundation.org>
References: <20070719194234.GA27917@elte.hu>
	<alpine.LFD.0.999.0707191307220.27249@woody.linux-foundation.org>
	<alpine.LFD.0.999.0707191324020.27249@woody.linux-foundation.org>
Organization: Silicon Graphics, Inc.
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 13:25:07 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 19 Jul 2007, Linus Torvalds wrote:
> > 
> > A better patch should be the appended. Does that work for you too?
> 
> Btw, I already committed this as obvious. 
> 
> I did the same for the SLAB __do_kmalloc() thing. Let's hope that
> that was the extent of the damage.
> 
> 		Linus

Hmmmm.. The issue is really in krealloc which can be called with a NULL
parameter (a special case). However, krealloc should not call ksize
with NULL.

The merged patch above makes ksize(NULL) return 0. So we are
returning zero size for an object that we have not allocated.
Better fail if someone tries that.

The __do_kmalloc issue looks like a hunk that was somehow dropped.

IMHO: The right fix for the ksize issue would be the following patch:


Index: linux-2.6/mm/util.c
===================================================================
--- linux-2.6.orig/mm/util.c	2007-07-23 13:29:42.000000000 -0700
+++ linux-2.6/mm/util.c	2007-07-23 13:31:28.000000000 -0700
@@ -88,7 +88,11 @@ void *krealloc(const void *p, size_t new
 		return ZERO_SIZE_PTR;
 	}
 
-	ks = ksize(p);
+	if (p)
+		ks = ksize(p);
+	else
+		ks = 0;
+
 	if (ks >= new_size)
 		return (void *)p;
 
