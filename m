Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbXKGCvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbXKGCvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 21:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbXKGCvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 21:51:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbXKGCvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 21:51:32 -0500
Date: Tue, 6 Nov 2007 21:51:27 -0500
From: Rik van Riel <riel@redhat.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/10] split anon and file LRUs
Message-ID: <20071106215127.29e90ecd@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0711061834340.5424@schroedinger.engr.sgi.com>
References: <20071103184229.3f20e2f0@bree.surriel.com>
	<Pine.LNX.4.64.0711061808460.5249@schroedinger.engr.sgi.com>
	<20071106212305.6aa3a4fe@bree.surriel.com>
	<Pine.LNX.4.64.0711061834340.5424@schroedinger.engr.sgi.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007 18:40:46 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 6 Nov 2007, Rik van Riel wrote:
> 
> > Also, a factor 16 increase in page size is not going to help
> > if memory sizes also increase by a factor 16, since we already 
> > have trouble with today's memory sizes.
> 
> Note that a factor 16 increase usually goes hand in hand with
> more processors. The synchronization of multiple processors becomes a 
> concern. If you have an 8p and each of them tries to get the zone locks 
> for reclaim then we are already in trouble. And given the immaturity
> of the handling of cacheline contention in current commodity hardware this 
> is likely to result in livelocks and/or starvation on some level.

Which is why we need to greatly reduce the number of pages
scanned to free a page.  In all workloads.

> > > We do not have an accepted standard load. So how would we figure that one 
> > > out?
> > 
> > The current worst case is where we need to scan all of memory, 
> > just to find a few pages we can swap out.  With the effects of
> > lock contention figured in, this can take hours on huge systems.
> 
> Right but I think this looks like a hopeless situation regardless of the 
> algorithm if you have a couple of million pages and are trying to free 
> one. Now image a series of processors going on the hunt for the few pages 
> that can be reclaimed.

An algorithm that only clears the referenced bit and then
moves the anonymous page from the active to the inactive
list will do a lot less work than an algorithm that needs
to scan the *whole* active list because all of the pages
on it are referenced.

This is not a theoretical situation: every anonymous page
starts out referenced!

Add in a relatively small inactive list on huge memory
systems, and we could have something of an acceptable
algorithmic complexity.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
