Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbXELKh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbXELKh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 06:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756015AbXELKhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 06:37:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34481 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575AbXELKhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 06:37:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Date: Sat, 12 May 2007 12:41:54 +0200
User-Agent: KMail/1.9.5
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl> <200705121127.37655.rjw@sisk.pl> <20070512101317.GB8860@in.ibm.com>
In-Reply-To: <20070512101317.GB8860@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705121241.55556.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 May 2007 12:13, Gautham R Shenoy wrote:
> On Sat, May 12, 2007 at 11:27:36AM +0200, Rafael J. Wysocki wrote:
> > On Saturday, 12 May 2007 10:16, Gautham R Shenoy wrote:
> > > 
> > > But I am not sure if this is the case with suspend/hibernate, since we
> > > need to do a sys_sync() between try_freeze_tasks(FREEZE_USER_SPACE) and
> > > try_to_freeze_tasks(FREEZE_KERNEL_THREADS).
> > 
> > From the point of view of syncing it's only necessary to make sure that we
> > won't freeze a kernel thread that's needed for the syncing.  We can have an
> > additional user space task running at this point.
> 
> Ok. Say we're might have an additional user space task which is not
> frozen (say A).
> 
> > > 
> > > So should we perform that check in reparent_to_kthreadd() ?
> > > We are protected by the tasklist_lock there, no?
> > 
> > Yes.  Still, I think the daemonize()ed threads should clear their TIF_FREEZE
> > flag unconditionally right after they have called exit_mm().  So that would be
> > in daemonize().
> > 
> > Or, perhaps, it's better to clear TIF_FREEZE (unconditionally) in exit_mm(),
> > after we've done tsk->mm = NULL?  Oleg, what do you think?
> >
> Is the following scenario possible? 
> 
> FREEZE_KERNEL_THREADS: 
> 1) Mark all leftover threads as freezeable. That would include 'A'.
> 2) 'A' is now daemonised and we clear TIF_FREEZE in exit_mm().
> 3) 'A' calls try_to_freeze() but doesn't enter the refrigerator.
> 
> Hmm, on second thought, this shouldn't matter .
> The subsequent iteration will set A's TIF_FREEZE flag anyway, right? 
> So I think it should be ok to unconditionally clear the TIF_FREEZE flag
> in exit_mm() after tsk->mm = NULL.

Yes.

Still, the following scenario is possible while we're freezing users space
tasks:

(1) user space task calls daemonize()
(2) freezer checks if this is a user space task and the test returns 'true'
(3) task calls exit_mm() and clears its TIF_FREEZE
(4) freezer sets TIF_FREEZE for the task
(5) task calls try_to_freeze() and freezes itself (bad!)

To prevent this from happening, I think, we should acquire task_lock() around
the entire block in which the test is made and TIF_FREEZE is set for the task,
so something more sophisticated than
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch is needed.

Well, I think we should ask Andrew to drop this patch and try to address the
issue in the next series of patches.

Greetings,
Rafael
