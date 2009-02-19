Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbZBSXV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbZBSXV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 18:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZBSXVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 18:21:19 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53180 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbZBSXVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 18:21:18 -0500
To: Oleg Nesterov <oleg@redhat.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@osdl.org>, roland@redhat.com, daniel@hozac.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
References: <20090219030207.GA18783@us.ibm.com>
	<20090219030743.GG18990@us.ibm.com> <m1y6w21k6d.fsf@fess.ebiederm.org>
	<20090219185159.GA374@redhat.com> <m1fxiayss9.fsf@fess.ebiederm.org>
	<20090219223137.GA10378@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Feb 2009 15:21:34 -0800
In-Reply-To: <20090219223137.GA10378@redhat.com> (Oleg Nesterov's message of "Thu\, 19 Feb 2009 23\:31\:37 +0100")
Message-ID: <m1fxiaxbb5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: oleg@redhat.com, linux-kernel@vger.kernel.org, containers@lists.osdl.org, daniel@hozac.com, roland@redhat.com, akpm@osdl.org, sukadev@linux.vnet.ibm.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0083]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.5 XMReplyNow Urgent/immediate reply
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
>> Oleg Nesterov <oleg@redhat.com> writes:
>> >
>> > SI_FROMUSER() == T, unless we have more (hopefully not) in-kernel
>> > users which send SI_FROMUSER() signals, .si_pid must be valid?
>>
>> So the argument is that while things such as force_sig_info(SIGSEGV)
>> don't have a si_pid we don't care because from_ancestor_ns  == 0.
>>
>> Interesting.  Then I don't know if we have any kernel senders
>> that cross the namespace boundaries.
>>
>> That said I still object to this code.
>>
>> sys_kill(-pgrp, SIGUSR1)
>>   kill_something_info(SIGUSR1, &info, 0)
>>     __kill_pgrp_info(SIGUSR1, &info task_pgrp(current))
>>       group_send_sig_info(SIGUSR1, &info, tsk)
>>         __group_send_sig_info(SIGUSR1, &info, tsk)
>>           send_signal(SIGUSR1, &info, tsk, 1)
>>             __send_signal(SIGUSR1, &info, tsk, 1)
>>
>>
>> Process groups and sessions can have processes in multiple pid
>> namespaces, which is very useful for not messing up your controlling
>> terminal.
>>
>> In which case sys_kill cannot possibly set the si_pid value correct
>> and from_ancestor_ns is not enough either.
>
> (I know, I shouldn't reply today because I am already sleeping ;)
>
> Why? send_signal() should calculate the correct value of
> from_parent and pass it to __send_signal(). If it is true, then
> we clear .si_pid in the copied siginfo (which was already queued).
> We don't mangle the original siginfo.
>
> This happens for each process we send the signal.
>
> Or I misunderstood you?

Suppose I have 3 processes in a process group in three separate pid
namespaces.

Looking from the init pid namespace I have:
     pid pgrp ppid
      10 10    1
      11 10    10
      12 10    11

Looking from the pid namespace of pid 11 I have:
     pid pgrp ppid
      0  0     0
      1  0     0
      2  0     1

Looking from the pid namespace of pid 12 I have:
     pid pgrp ppid
      0  0     0
      0  0     0
      1  0     0

So if the process with pid 12 in the initial pid namespace
sends to process group 0.

pid 10 should see si_pid 12.
pid 11 should see si_pid 2.

Neither should see si_pid 0, as from_ancestor_ns will not
be true.

Eric


