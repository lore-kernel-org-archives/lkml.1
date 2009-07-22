Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbZGVXIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbZGVXIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 19:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbZGVXIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 19:08:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729AbZGVXIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 19:08:06 -0400
Date: Wed, 22 Jul 2009 16:06:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: mel@csn.ul.ie, kosaki.motohiro@jp.fujitsu.com, maximlevitsky@gmail.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee.Schermerhorn@hp.com, penberg@cs.helsinki.fi, hannes@cmpxchg.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] mm: Warn once when a page is freed with PG_mlocked set
 V2
Message-Id: <20090722160649.61176c61.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0907151027410.23643@gentwo.org>
References: <20090715125822.GB29749@csn.ul.ie>
	<alpine.DEB.1.10.0907151027410.23643@gentwo.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 10:31:54 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Wed, 15 Jul 2009, Mel Gorman wrote:
> 
> > -static inline int free_pages_check(struct page *page)
> > +static inline int free_pages_check(struct page *page, int wasMlocked)
> >  {
> > +	WARN_ONCE(wasMlocked, KERN_WARNING
> > +		"Page flag mlocked set for process %s at pfn:%05lx\n"
> > +		"page:%p flags:0x%lX\n",
> > +		current->comm, page_to_pfn(page),
> > +		page, page->flags|__PG_MLOCKED);
> > +
> >  	if (unlikely(page_mapcount(page) |
> 
> There is already a free_page_mlocked() that is only called if the mlock
> bit is set. Move it into there to avoid having to run two checks in the
> hot codee path?

Agreed.

This patch gratuitously adds hotpath overhead.  Moving the change to be
inside those preexisting wasMlocked tests will reduce its overhead a lot.

As it stands, I'm really doubting that the patch's utility is worth its
cost.

Also, it's a bit of a figleaf, but please consider making more use of
CONFIG_DEBUG_VM (see VM_BUG_ON()).

