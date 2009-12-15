Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbZLOA45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbZLOA45 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757798AbZLOA44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:56:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51243 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361AbZLOA4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:56:54 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 5/8] Use io_schedule() instead schedule()
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       lwoodman@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091215084636.c7790658.minchan.kim@barrios-desktop>
References: <20091214213026.BBBD.A69D9226@jp.fujitsu.com> <20091215084636.c7790658.minchan.kim@barrios-desktop>
Message-Id: <20091215090441.CDB0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 15 Dec 2009 09:56:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 14 Dec 2009 21:30:54 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > All task sleeping point in vmscan (e.g. congestion_wait) use
> > io_schedule. then shrink_zone_begin use it too.
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  mm/vmscan.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 3562a2d..0880668 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1624,7 +1624,7 @@ static int shrink_zone_begin(struct zone *zone, struct scan_control *sc)
> >  		    max_zone_concurrent_reclaimers)
> >  			break;
> >  
> > -		schedule();
> > +		io_schedule();
> 
> Hmm. We have many cond_resched which is not io_schedule in vmscan.c.

cond_resched don't mean sleep on wait queue. it's similar to yield.

> In addition, if system doesn't have swap device space and out of page cache 
> due to heavy memory pressue, VM might scan & drop pages until priority is zero
> or zone is unreclaimable. 
> 
> I think it would be not a IO wait.

two point.
1. For long time, Administrator usually watch iowait% at heavy memory pressure. I
don't hope change this without reasonable reason. 2. iowait makes scheduler
bonus a bit, vmscan task should have many time slice than memory consume
task. it improve VM stabilization.

but I agree the benefit isn't so big. if we have reasonable reason, I
don't oppose use schedule().



