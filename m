Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbYFAIWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbYFAIWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 04:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYFAIWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 04:22:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48456 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbYFAIWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 04:22:06 -0400
Date: Sun, 1 Jun 2008 11:22:04 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <484256AA.3000709@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0806011119420.11749@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0805281328310.982@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0805281646470.27125@sbz-30.cs.Helsinki.FI>
 <20080528153648.GA27783@linux-sh.org> <483DBA85.2060502@cs.helsinki.fi>
 <Pine.LNX.4.64.0805281325260.932@schroedinger.engr.sgi.com>
 <483DBFC3.1070108@cs.helsinki.fi> <29611.1212066517@redhat.com>
 <Pine.LNX.4.64.0805291620250.5415@sbz-30.cs.helsinki.fi>
 <20080529211207.GB13663@linux-sh.org> <484256AA.3000709@cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008, Pekka Enberg wrote:
> > Not until the page->index bits are killed, otherwise you aren't fixing
> > anything. SLOB on nommu with those page->index tests will automatically
> > oops today, before or after your patches. Until that's resolved, there's
> > no point in pretending like kobjsize() has been "fixed". As no one has
> > come up with a valid reason for those tests existing in the first place,
> > simply having your patches and killing the BUG_ON()'s seems ok.
> 
> Sorry if I'm starting to sound like a broken record, but can you explain why
> removing the ->index bits are safe? I mean, if removing them is really okay,
> that means we don't hit that code path with SLAB at all?

Paul, so with something like this, the WARN_ON never triggers?

diff --git a/mm/nommu.c b/mm/nommu.c
index dca93fc..38eec2e 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -109,16 +109,23 @@ unsigned int kobjsize(const void *objp)
 	 * If the object we have should not have ksize performed on it,
 	 * return size of 0
 	 */
-	if (!objp || (unsigned long)objp >= memory_end || !((page = virt_to_page(objp))))
+	if (!objp)
+		return 0;
+
+	if ((unsigned long)objp >= memory_end)
+		return 0;
+
+	page = virt_to_page(objp);
+	if (!page)
 		return 0;
 
 	if (PageSlab(page))
 		return ksize(objp);
 
-	BUG_ON(page->index < 0);
-	BUG_ON(page->index >= MAX_ORDER);
+	if (WARN_ON(!PageCompound(page)))
+		return 0;
 
-	return (PAGE_SIZE << page->index);
+	return PAGE_SIZE << compound_order(page);
 }
 
 /*
