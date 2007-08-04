Return-Path: <linux-kernel-owner+w=401wt.eu-S1761920AbXHDGk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761920AbXHDGk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 02:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbXHDGkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 02:40:17 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:40170 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049AbXHDGkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 02:40:16 -0400
Date: Fri, 3 Aug 2007 23:39:47 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: [PATCH] Use ERESTART_RESTARTBLOCK if poll() is interrupted by a
	signal (was: Re: [PATCH] Use ERESTARTNOHAND if poll() is
	interrupted by a signal)
Message-ID: <20070804063947.GQ3672@sequoia.sous-sol.org>
References: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com> <20070730163538.67b256da.akpm@linux-foundation.org> <46AF9C2D.70808@colorfullife.com> <20070731210817.GA97@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731210817.GA97@tv-sign.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov (oleg@tv-sign.ru) wrote:
> What we need is ERESTART_RESTARTBLOCK, and restart_block.arg2 should
> have the new timeout value, which takes the time we already slept
> into account.

This passes my simple 32-bit and 64-bit testing.  See any issues with
this one?

thanks,
-chris
--

Subject: [PATCH] Use ERESTART_RESTARTBLOCK if poll() is interrupted by a signal
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
Patch against git-7a883eaf

 fs/select.c |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index a974082..50e6d8e 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -736,10 +736,29 @@ out_fds:
 	return err;
 }
 
+long do_restart_poll(struct restart_block *restart_block)
+{
+	struct pollfd __user *ufds = (struct pollfd __user*)restart_block->arg0;
+	int nfds = restart_block->arg1;
+	s64 timeout = ((s64)restart_block->arg3<<32) | (s64)restart_block->arg2;
+	int ret;
+
+	restart_block->fn = do_no_restart_syscall;
+	ret = do_sys_poll(ufds, nfds, &timeout);
+	if (ret == -EINTR) {
+		restart_block->fn = do_restart_poll;
+		restart_block->arg2 = timeout & 0xFFFFFFFF;
+		restart_block->arg3 = timeout >> 32;
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
@@ -754,7 +773,20 @@ asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
 		timeout_jiffies = timeout_msecs;
 	}
 
-	return do_sys_poll(ufds, nfds, &timeout_jiffies);
+	ret = do_sys_poll(ufds, nfds, &timeout_jiffies);
+	if (ret == -EINTR) {
+		if (timeout_msecs > 0) {
+			struct restart_block *restart_block;
+			restart_block = &current_thread_info()->restart_block;
+			restart_block->fn = do_restart_poll;
+			restart_block->arg0 = (unsigned long)ufds;
+			restart_block->arg1 = nfds;
+			restart_block->arg2 = timeout_jiffies & 0xFFFFFFFF;
+			restart_block->arg3 = timeout_jiffies >> 32;
+			ret = -ERESTART_RESTARTBLOCK;
+		}
+	}
+	return ret;
 }
 
 #ifdef TIF_RESTORE_SIGMASK
