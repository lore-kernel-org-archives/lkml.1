Return-Path: <linux-kernel-owner+w=401wt.eu-S1762094AbZLKAyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762094AbZLKAyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761964AbZLKAyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:54:53 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37635 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761687AbZLKAyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:54:53 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Dec 2009 09:51:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: [RFC mm][PATCH 2/5] percpu cached mm counter
Message-Id: <20091211095159.6472a009.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262360912101640y4b90db76w61a7a5dab5f8e796@mail.gmail.com>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
	<20091210163448.338a0bd2.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262360912101640y4b90db76w61a7a5dab5f8e796@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 09:40:07 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:
> > static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
> >  {
> > -       return (unsigned long)atomic_long_read(&(mm)->counters[member]);
> > +       long ret;
> > +       /*
> > +        * Because this counter is loosely synchronized with percpu cached
> > +        * information, it's possible that value gets to be minus. For user's
> > +        * convenience/sanity, avoid returning minus.
> > +        */
> > +       ret = atomic_long_read(&(mm)->counters[member]);
> > +       if (unlikely(ret < 0))
> > +               return 0;
> > +       return (unsigned long)ret;
> >  }
> 
> Now, your sync point is only task switching time.
> So we can't show exact number if many counting of mm happens
> in short time.(ie, before context switching).
> It isn't matter?
> 
I think it's not a matter from 2 reasons.

1. Now, considering servers which requires continuous memory usage monitoring
as ps/top, when there are 2000 processes, "ps -elf" takes 0.8sec.
Because system admins know that gathering process information consumes
some amount of cpu resource, they will not do that so frequently.(I hope)

2. When chains of page faults occur continously in a period, the monitor
of memory usage just see a snapshot of current numbers and "snapshot of what
moment" is at random, always. No one can get precise number in that kind of situation. 



> >
> >  static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
<snip>

> > Index: mmotm-2.6.32-Dec8/kernel/sched.c
> > ===================================================================
> > --- mmotm-2.6.32-Dec8.orig/kernel/sched.c
> > +++ mmotm-2.6.32-Dec8/kernel/sched.c
> > @@ -2858,6 +2858,7 @@ context_switch(struct rq *rq, struct tas
> >        trace_sched_switch(rq, prev, next);
> >        mm = next->mm;
> >        oldmm = prev->active_mm;
> > +
> >        /*
> >         * For paravirt, this is coupled with an exit in switch_to to
> >         * combine the page table reload and the switch backend into
> > @@ -5477,6 +5478,11 @@ need_resched_nonpreemptible:
> >
> >        if (sched_feat(HRTICK))
> >                hrtick_clear(rq);
> > +       /*
> > +        * sync/invaldidate per-cpu cached mm related information
> > +        * before taling rq->lock. (see include/linux/mm.h)
> 
> taling => taking
> 
> > +        */
> > +       sync_mm_counters_atomic();
> 
> It's my above concern.
> before the process schedule out, we could get the wrong info.
> It's not realistic problem?
> 
I think not, now.

Thanks,
-Kame

