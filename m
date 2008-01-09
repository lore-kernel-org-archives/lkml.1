Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbYAISgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbYAISgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 13:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYAISgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 13:36:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbYAISgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 13:36:42 -0500
Date: Wed, 9 Jan 2008 13:36:21 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, neilb@suse.de, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] NLM: Add reference counting to lockd
Message-ID: <20080109133621.72f611ec@tleilax.poochiereds.net>
In-Reply-To: <20080109174707.GC30523@infradead.org>
References: <1199820798-5289-1-git-send-email-jlayton@redhat.com>
	<1199820798-5289-2-git-send-email-jlayton@redhat.com>
	<1199820798-5289-3-git-send-email-jlayton@redhat.com>
	<1199820798-5289-4-git-send-email-jlayton@redhat.com>
	<1199820798-5289-5-git-send-email-jlayton@redhat.com>
	<1199820798-5289-6-git-send-email-jlayton@redhat.com>
	<1199820798-5289-7-git-send-email-jlayton@redhat.com>
	<20080109174707.GC30523@infradead.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 17:47:07 +0000
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Jan 08, 2008 at 02:33:18PM -0500, Jeff Layton wrote:
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
> > 
> > However there is no guarantee that lockd will be up when this
> > happens. If someone shuts down or restarts lockd before the async
> > call completes, then the b_daemon pointer will point to freed
> > memory and the kernel may oops.
> > 
> > I first noticed this on older kernels and had mistakenly thought
> > that newer kernels weren't susceptible, but that's not correct.
> > There's a bit of a race to make sure that the nlm_host is bound
> > when the async call is done, but I can now reproduce this at will
> > on current kernels.
> > 
> > This patch is based on Trond's suggestion to add a new reference
> > counter to lockd, and only allows lockd to go down when it reaches
> > 0. With this change we can't use kthread_stop here.
> > nlmsvc_unlink_block is called by lockd and a kthread can't call
> > kthread_stop on itself. So the patch changes lockd to check the
> > refcount itself and to return if it goes to 0. We do the checking
> > and exit while holding the nlmsvc_mutex to make sure that a new
> > lockd is not started until the old one is down.
> 
> I don't like this signals/kthread mixture at all.  Why can't we simply
> call kthread_stop when the refcount hits zero and keep all the nice
> kthread helpers?
> 

As I stated in an earlier email, I'm not fond of this either :-)

I don't see a good alternative though. We need to be able to drop the
and check the refcount in nlmsvc_unlink_block. That function is called
from lockd, and we can't have lockd call kthread_stop on itself.

If you see a better way to do this, I'm certainly open to suggestions.

I'll note that my first stab at fixing this problem was to change the
svc_wake_up() call in the rpc callback to a routine to wake up any
lockd on the box that happened to be up. That sidesteps this entire
problem of having to make sure lockd stays up. If we decided that was
the right approach we could dump the last patch in this series
altogether.

That said there could be other use after free bugs lurking in the lockd
code so maybe keeping lockd up until nlm_blocked is empty is the right
thing to do.

-- 
Jeff Layton <jlayton@redhat.com>
