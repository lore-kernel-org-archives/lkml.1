Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0CKX6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 18:58:17 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42050 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab0CKX6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 18:58:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 12 Mar 2010 08:54:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 2/3] memcg: oom notifier
Message-Id: <20100312085438.98c5fcc4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <cc557aab1003110647q1b70c9a0j73867c2c33dd28ce@mail.gmail.com>
References: <20100311165315.c282d6d2.kamezawa.hiroyu@jp.fujitsu.com>
	<20100311165700.4468ef2a.kamezawa.hiroyu@jp.fujitsu.com>
	<cc557aab1003110647q1b70c9a0j73867c2c33dd28ce@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you.

On Thu, 11 Mar 2010 16:47:00 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Thu, Mar 11, 2010 at 9:57 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> >        /*
> >         * Should we move charges of a task when a task is moved into this
> >         * mem_cgroup ? And what type of charges should we move ?
> > @@ -282,9 +292,12 @@ enum charge_type {
> >  /* for encoding cft->private value on file */
> >  #define _MEM                   (0)
> >  #define _MEMSWAP               (1)
> > +#define _OOM_TYPE              (2)
> >  #define MEMFILE_PRIVATE(x, val)        (((x) << 16) | (val))
> >  #define MEMFILE_TYPE(val)      (((val) >> 16) & 0xffff)
> >  #define MEMFILE_ATTR(val)      ((val) & 0xffff)
> > +/* Used for OOM nofiier */
> > +#define OOM_CONTROL            (0)
> >
> >  /*
> >  * Reclaim flags for mem_cgroup_hierarchical_reclaim
> > @@ -1351,6 +1364,8 @@ bool mem_cgroup_handle_oom(struct mem_cg
> >         */
> >        if (!locked)
> >                prepare_to_wait(&memcg_oom_waitq, &owait.wait, TASK_KILLABLE);
> > +       else
> > +               mem_cgroup_oom_notify(mem);
> >        mutex_unlock(&memcg_oom_mutex);
> >
> >        if (locked)
> > @@ -3398,8 +3413,22 @@ static int compare_thresholds(const void
> >        return _a->threshold - _b->threshold;
> >  }
> >
> > -static int mem_cgroup_register_event(struct cgroup *cgrp, struct cftype *cft,
> > -               struct eventfd_ctx *eventfd, const char *args)
> > +static int mem_cgroup_oom_notify_cb(struct mem_cgroup *mem, void *data)
> > +{
> > +       struct mem_cgroup_eventfd_list *ev;
> > +
> > +       list_for_each_entry(ev, &mem->oom_notify, list)
> > +               eventfd_signal(ev->eventfd, 1);
> > +       return 0;
> > +}
> > +
> > +static void mem_cgroup_oom_notify(struct mem_cgroup *mem)
> > +{
> > +       mem_cgroup_walk_tree(mem, NULL, mem_cgroup_oom_notify_cb);
> > +}
> > +
> > +static int mem_cgroup_usage_register_event(struct cgroup *cgrp,
> > +       struct cftype *cft, struct eventfd_ctx *eventfd, const char *args)
> >  {
> >        struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> >        struct mem_cgroup_threshold_ary *thresholds, *thresholds_new;
> > @@ -3483,8 +3512,8 @@ unlock:
> >        return ret;
> >  }
> >
> > -static int mem_cgroup_unregister_event(struct cgroup *cgrp, struct cftype *cft,
> > -               struct eventfd_ctx *eventfd)
> > +static int mem_cgroup_usage_unregister_event(struct cgroup *cgrp,
> > +       struct cftype *cft, struct eventfd_ctx *eventfd)
> >  {
> >        struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> >        struct mem_cgroup_threshold_ary *thresholds, *thresholds_new;
> > @@ -3568,13 +3597,66 @@ unlock:
> >        return ret;
> >  }
> >
> > +static int mem_cgroup_oom_register_event(struct cgroup *cgrp,
> > +       struct cftype *cft, struct eventfd_ctx *eventfd, const char *args)
> > +{
> > +       struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> > +       struct mem_cgroup_eventfd_list *event;
> > +       int type = MEMFILE_TYPE(cft->private);
> > +       int ret = -ENOMEM;
> > +
> > +       BUG_ON(type != _OOM_TYPE);
> > +
> > +       mutex_lock(&memcg_oom_mutex);
> > +
> > +       /* Allocate memory for new array of thresholds */
> 
> Irrelevant comment?
> 
> > +       event = kmalloc(sizeof(*event), GFP_KERNEL);
> > +       if (!event)
> > +               goto unlock;
> > +       /* Add new threshold */
> 
> Ditto.
> 
Ah...sorry for garbages..I'll clean these up.

Thanks,
-Kame

