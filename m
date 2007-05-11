Return-Path: <linux-kernel-owner+w=401wt.eu-S1030767AbXEKX0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030767AbXEKX0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758487AbXEKX02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:26:28 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755160AbXEKX01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:26:27 -0400
Date: Fri, 11 May 2007 16:25:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-Id: <20070511162530.2f98bda2.akpm@linux-foundation.org>
In-Reply-To: <200705120122.07177.rjw@sisk.pl>
References: <200705110035.32229.rjw@sisk.pl>
	<200705112240.54304.rjw@sisk.pl>
	<alpine.LFD.0.98.0705111555090.3986@woody.linux-foundation.org>
	<200705120122.07177.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007 01:22:06 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Saturday, 12 May 2007 00:56, Linus Torvalds wrote:
> > 
> > On Fri, 11 May 2007, Rafael J. Wysocki wrote:
> > > 
> > > For user space processes this condition is always true.
> > > 
> > > For kernel threads:
> > > (1) the change of tsk->mm from NULL to a nonzero value is only made in
> > > fs/aio.c:use_mm() along with the setting of PF_BORROWED_MM under
> > > the task_lock(),
> > > (2) the change of tsk->mm from a nonzero value to NULL is only made in
> > > fs/aio.c:unuse_mm() along with the resetting of PF_BORROWED_MM
> > > under the task_lock().
> > > Therefore, by taking the task_lock() here we make sure that the condition
> > > is alyways false when we check it for kernel threads.
> > 
> > Why *test* it then and return anything?
> > 
> > Why not just doa "task_lock(p); task_unlock(p);" with no return value? 
> > 
> > As it is, it sounds like either the code is buggy, or it's pointless.
> 
> I'm not sure what you mean.
> 
> We use this function (ie. kernel/power/process.c:is_user_space()) to
> distinguish kernel threads from user space processes.  Therefore we make it
> always return true for user space processes and always return false for kernel
> threads.  In the latter case we need to use the task_lock() to ensure that the
> result is as desired (ie. false), because otherwise it might be racing with
> either fs/aio.c:use_mm() or fs/aio.c:unuse_mm().
> 

ah, OK.

static void use_mm(struct mm_struct *mm)
{
	struct mm_struct *active_mm;
	struct task_struct *tsk = current;

	task_lock(tsk);
	tsk->flags |= PF_BORROWED_MM;
	active_mm = tsk->active_mm;
	atomic_inc(&mm->mm_count);
	tsk->mm = mm;
	tsk->active_mm = mm;
	/*
	 * Note that on UML this *requires* PF_BORROWED_MM to be set, otherwise
	 * it won't work. Update it accordingly if you change it here
	 */
	switch_mm(active_mm, mm, tsk);
	task_unlock(tsk);

So is_user_space() requires that the state of p->mm and p->flags be
consistent: it doesn't want to be looking at those two things in that
three-statement window above.

Good changelogging and commenting save quite a bit of time and email.

