Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZBSWei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZBSWei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbZBSWe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:34:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36575 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbZBSWe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:34:28 -0500
Date: Thu, 19 Feb 2009 23:31:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@osdl.org>, roland@redhat.com, daniel@hozac.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid
	ns boundary
Message-ID: <20090219223137.GA10378@redhat.com>
References: <20090219030207.GA18783@us.ibm.com> <20090219030743.GG18990@us.ibm.com> <m1y6w21k6d.fsf@fess.ebiederm.org> <20090219185159.GA374@redhat.com> <m1fxiayss9.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fxiayss9.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
> >
> > SI_FROMUSER() == T, unless we have more (hopefully not) in-kernel
> > users which send SI_FROMUSER() signals, .si_pid must be valid?
>
> So the argument is that while things such as force_sig_info(SIGSEGV)
> don't have a si_pid we don't care because from_ancestor_ns  == 0.
>
> Interesting.  Then I don't know if we have any kernel senders
> that cross the namespace boundaries.
>
> That said I still object to this code.
>
> sys_kill(-pgrp, SIGUSR1)
>   kill_something_info(SIGUSR1, &info, 0)
>     __kill_pgrp_info(SIGUSR1, &info task_pgrp(current))
>       group_send_sig_info(SIGUSR1, &info, tsk)
>         __group_send_sig_info(SIGUSR1, &info, tsk)
>           send_signal(SIGUSR1, &info, tsk, 1)
>             __send_signal(SIGUSR1, &info, tsk, 1)
>
>
> Process groups and sessions can have processes in multiple pid
> namespaces, which is very useful for not messing up your controlling
> terminal.
>
> In which case sys_kill cannot possibly set the si_pid value correct
> and from_ancestor_ns is not enough either.

(I know, I shouldn't reply today because I am already sleeping ;)

Why? send_signal() should calculate the correct value of
from_parent and pass it to __send_signal(). If it is true, then
we clear .si_pid in the copied siginfo (which was already queued).
We don't mangle the original siginfo.

This happens for each process we send the signal.

Or I misunderstood you?

Oleg.

