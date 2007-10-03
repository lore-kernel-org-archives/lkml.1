Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbXJCCls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbXJCCls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 22:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbXJCClk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 22:41:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50083 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753003AbXJCClk (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 22:41:40 -0400
Date: Wed, 3 Oct 2007 12:41:19 +1000
From: David Chinner <dgc@sgi.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: David Chinner <dgc@sgi.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Ken Chen <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 5/5] writeback: introduce writeback_control.more_io to indicate more io
Message-ID: <20071003024119.GL23367404@sgi.com>
References: <20071002084143.110486039@mail.ustc.edu.cn> <20071002090254.987182999@mail.ustc.edu.cn> <20071002214736.GJ995458@sgi.com> <20071003013439.GA6501@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003013439.GA6501@mail.ustc.edu.cn>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 09:34:39AM +0800, Fengguang Wu wrote:
> On Wed, Oct 03, 2007 at 07:47:45AM +1000, David Chinner wrote:
> > On Tue, Oct 02, 2007 at 04:41:48PM +0800, Fengguang Wu wrote:
> > >  		wbc.pages_skipped = 0;
> > > @@ -560,8 +561,9 @@ static void background_writeout(unsigned
> > >  		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> > >  		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
> > >  			/* Wrote less than expected */
> > > -			congestion_wait(WRITE, HZ/10);
> > > -			if (!wbc.encountered_congestion)
> > > +			if (wbc.encountered_congestion || wbc.more_io)
> > > +				congestion_wait(WRITE, HZ/10);
> > > +			else
> > >  				break;
> > >  		}
> > 
> > Why do you call congestion_wait() if there is more I/O to issue?  If
> > we have a fast filesystem, this might cause the device queues to
> > fill, then drain on congestion_wait(), then fill again, etc. i.e. we
> > will have trouble keeping the queues full, right?
> 
> You mean slow writers and fast RAID? That would be exactly the case
> these patches try to improve.

I mean any writers and a fast block device (raid or otherwise).

> This patchset makes kupdate/background writeback more responsible,
> so that if (avg-write-speed < device-capabilities), the dirty data are
> synced timely, and we don't have to go for balance_dirty_pages().

Sure, but I'm asking about the effect of the patches on the
(avg-write-speed == device-capabilities) case. I agree that
they are necessary for timely syncing of data but I'm trying
to understand what effect they have on the normal write case
(i.e. keeping the disk at full write throughput).

> So for your question of queue depth, the answer is: the queue length
> will not build up in the first place. 

Which queue are you talking about here? The block deivce queue?

> Also the name of congestion_wait() could be misleading:
> - when not congested, congestion_wait() will wakeup on write
>   completions;
> - when congested, congestion_wait() could also wakeup on write
>   completions on other non-congested devices.
> So congestion_wait(100ms) normally only takes 0.1-10ms.

True, but if we know we are not congested and have more work
to do, why sleep at all?

> For the more_io case, congestion_wait() serves more like 'to take a
> breath'. Tests show that the system could go mad without it.

I'm interested to know what tests show that pushing more I/O when
you don't have block device congestion make the system go mad (and
what mad means).  It sounds to me like it's hiding (yet another)
bug in the writeback code......

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
