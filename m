Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbYAJL6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbYAJL6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 06:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbYAJL6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 06:58:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758175AbYAJL6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 06:58:21 -0500
Date: Thu, 10 Jan 2008 06:58:14 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Neil Brown <neilb@suse.de>
Cc: akpm@linux-foundation.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] NLM: Add reference counting to lockd
Message-ID: <20080110065814.036be5e6@tleilax.poochiereds.net>
In-Reply-To: <18309.37138.207880.305870@notabene.brown>
References: <1199820798-5289-1-git-send-email-jlayton@redhat.com>
	<1199820798-5289-2-git-send-email-jlayton@redhat.com>
	<1199820798-5289-3-git-send-email-jlayton@redhat.com>
	<1199820798-5289-4-git-send-email-jlayton@redhat.com>
	<1199820798-5289-5-git-send-email-jlayton@redhat.com>
	<1199820798-5289-6-git-send-email-jlayton@redhat.com>
	<1199820798-5289-7-git-send-email-jlayton@redhat.com>
	<18309.37138.207880.305870@notabene.brown>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 14:29:22 +1100
Neil Brown <neilb@suse.de> wrote:

> On Tuesday January 8, jlayton@redhat.com wrote:
> > ...and only have lockd exit when the last reference is dropped.
> > 
> > The problem is this:
> > 
> > When a lock that a client is blocking on comes free, lockd does
> > this in nlmsvc_grant_blocked():
> > 
> >     nlm_async_call(block->b_call, NLMPROC_GRANTED_MSG,
> > &nlmsvc_grant_ops);
> > 
> > the callback from this call is nlmsvc_grant_callback(). That
> > function does this at the end to wake up lockd:
> > 
> >     svc_wake_up(block->b_daemon);
> 
> Uhmmm... Maybe there is an easier way.
> 
> block->b_daemon will always be nlmsvc_serv, so can we simply make this
> 
> 	svc_wake_up(nlmsvc_serv);
> with a little locking to make sure nlmsvc_serv is valid?
> 

That's very close to my original patch to fix this problem. I just
replaced svc_wake_up with a call to a new function that wakes up any
lockd that happens to be up. I'm not sure that my original patch was
careful enough with the locking though...

> Actually svc_wake_up is only called from lockd and goes through
> various hoops to find the right rqstp, which we could have known in
> advance.
> So store the rqstp in some global wrapped in a spinlock so we can
> access it safely and just:
> 
>    spin_lock(whatever)
>    if (nlmsvc_rqstp)
> 	wake_up(&nlmsvc_rqstp->rq_wait)
>    spin_unlock(whatever)
> 
> 
> That seems a somewhat simpler way of avoiding the particular problem.
> 

Yes. Much.

> 
> Hmmm.... I guess that nlmsvc_grant_callback could then be run after
> the 'lockd' module had been unloaded.
> Maybe nlm_shutdown_hosts could call rpc_killall_tasks(host->h_rpcclnt)
> on each host.  That should ensure the callback wont happen afterwards.
> 
> Maybe?
> 

I think so. If we let lockd go down before all the RPC's are done,
then the whole problem of accessing lockd data from them sounds like it
could be a problem. If not now, then future changes could cause it.

IIRC, The reason we don't get nlm_destroy_host done on each nlm_host in
this situation is because the h_count is too high. Doing
rpc_killall_tasks in this situation might fix that, but the logic in
all of this is pretty convoluted. I'll see if I can cook up a new
patchset that does this instead.

-- 
Jeff Layton <jlayton@redhat.com>
