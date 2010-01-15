Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab0AOCeG (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 21:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282Ab0AOCeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 21:34:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54862 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab0AOCeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 21:34:03 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 15 Jan 2010 11:30:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Minchan Kim <minchan.kim@gmail.com>, Huang Shijie <shijie8@gmail.com>
Subject: Re: [resend][PATCH] mm: Restore zone->all_unreclaimable to
 independence word
Message-Id: <20100115113035.0acbb3dc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100114151959.2c46ee79.akpm@linux-foundation.org>
References: <20100114103332.D71B.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1001132229250.15428@chino.kir.corp.google.com>
	<20100114161311.673B.A69D9226@jp.fujitsu.com>
	<20100114083229.GA7860@localhost>
	<20100114151959.2c46ee79.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010 15:19:59 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 14 Jan 2010 16:32:29 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > On Thu, Jan 14, 2010 at 03:14:10PM +0800, KOSAKI Motohiro wrote:
> > > > On Thu, 14 Jan 2010, KOSAKI Motohiro wrote:
> > > > 
> > > > > commit e815af95 (change all_unreclaimable zone member to flags) chage
> > > > > all_unreclaimable member to bit flag. but It have undesireble side
> > > > > effect.
> > > > > free_one_page() is one of most hot path in linux kernel and increasing
> > > > > atomic ops in it can reduce kernel performance a bit.
> > > > > 
> > > > > Thus, this patch revert such commit partially. at least
> > > > > all_unreclaimable shouldn't share memory word with other zone flags.
> > > > > 
> > > > 
> > > > I still think you need to quantify this; saying you don't have a large 
> > > > enough of a machine that will benefit from it isn't really a rationale for 
> > > > the lack of any data supporting your claim.  We should be basing VM 
> > > > changes on data, not on speculation that there's a measurable impact 
> > > > here.
> > > > 
> > > > Perhaps you could ask a colleague or another hacker to run a benchmark for 
> > > > you so that the changelog is complete?
> > > 
> > > ok, fair. although I dislike current unnecessary atomic-ops.
> > > I'll pending this patch until get good data.
> > 
> > I think it's a reasonable expectation to help large boxes.
> > 
> > What we can do now, is to measure if it hurts mainline SMP
> > boxes. If not, we are set on doing the patch :)
> 
> yup, the effects of the change might be hard to measure.  Not that one
> shouldn't try!
> 
> But sometimes we just have to do a best-effort change based upon theory
> and past experience.
> 
> Speaking of which...
> 
> : --- a/include/linux/mmzone.h
> : +++ b/include/linux/mmzone.h
> : @@ -341,6 +341,7 @@ struct zone {
> :  
> :  	unsigned long		pages_scanned;	   /* since last reclaim */
> :  	unsigned long		flags;		   /* zone flags, see below */
> : +	int                     all_unreclaimable; /* All pages pinned */
> :  
> :  	/* Zone statistics */
> :  	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
> 
> Was that the best place to put the field?  It adds four bytes of
> padding to the zone, hence is suboptimal from a cache utilisation point
> of view.
> 
> It might also be that we can place this field closed in memory to other
> fields which are being manipulated at the same time as
> all_unreclaimable, hm?
> 
How about the same line where zone->lock is ?

Thanks,
-Kame

