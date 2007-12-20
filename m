Return-Path: <linux-kernel-owner+w=401wt.eu-S1758849AbXLTBMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849AbXLTBMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755719AbXLTBMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:12:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39370 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513AbXLTBM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:12:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Miles Lane" <miles.lane@gmail.com>
Subject: Re: 2.6.24-rc5-mm1 -- inconsistent {in-hardirq-W} -> {hardirq-on-W} usage -- pm-hibernate/9940 [HC0[0]:SC0[0]:HE1:SE1]
Date: Thu, 20 Dec 2007 02:31:55 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Daniel Walker" <dwalker@mvista.com>, "Pavel Machek" <pavel@suse.cz>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <a44ae5cd0712190517t7c80e15bv759fa5486dfca234@mail.gmail.com> <200712200109.20452.rjw@sisk.pl> <a44ae5cd0712191709y25a454bfq427e9bc3b644fcf3@mail.gmail.com>
In-Reply-To: <a44ae5cd0712191709y25a454bfq427e9bc3b644fcf3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200231.56128.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 20 of December 2007, Miles Lane wrote:
> On Dec 19, 2007 7:09 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Thursday, 20 of December 2007, Christoph Lameter wrote:
> > > On Thu, 20 Dec 2007, Rafael J. Wysocki wrote:
> > >
> > > > > We could reexport drain_local_pages() again but then I do not
> > understand
> > > > > why we would only drain the pages of this processor and not of all
> > other
> > > > > processors as well. It seems that software suspend intend was to
> > flush
> > > > > them all right?
> > > >
> > > > Well, not exactly.  We are on one CPU at this point, the others have
> > been
> > > > disabled.
> > >
> > > Ok so the others are flush. Here is a patch to re-export
> > > drain_local_pages() again and use it for software suspend:
> > >
> > > Signed-off-by: Christoph Lameter <clameter@sgi.com>
> > >
> > > ---
> > >  include/linux/gfp.h     |    1 +
> > >  kernel/power/snapshot.c |    2 +-
> > >  mm/page_alloc.c         |    2 +-
> > >  3 files changed, 3 insertions(+), 2 deletions(-)
> > >
> > > Index: linux-2.6.24-rc5-mm1/kernel/power/snapshot.c
> > > ===================================================================
> > > --- linux-2.6.24-rc5-mm1.orig/kernel/power/snapshot.c 2007-12-19 11:59:
> > 25.233961700 -0800
> > > +++ linux-2.6.24-rc5-mm1/kernel/power/snapshot.c      2007-12-19 15:16:
> > 34.179661929 -0800
> > > @@ -1203,7 +1203,7 @@ asmlinkage int swsusp_save(void)
> > >
> > >       printk(KERN_INFO "PM: Creating hibernation image: \n");
> > >
> > > -     drain_all_pages();
> > > +     drain_local_pages(NULL);
> > >       nr_pages = count_data_pages();
> > >       nr_highmem = count_highmem_pages();
> > >       printk(KERN_INFO "PM: Need to copy %u pages\n", nr_pages +
> > nr_highmem);
> >
> > You've omitted the second instance, right before the copy_data_pages()
> > call.
> >
> 
> I guess I will wait for a revised patch.

There's an Andrew's fix on top of this one in -mm:
http://marc.info/?l=linux-mm-commits&m=119810866812965&w=2


> > > Index: linux-2.6.24-rc5-mm1/mm/page_alloc.c
> > > ===================================================================
> > > --- linux-2.6.24-rc5-mm1.orig/mm/page_alloc.c 2007-12-19 12:01:
> > 00.630421258 -0800
> > > +++ linux-2.6.24-rc5-mm1/mm/page_alloc.c      2007-12-19 15:12:
> > 19.850545818 -0800
> > > @@ -930,7 +930,7 @@ static void drain_pages(unsigned int cpu
> > >  /*
> > >   * Spill all of this CPU's per-cpu pages back into the buddy allocator.
> > >   */
> > > -static void drain_local_pages(void *arg)
> > > +void drain_local_pages(void *arg)
> > >  {
> > >       drain_pages(smp_processor_id());
> > >  }
> > > Index: linux-2.6.24-rc5-mm1/include/linux/gfp.h
> > > ===================================================================
> > > --- linux-2.6.24-rc5-mm1.orig/include/linux/gfp.h     2007-12-19 15:13:
> > 51.926950065 -0800
> > > +++ linux-2.6.24-rc5-mm1/include/linux/gfp.h  2007-12-19 15:16:
> > 11.951564369 -0800
> > > @@ -229,5 +229,6 @@ extern void FASTCALL(free_cold_page(stru
> > >  void page_alloc_init(void);
> > >  void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
> > >  void drain_all_pages(void);
> > > +void drain_local_pages(void *dummy);
> > >
> > >  #endif /* __LINUX_GFP_H */
> >
