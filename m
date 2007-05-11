Return-Path: <linux-kernel-owner+w=401wt.eu-S1760704AbXEKUgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbXEKUgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762657AbXEKUgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:36:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60682 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762243AbXEKUgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:36:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Date: Fri, 11 May 2007 22:40:53 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl> <200705110036.26617.rjw@sisk.pl> <20070511123959.190adfaf.akpm@linux-foundation.org>
In-Reply-To: <20070511123959.190adfaf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705112240.54304.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 11 May 2007 21:39, Andrew Morton wrote:
> On Fri, 11 May 2007 00:36:25 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > The reading of PF_BORROWED_MM in is_user_space() without task_lock() is racy. 
> > Fix it.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> > ---
> >  kernel/power/process.c |    8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6/kernel/power/process.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/power/process.c	2007-05-10 21:44:23.000000000 +0200
> > +++ linux-2.6/kernel/power/process.c	2007-05-10 21:44:28.000000000 +0200
> > @@ -8,6 +8,7 @@
> >  
> >  #undef DEBUG
> >  
> > +#include <linux/sched.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/suspend.h>
> >  #include <linux/module.h>
> > @@ -88,7 +89,12 @@ static void cancel_freezing(struct task_
> >  
> >  static inline int is_user_space(struct task_struct *p)
> >  {
> > -	return p->mm && !(p->flags & PF_BORROWED_MM);
> > +	int ret;
> > +
> > +	task_lock(p);
> > +	ret = p->mm && !(p->flags & PF_BORROWED_MM);
> > +	task_unlock(p);
> > +	return ret;
> >  }
> 
> The whole function is racy, isn't it?  I mean, the condition which it is
> testing can go from true->false or false->true at any instant after this
> function returns its now-wrong value.
> 
> iow, callers of this function need to to something to prevent the expression
> `p->mm && !(p->flags & PF_BORROWED_MM);' from changing value _anyway_.  In
> which case the new locking is not needed?

For user space processes this condition is always true.

For kernel threads:
(1) the change of tsk->mm from NULL to a nonzero value is only made in
fs/aio.c:use_mm() along with the setting of PF_BORROWED_MM under
the task_lock(),
(2) the change of tsk->mm from a nonzero value to NULL is only made in
fs/aio.c:unuse_mm() along with the resetting of PF_BORROWED_MM
under the task_lock().
Therefore, by taking the task_lock() here we make sure that the condition
is alyways false when we check it for kernel threads.

