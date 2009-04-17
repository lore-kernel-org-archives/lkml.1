Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbZDQAHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbZDQAHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757111AbZDQAGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:06:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54230 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698AbZDQAGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:06:36 -0400
Date: Fri, 17 Apr 2009 09:04:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, menage@google.com,
       balbir@linux.vnet.ibm.com, guijianfeng@cn.fujitsu.com,
       agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, chlunde@ping.uio.no, dave@linux.vnet.ibm.com,
       dpshah@google.com, eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       taka@valinux.co.jp, lizf@cn.fujitsu.com, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] bio-cgroup controller
Message-Id: <20090417090451.5ad9022f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090416104234.GA6656@linux>
References: <1239740480-28125-4-git-send-email-righi.andrea@gmail.com>
	<20090415111528.b796519a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090415093716.GA5968@linux>
	<20090415.213850.226770691.ryov@valinux.co.jp>
	<20090415132356.GA19270@linux>
	<20090416085814.8b6d077f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090416104234.GA6656@linux>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 12:42:36 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:

> On Thu, Apr 16, 2009 at 08:58:14AM +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 15 Apr 2009 15:23:57 +0200
> > Andrea Righi <righi.andrea@gmail.com> wrote:
> > 
> > > On Wed, Apr 15, 2009 at 09:38:50PM +0900, Ryo Tsuruta wrote:
> > > > Hi Andrea and Kamezawa-san,
> > > > 
> > > > > Ryo, it would be great if you can look at this and fix/integrate into
> > > > > the mainstream bio-cgroup. Otherwise I can try to to schedule this in my
> > > > > work.
> > > > 
> > > > O.K. I'll apply those fixes and post patches as soon as I can.
> > > > 
> > > 
> > > Very good! I've just tested the bio_cgroup_id inclusion in
> > > page_cgroup->flags. I'm posting the patch on-top-of my patchset.
> > > 
> > > If you're interested, it should apply cleanly to the original
> > > bio-cgroup, except for the get/put_cgroup_from_page() part.
> > > 
> > > Thanks,
> > > -Andrea
> > > ---
> > > bio-cgroup: encode bio_cgroup_id in page_cgroup->flags
> > > 
> > > Encode the bio_cgroup_id into the flags argument of page_cgroup as
> > > suggested by Kamezawa.
> > > 
> > > Lower 16-bits of the flags attribute are used for the actual page_cgroup
> > > flags. The rest is reserved to store the bio-cgroup id.
> > > 
> > > This allows to save 4 bytes (in 32-bit architectures) or 8 bytes (in
> > > 64-bit) for each page_cgroup element.
> > > 
> > > Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> > > ---
> > >  include/linux/biotrack.h    |    2 +-
> > >  include/linux/page_cgroup.h |   24 +++++++++++++++++++++---
> > >  mm/biotrack.c               |   26 ++++++++++++--------------
> > >  3 files changed, 34 insertions(+), 18 deletions(-)
> > > 
> > > diff --git a/include/linux/biotrack.h b/include/linux/biotrack.h
> > > index 25b8810..4bd0242 100644
> > > --- a/include/linux/biotrack.h
> > > +++ b/include/linux/biotrack.h
> > > @@ -28,7 +28,7 @@ struct bio_cgroup {
> > >  
> > >  static inline void __init_bio_page_cgroup(struct page_cgroup *pc)
> > >  {
> > > -	pc->bio_cgroup_id = 0;
> > > +	page_cgroup_set_bio_id(pc, 0);
> > >  }
> > >  
> > >  extern struct cgroup *get_cgroup_from_page(struct page *page);
> > > diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> > > index 00a49c5..af780a4 100644
> > > --- a/include/linux/page_cgroup.h
> > > +++ b/include/linux/page_cgroup.h
> > > @@ -16,12 +16,30 @@ struct page_cgroup {
> > >  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
> > >  	struct mem_cgroup *mem_cgroup;
> > >  #endif
> > > -#ifdef CONFIG_CGROUP_BIO
> > > -	int bio_cgroup_id;
> > > -#endif
> > >  	struct list_head lru;		/* per cgroup LRU list */
> > >  };
> > >  
> > > +#ifdef CONFIG_CGROUP_BIO
> > > +/*
> > > + * use lower 16 bits for flags and reserve the rest for the bio-cgroup id
> > > + */
> > > +#define BIO_CGROUP_ID_SHIFT	(16)
> > > +#define BIO_CGROUP_ID_BITS (8 * sizeof(unsigned long) - BIO_CGROUP_ID_SHIFT)
> > > +
> > > +static inline unsigned long page_cgroup_get_bio_id(struct page_cgroup *pc)
> > > +{
> > > +	return pc->flags >> BIO_CGROUP_ID_SHIFT;
> > > +}
> > > +
> > > +static inline void page_cgroup_set_bio_id(struct page_cgroup *pc,
> > > +				unsigned long id)
> > > +{
> > > +	WARN_ON(id >= (1UL << BIO_CGROUP_ID_BITS));
> > > +	pc->flags &= (1UL << BIO_CGROUP_ID_SHIFT) - 1;
> > > +	pc->flags |= (unsigned long)(id << BIO_CGROUP_ID_SHIFT);
> > > +}
> > > +#endif
> > > +
> > Ah, there is "Lock" bit in pc->flags and above "set" code does read-modify-write
> > without lock_page_cgroup().
> > 
> > Could you use lock_page_cgroup() or cmpxchg ? (or using something magical technique ?)
> 
> If I'm not wrong this should guarantee atomicity without using
> lock_page_cgroup().

  thread A                      thread B
=================         ======================
                          val = pc->flags
lock_page_cgroup()
                          pc->flags |= hogehoge
unlock_page_cgroup()


*And* we may add another flags to page_cgroup. plz avoid corner cases.

Thanks,
-Kame



