Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbYCGBx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbYCGBx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 20:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbYCGBxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 20:53:17 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:57572 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbYCGBxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 20:53:16 -0500
Date: Fri, 7 Mar 2008 04:52:15 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] orphaned pgrp fixes
Message-ID: <20080307015215.GA149@tv-sign.ru>
References: <20080302184430.GA16362@tv-sign.ru> <20080304122654.7313227010A@magilla.localdomain> <20080305171109.GB6723@tv-sign.ru> <m1y78w1wmr.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y78w1wmr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > I am hopeless, I can't understand orphaned pgrps.
> 
> I will give it a quick try.
> When you login in text mode you get a fresh session (setsid).
> If you are using job control in your shell each job is assigned
> a separate process group (setpgrp).
> 
> The shell and all process groups are in the same session.
> 
> Intuitively a process group is considered orphaned when there is
> are no processes in the session that know about it and can wake it
> up.  The goal is to prevent processes that will never wake up if
> they are stopped with ^Z.
> 
> A process is defined as knowing about a process in a process group
> when it is a parent of that process.

Thanks Eric. This does help.

Stupid question, just to be sure. Suppose that SIGTSTP was sent by a
"regular" kill_pid_info() (not by tty or kill_pgrp_info). In that case
get_signal_to_deliver() still must check is_current_pgrp_orphaned(),
yes?

> The task_tgid_nr_ns(p->real_parent, p->nsproxy->pid_ns) == 1 check is
> the proper check, as it handles namespaces properly.  If we need to
> retain it.
>
> I don't believe we need to retain the check for init at all. sysvinit
> doesn't use that feature and I would be surprised if any other init
> did.  Except for covering programming bugs which make testing harder
> I don't see how a version of init could care.
> 
> Further as init=/bin/bash is a common idiom for getting into a
> simplified system and debugging it, there is a case for job control
> to work properly for init.   Unless I am misreading things the check 
> for init prevent us from using job control from our first process.
> Which seems like it would make init=/bin/bash painful if job control
> was ever enabled.
>
> I believe that the only reason with a weird check for init like we are
> performing that we are POSIX compliant is that our init process can
> count as a special system process and can escape the definition.
> 
> Therefore I think the code would be more maintainable, and the system
> would be less surprising, and more useful if we removed this special
> case processing of init altogether.

Looks like a nice changelog for the patch ;)

Oleg.

