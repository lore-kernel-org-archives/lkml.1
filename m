Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbXJCBey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbXJCBey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 21:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbXJCBen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 21:34:43 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:41395 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753194AbXJCBem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 21:34:42 -0400
Message-ID: <391375282.31146@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 3 Oct 2007 09:34:39 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: David Chinner <dgc@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 5/5] writeback: introduce writeback_control.more_io to
	indicate more io
Message-ID: <20071003013439.GA6501@mail.ustc.edu.cn>
References: <20071002084143.110486039@mail.ustc.edu.cn> <20071002090254.987182999@mail.ustc.edu.cn> <20071002214736.GJ995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002214736.GJ995458@sgi.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 07:47:45AM +1000, David Chinner wrote:
> On Tue, Oct 02, 2007 at 04:41:48PM +0800, Fengguang Wu wrote:
> >  		wbc.pages_skipped = 0;
> > @@ -560,8 +561,9 @@ static void background_writeout(unsigned
> >  		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> >  		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
> >  			/* Wrote less than expected */
> > -			congestion_wait(WRITE, HZ/10);
> > -			if (!wbc.encountered_congestion)
> > +			if (wbc.encountered_congestion || wbc.more_io)
> > +				congestion_wait(WRITE, HZ/10);
> > +			else
> >  				break;
> >  		}
> 
> Why do you call congestion_wait() if there is more I/O to issue?  If
> we have a fast filesystem, this might cause the device queues to
> fill, then drain on congestion_wait(), then fill again, etc. i.e. we
> will have trouble keeping the queues full, right?

You mean slow writers and fast RAID? That would be exactly the case
these patches try to improve.

The old writeback behaviors are sluggish when there is
        - single big dirty file;
        - single congested device
the queues may well build up slowly, hit background_limit, and
continue to build up, until hit dirty_limit. That means:
        - kupdate writeback could leave behind many expired dirty data
        - background writeback used to return prematurely
        - eventually it relies on balance_dirty_pages() to do the job,
          which means
          - writers get throttled unnecessarily
          - dirty_limit pages are pinned unnecessarily

This patchset makes kupdate/background writeback more responsible,
so that if (avg-write-speed < device-capabilities), the dirty data are
synced timely, and we don't have to go for balance_dirty_pages().

So for your question of queue depth, the answer is: the queue length
will not build up in the first place. 

Also the name of congestion_wait() could be misleading:
- when not congested, congestion_wait() will wakeup on write
  completions;
- when congested, congestion_wait() could also wakeup on write
  completions on other non-congested devices.
So congestion_wait(100ms) normally only takes 0.1-10ms.

For the more_io case, congestion_wait() serves more like 'to take a
breath'. Tests show that the system could go mad without it.

Regards,
Fengguang

