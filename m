Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbZESHpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbZESHpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 03:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZESHox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 03:44:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39010 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZESHow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 03:44:52 -0400
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first
 class  citizen
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
In-Reply-To: <84144f020905182339o5fb1e78eved95c4c20fd9ffa7@mail.gmail.com>
References: <20090516090005.916779788@intel.com>
	 <20090516090448.410032840@intel.com>
	 <84144f020905182339o5fb1e78eved95c4c20fd9ffa7@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 19 May 2009 09:44:23 +0200
Message-Id: <1242719063.26820.457.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-19 at 09:39 +0300, Pekka Enberg wrote:
> Hi!
> 
> On Sat, May 16, 2009 at 12:00 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > @@ -1272,28 +1273,40 @@ static void shrink_active_list(unsigned
> >
> >                /* page_referenced clears PageReferenced */
> >                if (page_mapping_inuse(page) &&
> > -                   page_referenced(page, 0, sc->mem_cgroup, &vm_flags))
> > +                   page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
> >                        pgmoved++;
> > +                       /*
> > +                        * Identify referenced, file-backed active pages and
> > +                        * give them one more trip around the active list. So
> > +                        * that executable code get better chances to stay in
> > +                        * memory under moderate memory pressure.  Anon pages
> > +                        * are ignored, since JVM can create lots of anon
> > +                        * VM_EXEC pages.
> > +                        */
> > +                       if ((vm_flags & VM_EXEC) && !PageAnon(page)) {
> > +                               list_add(&page->lru, &l_active);
> > +                               continue;
> > +                       }
> 
> Why do we need to skip JIT'd code? There are plenty of desktop
> applications that use Mono, for example, and it would be nice if we
> gave them the same treatment as native applications. Likewise, I am
> sure all browsers that use JIT for JavaScript need to be considered.

Its a sekrit conspiracy against bloat by making JIT'd crap run
slower :-)

<rant>
Anyway, I just checked, we install tons of mono junk for _2_
applications, f-spot and tomboy, both are shite and both have
alternatives not requiring this disease.
</rant>

But seriously, like Kosaka-san already said, anonymous pages are treated
differently from file pages and should not suffer the same problems.
