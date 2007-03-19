Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbXCSVVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbXCSVVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXCSVVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:21:20 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:33335 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbXCSVVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:21:19 -0400
Date: Mon, 19 Mar 2007 16:19:59 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Ian Kent <raven@themaw.net>,
       Cedric Le Goater <clg@fr.ibm.com>, sukadev@us.ibm.com,
       Andrew Morton <akpm@osdl.org>, Dave Hansen <haveblue@us.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
Message-ID: <20070319211959.GA23538@sergelap.austin.ibm.com>
References: <20070313045100.GC8993@us.ibm.com> <Pine.LNX.4.64.0703161300520.4188@raven.themaw.net> <m1ird1o243.fsf@ebiederm.dsl.xmission.com> <1174055467.3397.17.camel@raven.themaw.net> <45FAAD4F.4000204@fr.ibm.com> <1174063618.3397.58.camel@raven.themaw.net> <m1hcslm1tc.fsf@ebiederm.dsl.xmission.com> <20070319200839.GB19449@sergelap.austin.ibm.com> <m1odmpvuft.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1odmpvuft.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> >> 
> >> >> Index: 2.6.20/fs/autofs4/waitq.c
> >> >> ===================================================================
> >> >> --- 2.6.20.orig/fs/autofs4/waitq.c
> >> >> +++ 2.6.20/fs/autofs4/waitq.c
> >> >> @@ -292,8 +292,8 @@ int autofs4_wait(struct autofs_sb_info *
> >> >>  		wq->ino = autofs4_get_ino(sbi);
> >> >>  		wq->uid = current->uid;
> >> >>  		wq->gid = current->gid;
> >> >> -		wq->pid = current->pid;
> >> >> -		wq->tgid = current->tgid;
> >> >> +		wq->pid = pid_nr(task_pid(current));
> >> >> +		wq->tgid = pid_nr(task_tgid(current));
> >> >>  		wq->status = -EINTR; /* Status return if interrupted */
> >> >>  		atomic_set(&wq->wait_ctr, 2);
> >> >>  		mutex_unlock(&sbi->wq_mutex);
> >> 
> >> I have a concern with this bit as I my quick review said the wait queue
> >> persists, and if so we should be cache the struct pid pointer, not the
> >> pid_t value.  Heck the whol pid_nr(task_xxx(current)) idiom I find very
> >> suspicious.
> >
> > Based just on what I see right here I agree it seems like we would want
> > to store a ref to the pid, not store the pid_nr(pid) output, so in this
> > context it is suspicious.
> 
> So that far we are in agreement.
> 
> > OTOH if you're saying that using pid_nr(task_pid(current)) anywhere
> > should always be 'wrong', then please explain why, as I think we have a
> > disagreement on the meanings of the structs involved.  In other words,
> > at some point I expect the only way to get a "pid number" out of a task
> > would be using this exact idiom, "pid_nr(task_pid(current))".
> 
> Dealing with the current process is very common, and
> "pid_nr(task_pid(current)" is very long winded.  Therefore I think it
> makes sense to have a specialized helper for that case.
> 
> I don't think "current->pid" and "current->tgid" are necessarily
> wrong.

True, current->pid can probably always be legitimately taken as the pid
number in the current task's cloning namespace.  But task->pid is wrong.
So if as you say it's worth caching (not saying I doubt you, just that I
haven't verified), then ideally we could cache current->pid but only
access it using current_pid().  Does that seem worth doing?

In any case, certainly adding a task_pid_nr() helper which for starters
returns pid_nr(task_pid(task)) seems reasonable.  Note that Suka's about
ready to send a new iteration of the pidns patchset, so I'd like this to
be considered something to clean up on top of that patchset.

-serge

> For "process_session(current)", and "process_group(current)" I think
> they are fine but we might optimize them to something like:
> "current_session()" and "current_group()".
> 
> The important part is that we have clearly detectable idioms for
> finding the pid values.  So we can find the users and audit the code.
> Having a little more change so that the problem cases don't compile
> when they comes from a patch that hasn't caught up yet with the changes
> is also useful.
> 
> The only advantage I see in making everything go through something
> like: pid_nr(task_pid(current)) is that we don't have the problem of
> storing the pid value twice.  However if we have short hand helper
> functions for that case it will still work and we won't be horribly
> wordy.  
> 
> Further I don't know how expensive pid_nr is going to be, I don't
> think it will be very expensive.  But I still think it may be
> reasonable to cache the answers for the current process on the
> task_struct.  Fewer cache lines and all of that jazz.
> 
> Mostly I just think pid_nr(task_pid(xxx)) looks ugly is rarely needed
> and is frequently associated with a bad conversion.
> 
> Eric
