Return-Path: <linux-kernel-owner+w=401wt.eu-S1752020AbZHSNYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbZHSNYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZHSNYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:24:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:48432 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbZHSNYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:24:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,408,1246863600"; 
   d="scan'208";a="177684099"
Date: Wed, 19 Aug 2009 21:24:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Jeff Dike <jdike@addtoit.com>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090819132420.GA6137@localhost>
References: <20090816051502.GB13740@localhost> <20090816112910.GA3208@localhost> <20090818234310.A64B.A69D9226@jp.fujitsu.com> <20090819120117.GB7306@localhost> <2f11576a0908190505h6da96280xf67c962aa3f5ba07@mail.gmail.com> <20090819121017.GA8226@localhost> <28c262360908190525i6e56ead0mb8dcb01c3d1a69f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28c262360908190525i6e56ead0mb8dcb01c3d1a69f1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 08:25:56PM +0800, Minchan Kim wrote:
> On Wed, Aug 19, 2009 at 9:10 PM, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > On Wed, Aug 19, 2009 at 08:05:19PM +0800, KOSAKI Motohiro wrote:
> >> >> page_referenced_file?
> >> >> I think we should change page_referenced().
> >> >
> >> > Yeah, good catch.
> >> >
> >> >>
> >> >> Instead, How about this?
> >> >> ==============================================
> >> >>
> >> >> Subject: [PATCH] mm: stop circulating of referenced mlocked pages
> >> >>
> >> >> Currently, mlock() systemcall doesn't gurantee to mark the page PG_Mlocked
> >> >
> >> >                                                    mark PG_mlocked
> >> >
> >> >> because some race prevent page grabbing.
> >> >> In that case, instead vmscan move the page to unevictable lru.
> >> >>
> >> >> However, Recently Wu Fengguang pointed out current vmscan logic isn't so
> >> >> efficient.
> >> >> mlocked page can move circulatly active and inactive list because
> >> >> vmscan check the page is referenced _before_ cull mlocked page.
> >> >>
> >> >> Plus, vmscan should mark PG_Mlocked when cull mlocked page.
> >> >
> >> >                           PG_mlocked
> >> >
> >> >> Otherwise vm stastics show strange number.
> >> >>
> >> >> This patch does that.
> >> >
> >> > Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
> >>
> >> Thanks.
> >>
> >>
> >>
> >> >> Index: b/mm/rmap.c
> >> >> ===================================================================
> >> >> --- a/mm/rmap.c       2009-08-18 19:48:14.000000000 +0900
> >> >> +++ b/mm/rmap.c       2009-08-18 23:47:34.000000000 +0900
> >> >> @@ -362,7 +362,9 @@ static int page_referenced_one(struct pa
> >> >>        * unevictable list.
> >> >>        */
> >> >>       if (vma->vm_flags & VM_LOCKED) {
> >> >> -             *mapcount = 1;  /* break early from loop */
> >> >> +             *mapcount = 1;          /* break early from loop */
> >> >> +             *vm_flags |= VM_LOCKED; /* for prevent to move active list */
> >> >
> >> >> +             try_set_page_mlocked(vma, page);
> >> >
> >> > That call is not absolutely necessary?
> >>
> >> Why? I haven't catch your point.
> >
> > Because we'll eventually hit another try_set_page_mlocked() when
> > trying to unmap the page. Ie. duplicated with another call you added
> > in this patch.
> 
> Yes. we don't have to call it and we can make patch simple.
> I already sent patch on yesterday.
> 
> http://marc.info/?l=linux-mm&m=125059325722370&w=2
> 
> I think It's more simple than KOSAKI's idea.
> Is any problem in my patch ?

No, IMHO your patch is simple and good, while KOSAKI's is more
complete :)

- the try_set_page_mlocked() rename is suitable
- the call to try_set_page_mlocked() is necessary on try_to_unmap()
- the "if (VM_LOCKED) referenced = 0" in page_referenced() could
  cover both active/inactive vmscan

I did like your proposed

                if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
-                                       referenced && page_mapping_inuse(page))
+                                       referenced && page_mapping_inuse(page)
+                                       && !(vm_flags & VM_LOCKED))
                        goto activate_locked;

which looks more intuitive and less confusing.

Thanks,
Fengguang
