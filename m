Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbYCYPsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbYCYPsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756058AbYCYPsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:48:04 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:59785 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbYCYPsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:48:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=IPmZdJ6sBPEMqjE13fL4kh4w+1vo3N5EF54KsXc0n+gJfDfbuhVcjpgkV3sc59BIgResDo/4/GPBmGZ2Pc9qPo7byud1QefyJ4V0bqtLB0b6l/31d0onwtEDyPl6p+taNZ8RwflAJ5y+JEkzVNJPiRjm535wJFzP6aaLLwbXgBE=
Message-ID: <661de9470803250848p1ead8571ibfbe6e1196da8a89@mail.gmail.com>
Date: Tue, 25 Mar 2008 21:18:00 +0530
From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [RFC][-mm] Memory controller add mm->owner
Cc: linux-mm@kvack.org, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Paul Menage" <menage@google.com>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, "David Rientjes" <rientjes@google.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47E854CD.1090105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080324140142.28786.97267.sendpatchset@localhost.localdomain>
	 <47E854CD.1090105@cn.fujitsu.com>
X-Google-Sender-Auth: 3b843a0ccc0fd0fa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 6:56 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> Balbir Singh wrote:
>  > This patch removes the mem_cgroup member from mm_struct and instead adds
>  > an owner. This approach was suggested by Paul Menage. The advantage of
>  > this approach is that, once the mm->owner is known, using the subsystem
>  > id, the cgroup can be determined. It also allows several control groups
>  > that are virtually grouped by mm_struct, to exist independent of the memory
>  > controller i.e., without adding mem_cgroup's for each controller,
>  > to mm_struct.
>  >
>  > The code initially assigns mm->owner to the task and then after the
>  > thread group leader is identified. The mm->owner is changed to the thread
>  > group leader of the task later at the end of copy_process.
>  >
>  > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>  > ---
>  >
>  >  include/linux/memcontrol.h |   14 +++++++++++++-
>  >  include/linux/mm_types.h   |    5 ++++-
>  >  kernel/fork.c              |    4 ++++
>  >  mm/memcontrol.c            |   42 ++++++++++++++++++++++++++++++++++--------
>  >  4 files changed, 55 insertions(+), 10 deletions(-)
>  >
>  > diff -puN include/linux/mm_types.h~memory-controller-add-mm-owner include/linux/mm_types.h
>  > --- linux-2.6.25-rc5/include/linux/mm_types.h~memory-controller-add-mm-owner  2008-03-20 13:35:09.000000000 +0530
>  > +++ linux-2.6.25-rc5-balbir/include/linux/mm_types.h  2008-03-20 15:11:05.000000000 +0530
>  > @@ -228,7 +228,10 @@ struct mm_struct {
>  >       rwlock_t                ioctx_list_lock;
>  >       struct kioctx           *ioctx_list;
>  >  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
>  > -     struct mem_cgroup *mem_cgroup;
>  > +     struct task_struct *owner;      /* The thread group leader that */
>  > +                                     /* owns the mm_struct. This     */
>  > +                                     /* might be useful even outside */
>  > +                                     /* of the config option         */
>  >  #endif
>  >
>  >  #ifdef CONFIG_PROC_FS
>  > diff -puN kernel/fork.c~memory-controller-add-mm-owner kernel/fork.c
>  > --- linux-2.6.25-rc5/kernel/fork.c~memory-controller-add-mm-owner     2008-03-20 13:35:09.000000000 +0530
>  > +++ linux-2.6.25-rc5-balbir/kernel/fork.c     2008-03-24 18:49:29.000000000 +0530
>  > @@ -1357,6 +1357,10 @@ static struct task_struct *copy_process(
>  >       write_unlock_irq(&tasklist_lock);
>  >       proc_fork_connector(p);
>  >       cgroup_post_fork(p);
>  > +
>  > +     if (!(clone_flags & CLONE_VM))
>  > +             mem_cgroup_fork_init(p);
>  > +
>  >       return p;
>  >
>  >  bad_fork_free_pid:
>  > diff -puN include/linux/memcontrol.h~memory-controller-add-mm-owner include/linux/memcontrol.h
>  > --- linux-2.6.25-rc5/include/linux/memcontrol.h~memory-controller-add-mm-owner        2008-03-20 13:35:09.000000000 +0530
>  > +++ linux-2.6.25-rc5-balbir/include/linux/memcontrol.h        2008-03-24 18:49:52.000000000 +0530
>  > @@ -29,6 +29,7 @@ struct mm_struct;
>  >
>  >  extern void mm_init_cgroup(struct mm_struct *mm, struct task_struct *p);
>  >  extern void mm_free_cgroup(struct mm_struct *mm);
>  > +extern void mem_cgroup_fork_init(struct task_struct *p);
>  >
>  >  #define page_reset_bad_cgroup(page)  ((page)->page_cgroup = 0)
>  >
>  > @@ -49,7 +50,7 @@ extern void mem_cgroup_out_of_memory(str
>  >  int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
>  >
>  >  #define mm_match_cgroup(mm, cgroup)  \
>  > -     ((cgroup) == rcu_dereference((mm)->mem_cgroup))
>  > +     ((cgroup) == mem_cgroup_from_task((mm)->owner))
>  >
>  >  extern int mem_cgroup_prepare_migration(struct page *page);
>  >  extern void mem_cgroup_end_migration(struct page *page);
>  > @@ -72,6 +73,8 @@ extern long mem_cgroup_calc_reclaim_acti
>  >  extern long mem_cgroup_calc_reclaim_inactive(struct mem_cgroup *mem,
>  >                               struct zone *zone, int priority);
>  >
>  > +extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
>  > +
>  >  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
>  >  static inline void mm_init_cgroup(struct mm_struct *mm,
>  >                                       struct task_struct *p)
>  > @@ -82,6 +85,10 @@ static inline void mm_free_cgroup(struct
>  >  {
>  >  }
>  >
>  > +static inline void mem_cgroup_fork_init(struct task_struct *p)
>  > +{
>  > +}
>  > +
>  >  static inline void page_reset_bad_cgroup(struct page *page)
>  >  {
>  >  }
>  > @@ -172,6 +179,11 @@ static inline long mem_cgroup_calc_recla
>  >  {
>  >       return 0;
>  >  }
>  > +
>  > +static void mm_free_fork_cgroup(struct task_struct *p)
>  > +{
>  > +}
>  > +
>
>  Where is this function used? I don't see the corresponding one
>  with CONFIG_CGROUP_MEM_RES_CTLR enabled?
>

I kept that as a template for freeing up code. I'll remove that since
it is additional code

>
>  >  #endif /* CONFIG_CGROUP_MEM_CONT */
>  >
>  >  #endif /* _LINUX_MEMCONTROL_H */
>  > diff -puN mm/memcontrol.c~memory-controller-add-mm-owner mm/memcontrol.c
>  > --- linux-2.6.25-rc5/mm/memcontrol.c~memory-controller-add-mm-owner   2008-03-20 13:35:09.000000000 +0530
>  > +++ linux-2.6.25-rc5-balbir/mm/memcontrol.c   2008-03-24 19:04:32.000000000 +0530
>  > @@ -236,7 +236,7 @@ static struct mem_cgroup *mem_cgroup_fro
>  >                               css);
>  >  }
>  >
>  > -static struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
>  > +struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
>  >  {
>  >       return container_of(task_subsys_state(p, mem_cgroup_subsys_id),
>  >                               struct mem_cgroup, css);
>  > @@ -248,12 +248,40 @@ void mm_init_cgroup(struct mm_struct *mm
>  >
>  >       mem = mem_cgroup_from_task(p);
>  >       css_get(&mem->css);
>  > -     mm->mem_cgroup = mem;
>  > +     mm->owner = p;
>  > +}
>  > +
>  > +void mem_cgroup_fork_init(struct task_struct *p)
>  > +{
>  > +     struct mm_struct *mm = get_task_mm(p);
>  > +     struct mem_cgroup *mem, *oldmem;
>
>  Leave an empty line here.
>

OK


Thanks for the review
Balbir
