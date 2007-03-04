Return-Path: <linux-kernel-owner+w=401wt.eu-S1751427AbXCDMIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbXCDMIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 07:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXCDMIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 07:08:00 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35227 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbXCDMH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 07:07:59 -0500
Date: Sun, 4 Mar 2007 04:07:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
Message-Id: <20070304040742.e56fc57f.akpm@linux-foundation.org>
In-Reply-To: <45EA274B.5090103@redhat.com>
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
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 20:56:27 -0500 Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> 
> >>> Doing a refault thing would help a bit, but stops working at a certain point.
> >> At what point does it stop working?
> > 
> > We need to store that this-page-got-reclaimed info somewhere.  I don't know
> > how space-efficient that is.  Did anyone ever do an implementation?
> 
> One 32 bit word per evicted page that we keep track of.

ok...

I wonder if we really need a new data structure to track that.  I mean,
once a file-backed (or indeed swapcache) page has been reclaimed, its
radix-tree slot is just sitting there with zeroes in it, asking us to reuse
that space for something interesting, no?

Of course, if all 64 pages in a radix-tree node get removed, we'll
currently free the node itself.  We could stop doing that, but the effects
of that might be pretty bad sometimes.  Instead, it sounds sensible to
populate the now-null slot in the parent radix-tree node with an
average/max/min/per-child-bitmap/whatever of the metrics for the 64
non-resident pages which that non-leaf slot represents.  So as the period
since a single page got evicted increases and increases, our information
about its state becomes less and less accurate.

If that inaccuracy is a problem then perhaps we could defer the collapsing
of a now-empty node into its parent in some manner.

> > You mean design it and review the design before coding it?  You'll find few
> > objections there.
> 
> Few objections, but sadly also very few people interested in
> actually reviewing the design :(
> 
> If you can find holes in http://linux-mm.org/PageReplacementDesign
> please let me know :)

That all looks pretty non-crazy and implementable to me.  Alas, getting the
stuff written and working is 1% of the effort.  The rest is the nasty hunt
for new corner-cases and general productisation hassle.  But if initial
results show benefit, I expect we could manage all that.
