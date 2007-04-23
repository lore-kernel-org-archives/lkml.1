Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbXDWK1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbXDWK1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 06:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbXDWK1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 06:27:42 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50995 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbXDWK1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 06:27:41 -0400
Date: Mon, 23 Apr 2007 15:56:18 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>, akpm@linux-foundation.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC PATCH 1/2] Fix PF_NOFREEZE and freezeable race
Message-ID: <20070423102618.GA25144@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070419120131.GB13435@in.ibm.com> <20070419120234.GA17069@in.ibm.com> <200704192339.30783.rjw@sisk.pl> <20070420180208.GA721@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420180208.GA721@tv-sign.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 10:02:08PM +0400, Oleg Nesterov wrote:
> On 04/19, Rafael J. Wysocki wrote:
> > 
> > On Thursday, 19 April 2007 14:02, Gautham R Shenoy wrote:
> > > This patch fixes the race pointed out by Oleg Nesterov.
> > > 
> > > * Freezer marks a thread as freezeable. 
> > > * The thread now marks itself PF_NOFREEZE causing it to
> > >   freeze on calling try_to_freeze(). Thus the task is frozen, even though
> > >   it doesn't want to.
> > > * Subsequent thaw_processes() will also fail to thaw the task since it is 
> > >   marked PF_NOFREEZE.
> > > 
> > > Avoid this problem by checking the current task's PF_NOFREEZE status in the 
> > > refrigerator before marking current as frozen.
> > > 
> > > Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> > 
> > Looks good, although I'm not sure if we don't need to call recalc_sigpending()
> > for tasks that turn out to be PF_NOFREEZE.
> 
> I agree, we should clear TIF_SIGPENDING. It is not so critical for user-space
> tasks, but for the kernel thread it may remain pending forever, causing subtle
> failures.
> 
> Gautham, isn't it possible to make a more simpler patch ? Just add PF_NOFREEZE
> check to frozen_process,
> 
> 	static inline void frozen_process(struct task_struct *p)
> 	{
> 		if (!unlikely(current->flags & PF_NOFREEZE)) {
> 			p->flags |= PF_FROZEN;
> 			wmb();
> 		}
> 		clear_tsk_thread_flag(p, TIF_FREEZE);
> 	}
> 
> No?

Actually yes. The idea anyway was to check one last time before declaring
ourselves as frozen. So I thought the best place was inside refrigerator since
we are already holding the task_lock there.
I wasn't too sure about calling recalc_sigpending(), but now that you
mention it, I agree, this would be a nicer way to do it.

Btw, since frozen_process is currently being called only from
refrigerator, I am wondering if we still need the struct task_struct *p
parameter there. It's very unlikely that some other task would mark a
particular task as frozen. No?

Anyways, Andrew, Could you please replace the earlier sent patch titled
"fix_pf_nofreeze_and_freezeable_race.patch" with the following one?

Thanks and Regards
gautham.

-->
This patch fixes the race pointed out by Oleg Nesterov.

* Freezer marks a thread as freezeable.
* The thread now marks itself PF_NOFREEZE causing it to
  freeze on calling try_to_freeze(). Thus the task is frozen, even though
  it doesn't want to.
* Subsequent thaw_processes() will also fail to thaw the task since it is
  marked PF_NOFREEZE.

Avoid this problem by checking the task's PF_NOFREEZE status in 
frozen_processes() before marking the task as frozen.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 include/linux/freezer.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.21-rc6/include/linux/freezer.h
===================================================================
--- linux-2.6.21-rc6.orig/include/linux/freezer.h
+++ linux-2.6.21-rc6/include/linux/freezer.h
@@ -57,8 +57,10 @@ static inline int thaw_process(struct ta
  */
 static inline void frozen_process(struct task_struct *p)
 {
-	p->flags |= PF_FROZEN;
-	wmb();
+	if (!unlikely(p->flags & PF_NOFREEZE)) {
+		p->flags |= PF_FROZEN;
+		wmb();
+	}
 	clear_tsk_thread_flag(p, TIF_FREEZE);
 }
 
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
