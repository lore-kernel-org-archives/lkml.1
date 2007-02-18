Return-Path: <linux-kernel-owner+w=401wt.eu-S1751298AbXBRPTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbXBRPTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 10:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbXBRPTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 10:19:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49023 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbXBRPTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 10:19:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: freezer problems
Date: Sun, 18 Feb 2007 16:14:36 +0100
User-Agent: KMail/1.9.5
Cc: ego@in.ibm.com, akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu,
       vatsa@in.ibm.com, dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
References: <20070214144031.GA15257@in.ibm.com> <200702181314.29214.rjw@sisk.pl> <20070218145246.GA80@tv-sign.ru>
In-Reply-To: <20070218145246.GA80@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702181614.38315.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 February 2007 15:52, Oleg Nesterov wrote:
> On 02/18, Rafael J. Wysocki wrote:
> >
> > On Sunday, 18 February 2007 12:31, Oleg Nesterov wrote:
> > > > > 
> > > > > However, this means that sys_vfork() makes impossible to freeze processes
> > > > > until child exits/execs. Not good.
> > > > 
> > > I forgot to say that we have another problem: coredumping.
> > > 
> > > A thread which does do_coredump() send SIGKILL to ->mm users, and sleeps
> > > on ->mm->core_startup_done. Now it can't be frozen if sub-thread goes to
> > > refrigerator. I think this could be solved easily if we add a check to
> > > refrigerator() as you suggested for ->vfork_donw.
> > > 
> > > > I think the real solution would be to use an interruptible completion in the
> > > > vfork code.  It was discussed some time ago and, IIRC, Ingo had an experimental
> > > > patch that implemented it.  Still, for the suspend this really is not an issue
> > > > in practice, so it wasn't merged.
> > > 
> > > It is not (afaics) so trivial to do rightly, and with this change the parent
> > > will be seen as TASK_INTERRUPTIBLE even without freezer in progress.
> > > 
> > > A very vague idea: what if parent will do
> > > 
> > > 	current->flags |= PF_PLEASE_CONSIDER_ME_AS_FROZEN_BUT_SET_TIF_FREEZE
> > > 	wait_for_completion(&vfork);
> > > 	try_to_freeze();
> > > 
> > > ?
> > 
> > This should work,
> 
> Good. So try_to_freeze_tasks() can forget about "if (!p->vfork_done)" check.
> This needs more thinking, of course. For example, thaw_process() should be
> carefull to clear TIF_FREEZE if we have the new flag set, but not PF_FROZEN.
> frozen() should be changed to return true if PF_NEW_FLAG && TIF_FREEZE, but
> it also called by refrigerator.
> 
> But IF we really can do this, it will be a general solution.
> 
> >                    but we'll need a separate process flag for it.  If that's
> > acceptable,
> 
> I can't judge. Changed the subject to have more attention from experts.
> 
> >              I'd call it PF_VFORK_PARENT
> 
> I'd suggest not to put "VFORK" into the name. Probably we will find other
> usage for this flag which in fact means: "I am sleeping TASK_UNINTERRUPTIBLE
> at the safe place to freeze, I promise to do try_to_freeze() when I have
> CPU".
> 
> And now another problem: exec. de_thread() sleeps in TASK_UNINTERRUPTIBLE
> waiting for all sub-threads to die, and we have the same "deadlock" if
> one of them is frozen. This is nasty. Probably we can change the ->state
> to TASK_INTERRUPTIBLE and add try_to_freeze(), or play with the new PF_
> flag, but I am not sure it is safe to freeze() the task which is deep
> in the exec() path.

Hm, I haven't been aware of this case.

Well, probably we can do something like in the patch that I've just sent: the
child that enters the refrigerator should know that the parent is
uninterruptible and will wait for it to exit.  Thus it can either mark the
parent as frozen or just exit the refrigerator without freezing itself.

Greetings,
Rafael
