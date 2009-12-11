Return-Path: <linux-kernel-owner+w=401wt.eu-S1762159AbZLKB3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159AbZLKB3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762054AbZLKB3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:29:23 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39166 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762053AbZLKB3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:29:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Dec 2009 10:26:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: [RFC mm][PATCH 2/5] percpu cached mm counter
Message-Id: <20091211102629.4fe1ac43.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262360912101725ydb0a0d9i12a91c1d4fe57672@mail.gmail.com>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
	<20091210163448.338a0bd2.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262360912101640y4b90db76w61a7a5dab5f8e796@mail.gmail.com>
	<20091211095159.6472a009.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262360912101725ydb0a0d9i12a91c1d4fe57672@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Dec 2009 10:25:03 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Fri, Dec 11, 2009 at 9:51 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Fri, 11 Dec 2009 09:40:07 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> >> > static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
> >> >  {
> >> > -       return (unsigned long)atomic_long_read(&(mm)->counters[member]);
> >> > +       long ret;
> >> > +       /*
> >> > +        * Because this counter is loosely synchronized with percpu cached
> >> > +        * information, it's possible that value gets to be minus. For user's
> >> > +        * convenience/sanity, avoid returning minus.
> >> > +        */
> >> > +       ret = atomic_long_read(&(mm)->counters[member]);
> >> > +       if (unlikely(ret < 0))
> >> > +               return 0;
> >> > +       return (unsigned long)ret;
> >> >  }
> >>
> >> Now, your sync point is only task switching time.
> >> So we can't show exact number if many counting of mm happens
> >> in short time.(ie, before context switching).
> >> It isn't matter?
> >>
> > I think it's not a matter from 2 reasons.
> >
> > 1. Now, considering servers which requires continuous memory usage monitoring
> > as ps/top, when there are 2000 processes, "ps -elf" takes 0.8sec.
> > Because system admins know that gathering process information consumes
> > some amount of cpu resource, they will not do that so frequently.(I hope)
> >
> > 2. When chains of page faults occur continously in a period, the monitor
> > of memory usage just see a snapshot of current numbers and "snapshot of what
> > moment" is at random, always. No one can get precise number in that kind of situation.
> >
> 
> Yes. I understand that.
> 
> But we did rss updating as batch until now.
> It was also stale. Just only your patch make stale period longer.
> Hmm. I hope people don't expect mm count is precise.
> 
I hope so, too...

> I saw the many people believed sanpshot of mm counting is real in
> embedded system.
> They want to know the exact memory usage in system.
> Maybe embedded system doesn't use SPLIT_LOCK so that there is no regression.
> 
> At least, I would like to add comment "It's not precise value." on
> statm's Documentation.

Ok, I'll will do.

> Of course, It's off topic.  :)
> 
> Thanks for commenting. Kame.

Thank you for review.

Regards,
-Kame

