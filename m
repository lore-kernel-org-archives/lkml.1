Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbYFJVCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbYFJVCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYFJVCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:02:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbYFJVCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:02:04 -0400
Date: Tue, 10 Jun 2008 17:01:54 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, linux-nfs@vger.kernel.org,
       nfsv4@linux-nfs.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       bfields@fieldses.org
Subject: Re: [2.6.26-rc4] mount.nfsv4/memory poisoning issues...
Message-ID: <20080610170154.68e2e6fb@tleilax.poochiereds.net>
In-Reply-To: <1213130012.20459.58.camel@localhost>
References: <6278d2220806041633n3bfe3dd2ke9602697697228b@mail.gmail.com>
	<20080604203504.62730951@tleilax.poochiereds.net>
	<1213124088.20459.16.camel@localhost>
	<20080610151357.150b6f69@tleilax.poochiereds.net>
	<1213127909.20459.48.camel@localhost>
	<20080610161352.4e588653@tleilax.poochiereds.net>
	<1213130012.20459.58.camel@localhost>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 16:33:32 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Tue, 2008-06-10 at 16:13 -0400, Jeff Layton wrote:
> 
> > We can't call nfs_callback_down() until after nfs_callback_up()
> > returns, so we're guaranteed to have "task" set to a valid task
> > (presuming that nfs_callback_up() doesn't return error). We also can't
> > return from nfs_callback_down() until after the nfs_callback_svc() has
> > exited. kthread_stop() will block until it does.
> 
> The code I'm alluding to is in kthread():
> 
>        /* OK, tell user we're spawned, wait for stop or wakeup */
>         __set_current_state(TASK_UNINTERRUPTIBLE);
>         complete(&create->started);
>         schedule();
> 
>         if (!kthread_should_stop())
>                 ret = threadfn(data);
> 
> schedule() is called _after_ the complete() call, and _before_ we
> execute threadfn() a.k.a. nfs_callback_svc(). If nfs_alloc_client() has
> time to call nfs_callback_down() before the above thread gets scheduled
> back in, then threadfn() doesn't get called at all, since
> kthread_should_stop() is true.
> 

Hmm...this is a bigger problem than it looked at first glance. lockd
also has a similar problem...ditto for the new nfsd code wrt module
refcounts.

In practice, I think the thread generally runs immediately (at least
with current scheduler behavior), so we're probably not terribly
vulnerable to this race. Still, we shouldn't rely on that...

For lockd and the nfs4 callback thread, we'll also need to deal with
the fact that svc_exit_thread() doesn't get called if this happens. So
we'll need to call svc_exit_thread from the *_down() functions too
(I presume that's OK).

nfsd is a bigger problem since it exits on a signal. For that, perhaps
we should declare a completion variable and have svc_set_num_threads()
wait until nfsd() has actually run before continuing.

Thoughts?

-- 
Jeff Layton <jlayton@redhat.com>
