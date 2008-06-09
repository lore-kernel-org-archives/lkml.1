Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbYFIP6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbYFIP6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYFIP56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:57:58 -0400
Received: from relay1.sgi.com ([192.48.171.29]:49873 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751748AbYFIP55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:57:57 -0400
Date: Mon, 9 Jun 2008 10:57:56 -0500
From: Russ Anderson <rja@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 2/3] mm: Avoid putting a bad page back on the LRU v5
Message-ID: <20080609155755.GC25842@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080516192320.GE7885@sgi.com> <Pine.LNX.4.64.0805161609060.5114@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805161609060.5114@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 04:13:11PM -0700, Christoph Lameter wrote:
> >  /*
> >   * Isolate one page from the LRU lists. If successful put it onto
> >   * the indicated list with elevated page count.
> > @@ -110,6 +112,8 @@ int putback_lru_pages(struct list_head *
> >  
> >  	list_for_each_entry_safe(page, page2, l, lru) {
> >  		list_del(&page->lru);
> > +		if (unlikely(PageMemError(page)))
> > +			continue;
> >  		move_to_lru(page);
> >  		count++;
> >  	}
> > @@ -717,10 +721,14 @@ unlock:
> >   		 * A page that has been migrated has all references
> >   		 * removed and will be freed. A page that has not been
> >   		 * migrated will have kepts its references and be
> > - 		 * restored.
> > +		 * restored.  A page with a memory error will not
> > +		 * be moved to the LRU.
> >   		 */
> >   		list_del(&page->lru);
> > - 		move_to_lru(page);
> > +		if (PageMemError(page))
> > +			totalbad_pages++;
> > +		else
> > +			move_to_lru(page);
> >  	}
> 
> So what happens if a page has acquired an additional ref count and 
> PageMemError is set. Then we fail migration and the page will not be put 
> back on the LRU? So it will not be migratable anymore?

That was a problem.  If migration failed the page would end up with an extra 
page reference.  The new patch fixes that problem.  If the page fails
to migrate it will be put back on the LRU and the MemError bit cleared.
If the page gets another corrected error it will try to migrate the page
again.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
