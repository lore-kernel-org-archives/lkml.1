Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbZBSWSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbZBSWSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 17:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbZBSWSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 17:18:31 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:50357 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbZBSWSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 17:18:31 -0500
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@osdl.org>, roland@redhat.com, daniel@hozac.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
References: <20090219030207.GA18783@us.ibm.com>
	<20090219030743.GG18990@us.ibm.com> <m1y6w21k6d.fsf@fess.ebiederm.org>
	<20090219185159.GA374@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Feb 2009 14:18:46 -0800
In-Reply-To: <20090219185159.GA374@redhat.com> (Oleg Nesterov's message of "Thu\, 19 Feb 2009 19\:51\:59 +0100")
Message-ID: <m1fxiayss9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: oleg@redhat.com, linux-kernel@vger.kernel.org, containers@lists.osdl.org, daniel@hozac.com, roland@redhat.com, akpm@osdl.org, sukadev@linux.vnet.ibm.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid ns boundary
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 02/19, Eric W. Biederman wrote:
>>
>> Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:
>>
>> > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>> > Date: Wed, 24 Dec 2008 14:14:18 -0800
>> > Subject: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid ns
>> > boundary
>> >
>> > When sending a signal to a descendant namespace, set ->si_pid to 0 since
>> > the sender does not have a pid in the receiver's namespace.
>> >
>> > Note:
>> > 	- If rt_sigqueueinfo() sets si_code to SI_USER when sending a
>> > 	  signal across a pid namespace boundary, the value in ->si_pid
>> > 	  will be cleared to 0.
>> >
>> > Changelog[v5]:
>> > 	- (Oleg Nesterov) Address both sys_kill() and sys_tkill() cases
>> > 	  in send_signal() to simplify code (this drops patch 7/7 from
>> > 	  earlier version of patchset).
>> >
>> > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
>> > ---
>> >  kernel/signal.c |    2 ++
>> >  1 files changed, 2 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/kernel/signal.c b/kernel/signal.c
>> > index c94355b..a416d77 100644
>> > --- a/kernel/signal.c
>> > +++ b/kernel/signal.c
>> > @@ -883,6 +883,8 @@ static int __send_signal(int sig, struct siginfo *info,
>> > struct task_struct *t,
>> >  			break;
>> >  		default:
>> >  			copy_siginfo(&q->info, info);
>> > +			if (from_ancestor_ns)
>> > +				q->info.si_pid = 0;
>>
>> This is wrong.  siginfo is a union and you need to inspect
>> code to see if si_pid is present in the current union.
>
> SI_FROMUSER() == T, unless we have more (hopefully not) in-kernel
> users which send SI_FROMUSER() signals, .si_pid must be valid?

So the argument is that while things such as force_sig_info(SIGSEGV)
don't have a si_pid we don't care because from_ancestor_ns  == 0.

Interesting.  Then I don't know if we have any kernel senders
that cross the namespace boundaries.

That said I still object to this code.

sys_kill(-pgrp, SIGUSR1)
  kill_something_info(SIGUSR1, &info, 0)
    __kill_pgrp_info(SIGUSR1, &info task_pgrp(current))
      group_send_sig_info(SIGUSR1, &info, tsk)
        __group_send_sig_info(SIGUSR1, &info, tsk)
          send_signal(SIGUSR1, &info, tsk, 1)
            __send_signal(SIGUSR1, &info, tsk, 1)


Process groups and sessions can have processes in multiple pid
namespaces, which is very useful for not messing up your controlling
terminal.

In which case sys_kill cannot possibly set the si_pid value correct
and from_ancestor_ns is not enough either.

So I see two valid policies with setting si_pid.  Push the work
out to the callers of send_signal (kill_pgrp in this case).  And
know you have a valid set of siginfo values.  Or handle the work
in send_signal.

Given that except for process groups we don't send the same siginfo
to multiple processes simply generating the right siginfo values
from the start appears easy enough.

I am not current with the current rule: the caller of send_signal will
do all of the work except for sometimes.  I don't see how we can figure
out which code path has the bug in it with a rule like that.

Eric
