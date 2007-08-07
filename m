Return-Path: <linux-kernel-owner+w=401wt.eu-S1763048AbXHGWMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763048AbXHGWMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938090AbXHGWFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:05:41 -0400
Received: from pat.uio.no ([129.240.10.15]:42030 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938083AbXHGWFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:05:39 -0400
Subject: Re: [NFS] 2.6.23-rc1-mm2
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>,
       Johannes Berg <johannes@sipsolutions.net>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070807213749.GA461@tv-sign.ru>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	 <200708031301.01569.marc.dietrich@ap.physik.uni-giessen.de>
	 <20070803093830.39852a01.akpm@linux-foundation.org>
	 <1186160608.7255.10.camel@localhost> <20070803172137.GA3783@tv-sign.ru>
	 <1186520929.6625.12.camel@heimdal.trondhjem.org>
	 <20070807213749.GA461@tv-sign.ru>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 18:05:14 -0400
Message-Id: <1186524314.6625.29.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.105)
X-UiO-Scanned: 85D0753F86F30DDC4CC6028E1D4FA9D76026CA8B
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 41 total 3141778 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-08 at 01:37 +0400, Oleg Nesterov wrote:
> On 08/07, Trond Myklebust wrote:
> >
> > On Fri, 2007-08-03 at 21:21 +0400, Oleg Nesterov wrote:
> > > On 08/03, Trond Myklebust wrote:
> > > > I'll have a look at this. I suspect that most if not all of our calls to
> > > > run_workqueue()/flush_scheduled_work() can now be replaced by more
> > > > targeted calls to cancel_work_sync() and cancel_delayed_work_sync().
> > > 
> > > Yes, please, if possible.
> > 
> > All the NFS and SUNRPC cases appear to be trivial. IOW: the only reason
> > for the flush_workqueue()/flush_scheduled_work() calls was to ensure
> > that the cancel_work()/cancel_delayed_work() calls preceding them have
> > completed. Nevertheless I've split the conversion into two patches,
> > since one touches only the NFS code, whereas the other touches the
> > SUNRPC client and server code.
> > 
> > The two patches have been tested, and appear to work...
> 
> Great!
> 
> >  void
> >  nfs4_kill_renewd(struct nfs_client *clp)
> >  {
> >  	down_read(&clp->cl_sem);
> > -	cancel_delayed_work(&clp->cl_renewd);
> > +	cancel_delayed_work_sync(&clp->cl_renewd);
> >  	up_read(&clp->cl_sem);
> > -	flush_scheduled_work();
> >  }
> 
> this looks unsafe to me, the window is very small, but afaics this can
> deadlock if called when nfs4_renew_state() has already started, but didn't
> take ->cl_sem yet.

Not really. We have removed the nfs_client from the public lists, and we
are guaranteed that there are no more active superblocks attached to it
so nothing can call the reclaimer routine (which is the only routine
that takes a write lock on clp->cl_sem).

> Can't we avoid taking clp->cl_sem here?

Yes, I believe that we can, for the same reasons as above: the race with
the reclaimer is impossible, hence the read lock on cl_sem is redundant.

> Btw, unless I missed something, the code without this patch looks incorrect
> too: cancel_delayed_work() can fail if the timer expired, but the ->cl_renewd
> didn't run yet. In that case nfs4_renew_state() can run and re-schedule itself
> after flush_scheduled_work() returns.

No, that should not be possible. Again, see above: there are no active
superblocks, so clp->cl_superblocks is empty.

Cheers
  Trond

