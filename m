Return-Path: <linux-kernel-owner+w=401wt.eu-S932799AbXCDOfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbXCDOfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 09:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932807AbXCDOfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 09:35:45 -0500
Received: from amsfep17-int.chello.nl ([62.179.120.12]:19572 "EHLO
	amsfep17-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932799AbXCDOfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 09:35:44 -0500
Subject: Re: userspace pagecache management tool
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070304040742.e56fc57f.akpm@linux-foundation.org>
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>
	 <45E9DD4A.2060806@redhat.com>
	 <20070303131204.6706a95c.akpm@linux-foundation.org>
	 <45E9E910.2070804@redhat.com>
	 <20070303140744.b22699dd.akpm@linux-foundation.org>
	 <45E9F5DA.2070708@redhat.com>
	 <20070303145221.2a42cc0f.akpm@linux-foundation.org>
	 <45EA0C3D.1010001@redhat.com>
	 <20070303170237.31d26382.akpm@linux-foundation.org>
	 <45EA1F7B.9060107@redhat.com>
	 <20070303174927.2d314a71.akpm@linux-foundation.org>
	 <45EA274B.5090103@redhat.com>
	 <20070304040742.e56fc57f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Date: Sun, 04 Mar 2007 15:35:30 +0100
Message-Id: <1173018930.4845.11.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-04 at 04:07 -0800, Andrew Morton wrote:
> On Sat, 03 Mar 2007 20:56:27 -0500 Rik van Riel <riel@redhat.com> wrote:
> 
> > Andrew Morton wrote:
> > 
> > >>> Doing a refault thing would help a bit, but stops working at a certain point.
> > >> At what point does it stop working?
> > > 
> > > We need to store that this-page-got-reclaimed info somewhere.  I don't know
> > > how space-efficient that is.  Did anyone ever do an implementation?
> > 
> > One 32 bit word per evicted page that we keep track of.
> 
> ok...
> 
> I wonder if we really need a new data structure to track that.  I mean,
> once a file-backed (or indeed swapcache) page has been reclaimed, its
> radix-tree slot is just sitting there with zeroes in it, asking us to reuse
> that space for something interesting, no?
> 
> Of course, if all 64 pages in a radix-tree node get removed, we'll
> currently free the node itself.  We could stop doing that, but the effects
> of that might be pretty bad sometimes.  Instead, it sounds sensible to
> populate the now-null slot in the parent radix-tree node with an
> average/max/min/per-child-bitmap/whatever of the metrics for the 64
> non-resident pages which that non-leaf slot represents.  So as the period
> since a single page got evicted increases and increases, our information
> about its state becomes less and less accurate.
> 
> If that inaccuracy is a problem then perhaps we could defer the collapsing
> of a now-empty node into its parent in some manner.

Getting the refault distance out of such a radix tree would be tricky.
One solution I can think of would entail keeping a global fault count
and storing the current fault count in the radix node and on refault
subtract from the global count. The downside however is this global
thing, perhaps we could do some smart percpu count aggregate to fix it.

The other point you mention is when to we reap these radix tree nodes,
normally nonresident information gets dropped once the distance is
further than our memory is big, but these nodes don´t have explicit
order.

The collapsing idea is interesting, esp. if we could delay the collapse
so that the avg refault distance would be in some relation to the error.

