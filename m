Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbYFTRut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbYFTRut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYFTRul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:50:41 -0400
Received: from mail.fieldses.org ([66.93.2.214]:53500 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYFTRuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:50:39 -0400
Date: Fri, 20 Jun 2008 13:50:36 -0400
To: Jeff Layton <jlayton@redhat.com>
Cc: Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH - take 2] knfsd: nfsd: Handle ERESTARTSYS from syscalls.
Message-ID: <20080620175036.GC563@fieldses.org>
References: <20080619101025.24263.patches@notabene> <1080619001109.24338@suse.de> <20080618210947.2110a541@tleilax.poochiereds.net> <18521.50300.572838.123366@notabene.brown> <20080619063824.00ca6381@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619063824.00ca6381@tleilax.poochiereds.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 06:38:24AM -0400, Jeff Layton wrote:
> On Thu, 19 Jun 2008 12:29:16 +1000
> Neil Brown <neilb@suse.de> wrote:
> 
> > On Wednesday June 18, jlayton@redhat.com wrote:
> > > 
> > > No objection to the patch, but what signal was being sent to nfsd when
> > > you saw this? If it's anything but a SIGKILL, then I wonder if we have
> > > a race that we need to deal with. My understanding is that we have nfsd
> > > flip between 2 sigmasks to prevent anything but a SIGKILL from being
> > > delivered while we're handling the local filesystem operation.
> > 
> > SuSE /etc/init.d/nfsserver does
> > 
> >         killproc -n -KILL nfsd 
> > 
> > so it looks like a SIGKILL.
> > 
> > 
> > > 
> > > From nfsd():
> > > 
> > > ----------[snip]-----------
> > >                 sigprocmask(SIG_SETMASK, &shutdown_mask, NULL);
> > > 
> > >                 /*
> > >                  * Find a socket with data available and call its
> > >                  * recvfrom routine.
> > >                  */
> > >                 while ((err = svc_recv(rqstp, 60*60*HZ)) == -EAGAIN)
> > >                         ;
> > >                 if (err < 0)
> > >                         break;
> > >                 update_thread_usage(atomic_read(&nfsd_busy));
> > >                 atomic_inc(&nfsd_busy);
> > > 
> > >                 /* Lock the export hash tables for reading. */
> > >                 exp_readlock();
> > > 
> > >                 /* Process request with signals blocked.  */
> > >                 sigprocmask(SIG_SETMASK, &allowed_mask, NULL);
> > > 
> > >                 svc_process(rqstp);
> > > 
> > > ----------[snip]-----------
> > > 
> > > What happens if this catches a SIGINT after the err<0 check, but before
> > > the mask is set to allowed_mask? Does svc_process() then get called with
> > > a signal pending?
> > 
> > Yes, I suspect it does.
> > 
> > I wonder why we have all this mucking about this signal masks anyway.
> > Anyone have any ideas about what it actually achieves?
> > 
> 
> HCH asked me the same question when I did the conversion to kthreads.
> My interpretation (based on guesswork here) was that we wanted to
> distinguish between SIGKILL and other allowed signals. A SIGKILL is
> allowed to interrupt the underlying I/O, but other signals should not.
> 
> The question to answer here, I suppose, is whether masking a pending
> signal is sufficient to make signal_pending() return false. If I'm
> looking correctly then the answer should be "yes".

Just looking out of curiosity: signal_pending() checks whether some
thread_info->flags has TIF_SIGPENDING set.

sigprocmask() sets current->blocked to the given set, then calls
recalc_sigpending(), which (ignoring some freezer and SIGSTOP code that
I don't understand), clears TIF_SIGPENDING if any pending signals are in
the newly blocked set.  So, yes.

--b.

> So I don't think we
> have a race here after all. I suspect that if SuSE used a different
> signal here, that would prevent this from happening. For the record,
> both RHEL and Fedora's init scripts use SIGINT for this.
