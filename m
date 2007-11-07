Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbXKGSQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbXKGSQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbXKGSQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:16:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbXKGSQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:16:40 -0500
Date: Wed, 7 Nov 2007 13:16:27 -0500
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/10] split anon and file LRUs
Message-ID: <20071107131627.57e8f666@bree.surriel.com>
In-Reply-To: <20071107095945.c9b870fc.akpm@linux-foundation.org>
References: <20071103184229.3f20e2f0@bree.surriel.com>
	<Pine.LNX.4.64.0711061808460.5249@schroedinger.engr.sgi.com>
	<20071106212305.6aa3a4fe@bree.surriel.com>
	<Pine.LNX.4.64.0711061834340.5424@schroedinger.engr.sgi.com>
	<20071106215127.29e90ecd@bree.surriel.com>
	<20071107095945.c9b870fc.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007 09:59:45 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > On Tue, 6 Nov 2007 21:51:27 -0500 Rik van Riel <riel@redhat.com> wrote:

> > Which is why we need to greatly reduce the number of pages
> > scanned to free a page.  In all workloads.
> 
> It strikes me that splitting one list into two lists will not provide
> sufficient improvement in search efficiency to do that. 

Well, if you look at the typical problem systems today, you
will see that most of the pages being allocated and evicted
are in the page cache, while most of the pages in memory are
actually anonymous pages.

Not having to scan over that 80% of memory that contains
anonymous pages and shared memory segments to get at the
20% page cache pages is much more than a factor two
improvement.

> I mean, a naive guess would be that it will, on average, halve the amount
> of work which needs to be done.
> 
> But we need multiple-orders-of-magnitude improvements to address the
> pathological worst-cases which you're looking at there.  Where is this
> coming from?

Replacing page cache pages is easy.  If they were referenced
once (typical), we can just evict the page the first time we
scan it.

Anonymous pages have a similar optimization: every anonymous
page starts out referenced, so moving referenced pages back
to the front of the active list is unneeded work.

However, we cannot just place referenced anonymous pages onto
an inactive list that is shared with page cache pages, because
of the difference in replacement cost and relative importance
of both types of pages!

> Or is the problem which you're seeing due to scanning of mapped pages
> at low "distress" levels?
> 
> Would be interested in seeing more details on all of this, please.

http://linux-mm.org/PageReplacementDesign

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
