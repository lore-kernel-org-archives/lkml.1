Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZFBR6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZFBR6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 13:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755131AbZFBR6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 13:58:13 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40434 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbZFBR6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 13:58:12 -0400
Date: Tue, 2 Jun 2009 19:58:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: scameron@beardog.cca.cpqcorp.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, mikem@beardog.cca.cpqcorp.net
Subject: Re: [PATCH 2/2] cciss: Fix SCSI device reset handler
Message-ID: <20090602175814.GO11363@kernel.dk>
References: <20090527203007.GA30160@beardog.cca.cpqcorp.net> <20090529124208.531839fe.akpm@linux-foundation.org> <20090602125011.GJ11363@kernel.dk> <20090602105114.fe754481.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602105114.fe754481.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02 2009, Andrew Morton wrote:
> On Tue, 2 Jun 2009 14:50:11 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Fri, May 29 2009, Andrew Morton wrote:
> > > On Wed, 27 May 2009 15:30:07 -0500
> > > scameron@beardog.cca.cpqcorp.net wrote:
> > > 
> > > > +static int wait_for_device_to_become_ready(ctlr_info_t *h,
> > > > +	unsigned char lunaddr[])
> > > > +{
> > > > +	int rc;
> > > > +	int count = 0;
> > > > +	int waittime = HZ;
> > > > +	CommandList_struct *c;
> > > > +
> > > > +	c = cmd_alloc(h, 1);
> > > > +	if (!c) {
> > > > +		printk(KERN_WARNING "cciss%d: out of memory in "
> > > > +			"wait_for_device_to_become_ready.\n", h->ctlr);
> > > > +		return IO_ERROR;
> > > > +	}
> > > > +
> > > > +	/* Send test unit ready until device ready, or give up. */
> > > > +	while (count < 20) {
> > > > +
> > > > +		/* Wait for a bit.  do this first, because if we send
> > > > +		 * the TUR right away, the reset will just abort it.
> > > > +		 */
> > > > +		set_current_state(TASK_INTERRUPTIBLE);
> > > > +		schedule_timeout(waittime);
> > > 
> > > That's schedule_timeout_interruptible().
> > > 
> > > The problem with interruptible sleeps of this nature is that they are
> > > no-ops if the calling process happens to have signal_pending().  I
> > > suspect that this condition will break your driver.
> > > 
> > > If so, switching to schedule_timeout_uninterruptible() will unbreak it.
> > 
> > I added Stephens patch and your fixup.
> 
> My cciss-fix-scsi-device-reset-handler-fix.patch was a simple cleanup -
> it uses schedule_timeout_interruptible().
> 
> I believe that this should be changed to
> schedule_timeout_uninterruptible() for the above reasons, but the cciss
> guys fell asleep on me.

It's an improvement, none the less. And I bet it should just be
uninterruptible sleep, unless it has a good reason to accept signals.
Mike? Stephen?

-- 
Jens Axboe

