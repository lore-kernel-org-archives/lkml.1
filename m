Return-Path: <linux-kernel-owner+w=401wt.eu-S932192AbXDFTge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbXDFTge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbXDFTge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:36:34 -0400
Received: from mail.screens.ru ([213.234.233.54]:45684 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbXDFTgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:36:33 -0400
Date: Fri, 6 Apr 2007 23:36:21 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406193621.GA96@tv-sign.ru>
References: <20070406084250.GA179@tv-sign.ru> <m18xd5amwq.fsf@ebiederm.dsl.xmission.com> <20070406094413.GA673@tv-sign.ru> <m1lkh58q16.fsf@ebiederm.dsl.xmission.com> <20070406154750.GA541@tv-sign.ru> <Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06, Linus Torvalds wrote:
> 
> On Fri, 6 Apr 2007, Oleg Nesterov wrote:
> > 
> > Oops. I misread stop_machine(), it does kernel_thread(), not kthread_create().
> > So "stopmachine" threads are all re-parented to init when the caller exits.
> > I think it makes sense to set ->exit_state = -1 in stopmachine(), regadless
> > of any other changes.
> 
> I agree that "->exit_state = -1" makes sense, but I disagree in that I 
> don't think it *matters*.
> 
> Most of the problematic kernel threads are long-running (as in "never 
> exit"). Things like eventd, khelper, migration-threads etc will have init 
> as their parent and never actually exit, so their ->exit_state doesn't 
> matter. What matters is that they are on the children list, so when you 
> have 1024 CPU's, and init has many thousand of these per-cpu threads as 
> its children, then the *user* threads (that do exit) will cause problems!
> 
> I'd almost prefer to just not add kernel threads to any parent process 
> list *at*all*. 

Yes sure, I didn't argue with that. However, "->exit_state = -1" does matter,
we can't detach process unless we make it auto-reap.

Perhaps,

--- t/kernel/exit.c~	2007-04-06 23:31:31.000000000 +0400
+++ t/kernel/exit.c	2007-04-06 23:31:57.000000000 +0400
@@ -275,10 +275,7 @@ static void reparent_to_init(void)
 	remove_parent(current);
 	current->parent = child_reaper(current);
 	current->real_parent = child_reaper(current);
-	add_parent(current);
-
-	/* Set the exit signal to SIGCHLD so we signal init on exit */
-	current->exit_signal = SIGCHLD;
+	current->exit_signal = -1;
 
 	if (!has_rt_policy(current) && (task_nice(current) < 0))
 		set_user_nice(current, 0);

is enough. init is still our parent (make ps happy), but it can't see us,
we are not on ->children list.

Off course, we also need to add preparent_to_init() to kthread() and
(say) stopmachine(). Or we can create kernel_thread_detached() and
modify callers to use it.

Oleg.

