Return-Path: <linux-kernel-owner+w=401wt.eu-S934170AbZLOX43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170AbZLOX43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934097AbZLOX4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:56:25 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43446 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934133AbZLOX4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:56:20 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Dec 2009 08:53:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       cl@linux-foundation.org, Lee.Schermerhorn@hp.com
Subject: Re: [mmotm][PATCH 1/5] clean up mm_counter
Message-Id: <20091216085305.d7b46376.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091216082529.8fc0d3c4.minchan.kim@barrios-desktop>
References: <20091215180904.c307629f.kamezawa.hiroyu@jp.fujitsu.com>
	<20091215181116.ee2c31f7.kamezawa.hiroyu@jp.fujitsu.com>
	<20091216082529.8fc0d3c4.minchan.kim@barrios-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 08:25:29 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Tue, 15 Dec 2009 18:11:16 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Now, per-mm statistics counter is defined by macro in sched.h
> > 
> > This patch modifies it to
> >   - defined in mm.h as inlinf functions
> >   - use array instead of macro's name creation.
> > 
> > This patch is for reducing patch size in future patch to modify
> > implementation of per-mm counter.
> > 
> > Changelog: 2009/12/14
> >  - added a struct rss_stat instead of bare counters.
> >  - use memset instead of for() loop.
> >  - rewrite macros into static inline functions.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  fs/proc/task_mmu.c       |    4 -
> >  include/linux/mm.h       |  104 +++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mm_types.h |   33 +++++++++-----
> >  include/linux/sched.h    |   54 ------------------------
> >  kernel/fork.c            |    3 -
> >  kernel/tsacct.c          |    1 
> >  mm/filemap_xip.c         |    2 
> >  mm/fremap.c              |    2 
> >  mm/memory.c              |   56 +++++++++++++++----------
> >  mm/oom_kill.c            |    4 -
> >  mm/rmap.c                |   10 ++--
> >  mm/swapfile.c            |    2 
> >  12 files changed, 174 insertions(+), 101 deletions(-)
> > 
> > Index: mmotm-2.6.32-Dec8-pth/include/linux/mm.h
> > ===================================================================
> > --- mmotm-2.6.32-Dec8-pth.orig/include/linux/mm.h
> > +++ mmotm-2.6.32-Dec8-pth/include/linux/mm.h
> > @@ -868,6 +868,110 @@ extern int mprotect_fixup(struct vm_area
> >   */
> >  int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
> >  			  struct page **pages);
> > +/*
> > + * per-process(per-mm_struct) statistics.
> > + */
> > +#if USE_SPLIT_PTLOCKS
> > +/*
> > + * The mm counters are not protected by its page_table_lock,
> > + * so must be incremented atomically.
> > + */
> > +static inline void set_mm_counter(struct mm_struct *mm, int member, long value)
> > +{
> > +	atomic_long_set(&mm->rss_stat.count[member], value);
> > +}
> 
> I can't find mm->rss_stat in this patch.
> Maybe it's part of next patch. 

It's in mm_types.h

@@ -223,11 +233,6 @@ struct mm_struct {
 						 * by mmlist_lock
 						 */
 
-	/* Special counters, in some configurations protected by the
-	 * page_table_lock, in other configurations by being atomic.
-	 */
-	mm_counter_t _file_rss;
-	mm_counter_t _anon_rss;
 
 	unsigned long hiwater_rss;	/* High-watermark of RSS usage */
 	unsigned long hiwater_vm;	/* High-water virtual memory usage */
@@ -240,6 +245,12 @@ struct mm_struct {
 
 	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
+	/*
+	 * Special counters, in some configurations protected by the
+	 * page_table_lock, in other configurations by being atomic.
+	 */
+	struct mm_rss_stat rss_stat;
+
 	struct linux_binfmt *binfmt;

Moved to some bytes higher address for avoiding false sharing storm
of mmap_sem..


> Otherwise, Looks good to me. 
> 
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 

Thank you for all your help for this series.

Regards,
-Kame

