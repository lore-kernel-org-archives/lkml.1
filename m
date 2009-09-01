Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZIAO1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZIAO1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 10:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZIAO1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 10:27:24 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57299 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZIAO1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 10:27:21 -0400
Date: Tue, 1 Sep 2009 23:27:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: page allocator regression on nommu
Message-ID: <20090901142716.GA16759@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, Mel Gorman <mel@csn.ul.ie>,
	Christoph Lameter <cl@linux-foundation.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Dave Hansen <dave@linux.vnet.ibm.com>,
	Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <20090831102642.GA30264@linux-sh.org> <20090831074842.GA28091@linux-sh.org> <84144f020908310308i48790f78g5a7d73a60ea854f8@mail.gmail.com> <12589.1251812805@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12589.1251812805@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 02:46:45PM +0100, David Howells wrote:
> Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > Yeah, that looks a bit suspect. __put_nommu_region() is safe to be called
> > without a call to add_nommu_region(), but we happen to trip over the
> > BUG_ON() in this case because we've never made a single addition to the
> > region tree.
> > 
> > We probably ought to just up_write() and return if nommu_region_tree ==
> > RB_ROOT, which is what I'll do unless David objects.
> 
> I think that's the wrong thing to do.  I think we're better moving the call to
> add_nommu_region() to above the "/* set up the mapping */" comment.  We hold
> the region semaphore at this point, so the fact that it winds up in the tree
> briefly won't cause a race, and it means __put_nommu_region() can be used with
> impunity to correctly clean up.
> 
[snip]

> From: David Howells <dhowells@redhat.com>
> Subject: [PATCH] NOMMU: Fix error handling in do_mmap_pgoff()
> 
> Fix the error handling in do_mmap_pgoff().  If do_mmap_shared_file() or
> do_mmap_private() fail, we jump to the error_put_region label at which point we
> cann __put_nommu_region() on the region - but we haven't yet added the region
> to the tree, and so __put_nommu_region() may BUG because the region tree is
> empty or it may corrupt the region tree.
> 
> To get around this, we can afford to add the region to the region tree before
> calling do_mmap_shared_file() or do_mmap_private() as we keep nommu_region_sem
> write-locked, so no-one can race with us by seeing a transient region.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Agreed, that does look cleaner. After playing around with it a bit, I concede
that the BUG_ON() is definitely worth preserving. :-)

Acked-by: Paul Mundt <lethal@linux-sh.org>
