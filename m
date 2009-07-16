Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbZGPDVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbZGPDVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 23:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbZGPDVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 23:21:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757243AbZGPDVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 23:21:35 -0400
Date: Wed, 15 Jul 2009 20:21:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH -mm] throttle direct reclaim when too many pages are
 isolated already
Message-Id: <20090715202114.789d36f7.akpm@linux-foundation.org>
In-Reply-To: <4A5E9A33.3030704@redhat.com>
References: <20090715223854.7548740a@bree.surriel.com>
	<20090715194820.237a4d77.akpm@linux-foundation.org>
	<4A5E9A33.3030704@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 23:10:43 -0400 Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> > On Wed, 15 Jul 2009 22:38:53 -0400 Rik van Riel <riel@redhat.com> wrote:
> > 
> >> When way too many processes go into direct reclaim, it is possible
> >> for all of the pages to be taken off the LRU.  One result of this
> >> is that the next process in the page reclaim code thinks there are
> >> no reclaimable pages left and triggers an out of memory kill.
> >>
> >> One solution to this problem is to never let so many processes into
> >> the page reclaim path that the entire LRU is emptied.  Limiting the
> >> system to only having half of each inactive list isolated for
> >> reclaim should be safe.
> >>
> > 
> > Since when?  Linux page reclaim has a bilion machine years testing and
> > now stuff like this turns up.  Did we break it or is this a
> > never-before-discovered workload?
> 
> It's been there for years, in various forms.  It hardly ever
> shows up, but Kosaki's patch series give us a nice chance to
> fix it for good.

OK.

> >> @@ -1049,6 +1070,10 @@ static unsigned long shrink_inactive_lis
> >>  	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
> >>  	int lumpy_reclaim = 0;
> >>  
> >> +	while (unlikely(too_many_isolated(zone, file))) {
> >> +		schedule_timeout_interruptible(HZ/10);
> >> +	}
> > 
> > This (incorrectly-laid-out) code is a no-op if signal_pending().
> 
> Good point, I should add some code to break out of page reclaim
> if a fatal signal is pending,

We can't just return NULL from __alloc_pages(), and if we can't
get a page from the freelists then we're just going to have to keep
reclaiming.  So I'm not sure how we can do this.

> and use a normal schedule_timeout
> otherwise.

congestion_wait() would be typical.

> Btw, how is this laid out wrong?  How do I do this better?

ask checkpatch ;)

WARNING: braces {} are not necessary for single statement blocks
#99: FILE: mm/vmscan.c:1073:
+	while (unlikely(too_many_isolated(zone, file))) {
+		schedule_timeout_interruptible(HZ/10);
+	}

total: 0 errors, 1 warnings, 37 lines checked

