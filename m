Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZHRCem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZHRCem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 22:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZHRCel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 22:34:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:17447 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbZHRCel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 22:34:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,399,1246863600"; 
   d="scan'208";a="176831820"
Date: Tue, 18 Aug 2009 10:34:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Jeff Dike <jdike@addtoit.com>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090818023438.GB7958@localhost>
References: <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost> <4A7AC201.4010202@redhat.com> <20090806130631.GB6162@localhost> <20090806210955.GA14201@c2.user-mode-linux.org> <20090816031827.GA6888@localhost> <4A87829C.4090908@redhat.com> <20090816051502.GB13740@localhost> <20090816112910.GA3208@localhost> <28c262360908170733q4bc5ddb8ob2fc976b6a468d6e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28c262360908170733q4bc5ddb8ob2fc976b6a468d6e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan,

On Mon, Aug 17, 2009 at 10:33:54PM +0800, Minchan Kim wrote:
> On Sun, Aug 16, 2009 at 8:29 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > On Sun, Aug 16, 2009 at 01:15:02PM +0800, Wu Fengguang wrote:
> >> On Sun, Aug 16, 2009 at 11:53:00AM +0800, Rik van Riel wrote:
> >> > Wu Fengguang wrote:
> >> > > On Fri, Aug 07, 2009 at 05:09:55AM +0800, Jeff Dike wrote:
> >> > >> Side question -
> >> > >>  Is there a good reason for this to be in shrink_active_list()
> >> > >> as opposed to __isolate_lru_page?
> >> > >>
> >> > >>          if (unlikely(!page_evictable(page, NULL))) {
> >> > >>                  putback_lru_page(page);
> >> > >>                  continue;
> >> > >>          }
> >> > >>
> >> > >> Maybe we want to minimize the amount of code under the lru lock or
> >> > >> avoid duplicate logic in the isolate_page functions.
> >> > >
> >> > > I guess the quick test means to avoid the expensive page_referenced()
> >> > > call that follows it. But that should be mostly one shot cost - the
> >> > > unevictable pages are unlikely to cycle in active/inactive list again
> >> > > and again.
> >> >
> >> > Please read what putback_lru_page does.
> >> >
> >> > It moves the page onto the unevictable list, so that
> >> > it will not end up in this scan again.
> >>
> >> Yes it does. I said 'mostly' because there is a small hole that an
> >> unevictable page may be scanned but still not moved to unevictable
> >> list: when a page is mapped in two places, the first pte has the
> >> referenced bit set, the _second_ VMA has VM_LOCKED bit set, then
> >> page_referenced() will return 1 and shrink_page_list() will move it
> >> into active list instead of unevictable list. Shall we fix this rare
> >> case?
> 
> I think it's not a big deal.

Maybe, otherwise I should bring up this issue long time before :)

> As you mentioned, it's rare case so there would be few pages in active
> list instead of unevictable list.

Yes.

> When next time to scan comes, we can try to move the pages into
> unevictable list, again.

Will PG_mlocked be set by then? Otherwise the situation is not likely 
to change and the VM_LOCKED pages may circulate in active/inactive
list for countless times.

> As I know about mlock pages, we already had some races condition.
> They will be rescued like above.

Thanks,
Fengguang

> >
> > How about this fix?
> >
> > ---
> > mm: stop circulating of referenced mlocked pages
> >
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >
> > --- linux.orig/mm/rmap.c        2009-08-16 19:11:13.000000000 +0800
> > +++ linux/mm/rmap.c     2009-08-16 19:22:46.000000000 +0800
> > @@ -358,6 +358,7 @@ static int page_referenced_one(struct pa
> >         */
> >        if (vma->vm_flags & VM_LOCKED) {
> >                *mapcount = 1;  /* break early from loop */
> > +               *vm_flags |= VM_LOCKED;
> >                goto out_unmap;
> >        }
> >
> > @@ -482,6 +483,8 @@ static int page_referenced_file(struct p
> >        }
> >
> >        spin_unlock(&mapping->i_mmap_lock);
> > +       if (*vm_flags & VM_LOCKED)
> > +               referenced = 0;
> >        return referenced;
> >  }
> >
> >
> > --
> > To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > the body to majordomo@kvack.org.  For more info on Linux MM,
> > see: http://www.linux-mm.org/ .
> > Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> >
> 
> 
> 
> -- 
> Kind regards,
> Minchan Kim
