Return-Path: <linux-kernel-owner+w=401wt.eu-S1755598AbZEIBc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbZEIBc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 21:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZEIBcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 21:32:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48240 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbZEIBcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 21:32:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Sat, 9 May 2009 02:08:43 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "alan-jenkins@tuffmail.co.uk" <alan-jenkins@tuffmail.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <20090508095010.GA26398@localhost> <200905081551.56577.rjw@sisk.pl>
In-Reply-To: <200905081551.56577.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905090208.44381.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 May 2009, Rafael J. Wysocki wrote:
> On Friday 08 May 2009, Wu Fengguang wrote:
[--snip--]
> > But hey, that 'count' counts "savable+free" memory.
> > We don't have a counter for an estimation of "free+freeable" memory,
> > ie. we are sure we cannot preallocate above that threshold. 
> > 
> > One applicable situation is, when there are 800M anonymous memory,
> > but only 500M image_size and no swap space.
> > 
> > In that case we will otherwise goto the oom code path. Sure oom is
> > (and shall be) reliably disabled in hibernation, but still we shall be
> > cautious enough not to create a low memory situation, which will hurt:
> > - hibernation speed
> >   (vmscan goes mad trying to squeeze the last free page)
> > - user experiences after resume
> >   (all *active* file data and metadata have to reloaded)
> 
> Strangely enough, my recent testing with this patch doesn't confirm the
> theory. :-)  Namely, I set image_size too low on purpose and it only caused
> preallocate_image_memory() to return NULL at one point and that was it.
> 
> It didn't even took too much time.
> 
> I'll carry out more testing to verify this observation.

I can confirm that even if image_size is below the minimum we can get,
the second preallocate_image_memory() just returns after allocating fewer pages
that it's been asked for (that's with the original __GFP_NO_OOM_KILL-based
approach, as I wrote in the previous message in this thread) and nothing bad
happens.

That may be because we freeze the mm kernel threads, but I've also tested
without freezing them and it's still worked the same way.

> > The current code simply tries *too hard* to meet image_size.
> > I'd rather take that as a mild advice, and to only free
> > "free+freeable-margin" pages when image_size is not approachable.
> > 
> > The safety margin can be totalreserve_pages, plus enough pages for
> > retaining the "hard core working set".
> 
> How to compute the size of the "hard core working set", then?

Well, I'm still interested in the answer here. ;-)

Best,
Rafael
