Return-Path: <linux-kernel-owner+w=401wt.eu-S2992786AbXDDJfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992786AbXDDJfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 05:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992789AbXDDJfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 05:35:44 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:51403 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992786AbXDDJe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 05:34:57 -0400
To: a.p.zijlstra@chello.nl
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, a.p.zijlstra@chello.nl
In-reply-to: <20070403144224.709586192@taijtu.programming.kicks-ass.net>
	(message from Peter Zijlstra on Tue, 03 Apr 2007 16:40:53 +0200)
Subject: Re: [PATCH 6/6] mm: per device dirty threshold
References: <20070403144047.073283598@taijtu.programming.kicks-ass.net> <20070403144224.709586192@taijtu.programming.kicks-ass.net>
Message-Id: <E1HZ1so-0005q8-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Apr 2007 11:34:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Scale writeback cache per backing device, proportional to its writeout speed.
> 
> akpm sayeth:
> > Which problem are we trying to solve here?  afaik our two uppermost
> > problems are:
> > 
> > a) Heavy write to queue A causes light writer to queue B to blok for a long
> > time in balance_dirty_pages().  Even if the devices have the same speed.  
> 
> This one; esp when not the same speed. The - my usb stick makes my
> computer suck - problem. But even on similar speed, the separation of
> device should avoid blocking dev B when dev A is being throttled.
> 
> The writeout speed is measure dynamically, so when it doesn't have
> anything to write out for a while its writeback cache size goes to 0.
> 
> Conversely, when starting up it will in the beginning act almost
> synchronous but will quickly build up a 'fair' share of the writeback
> cache.

I'm worried about two things:

1) If the per-bdi threshold becomes smaller than the granularity of
   the per-bdi stat (due to the per-CPU counters), then things will
   break.  Shouldn't there be some sanity checking for the calculated
   threshold?

2) The loop is sleeping in congestion_wait(WRITE), which seems wrong.
   It may well be possible that none of the queues are congested, so
   it will sleep the full .1 second.  But by that time the queue may
   have become idle and is just sitting there doing nothing.  Maybe
   there should be a per-bdi waitq, that is woken up, when the per-bdi
   stats are updated.


Thanks,
Miklos
