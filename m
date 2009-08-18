Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbZHRQ3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbZHRQ3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758760AbZHRQ3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:29:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58648 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757231AbZHRQ3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:29:39 -0400
Date: Wed, 19 Aug 2009 01:27:57 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>, Jeff Dike <jdike@addtoit.com>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20090818111125.GA20217@localhost>
References: <28c262360908180400q361ea322o8959fd5ea5ae3217@mail.gmail.com> <20090818111125.GA20217@localhost>
Message-Id: <20090819012330.A659.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Aug 18, 2009 at 07:00:48PM +0800, Minchan Kim wrote:
> > On Tue, Aug 18, 2009 at 7:00 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > > On Tue, Aug 18, 2009 at 05:52:47PM +0800, Minchan Kim wrote:
> > >> On Tue, 18 Aug 2009 17:31:19 +0800
> > >> Wu Fengguang <fengguang.wu@intel.com> wrote:
> > >>
> > >> > On Tue, Aug 18, 2009 at 12:17:34PM +0800, Minchan Kim wrote:
> > >> > > On Tue, 18 Aug 2009 10:34:38 +0800
> > >> > > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > >> > >
> > >> > > > Minchan,
> > >> > > >
> > >> > > > On Mon, Aug 17, 2009 at 10:33:54PM +0800, Minchan Kim wrote:
> > >> > > > > On Sun, Aug 16, 2009 at 8:29 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > >> > > > > > On Sun, Aug 16, 2009 at 01:15:02PM +0800, Wu Fengguang wrote:
> > >> > > > > >> On Sun, Aug 16, 2009 at 11:53:00AM +0800, Rik van Riel wrote:
> > >> > > > > >> > Wu Fengguang wrote:
> > >> > > > > >> > > On Fri, Aug 07, 2009 at 05:09:55AM +0800, Jeff Dike wrote:
> > >> > > > > >> > >> Side question -
> > >> > > > > >> > >>  Is there a good reason for this to be in shrink_active_list()
> > >> > > > > >> > >> as opposed to __isolate_lru_page?
> > >> > > > > >> > >>
> > >> > > > > >> > >>          if (unlikely(!page_evictable(page, NULL))) {
> > >> > > > > >> > >>                  putback_lru_page(page);
> > >> > > > > >> > >>                  continue;
> > >> > > > > >> > >>          }
> > >> > > > > >> > >>
> > >> > > > > >> > >> Maybe we want to minimize the amount of code under the lru lock or
> > >> > > > > >> > >> avoid duplicate logic in the isolate_page functions.
> > >> > > > > >> > >
> > >> > > > > >> > > I guess the quick test means to avoid the expensive page_referenced()
> > >> > > > > >> > > call that follows it. But that should be mostly one shot cost - the
> > >> > > > > >> > > unevictable pages are unlikely to cycle in active/inactive list again
> > >> > > > > >> > > and again.
> > >> > > > > >> >
> > >> > > > > >> > Please read what putback_lru_page does.
> > >> > > > > >> >
> > >> > > > > >> > It moves the page onto the unevictable list, so that
> > >> > > > > >> > it will not end up in this scan again.
> > >> > > > > >>
> > >> > > > > >> Yes it does. I said 'mostly' because there is a small hole that an
> > >> > > > > >> unevictable page may be scanned but still not moved to unevictable
> > >> > > > > >> list: when a page is mapped in two places, the first pte has the
> > >> > > > > >> referenced bit set, the _second_ VMA has VM_LOCKED bit set, then
> > >> > > > > >> page_referenced() will return 1 and shrink_page_list() will move it
> > >> > > > > >> into active list instead of unevictable list. Shall we fix this rare
> > >> > > > > >> case?
> > >> > > > >
> > >> > > > > I think it's not a big deal.
> > >> > > >
> > >> > > > Maybe, otherwise I should bring up this issue long time before :)
> > >> > > >
> > >> > > > > As you mentioned, it's rare case so there would be few pages in active
> > >> > > > > list instead of unevictable list.
> > >> > > >
> > >> > > > Yes.
> > >> > > >
> > >> > > > > When next time to scan comes, we can try to move the pages into
> > >> > > > > unevictable list, again.
> > >> > > >
> > >> > > > Will PG_mlocked be set by then? Otherwise the situation is not likely
> > >> > > > to change and the VM_LOCKED pages may circulate in active/inactive
> > >> > > > list for countless times.
> > >> > >
> > >> > > PG_mlocked is not important in that case.
> > >> > > Important thing is VM_LOCKED vma.
> > >> > > I think below annotaion can help you to understand my point. :)
> > >> >
> > >> > Hmm, it looks like pages under VM_LOCKED vma is guaranteed to have
> > >> > PG_mlocked set, and so will be caught by page_evictable(). Is it?
> > >>
> > >> No. I am sorry for making my point not clear.
> > >> I meant following as.
> > >> When the next time to scan,
> > >>
> > >> shrink_page_list
> > >  ->
> > >                referenced = page_referenced(page, 1,
> > >                                                sc->mem_cgroup, &vm_flags);
> > >                /* In active use or really unfreeable?  Activate it. */
> > >                if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
> > >                                        referenced && page_mapping_inuse(page))
> > >                        goto activate_locked;
> > >
> > >> -> try_to_unmap
> > >     ~~~~~~~~~~~~ this line won't be reached if page is found to be
> > >     referenced in the above lines?
> > 
> > Indeed! In fact, I was worry about that.
> > It looks after live lock problem.
> > But I think  it's very small race window so  there isn't any report until now.
> > Let's Cced Lee.
> > 
> > If we have to fix it, how about this ?
> > This version  has small overhead than yours since
> > there is less shrink_page_list call than page_referenced.
> 
> Yeah, it looks better. However I still wonder if (VM_LOCKED && !PG_mlocked)
> is possible and somehow persistent. Does anyone have the answer? Thanks!

hehe, that's bug. you spotted very good thing IMHO ;)
I posted fixed patch. can you see it?



