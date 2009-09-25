Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZIYALy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZIYALy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753103AbZIYALx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:11:53 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:52058 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753042AbZIYALw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:11:52 -0400
Date: Fri, 25 Sep 2009 10:11:17 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090925001117.GA9464@discord.disaster>
References: <20090923002220.GA6382@localhost> <20090922175452.d66400dd.akpm@linux-foundation.org> <20090923011758.GC6382@localhost> <20090922182832.28e7f73a.akpm@linux-foundation.org> <20090923014500.GA11076@localhost> <20090922185941.1118e011.akpm@linux-foundation.org> <20090923022622.GB11918@localhost> <20090922193622.42c00012.akpm@linux-foundation.org> <20090923140058.GA2794@think> <20090924031508.GD6456@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924031508.GD6456@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 11:15:08AM +0800, Wu Fengguang wrote:
> On Wed, Sep 23, 2009 at 10:00:58PM +0800, Chris Mason wrote:
> > The only place that actually honors the congestion flag is pdflush.
> > It's trivial to get pdflush backed up and make it sit down without
> > making any progress because once the queue congests, pdflush goes away.
> 
> Right. I guess that's more or less intentional - to give lowest priority
> to periodic/background writeback.

IMO, this is the wrong design. Background writeback should
have higher CPU/scheduler priority than normal tasks. If there is
sufficient dirty pages in the system for background writeback to
be active, it should be running *now* to start as much IO as it can
without being held up by other, lower priority tasks.

Cleaning pages is important to keeping the system running smoothly.
Given that IO takes time to clean pages, it is therefore important
to issue as much as possible as quickly as possible without delays
before going back to sleep. Delaying issue of the IO or doing
sub-optimal issue simply reduces performance of the system because
it takes longer to clean the same number of dirty pages.

> > Nothing stops other procs from keeping the queue congested forever.
> > This can only be fixed by making everyone wait for congestion, at which
> > point we might as well wait for requests.
> 
> Yes. That gives everyone somehow equal opportunity, this is a policy change
> that may lead to interesting effects, as well as present a challenge to
> get_request_wait(). That said, I'm not against the change to a wait queue
> in general.

If you block all threads doing _writebehind caching_ (synchronous IO
is self-throttling) to the same BDI on the same queue as the bdi
flusher then when congestion clears the higher priority background
flusher thread should run first and issue more IO.  This should
happen as a natural side-effect of our scheduling algorithms and it
gives preference to efficient background writeback over in-efficient
foreground writeback. Indeed, with this approach we can even avoid
foreground writeback altogether...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
