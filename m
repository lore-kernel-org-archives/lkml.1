Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbXJDCVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbXJDCVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 22:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbXJDCVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 22:21:38 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:35484 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752694AbXJDCVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 22:21:37 -0400
Message-ID: <391464497.22880@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Thu, 4 Oct 2007 10:21:33 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: David Chinner <dgc@sgi.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 5/5] writeback: introduce writeback_control.more_io to
	indicate more io
Message-ID: <20071004022133.GA6244@mail.ustc.edu.cn>
References: <20071002084143.110486039@mail.ustc.edu.cn> <20071002090254.987182999@mail.ustc.edu.cn> <20071002214736.GJ995458@sgi.com> <20071003013439.GA6501@mail.ustc.edu.cn> <20071003024119.GL23367404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071003024119.GL23367404@sgi.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 12:41:19PM +1000, David Chinner wrote:
> On Wed, Oct 03, 2007 at 09:34:39AM +0800, Fengguang Wu wrote:
> > On Wed, Oct 03, 2007 at 07:47:45AM +1000, David Chinner wrote:
> > > On Tue, Oct 02, 2007 at 04:41:48PM +0800, Fengguang Wu wrote:
> > > >  		wbc.pages_skipped = 0;
> > > > @@ -560,8 +561,9 @@ static void background_writeout(unsigned
> > > >  		min_pages -= MAX_WRITEBACK_PAGES - wbc.nr_to_write;
> > > >  		if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
> > > >  			/* Wrote less than expected */
> > > > -			congestion_wait(WRITE, HZ/10);
> > > > -			if (!wbc.encountered_congestion)
> > > > +			if (wbc.encountered_congestion || wbc.more_io)
> > > > +				congestion_wait(WRITE, HZ/10);
> > > > +			else
> > > >  				break;
> > > >  		}
> > > 
> > > Why do you call congestion_wait() if there is more I/O to issue?  If
> > > we have a fast filesystem, this might cause the device queues to
> > > fill, then drain on congestion_wait(), then fill again, etc. i.e. we
> > > will have trouble keeping the queues full, right?
> > 
> > You mean slow writers and fast RAID? That would be exactly the case
> > these patches try to improve.
> 
> I mean any writers and a fast block device (raid or otherwise).
> 
> > This patchset makes kupdate/background writeback more responsible,
> > so that if (avg-write-speed < device-capabilities), the dirty data are
> > synced timely, and we don't have to go for balance_dirty_pages().
> 
> Sure, but I'm asking about the effect of the patches on the
> (avg-write-speed == device-capabilities) case. I agree that
> they are necessary for timely syncing of data but I'm trying
> to understand what effect they have on the normal write case

> (i.e. keeping the disk at full write throughput).

OK, I guess it is the focus of all your questions: Why should we sleep
in congestion_wait() and possibly hurt the write throughput? I'll try
to summary it:

- congestion_wait() is necessary
Besides device congestions, there may be other blockades we have to
wait on, e.g. temporary page locks, NFS/journal issues(I guess).

- congestion_wait() is called only when necessary
congestion_wait() will only be called we saw blockades:
        if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
                congestion_wait(WRITE, HZ/10);
        }
So in normal case, it may well write 128MB data without any waiting.

- congestion_wait() won't hurt write throughput
When not congested, congestion_wait() will be wake up on each write
completion. Note that MAX_WRITEBACK_PAGES=1024 and
/sys/block/sda/queue/max_sectors_kb=512(for me),
which means we are gave the chance to sync 4MB on every 512KB written,
which means we are able to submit write IOs 8 times faster than the
device capability. congestion_wait() is a magical timer :-)

> > So for your question of queue depth, the answer is: the queue length
> > will not build up in the first place. 
> 
> Which queue are you talking about here? The block deivce queue?

Yes, the elevator's queues.

