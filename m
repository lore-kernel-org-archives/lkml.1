Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbZBTAcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbZBTAcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 19:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbZBTAco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 19:32:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54377 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZBTAco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 19:32:44 -0500
Date: Fri, 20 Feb 2009 01:28:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@osdl.org>, roland@redhat.com, daniel@hozac.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid
	ns boundary
Message-ID: <20090220002851.GA15255@redhat.com>
References: <20090219030207.GA18783@us.ibm.com> <20090219030743.GG18990@us.ibm.com> <m1y6w21k6d.fsf@fess.ebiederm.org> <20090219185159.GA374@redhat.com> <m1fxiayss9.fsf@fess.ebiederm.org> <20090219223137.GA10378@redhat.com> <m1fxiaxbb5.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fxiaxbb5.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
> 
> > On 02/19, Eric W. Biederman wrote:
> >>
> >> Oleg Nesterov <oleg@redhat.com> writes:
> >> >
> >> > SI_FROMUSER() == T, unless we have more (hopefully not) in-kernel
> >> > users which send SI_FROMUSER() signals, .si_pid must be valid?
> >>
> >> So the argument is that while things such as force_sig_info(SIGSEGV)
> >> don't have a si_pid we don't care because from_ancestor_ns  == 0.
> >>
> >> Interesting.  Then I don't know if we have any kernel senders
> >> that cross the namespace boundaries.
> >>
> >> That said I still object to this code.
> >>
> >> sys_kill(-pgrp, SIGUSR1)
> >>   kill_something_info(SIGUSR1, &info, 0)
> >>     __kill_pgrp_info(SIGUSR1, &info task_pgrp(current))
> >>       group_send_sig_info(SIGUSR1, &info, tsk)
> >>         __group_send_sig_info(SIGUSR1, &info, tsk)
> >>           send_signal(SIGUSR1, &info, tsk, 1)
> >>             __send_signal(SIGUSR1, &info, tsk, 1)
> >>
> >>
> >> Process groups and sessions can have processes in multiple pid
> >> namespaces, which is very useful for not messing up your controlling
> >> terminal.
> >>
> >> In which case sys_kill cannot possibly set the si_pid value correct
> >> and from_ancestor_ns is not enough either.
> >
> > (I know, I shouldn't reply today because I am already sleeping ;)
> >
> > Why? send_signal() should calculate the correct value of
> > from_parent and pass it to __send_signal(). If it is true, then
> > we clear .si_pid in the copied siginfo (which was already queued).
> > We don't mangle the original siginfo.
> >
> > This happens for each process we send the signal.
> >
> > Or I misunderstood you?
>
> Suppose I have 3 processes in a process group in three separate pid
> namespaces.
>
> Looking from the init pid namespace I have:
>      pid pgrp ppid
>       10 10    1
>       11 10    10
>       12 10    11
>
> Looking from the pid namespace of pid 11 I have:
>      pid pgrp ppid
>       0  0     0
>       1  0     0
>       2  0     1
>
> Looking from the pid namespace of pid 12 I have:
>      pid pgrp ppid
>       0  0     0
>       0  0     0
>       1  0     0
>
> So if the process with pid 12 in the initial pid namespace
> sends to process group 0.

But this is the different problem, it is not that we clear si_pid while
we shouldn't, just the .si_pid passed from kill_something_info() is not
right.

Personally, I think we should not allow to send signals outside our
namespace (except SIGCHLD on exit), this looks just wrong to me. And
some time ago copy_process(CLONE_PID) did "setsid".

Hmm... that was changed by your commit 5cd17569fd0eeca510735e63a6061291e3971bf6.
And while I agree with this commit, I think that cinit should do sys_setsid()
itself to detach itself from the parent namespace.


Or. We can fix the case you described. We can move "si_pid = task_tgid_vnr()"
from sys_kill/do_tkill/etc to send_signal(), it can calculate the correct
.si_pid looking at sender/receiver namespaces.

Oleg.

