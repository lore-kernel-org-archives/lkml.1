Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbXHCKaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbXHCKaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 06:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbXHCK3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 06:29:51 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43098 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759218AbXHCK3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 06:29:49 -0400
Date: Fri, 3 Aug 2007 14:26:29 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Daniel Phillips <phillips@phunq.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Distributed storage.
Message-ID: <20070803102629.GB10089@2ka.mipt.ru>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708021408.24876.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200708021408.24876.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 02:08:24PM -0700, Daniel Phillips (phillips@phunq.net) wrote:
> On Tuesday 31 July 2007 10:13, Evgeniy Polyakov wrote:
> > Hi.
> >
> > I'm pleased to announce first release of the distributed storage
> > subsystem, which allows to form a storage on top of remote and local
> > nodes, which in turn can be exported to another storage as a node to
> > form tree-like storages.
> 
> Excellent!  This is precisely what the doctor ordered for the 
> OCFS2-based distributed storage system I have been mumbling about for 
> some time.  In fact the dd in ddsnap and ddraid stands for "distributed 
> data".  The ddsnap/raid devices do not include an actual network 
> transport, that is expected to be provided by a specialized block 
> device, which up till now has been NBD.  But NBD has various 
> deficiencies as you note, in addition to its tendency to deadlock when 
> accessed locally.  Your new code base may be just the thing we always 
> wanted.  We (zumastor et al) will take it for a drive and see if 
> anything breaks.

That would be great.

> Memory deadlock is a concern of course.  From a cursory glance through, 
> it looks like this code is pretty vm-friendly and you have thought 
> quite a lot about it, however I respectfully invite peterz 
> (obsessive/compulsive memory deadlock hunter) to help give it a good 
> going over with me.
> 
> I see bits that worry me, e.g.:
> 
> +		req = mempool_alloc(st->w->req_pool, GFP_NOIO);
> 
> which seems to be callable in response to a local request, just the case 
> where NBD deadlocks.  Your mempool strategy can work reliably only if 
> you can prove that the pool allocations of the maximum number of 
> requests you can have in flight do not exceed the size of the pool.  In 
> other words, if you ever take the pool's fallback path to normal 
> allocation, you risk deadlock.

mempool should be allocated to be able to catch up with maximum
in-flight requests, in my tests I was unable to force block layer to put
more than 31 pages in sync, but in one bio. Each request is essentially
dealyed bio processing, so this must handle maximum number of in-flight
bios (if they do not cover multiple nodes, if they do, then each node
requires own request). Sync has one bio in-flight on my machines (from
tiny VIA nodes to low-end amd64), number of normal requests *usually*
does not increase several dozens (less than hundred always), but that
might be only my small systems, so request size was selected as small as
possible and number of allocations decreased to absolutely healthcare 
minimum.

> Anyway, if this is as grand as it seems then I would think we ought to 
> factor out a common transfer core that can be used by all of NBD, 
> iSCSI, ATAoE and your own kernel server, in place of the roll-yer-own 
> code those things have now.
> 
> Regards,
> 
> Daniel

Thanks.

-- 
	Evgeniy Polyakov
