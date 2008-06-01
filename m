Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYFAJNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYFAJNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 05:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYFAJNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 05:13:07 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34554 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbYFAJNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 05:13:06 -0400
Date: Sun, 1 Jun 2008 12:13:02 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Paul Mundt <lethal@linux-sh.org>
cc: David Howells <dhowells@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <20080601082427.GC25429@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0806011208480.13090@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0805281646470.27125@sbz-30.cs.Helsinki.FI>
 <20080528153648.GA27783@linux-sh.org> <483DBA85.2060502@cs.helsinki.fi>
 <Pine.LNX.4.64.0805281325260.932@schroedinger.engr.sgi.com>
 <483DBFC3.1070108@cs.helsinki.fi> <29611.1212066517@redhat.com>
 <Pine.LNX.4.64.0805291620250.5415@sbz-30.cs.helsinki.fi>
 <20080529211207.GB13663@linux-sh.org> <484256AA.3000709@cs.helsinki.fi>
 <Pine.LNX.4.64.0806011119420.11749@sbz-30.cs.Helsinki.FI>
 <20080601082427.GC25429@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Sun, 1 Jun 2008, Paul Mundt wrote:
> This still needs to be virt_to_head_page() I think.
> 
> I don't have my nommu boards at home, so I'll test at the office tomorow
> morning and let you know.

I was about to send a patch that fixes some of the kobjsize() abuses to 
use ksize() but then I realized that what we probably should do is 
something like this instead.

I mean, assuming the BUG_ON bits are bogus, then we should always pass the 
pointer to the allocator. I audited most of the callers and they all seem 
to be really just using kmalloc() for allocation anyway.

What do you think?

		Pekka

diff --git a/mm/nommu.c b/mm/nommu.c
index dca93fc..fc1ff52 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -103,22 +103,20 @@ EXPORT_SYMBOL(vmtruncate);
  */
 unsigned int kobjsize(const void *objp)
 {
-	struct page *page;
-
 	/*
 	 * If the object we have should not have ksize performed on it,
 	 * return size of 0
 	 */
-	if (!objp || (unsigned long)objp >= memory_end || !((page = virt_to_page(objp))))
+	if (!objp)
 		return 0;
 
-	if (PageSlab(page))
-		return ksize(objp);
+	if ((unsigned long)objp >= memory_end)
+		return 0;
 
-	BUG_ON(page->index < 0);
-	BUG_ON(page->index >= MAX_ORDER);
+	if (!virt_to_page(objp))
+		return 0;
 
-	return (PAGE_SIZE << page->index);
+	return ksize(objp);
 }
 
 /*
