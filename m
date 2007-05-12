Return-Path: <linux-kernel-owner+w=401wt.eu-S1762833AbXEKX5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762833AbXEKX5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXEKX46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:56:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32948 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbXEKX45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:56:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Date: Sat, 12 May 2007 02:01:41 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200705110035.32229.rjw@sisk.pl> <200705120122.07177.rjw@sisk.pl> <alpine.LFD.0.98.0705111625300.3986@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705111625300.3986@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705120201.42619.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 May 2007 01:29, Linus Torvalds wrote:
> 
> On Sat, 12 May 2007, Rafael J. Wysocki wrote:
> >
> > We use this function (ie. kernel/power/process.c:is_user_space()) to
> > distinguish kernel threads from user space processes.  Therefore we make it
> > always return true for user space processes and always return false for kernel
> > threads.  In the latter case we need to use the task_lock() to ensure that the
> > result is as desired (ie. false), because otherwise it might be racing with
> > either fs/aio.c:use_mm() or fs/aio.c:unuse_mm().
> 
> But there is no race protection in the *caller*, so if it can ever return 
> one or the other, what protects it from changing once the caller returns?
> 
> And if the value can change (because some thread uses "use_mm()"), then 
> the caller cannot rely on the value that got returned.

The value cannot change because of that.  There only is a small window inside
unuse_mm() (or use_mm()) in which the value may be wrong.  Namely:

static void unuse_mm(struct mm_struct *mm)
{
	struct task_struct *tsk = current;

	task_lock(tsk);
	tsk->flags &= ~PF_BORROWED_MM;
---
--- If is_user_space() without the task_lock() is called right here, it will
--- return 'true', although it should return 'false'.
---
	tsk->mm = NULL;
	/* active_mm is still 'mm' */
	enter_lazy_tlb(mm, tsk);
	task_unlock(tsk);
}

IOW, quoting Andrew, "is_user_space() requires that the state of p->mm and
p->flags be consistent".

> So you migt as well not return any value at all, since the returned value 
> is apparently meaningless once the lock has been released.

No, it is not meaningless.

Rafael
