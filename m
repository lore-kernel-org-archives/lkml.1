Return-Path: <linux-kernel-owner+w=401wt.eu-S936076AbXHOW2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936076AbXHOW2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbXHOW2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:28:05 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:51024 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324AbXHOW2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:28:03 -0400
Date: Wed, 15 Aug 2007 15:27:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Manfred Spraul <manfred@colorfullife.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: [PATCH take2] Use ERESTART_RESTARTBLOCK if poll() is interrupted
	by a signal
Message-ID: <20070815222737.GC3672@sequoia.sous-sol.org>
References: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com> <20070730163538.67b256da.akpm@linux-foundation.org> <46AF9C2D.70808@colorfullife.com> <20070731210817.GA97@tv-sign.ru> <20070804063947.GQ3672@sequoia.sous-sol.org> <20070804110721.GA83@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070804110721.GA83@tv-sign.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov (oleg@tv-sign.ru) wrote:
> On 08/03, Chris Wright wrote:
> >
> > +long do_restart_poll(struct restart_block *restart_block)
> > +{
> > +	struct pollfd __user *ufds = (struct pollfd __user*)restart_block->arg0;
> > +	int nfds = restart_block->arg1;
> > +	s64 timeout = ((s64)restart_block->arg3<<32) | (s64)restart_block->arg2;
> > +	int ret;
> > +
> > +	restart_block->fn = do_no_restart_syscall;
> 
> (just in case, this is not strictly necessary)

Removed, thanks.

> > +	ret = do_sys_poll(ufds, nfds, &timeout);
> > +	if (ret == -EINTR) {
> > +		restart_block->fn = do_restart_poll;
> > +		restart_block->arg2 = timeout & 0xFFFFFFFF;
> > +		restart_block->arg3 = timeout >> 32;
> > +		ret = -ERESTART_RESTARTBLOCK;
> > +	}
> > +	return ret;
> > +}
> > +
> >  asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
> >  			long timeout_msecs)
> >  {
> >  	s64 timeout_jiffies;
> > +	int ret;
> >  
> >  	if (timeout_msecs > 0) {
> >  #if HZ > 1000
> > @@ -754,7 +773,20 @@ asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
> >  		timeout_jiffies = timeout_msecs;
> >  	}
> >  
> > -	return do_sys_poll(ufds, nfds, &timeout_jiffies);
> > +	ret = do_sys_poll(ufds, nfds, &timeout_jiffies);
> > +	if (ret == -EINTR) {
> > +		if (timeout_msecs > 0) {
> 
> This should be "if (timeout_msecs)", a negative timeout means
> "wait indefinitely", so we should restart as well.

Yes, you're right (not really sure what I was thinking there ;-)

> > +			struct restart_block *restart_block;
> > +			restart_block = &current_thread_info()->restart_block;
> > +			restart_block->fn = do_restart_poll;
> > +			restart_block->arg0 = (unsigned long)ufds;
> > +			restart_block->arg1 = nfds;
> > +			restart_block->arg2 = timeout_jiffies & 0xFFFFFFFF;
> > +			restart_block->arg3 = timeout_jiffies >> 32;
> 
> and, in that case, we should use "(u64)timeout_jiffies >> 32".

Sure, sign extension should get shifted back off, but that is more
accurate.

> Small nit: sys_poll() and do_restart_poll() are not "symmetrical", the latter
> doesn't check *timeout at all. Either way is correct, restart with zero timeout
> means "try again once but doesn't wait".
> 
> There is a subtle (but harmless) difference though. Suppose that *timeout == 0
> (either because timeout_msecs == 0 or because timeout expiried) and we have a
> "false" signal_pending(). In that case sys_poll() returns EINTR, but do_restart_poll()
> returns 0.
> 
> I was a bit surprized that sys_poll() return EINTR even if timeout expired, but
> preserved this behaviour in do_poll-return-eintr-when-signalled.patch.
> 
> Perhaps it is better to just remove "if (timeout_msecs > 0)" check from sys_poll().
> Then we can modify do_poll() to return EINTR only when !*timeout, to eliminate
> unneeded (but correct) restart.
> 
> What do you think?

I agree.  Here's the respin.

thanks,
-chris
--

Subject: [PATCH take2] Use ERESTART_RESTARTBLOCK if poll() is interrupted by a signal
From: Chris Wright <chrisw@sous-sol.org>

Lomesh reported poll returning EINTR during suspend/resume cycle.
This is caused by the STOP/CONT cycle that the freezer uses, generating
a pending signal for what in effect is an ignored signal.  In general
poll is a little eager in returning EINTR, when it could try not bother
userspace and simply restart the syscall.  Both select and ppoll do use
ERESTARTNOHAND to restart the syscall.  Oleg points out that simply using
ERESTARTNOHAND will cause poll to restart with original timeout value.
which could ultimately lead to process never returning to userspace.
Instead use ERESTART_RESTARTBLOCK, and restart poll with updated timeout
value.  Inspired by Manfred's use ERESTARTNOHAND in poll patch.

Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
Patch against git-28e8351a

 fs/select.c |   31 ++++++++++++++++++++++++++++++-
 1 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index a974082..5562195 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -736,10 +736,28 @@ out_fds:
 	return err;
 }
 
+long do_restart_poll(struct restart_block *restart_block)
+{
+	struct pollfd __user *ufds = (struct pollfd __user*)restart_block->arg0;
+	int nfds = restart_block->arg1;
+	s64 timeout = ((s64)restart_block->arg3<<32) | (s64)restart_block->arg2;
+	int ret;
+
+	ret = do_sys_poll(ufds, nfds, &timeout);
+	if (ret == -EINTR) {
+		restart_block->fn = do_restart_poll;
+		restart_block->arg2 = timeout & 0xFFFFFFFF;
+		restart_block->arg3 = (u64)timeout >> 32;
+		ret = -ERESTART_RESTARTBLOCK;
+	}
+	return ret;
+}
+
 asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
 			long timeout_msecs)
 {
 	s64 timeout_jiffies;
+	int ret;
 
 	if (timeout_msecs > 0) {
 #if HZ > 1000
@@ -754,7 +772,18 @@ asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
 		timeout_jiffies = timeout_msecs;
 	}
 
-	return do_sys_poll(ufds, nfds, &timeout_jiffies);
+	ret = do_sys_poll(ufds, nfds, &timeout_jiffies);
+	if (ret == -EINTR) {
+		struct restart_block *restart_block;
+		restart_block = &current_thread_info()->restart_block;
+		restart_block->fn = do_restart_poll;
+		restart_block->arg0 = (unsigned long)ufds;
+		restart_block->arg1 = nfds;
+		restart_block->arg2 = timeout_jiffies & 0xFFFFFFFF;
+		restart_block->arg3 = (u64)timeout_jiffies >> 32;
+		ret = -ERESTART_RESTARTBLOCK;
+	}
+	return ret;
 }
 
 #ifdef TIF_RESTORE_SIGMASK
