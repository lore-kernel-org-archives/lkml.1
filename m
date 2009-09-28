Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbZI1O0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbZI1O0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 10:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbZI1O0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 10:26:22 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:20517 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZI1O0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 10:26:21 -0400
Date: Mon, 28 Sep 2009 10:25:24 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090928142524.GC6405@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Li, Shaohua" <shaohua.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
	"jens.axboe@oracle.com" <jens.axboe@oracle.com>
References: <20090922185941.1118e011.akpm@linux-foundation.org>
 <20090923022622.GB11918@localhost>
 <20090922193622.42c00012.akpm@linux-foundation.org>
 <20090923140058.GA2794@think>
 <20090924031508.GD6456@localhost>
 <20090925001117.GA9464@discord.disaster>
 <20090925003820.GK2662@think>
 <20090925050413.GC9464@discord.disaster>
 <20090925064503.GA30450@localhost>
 <20090928010700.GE9464@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928010700.GE9464@discord.disaster>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AC0C757.009D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 11:07:00AM +1000, Dave Chinner wrote:
> On Fri, Sep 25, 2009 at 02:45:03PM +0800, Wu Fengguang wrote:
> > On Fri, Sep 25, 2009 at 01:04:13PM +0800, Dave Chinner wrote:
> > > On Thu, Sep 24, 2009 at 08:38:20PM -0400, Chris Mason wrote:
> > > > On Fri, Sep 25, 2009 at 10:11:17AM +1000, Dave Chinner wrote:
> > > > > On Thu, Sep 24, 2009 at 11:15:08AM +0800, Wu Fengguang wrote:
> > > > > > On Wed, Sep 23, 2009 at 10:00:58PM +0800, Chris Mason wrote:
> > > > > > > The only place that actually honors the congestion flag is pdflush.
> > > > > > > It's trivial to get pdflush backed up and make it sit down without
> > > > > > > making any progress because once the queue congests, pdflush goes away.
> > > > > > 
> > > > > > Right. I guess that's more or less intentional - to give lowest priority
> > > > > > to periodic/background writeback.
> > > > > 
> > > > > IMO, this is the wrong design. Background writeback should
> > > > > have higher CPU/scheduler priority than normal tasks. If there is
> > > > > sufficient dirty pages in the system for background writeback to
> > > > > be active, it should be running *now* to start as much IO as it can
> > > > > without being held up by other, lower priority tasks.
> > > > 
> > > > I'd say that an fsync from mutt or vi should be done at a higher prio
> > > > than a background streaming writer.
> > > 
> > > I don't think you caught everything I said - synchronous IO is
> > > un-throttled.
> > 
> > O_SYNC writes may be un-throttled in theory, however it seems to be
> > throttled in practice:
> > 
> >   generic_file_aio_write
> >     __generic_file_aio_write
> >       generic_file_buffered_write
> >         generic_perform_write
> >           balance_dirty_pages_ratelimited
> >     generic_write_sync
> > 
> > Do you mean some other code path?
> 
> In the context of the setup I was talking about, I meant is that sync
> IO _should_ be unthrottled because it is self-throttling by it's
> very nature. The current code makes no differentiation between the
> two.

This isn't entirely true anymore.  WB_SYNC_ALL is turned into a sync
bio, which is sent down with higher priority.  There may be a few spots
that still need to be changed for it, but it is much better than it was.

re: pageout() being the worst way to do IO, definitely agree.

-chris
