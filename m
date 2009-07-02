Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZGBNlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZGBNlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZGBNlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:41:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:23211 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbZGBNlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:41:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,334,1243839600"; 
   d="scan'208";a="160906850"
Date: Thu, 2 Jul 2009 20:43:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       "riel@redhat.com" <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: Found the commit that causes the OOMs
Message-ID: <20090702124351.GA7488@localhost>
References: <2f11576a0906280801w417d1b9fpe10585b7a641d41b@mail.gmail.com> <20090628151026.GB25076@localhost> <20090629091741.ab815ae7.minchan.kim@barrios-desktop> <17678.1246270219@redhat.com> <20090629125549.GA22932@localhost> <29432.1246285300@redhat.com> <28c262360906290800v37f91d7av3642b1ad8b5f0477@mail.gmail.com> <20090629160725.GF5065@csn.ul.ie> <24767.1246391867@redhat.com> <20090702164106.76db077b.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702164106.76db077b.minchan.kim@barrios-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 03:41:06PM +0800, Minchan Kim wrote:
> 
> 
> On Tue, 30 Jun 2009 20:57:47 +0100
> David Howells <dhowells@redhat.com> wrote:
> 
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> > 
> > > David. Doesn't it happen OOM if you revert my patch, still?
> > 
> > It does happen, and indeed happens in v2.6.30, but requires two adjacent runs
> > of msgctl11 to trigger, rather than usually triggering on the first run.  If
> > you interpolate the rest of LTP between the iterations, it doesn't seem to
> > happen at all on v2.6.30.  My guess is that with the rest of LTP interpolated,
> > there's either enough time for some cleanup or something triggers a cleanup
> > (the swapfile tests perhaps?).
> > 
> > > Befor I go to the trip, I made debugging patch in a hurry.  Mel and I
> > > suspect to put the wrong page in lru list.
> > > 
> > > This patch's goal is that print page's detail on active anon lru when it
> > > happen OOM.  Maybe you could expand your log buffer size.
> > 
> > Do you mean to expand the dmesg buffer?  That's probably unnecessary: I capture
> > the kernel log over a serial port into a file on another machine.
> > 
> > > Could you show me the information with OOM, please ?
> > 
> > Attached.  It's compressed as there was rather a lot.
> > 
> > David
> > ---
> 
> Hi, David. 
> 
> Sorry for late response.
> 
> I looked over your captured data when I got home but I didn't find any problem
> in lru page moving scheme.
> As Wu, Kosaki and Rik discussed, I think this issue is also related to process fork bomb. 

Yes, me think so.

> When I tested msgctl11 in my machine with 2.6.31-rc1, I found that:

Were you testing the no-swap case?

> 2.6.31-rc1		
> real	0m38.628s
> user	0m10.589s
> sys	1m12.613s
> 
> vmstat
> 
> allocstall 3196
> 
> 2.6.31-rc1-revert-mypatch
> 
> real	1m17.396s
> user	0m11.193s
> sys	4m3.803s 

It's interesting that (sys > real).

> vmstat
> 
> allocstall 584
> 
> Sometimes I got OOM, sometime not in with 2.6.31-rc1.
> 
> Anyway, the current kernel's test took a rather short time than my reverted patch. 
> In addition, the current kernel has small allocstall(direct reclaim)
> 
> As you know, my patch was just to remove calling shrink_active_list in case of no swap.
> shrink_active_list function is a big cost function.
> The old shrink_active_list could throttle to fork processes by chance. 
> But by removing that function with my patch, we have a high
> probability to make process fork bomb. Wu, KOSAKI and Rik, does it
> make sense? 

Maybe, but I'm not sure on how to explain the time/vmstat numbers :(

> So I think you were just lucky with a unnecessary routine.
> Anyway, AFAIK, Rik is making throttling page reclaim. 
> I think it can solve your problem. 

Yes, with good luck :)

Thanks,
Fengguang
