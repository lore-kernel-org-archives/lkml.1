Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZK3KSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZK3KSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbZK3KSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:18:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59272 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbZK3KSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:18:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH-RFC] cfq: Disable low_latency by default for 2.6.32
Cc: kosaki.motohiro@jp.fujitsu.com, Corrado Zoccolo <czoccolo@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20091127121627.GL13095@csn.ul.ie>
References: <20091127143307.A7E1.A69D9226@jp.fujitsu.com> <20091127121627.GL13095@csn.ul.ie>
Message-Id: <20091130190711.5BFF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 30 Nov 2009 19:18:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Nov 27, 2009 at 02:58:26PM +0900, KOSAKI Motohiro wrote:
> > > > <SNIP>
> > > > low_latency was tested on other scenarios:
> > > > http://lkml.indiana.edu/hypermail/linux/kernel/0910.0/01410.html
> > > > http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-11/msg04855.html
> > > > where it improved actual and perceived performance, so disabling it
> > > > completely may not be good.
> > > > 
> > > 
> > > It may not indeed.
> > > 
> > > In case you mean a partial disabling of cfq_latency, I'm try the
> > > following patch. The intention is to disable the low_latency logic if
> > > kswapd is at work and presumably needs clean pages. Alternative
> > > suggestions welcome.
> > 
> > I like treat vmscan writeout as special. because
> >   - vmscan use various process context. but it doesn't write own process's page.
> >     IOW, it doesn't so match cfq's io fairness logic.
> >   - plus, the above mean vmscan writeout doesn't need good i/o latency.
> 
> While it might not need good latency as such, it does need pages to be
> clean because direct reclaim has trouble cleaning pages in its own
> behalf.

Well.
if direct reclaim need lumpy reclaim, you are right.

In no lupy case, vmscan start pageout and move the page list tail typically.
cleaned page will be used by another task.

---------------------------------------------------------------------------------------
static unsigned long shrink_page_list(struct list_head *page_list,
                                      struct list_head *freed_pages_list,
                                        struct scan_control *sc,
                                        enum pageout_io sync_writeback)
{
(snip)
                        switch (pageout(page, mapping, sync_writeback)) {
                        case PAGE_KEEP:
                                goto keep_locked;
                        case PAGE_ACTIVATE:
                                goto activate_locked;
                        case PAGE_SUCCESS:
                                if (PageWriteback(page) || PageDirty(page))
                                        goto keep;                                     ///////  HERE
---------------------------------------------------------------------------------------



> >   - vmscan maintain page granularity lru list. It mean vmscan makes awful
> >     seekful I/O. it assume block-layer buffered much i/o request.
> >   - plus, the above mena vmscan. writeout need good io throughput. otherwise
> >     system might cause hangup.
> > 
> > However, I don't think kswapd_awake is good choice. because
> >   - zone reclaim run before kswapd wakeup. iow, this patch doesn't solve hpc machine.
> >     btw, some Core i7 box (at least, Intel's reference box) also use zone reclaim.
> 
> Good point.
> 
> >   - On large (many memory node) machine, one of much kswapd always run.
> > 
> 
> Also true.
> 
> > 
> > Instead, PF_MEMALLOC is good idea?
> 
> It doesn't work out either because a process with PF_MEMALLOC is in
> direct reclaim and like kswapd, it may not be able to clean the pages at
> all, let alone in a small period of time.

please forget this idea ;)


