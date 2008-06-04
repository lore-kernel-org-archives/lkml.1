Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbYFDJVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbYFDJVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbYFDJVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:21:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50132 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758714AbYFDJVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:21:01 -0400
Date: Wed, 4 Jun 2008 18:26:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Paul Menage" <menage@google.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][PATCH 2/2] memcg: hardwall hierarhcy for memcg
Message-Id: <20080604182626.fcc26e24.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830806040159w1026003fhe3212beac895927a@mail.gmail.com>
References: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com>
	<20080604140329.8db1b67e.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830806040159w1026003fhe3212beac895927a@mail.gmail.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008 01:59:12 -0700
"Paul Menage" <menage@google.com> wrote:

> On Tue, Jun 3, 2008 at 10:03 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > @@ -792,6 +798,89 @@ int mem_cgroup_shrink_usage(struct mm_st
> >  }
> >
> >  /*
> > + * Memory Controller hierarchy support.
> > + */
> > +
> > +/*
> > + * shrink usage to be res->usage + val < res->limit.
> > + */
> > +
> > +int memcg_shrink_val(struct res_counter *cnt, unsigned long long val)
> > +{
> > +       struct mem_cgroup *memcg = container_of(cnt, struct mem_cgroup, res);
> > +       unsigned long flags;
> > +       int ret = 1;
> > +       int progress = 1;
> > +
> > +retry:
> > +       spin_lock_irqsave(&cnt->lock, flags);
> > +       /* Need to shrink ? */
> > +       if (cnt->usage + val <= cnt->limit)
> > +               ret = 0;
> > +       spin_unlock_irqrestore(&cnt->lock, flags);
> 
> Can't this logic be in res_counter itself? I.e. the callback can
> assume that some shrinking needs to be done, and should just do it and
> return. The res_counter can handle retrying if necessary.
> 
Hmm ok. Maybe All I have to do is to define "What the callback has to do"
and to move this check interface to res_counter.


> > +/*
> > + * For Hard Wall Hierarchy.
> > + */
> > +
> > +int mem_cgroup_resize_callback(struct res_counter *cnt,
> > +                       unsigned long long val, int what)
> > +{
> > +       unsigned long flags, borrow;
> > +       unsigned long long diffs;
> > +       int ret = 0;
> > +
> > +       BUG_ON(what != RES_LIMIT);
> > +
> > +       /* Is this under hierarchy ? */
> > +       if (!cnt->parent) {
> > +               spin_lock_irqsave(&cnt->lock, flags);
> > +               cnt->limit = val;
> > +               spin_unlock_irqrestore(&cnt->lock, flags);
> > +               return 0;
> > +       }
> > +
> > +       spin_lock_irqsave(&cnt->lock, flags);
> > +       if (val > cnt->limit) {
> > +               diffs = val - cnt->limit;
> > +               borrow = 1;
> > +       } else {
> > +               diffs = cnt->limit - val;
> > +               borrow = 0;
> > +       }
> > +       spin_unlock_irqrestore(&cnt->lock, flags);
> > +
> > +       if (borrow)
> > +               ret = res_counter_move_resource(cnt,diffs,
> > +                                       memcg_shrink_val,
> > +                                       MEM_CGROUP_RECLAIM_RETRIES);
> > +       else
> > +               ret = res_counter_return_resource(cnt, diffs,
> > +                                       memcg_shrink_val,
> > +                                       MEM_CGROUP_RECLAIM_RETRIES);
> > +       return ret;
> > +}
> 
> Again, a lot of this function seems like generic logic that should be
> in res_counter. The only bit that's memory specific is the
> memcg_shrink_val, and maybe that could just be passed when creating
> the res_counter. Perhaps we should have a res_counter_ops structure
> with operations like "parse" for parsing strings into numbers
> (currently called "write_strategy") and "reclaim" for trying to shrink
> the usage.
> 
ok, will try.


> > @@ -896,11 +987,44 @@ static ssize_t mem_cgroup_write(struct c
> >                                struct file *file, const char __user *userbuf,
> >                                size_t nbytes, loff_t *ppos)
> >  {
> > -       return res_counter_write(&mem_cgroup_from_cont(cont)->res,
> > +       struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> > +
> > +       if (cft->private != RES_LIMIT
> > +               || !cont->parent
> > +               || memcg->hierarchy_model == MEMCG_NO_HIERARCHY)
> 
> The res_counter already knows whether it has a parent, so these checks
> shouldn't be necessary.
> 
ok, will check in res_counter itself.

> > @@ -1096,6 +1238,12 @@ static void mem_cgroup_destroy(struct cg
> >        int node;
> >        struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
> >
> > +       if (cont->parent &&
> > +           mem->hierarchy_model == MEMCG_HARDWALL_HIERARCHY) {
> > +               /* we did what we can...just returns what we borrow */
> > +               res_counter_return_resource(&mem->res, -1, NULL, 0);
> > +       }
> > +
> 
> Should we also re-account any remaining child usage to the parent?
> 
When this is called, there are no process in this group. Then, remaining
resources in this level is
  - file cache
  - swap cache (if shared)
  - shmem

And the biggest usage will be "file cache".
So, I don't think it's necessary to move child's usage to the parent,
in hurry. But maybe shmem is worth to be moved.

I'd like to revisit this when I implements "usage move at task move"
logic. (currenty, memory usage doesn't move to new cgroup at task_attach.)

It will help me to implement the logic "move remaining usage to the parent"
in clean way.

Thanks,
-Kame









