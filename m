Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbZLPAtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbZLPAtI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZLPAs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:48:59 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41847 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbZLPAs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:48:57 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/8] Use prepare_to_wait_exclusive() instead prepare_to_wait()
Cc: kosaki.motohiro@jp.fujitsu.com, Mike Galbraith <efault@gmx.de>,
       lwoodman@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
In-Reply-To: <4B27A417.3040206@redhat.com>
References: <1260855146.6126.30.camel@marge.simson.net> <4B27A417.3040206@redhat.com>
Message-Id: <20091216093533.CDF1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 16 Dec 2009 09:48:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/15/2009 12:32 AM, Mike Galbraith wrote:
> > On Tue, 2009-12-15 at 09:45 +0900, KOSAKI Motohiro wrote:
> >>> On 12/14/2009 07:30 AM, KOSAKI Motohiro wrote:
> >>>> if we don't use exclusive queue, wake_up() function wake _all_ waited
> >>>> task. This is simply cpu wasting.
> >>>>
> >>>> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> >>>
> >>>>    		if (zone_watermark_ok(zone, sc->order, low_wmark_pages(zone),
> >>>>    					0, 0)) {
> >>>> -			wake_up(wq);
> >>>> +			wake_up_all(wq);
> >>>>    			finish_wait(wq,&wait);
> >>>>    			sc->nr_reclaimed += sc->nr_to_reclaim;
> >>>>    			return -ERESTARTSYS;
> >>>
> >>> I believe we want to wake the processes up one at a time
> >>> here.
> 
> >> Actually, wake_up() and wake_up_all() aren't different so much.
> >> Although we use wake_up(), the task wake up next task before
> >> try to alloate memory. then, it's similar to wake_up_all().
> 
> That is a good point.  Maybe processes need to wait a little
> in this if() condition, before the wake_up().  That would give
> the previous process a chance to allocate memory and we can
> avoid waking up too many processes.

if we really need wait a bit, Mike's wake_up_batch is best, I think.
It mean
 - if another CPU is idle, wake up one process soon. iow, it don't
   make meaningless idle.
 - if another CPU is busy, woken process don't start to run awhile.
   then, zone_watermark_ok() can calculate correct value.


> > What happens to waiters should running tasks not allocate for a while?
> 
> When a waiter is woken up, it will either:
> 1) see that there is enough free memory and wake up the next guy, or
> 2) run shrink_zone and wake up the next guy
> 
> Either way, the processes that just got woken up will ensure that
> the sleepers behind them in the queue will get woken up.
> 
> -- 
> All rights reversed.



