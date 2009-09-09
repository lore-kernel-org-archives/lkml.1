Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbZIIQSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbZIIQSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZIIQSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:18:24 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:28106 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZIIQSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:18:24 -0400
Subject: Re: [rfc] lru_add_drain_all() vs isolation
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <28c262360909090839j626ff818of930cf13a6185123@mail.gmail.com>
References: <alpine.DEB.1.10.0909081110450.30203@V090114053VZO-1>
	 <alpine.DEB.1.10.0909081124240.30203@V090114053VZO-1>
	 <20090909131945.0CF5.A69D9226@jp.fujitsu.com>
	 <28c262360909090839j626ff818of930cf13a6185123@mail.gmail.com>
Content-Type: text/plain
Organization: HP/LKTT
Date: Wed, 09 Sep 2009 12:18:23 -0400
Message-Id: <1252513103.4102.14.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 00:39 +0900, Minchan Kim wrote:
> On Wed, Sep 9, 2009 at 1:27 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> The usefulness of a scheme like this requires:
> >>
> >> 1. There are cpus that continually execute user space code
> >>    without system interaction.
> >>
> >> 2. There are repeated VM activities that require page isolation /
> >>    migration.
> >>
> >> The first page isolation activity will then clear the lru caches of the
> >> processes doing number crunching in user space (and therefore the first
> >> isolation will still interrupt). The second and following isolation will
> >> then no longer interrupt the processes.
> >>
> >> 2. is rare. So the question is if the additional code in the LRU handling
> >> can be justified. If lru handling is not time sensitive then yes.
> >
> > Christoph, I'd like to discuss a bit related (and almost unrelated) thing.
> > I think page migration don't need lru_add_drain_all() as synchronous, because
> > page migration have 10 times retry.
> >
> > Then asynchronous lru_add_drain_all() cause
> >
> >  - if system isn't under heavy pressure, retry succussfull.
> >  - if system is under heavy pressure or RT-thread work busy busy loop, retry failure.
> >
> > I don't think this is problematic bahavior. Also, mlock can use asynchrounous lru drain.
> 
> I think, more exactly, we don't have to drain lru pages for mlocking.
> Mlocked pages will go into unevictable lru due to
> try_to_unmap when shrink of lru happens.
> How about removing draining in case of mlock?
> 
> >
> > What do you think?


Remember how the code works:  __mlock_vma_pages_range() loops calliing
get_user_pages() to fault in batches of 16 pages and returns the page
pointers for mlocking.  Mlocking now requires isolation from the lru.
If you don't drain after each call to get_user_pages(), up to a
pagevec's worth of pages [~14] will likely still be in the pagevec and
won't be isolatable/mlockable().  We can end up with most of the pages
still on the normal lru lists.  If we want to move to an almost
exclusively lazy culling of mlocked pages to the unevictable then we can
remove the drain.  If we want to be more proactive in culling the
unevictable pages as we populate the vma, we'll want to keep the drain.

Lee

