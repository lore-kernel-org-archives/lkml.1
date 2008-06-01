Return-Path: <linux-kernel-owner+w=401wt.eu-S1757083AbYFAIhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbYFAIhW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 04:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYFAIgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 04:36:51 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38179 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbYFAIgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 04:36:50 -0400
Date: Sun, 1 Jun 2008 11:36:48 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Paul Mundt <lethal@linux-sh.org>
cc: David Howells <dhowells@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <20080601082427.GC25429@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0806011135350.11966@sbz-30.cs.Helsinki.FI>
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

On Sun, 1 Jun 2008, Paul Mundt wrote:
> This still needs to be virt_to_head_page() I think.
> 
> I don't have my nommu boards at home, so I'll test at the office tomorow
> morning and let you know.

Yes, I messed that up. Thanks a lot for your help, Paul!

		Pekka

[PATCH] nommu: kobjsize fix
From: Christoph Lameter <clameter@sgi.com>

The kobjsize() function is broken with SLOB and SLUB. As summarized by Paul
Mundt:

  The page->index bits look like they are being used for determining compound
  order, which is _completely_ bogus, and only happens to "work" in a few
  cases.  Christoph and I have repeatedly asked for someone to explain what the
  hell those tests are there for, as right now they not only look completely
  bogus, but they also stop us from booting on SLOB.  So far no one has
  provided any input on why those page->index BUG_ON()'s have any right to
  exist.

  So while having 2 out of 3 SLAB allocators in a bootable state might seem
  like progress, I'd rather see kobjsize() fixed correctly. Even my initial
  patches worked for all 3.

  If no one can speak up to defend those bits, they should be killed off before
  2.6.26. Whether this is done in combination with your patch or Christoph's
  patch or whatever else doesn't matter.

You can find the discussion here:

  http://lkml.org/lkml/2008/5/22/223

Reported-by: Paul Mundt <lethal@linux-sh.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---

diff --git a/mm/nommu.c b/mm/nommu.c
index dca93fc..935887b 100644
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
+	page = virt_to_head_page(objp);
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
