Return-Path: <linux-kernel-owner+w=401wt.eu-S965626AbXBTANx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965626AbXBTANx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965622AbXBTANW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:13:22 -0500
Received: from mail.screens.ru ([213.234.233.54]:59032 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965615AbXBTANP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:13:15 -0500
Date: Tue, 20 Feb 2007 03:12:09 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: freezer problems
Message-ID: <20070220001209.GA15991@tv-sign.ru>
References: <20070214144031.GA15257@in.ibm.com> <200702192221.35219.rjw@sisk.pl> <20070219224141.GB5070@tv-sign.ru> <200702200036.01515.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702200036.01515.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Rafael J. Wysocki wrote:
>
> On Monday, 19 February 2007 23:41, Oleg Nesterov wrote:
> > On 02/19, Rafael J. Wysocki wrote:
> > >
> > > On Monday, 19 February 2007 21:23, Oleg Nesterov wrote:
> > > 
> > > > > @@ -199,6 +189,10 @@ static void thaw_tasks(int thaw_user_spa
> > > > >
> > > > >         do_each_thread(g, p) {
> > > > > +               if (freezer_should_skip(p))
> > > > > +                       cancel_freezing(p);
> > > > > +       } while_each_thread(g, p);
> > > > > +       do_each_thread(g, p) {
> > > > >                 if (!freezeable(p))
> > > > >                         continue;
> > > > 
> > > > Any reason for 2 separate do_each_thread() loops ?
> > > 
> > > Yes.  If there is a "freeze" request pending for the vfork parent (TIF_FREEZE
> > > set), we have to cancel it before the child is unfrozen, since otherwise the
> > > parent may go freezing after we try to reset PF_FROZEN for it.
> > 
> > I see, thanks... thaw_process() doesn't take TIF_FREEZE into account.
> > 
> > But doesn't this mean we have a race?
> > 
> > Suppose that try_to_freeze_tasks() failed. It does cancel_freezing() for each
> > process before return, but what if some thread already checked TIF_FREEZE and
> > (for simplicity) it is preempted before frozen_process() in refrigerator().
> > 
> > thaw_tasks() runs, ignores this task (P), returns. P gets CPU, and becomes
> > frozen, but nobody will thaw it.
> > 
> > No?
> 
> Well, I think this is highly theoretical.  Namely, try_to_freeze_tasks() only
> fails after the timeout that's currently set to 20 sec., and it yields the CPU
> in each iteration of the main loop.  The task in question would have to refuse
> being frozen for 20 sec. and then suddenly decide to freeze itself right before
> try_to_freeze_tasks() checks the timeout for the very last time.  Then, it
> would have to get preempted at this very moment and stay unfrozen at least
> until thaw_tasks() starts running and in fact even longer.

Yes, yes, it is pure theroretical,

> I think we may avoid this by making try_to_freeze_tasks() sleep for some time
> after it has reset TIF_FREEZE for all tasks in the error path, if anyone is
> ever able to trigger it.

This makes this race  (pure theroretical) ** 2  :)

Still. May be it make sense to introduce cancel_freezing_and_thaw() function
(not right now) which stops the task from sleeping in refrigirator reliably.
I didn't think much about this, but it looks like we can fix coredump/exec
problems. Of course, this is not so important, we can ignore them at least
for now (->vfork_done is different, should be imho solved, because any user
can block freezer forever).

The fix:

	refrigerator:

	+	// we are going to call do_exit() really soon,
	+	// we have a pending SIGKILL
	+	if (current->signal->flags & SIGNAL_GROUP_EXIT)
	+		return;

		frozen_process(current);
		...


	zap_other_threads:

		for_each_subthread() {
			...

	+		// ---- SIGNAL_GROUP_EXIT is set ------
	+		// we can check sig->group_exit_task to detect de_thread,
	+		// but perhaps it doesn't hurt if the caller is do_group_exit
	+		cancel_freezing_and_thaw(p);
			sigaddset(&t->pending.signal, SIGKILL);
			signal_wake_up(t, 1);
		}

This way execer reliably kills all sub-threads and proceeds without blocking
try_to_freeze_tasks(). The same change could be done for zap_process() to fix
coredump.

Oleg.

