Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbZF2KWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbZF2KWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 06:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757163AbZF2KWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 06:22:13 -0400
Received: from cmpxchg.org ([85.214.51.133]:41761 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbZF2KWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 06:22:12 -0400
Date: Mon, 29 Jun 2009 12:18:19 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Jiri Slaby <jirislaby@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>
Subject: Re: BUG: Bad page state [was: Strange oopses in 2.6.30]
Message-ID: <20090629101819.GA2052@cmpxchg.org>
References: <1245686553.7799.102.camel@lts-notebook> <20090622205308.GG3981@csn.ul.ie> <20090623200846.223C.A69D9226@jp.fujitsu.com> <20090629084114.GA28597@csn.ul.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629084114.GA28597@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 09:41:14AM +0100, Mel Gorman wrote:
> I see the unconditionoal clearing of the flag was merged since but even
> that might be too heavy handed as we are making a locked bit operation
> on every page free. That's unfortunate overhead to incur on every page
> free to handle a situation that should not be occurring at all.

Linus was probably quick to merge it as istr several people hitting
bad_page() triggering.  We should get rid of the locked op, I was just
not 100% sure and chose the safer version.

> > > +		WARN_ONCE(1, KERN_WARNING
> > > +			"Sloppy page flags set process %s at pfn:%05lx\n"
> > > +			"page:%p flags:%p\n",
> > > +			current->comm, page_to_pfn(page),
> > > +			page, (void *)page->flags);
[...]
> > > +		page->flags &= ~PAGE_FLAGS_WARN_AT_FREE;
> > > +	}
> > > +
> > >  	if (unlikely(page_mapcount(page) |
> > >  		(page->mapping != NULL)  |
> > >  		(atomic_read(&page->_count) != 0) |
> > 
> > Howerver, I like this patch concept. this warning is useful and meaningful IMHO.
> > 
> 
> This is a version that is based on top of current mainline that just
> displays the warning. However, I think we should consider changing
> TestClearPageMlocked() back to PageMlocked() and only clearing the flags
> when the unusual condition is encountered.

I have a diff at home that makes this an unlocked
__TestClearPageMlocked(), would you be okay with this?
