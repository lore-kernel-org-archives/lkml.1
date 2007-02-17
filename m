Return-Path: <linux-kernel-owner+w=401wt.eu-S933005AbXBQVe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbXBQVe5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933010AbXBQVe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:34:57 -0500
Received: from mail.screens.ru ([213.234.233.54]:46645 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933005AbXBQVe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:34:56 -0500
Date: Sun, 18 Feb 2007 00:34:06 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Message-ID: <20070217213406.GA541@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <200702151431.10068.rjw@sisk.pl> <20070215142542.GA14931@in.ibm.com> <200702171224.46626.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702171224.46626.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael, I am trying to understand try_to_freeze_tasks(), and I have a
couple of questions.

	static inline int is_user_space(struct task_struct *p)
	{
		return p->mm && !(p->flags & PF_BORROWED_MM);
	}

This doesn't look right. First, an exiting task has ->mm == NULL after
do_exit()->exit_mm(). Probably not a problem. However, PF_BORROWED_MM
check is racy without task_lock(), so we can have a false positive as
well. Is it ok? We can freeze aio_wq prematurely.


	try_to_freeze_tasks:

		do_each_thread(g, p) {

			if (p->state == TASK_TRACED && frozen(p->parent)) {

Why we are doing this check outside of "if (is_user_space(p))" ?
Not a bug of course, but looks strange.

				cancel_freezing(p);
				continue;

Is it right? Shouldn't we increment "todo" counter?

			}
			if (is_user_space(p)) {
				if (!freeze_user_space)
					continue;

				/* Freeze the task unless there is a vfork
				 * completion pending
				 */
				if (!p->vfork_done)
					freeze_process(p);


Racy. do_fork(CLONE_VFORK) first does copy_process() which puts 'p' on
the task list and unlocks tasklist_lock. This means that 'p' is visible
to try_to_freeze_tasks(), and p->vfork_done == NULL. try_to_freeze_tasks()
sets TIF_FREEZE.

Now, do_fork() continues, sets ->vfork_done, p goes to user space, notices
the fake signal and goes to refrigerator while its parent is blocked on
"struct completion vfork". Freezing failed.

So, shouldn't we do

	if (p->vfork_done)
		cancel_freezing(p);

instead?

Thanks,

Oleg.

