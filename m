Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbZFXR7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbZFXR7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZFXR71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:59:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55057 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbZFXR71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:59:27 -0400
Date: Wed, 24 Jun 2009 16:44:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Scott James Remnant <scott@ubuntu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matt Helsley <matthltc@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: +
	proc-connector-add-event-for-process-becoming-session-leader.patch
	added to -mm tree
Message-ID: <20090624144446.GA23848@redhat.com>
References: <20090623202937.GA31252@redhat.com> <1245833631.3280.0.camel@wing-commander>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245833631.3280.0.camel@wing-commander>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Scott James Remnant wrote:
>
> On Tue, 2009-06-23 at 22:29 +0200, Oleg Nesterov wrote:
>
> > > The act of a process becoming a session leader is a useful signal to a
> > > supervising init daemon such as Upstart.
> > ...
> > > @@ -360,8 +360,10 @@ void __set_special_pids(struct pid *pid)
> > >  {
> > >  	struct task_struct *curr = current->group_leader;
> > >
> > > -	if (task_session(curr) != pid)
> > > +	if (task_session(curr) != pid) {
> > >  		change_pid(curr, PIDTYPE_SID, pid);
> > > +		proc_sid_connector(curr);
> > > +	}
> >
> > Wouldn't it better to change sys_setsid() then? This looks more clear
> > imho, and we can move proc_sid_connector() outside of tasklist_lock.
> >
> > Note also that __set_special_pids() does not neccessary mean we are
> > becoming a session leader, see daemonize().
> >
> Actually, I specifically wanted to receive this event if the process
> called daemonize() which is why this is done here rather than in
> sys_setsid()

Aha. I was confused by "becoming a session leader" in the changelog.

> The new session is important information to init in figuring out what
> the process is up to (ie, fork(), setsid(), fork() = daemonise)

daemonize() is only needed when a user-space thread does kernel_thread(),
hopefully it will die eventually, this is already deprecated. Then we can
move proc_sid_connector() to sys_setsid(), I think.

Thanks!

Oleg.

