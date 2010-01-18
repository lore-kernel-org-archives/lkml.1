Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619Ab0ARByZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab0ARByZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 20:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114Ab0ARByY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 20:54:24 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54812 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab0ARByX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 20:54:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/3][v2] vmstat: add anon_scan_ratio field to zoneinfo
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <28c262361001171747w450c8fd8j4daf84b72fb68e1a@mail.gmail.com>
References: <20100118100359.AE22.A69D9226@jp.fujitsu.com> <28c262361001171747w450c8fd8j4daf84b72fb68e1a@mail.gmail.com>
Message-Id: <20100118104910.AE2D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 18 Jan 2010 10:54:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, KOSAKI.
> 
> On Mon, Jan 18, 2010 at 10:04 AM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> Hi, KOSAKI.
> >>
> >> On Thu, Jan 14, 2010 at 2:18 PM, KOSAKI Motohiro
> >> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> >> > Well. zone->lock and zone->lru_lock should be not taked at the same time.
> >> >>
> >> >> I looked over the code since I am out of office.
> >> >> I can't find any locking problem zone->lock and zone->lru_lock.
> >> >> Do you know any locking order problem?
> >> >> Could you explain it with call graph if you don't mind?
> >> >>
> >> >> I am out of office by tomorrow so I can't reply quickly.
> >> >> Sorry for late reponse.
> >> >
> >> > This is not lock order issue. both zone->lock and zone->lru_lock are
> >> > hotpath lock. then, same tame grabbing might cause performance impact.
> >>
> >> Sorry for late response.
> >>
> >> Your patch makes get_anon_scan_ratio of zoneinfo stale.
> >> What you said about performance impact is effective when VM pressure high.
> >> I think stale data is all right normally.
> >> But when VM pressure is high and we want to see the information in zoneinfo(
> >> this case is what you said), stale data is not a good, I think.
> >>
> >> If it's not a strong argue, I want to use old get_scan_ratio
> >> in get_anon_scan_ratio.
> >
> > please looks such function again.
> >
> > usally we use recent_rotated/recent_scanned ratio. then following
> > decreasing doesn't change any scan-ratio meaning. it only prevent
> > stat overflow.
> 
> It has a primary role that floating average as well as prevenitng overflow. :)
> So, It's important.
> 
> >
> >        if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
> >                spin_lock_irq(&zone->lru_lock);
> >                reclaim_stat->recent_scanned[0] /= 2;
> >                reclaim_stat->recent_rotated[0] /= 2;
> >                spin_unlock_irq(&zone->lru_lock);
> >        }
> >
> >
> > So, I don't think current implementation can show stale data.
> 
> It can make stale data when high memory pressure happens.

?? why? and when?
I think it depend on what's stale mean.

Currently(i.e. before the patch), get_scan_ratio have following fomula.
in such region, recent_scanned is not protected by zone->lru_lock.

        ap = (anon_prio + 1) * (reclaim_stat->recent_scanned[0] + 1);
        ap /= reclaim_stat->recent_rotated[0] + 1;
        fp = (file_prio + 1) * (reclaim_stat->recent_scanned[1] + 1);
        fp /= reclaim_stat->recent_rotated[1] + 1;
        percent[0] = 100 * ap / (ap + fp + 1);
        percent[1] = 100 - percent[0];

It mean, shrink_zone() doesn't use exactly recent_scanned value. then
zoneinfo can use the same unexactly value.


> Moreever, I don't want to make complicate thing(ie, need_update)
> than old if it doesn't have some benefit.(I think lru_lock isn't big overhead)

Hmm..
I think lru_lock can makes big overhead.



