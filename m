Return-Path: <linux-kernel-owner+w=401wt.eu-S937298AbXHGWUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937298AbXHGWUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbXHGWUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:20:35 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:33261 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760847AbXHGWUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:20:34 -0400
Date: Wed, 8 Aug 2007 02:20:42 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>,
       Johannes Berg <johannes@sipsolutions.net>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] 2.6.23-rc1-mm2
Message-ID: <20070807222042.GA553@tv-sign.ru>
References: <20070731230932.a9459617.akpm@linux-foundation.org> <200708031301.01569.marc.dietrich@ap.physik.uni-giessen.de> <20070803093830.39852a01.akpm@linux-foundation.org> <1186160608.7255.10.camel@localhost> <20070803172137.GA3783@tv-sign.ru> <1186520929.6625.12.camel@heimdal.trondhjem.org> <20070807213749.GA461@tv-sign.ru> <1186524314.6625.29.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186524314.6625.29.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, Trond Myklebust wrote:
>
> On Wed, 2007-08-08 at 01:37 +0400, Oleg Nesterov wrote:
> > On 08/07, Trond Myklebust wrote:
> > >
> > > On Fri, 2007-08-03 at 21:21 +0400, Oleg Nesterov wrote:
> > > > On 08/03, Trond Myklebust wrote:
> > > > > I'll have a look at this. I suspect that most if not all of our calls to
> > > > > run_workqueue()/flush_scheduled_work() can now be replaced by more
> > > > > targeted calls to cancel_work_sync() and cancel_delayed_work_sync().
> > > > 
> > > > Yes, please, if possible.
> > > 
> > > All the NFS and SUNRPC cases appear to be trivial. IOW: the only reason
> > > for the flush_workqueue()/flush_scheduled_work() calls was to ensure
> > > that the cancel_work()/cancel_delayed_work() calls preceding them have
> > > completed. Nevertheless I've split the conversion into two patches,
> > > since one touches only the NFS code, whereas the other touches the
> > > SUNRPC client and server code.
> > > 
> > > The two patches have been tested, and appear to work...
> > 
> > Great!
> > 
> > >  void
> > >  nfs4_kill_renewd(struct nfs_client *clp)
> > >  {
> > >  	down_read(&clp->cl_sem);
> > > -	cancel_delayed_work(&clp->cl_renewd);
> > > +	cancel_delayed_work_sync(&clp->cl_renewd);
> > >  	up_read(&clp->cl_sem);
> > > -	flush_scheduled_work();
> > >  }
> > 
> > this looks unsafe to me, the window is very small, but afaics this can
> > deadlock if called when nfs4_renew_state() has already started, but didn't
> > take ->cl_sem yet.
> 
> Not really. We have removed the nfs_client from the public lists, and we
> are guaranteed that there are no more active superblocks attached to it
> so nothing can call the reclaimer routine (which is the only routine
> that takes a write lock on clp->cl_sem).

Thanks for your explanation. Not that I was able to understand, nfs is a
black magic to me :)

But. nfs4_renew_state() checks list_empty(&clp->cl_superblocks) under
clp->cl_sem? So, if it is possible that clp->cl_renewd was scheduled
at the time when nfs4_kill_renewd(), we can deadlock, no? Because
nfs4_renew_state() needs clp->cl_sem to complete, but nfs4_kill_renewd()
holds this sem, and waits for nfs4_renew_state() completion.

> > Btw, unless I missed something, the code without this patch looks incorrect
> > too: cancel_delayed_work() can fail if the timer expired, but the ->cl_renewd
> > didn't run yet. In that case nfs4_renew_state() can run and re-schedule itself
> > after flush_scheduled_work() returns.
> 
> No, that should not be possible. Again, see above: there are no active
> superblocks, so clp->cl_superblocks is empty.

Yes, thanks. I missed "goto out" in nfs4_renew_state().

Oleg.

