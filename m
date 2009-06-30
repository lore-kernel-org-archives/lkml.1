Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbZF3JYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbZF3JYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 05:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZF3JYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 05:24:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49820 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbZF3JYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 05:24:37 -0400
Date: Tue, 30 Jun 2009 18:23:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH 2/2] cgroup: exlclude release rmdir
Message-Id: <20090630182304.8049039c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830906300215q56bda5ccnc99862211dc65289@mail.gmail.com>
References: <20090630180109.f137c10e.kamezawa.hiroyu@jp.fujitsu.com>
	<20090630180344.d7274644.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830906300215q56bda5ccnc99862211dc65289@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009 02:15:03 -0700
Paul Menage <menage@google.com> wrote:

> On Tue, Jun 30, 2009 at 2:03 AM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > Paul Menage pointed out that css_get()/put() only for avoiding race with
> > rmdir() is complicated and these should be treated as it is for.
> >
> > This adds
> >   - cgroup_exclude_rmdir() ....prevent rmdir() for a while.
> >   - cgroup_release_rmdir() ....rerun rmdir() if necessary.
> > And hides cgroup_wakeup_rmdir_waiter() into kernel/cgroup.c, again.
> 
> Wouldn't it be better to merge these into a single patch? Having one
> patch that exposes complexity only to take it away in the following
> patch seems unnecessary; the combined patch would be simpler than the
> constituents.
> 
This patch is _not_ tested by Nishimura.
What I want is patch 1/2, it's BUGFIX and passed tests by him.
I trust his test very much.
I want the patch 1/2 should be on fast-path as BUGFIX.

But, I think this patch 2/2 is not for fast-path.
This is something new but just a refactoring.

Anyway, I can postpone this until things are settled. Only merging patch 1/2
is okay for me now.

Thanks,
-Kame


> Paul
> 
> >
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >
> > ---
> >  include/linux/cgroup.h |   21 +++++++++++----------
> >  kernel/cgroup.c        |   17 +++++++++++++++--
> >  mm/memcontrol.c        |   12 ++++--------
> >  3 files changed, 30 insertions(+), 20 deletions(-)
> >
> > Index: mmotm-2.6.31-Jun25/include/linux/cgroup.h
> > ===================================================================
> > --- mmotm-2.6.31-Jun25.orig/include/linux/cgroup.h
> > +++ mmotm-2.6.31-Jun25/include/linux/cgroup.h
> > @@ -366,17 +366,18 @@ int cgroup_task_count(const struct cgrou
> >  int cgroup_is_descendant(const struct cgroup *cgrp, struct task_struct *task);
> >
> >  /*
> > - * Allow to use CGRP_WAIT_ON_RMDIR flag to check race with rmdir() for subsys.
> > - * Subsys can call this function if it's necessary to call pre_destroy() again
> > - * because it adds not-temporary refs to css after or while pre_destroy().
> > - * The caller of this function should use css_tryget(), too.
> > + * When the subsys has to access css and may add permanent refcnt to css,
> > + * it should take care of racy conditions with rmdir(). Following set of
> > + * functions, is for stop/restart rmdir if necessary.
> > + * Because these will call css_get/put, "css" should be alive css.
> > + *
> > + *  cgroup_exclude_rmdir();
> > + *  ...do some jobs which may access arbitrary empty cgroup
> > + *  cgroup_release_rmdir();
> >  */
> > -void __cgroup_wakeup_rmdir_waiters(void);
> > -static inline void cgroup_wakeup_rmdir_waiter(struct cgroup *cgrp)
> > -{
> > -       if (unlikely(test_and_clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags)))
> > -               __cgroup_wakeup_rmdir_waiters();
> > -}
> > +
> > +void cgroup_exclude_rmdir(struct cgroup_subsys_state *css);
> > +void cgroup_release_rmdir(struct cgroup_subsys_state *css);
> >
> >  /*
> >  * Control Group subsystem type.
> > Index: mmotm-2.6.31-Jun25/kernel/cgroup.c
> > ===================================================================
> > --- mmotm-2.6.31-Jun25.orig/kernel/cgroup.c
> > +++ mmotm-2.6.31-Jun25/kernel/cgroup.c
> > @@ -738,11 +738,24 @@ static void cgroup_d_remove_dir(struct d
> >  */
> >  DECLARE_WAIT_QUEUE_HEAD(cgroup_rmdir_waitq);
> >
> > -void __cgroup_wakeup_rmdir_waiters(void)
> > +static void cgroup_wakeup_rmdir_waiter(struct cgroup *cgrp)
> >  {
> > -       wake_up_all(&cgroup_rmdir_waitq);
> > +       if (unlikely(test_and_clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags)))
> > +               wake_up_all(&cgroup_rmdir_waitq);
> >  }
> >
> > +void cgroup_exclude_rmdir(struct cgroup_subsys_state *css)
> > +{
> > +       css_get(css);
> > +}
> > +
> > +void cgroup_release_rmdir(struct cgroup_subsys_state *css)
> > +{
> > +       cgroup_wakeup_rmdir_waiter(css->cgroup);
> > +       css_put(css);
> > +}
> > +
> > +
> >  static int rebind_subsystems(struct cgroupfs_root *root,
> >                              unsigned long final_bits)
> >  {
> > Index: mmotm-2.6.31-Jun25/mm/memcontrol.c
> > ===================================================================
> > --- mmotm-2.6.31-Jun25.orig/mm/memcontrol.c
> > +++ mmotm-2.6.31-Jun25/mm/memcontrol.c
> > @@ -1461,7 +1461,7 @@ __mem_cgroup_commit_charge_swapin(struct
> >                return;
> >        if (!ptr)
> >                return;
> > -       css_get(&ptr->css);
> > +       cgroup_exclude_rmdir(&ptr->css);
> >        pc = lookup_page_cgroup(page);
> >        mem_cgroup_lru_del_before_commit_swapcache(page);
> >        __mem_cgroup_commit_charge(ptr, pc, ctype);
> > @@ -1496,9 +1496,7 @@ __mem_cgroup_commit_charge_swapin(struct
> >         * So, rmdir()->pre_destroy() can be called while we do this charge.
> >         * In that case, we need to call pre_destroy() again. check it here.
> >         */
> > -       cgroup_wakeup_rmdir_waiter(ptr->css.cgroup);
> > -       css_put(&ptr->css);
> > -
> > +       cgroup_release_rmdir(&ptr->css);
> >  }
> >
> >  void mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr)
> > @@ -1704,7 +1702,7 @@ void mem_cgroup_end_migration(struct mem
> >
> >        if (!mem)
> >                return;
> > -       css_get(&mem->css);
> > +       cgroup_exclude_rmdir(&mem->css);
> >        /* at migration success, oldpage->mapping is NULL. */
> >        if (oldpage->mapping) {
> >                target = oldpage;
> > @@ -1749,9 +1747,7 @@ void mem_cgroup_end_migration(struct mem
> >         * So, rmdir()->pre_destroy() can be called while we do this charge.
> >         * In that case, we need to call pre_destroy() again. check it here.
> >         */
> > -       cgroup_wakeup_rmdir_waiter(mem->css.cgroup);
> > -       css_put(&mem->css);
> > -
> > +       cgroup_release_rmdir(&mem->css);
> >  }
> >
> >  /*
> >
> >
> 

