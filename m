Return-Path: <linux-kernel-owner+w=401wt.eu-S934061AbYCFBXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061AbYCFBXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 20:23:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932188AbYCFBRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 20:17:25 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41080 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbYCFBRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 20:17:22 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] orphaned pgrp fixes
References: <20080302184430.GA16362@tv-sign.ru>
	<20080304122654.7313227010A@magilla.localdomain>
	<20080305171109.GB6723@tv-sign.ru>
Date: Wed, 05 Mar 2008 18:14:52 -0700
In-Reply-To: <20080305171109.GB6723@tv-sign.ru> (Oleg Nesterov's message of
	"Wed, 5 Mar 2008 20:11:09 +0300")
Message-ID: <m1y78w1wmr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 03/04, Roland McGrath wrote:

>> Since it's after our own
>> group_dead hit, the "ignored_task" check for our own group leader is
>> redundant with that.
>
> Ah, good point. I didn't realize this when I was thinking about using
> signal->live.
>
> So perhaps it's:
>> 
>> 	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
>> 		if (task_session(p->real_parent) == task_session(p) &&
>> 		    task_pgrp(p->real_parent) != pgrp &&
>>  		    atomic_read(&p->signal->live) > 0 &&
>> 		    task_tgid_nr_ns(p->real_parent, p->nsproxy->pid_ns) != 1)
>> 			return 0;
>> 	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
>
> I am hopeless, I can't understand orphaned pgrps.

I will give it a quick try.
When you login in text mode you get a fresh session (setsid).
If you are using job control in your shell each job is assigned
a separate process group (setpgrp).

The shell and all process groups are in the same session.

Intuitively a process group is considered orphaned when there is
are no processes in the session that know about it and can wake it
up.  The goal is to prevent processes that will never wake up if
they are stopped with ^Z.

A process is defined as knowing about a process in a process group
when it is a parent of that process.



The task_tgid_nr_ns(p->real_parent, p->nsproxy->pid_ns) == 1 check is
the proper check, as it handles namespaces properly.  If we need to
retain it.



I don't believe we need to retain the check for init at all. sysvinit
doesn't use that feature and I would be surprised if any other init
did.  Except for covering programming bugs which make testing harder
I don't see how a version of init could care.

Further as init=/bin/bash is a common idiom for getting into a
simplified system and debugging it, there is a case for job control
to work properly for init.   Unless I am misreading things the check 
for init prevent us from using job control from our first process.
Which seems like it would make init=/bin/bash painful if job control
was ever enabled.

I believe that the only reason with a weird check for init like we are
performing that we are POSIX compliant is that our init process can
count as a special system process and can escape the definition.

Therefore I think the code would be more maintainable, and the system
would be less surprising, and more useful if we removed this special
case processing of init altogether.

I'm hoping that we can kill this check before pid namespaces are
widely deployed and a much larger number of programs can run as init.

Eric
