Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbZGWRYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbZGWRYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 13:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZGWRYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 13:24:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752472AbZGWRYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 13:24:33 -0400
Date: Thu, 23 Jul 2009 10:23:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       kosaki.motohiro@jp.fujitsu.com, maximlevitsky@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee.Schermerhorn@hp.com, penberg@cs.helsinki.fi, hannes@cmpxchg.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] mm: Warn once when a page is freed with PG_mlocked set
 V2
Message-Id: <20090723102316.b94a2e4f.akpm@linux-foundation.org>
In-Reply-To: <20090723102938.GA27731@csn.ul.ie>
References: <20090715125822.GB29749@csn.ul.ie>
	<alpine.DEB.1.10.0907151027410.23643@gentwo.org>
	<20090722160649.61176c61.akpm@linux-foundation.org>
	<20090723102938.GA27731@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 11:29:39 +0100 Mel Gorman <mel@csn.ul.ie> wrote:

> On Wed, Jul 22, 2009 at 04:06:49PM -0700, Andrew Morton wrote:
> > On Wed, 15 Jul 2009 10:31:54 -0400 (EDT)
> > Christoph Lameter <cl@linux-foundation.org> wrote:
> > 
> > > On Wed, 15 Jul 2009, Mel Gorman wrote:
> > > 
> > > > -static inline int free_pages_check(struct page *page)
> > > > +static inline int free_pages_check(struct page *page, int wasMlocked)
> > > >  {
> > > > +	WARN_ONCE(wasMlocked, KERN_WARNING
> > > > +		"Page flag mlocked set for process %s at pfn:%05lx\n"
> > > > +		"page:%p flags:0x%lX\n",
> > > > +		current->comm, page_to_pfn(page),
> > > > +		page, page->flags|__PG_MLOCKED);
> > > > +
> > > >  	if (unlikely(page_mapcount(page) |
> > > 
> > > There is already a free_page_mlocked() that is only called if the mlock
> > > bit is set. Move it into there to avoid having to run two checks in the
> > > hot codee path?
> > 
> > Agreed.
> > 
> > This patch gratuitously adds hotpath overhead.  Moving the change to be
> > inside those preexisting wasMlocked tests will reduce its overhead a lot.
> > 
> 
> It adds code duplication then, one of which is in a fast path.
> 
> > As it stands, I'm really doubting that the patch's utility is worth its
> > cost.
> > 
> 
> I'm happy to let this one drop. It seemed like it would be nice for debugging
> while there are still corner cases where mlocked pages are getting freed
> instead of torn down but we already account for that situation occuring. While
> I think it'll be tricky to spot, it's probably preferable to having warnings
> spew out onto dmesg.

If we do in it the way which Christoph recommends, the additional
overhead is miniscule?


