Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZBCXav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZBCXav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbZBCXa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:30:27 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34217 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbZBCXaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:30:25 -0500
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       linux-kernel@vger.kernel.org
References: <20090203193904.GA23695@redhat.com>
	<20090203194214.GA23703@redhat.com> <m1fxivw673.fsf@fess.ebiederm.org>
	<20090203222803.GA31756@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 03 Feb 2009 15:30:43 -0800
In-Reply-To: <20090203222803.GA31756@redhat.com> (Oleg Nesterov's message of "Tue\, 3 Feb 2009 23\:28\:03 +0100")
Message-ID: <m1zlh3umho.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.180.49.163;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.180.49.163
X-SA-Exim-Rcpt-To: oleg@redhat.com, linux-kernel@vger.kernel.org, srostedt@redhat.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] ftrace: do_each_pid_task() needs rcu lock
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 02/03, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@redhat.com> writes:
>>
>> > On 02/03, Oleg Nesterov wrote:
>> >>
>> >> "ftrace: use struct pid" commit 978f3a45d9499c7a447ca7615455cefb63d44165
>> >> converted ftrace_pid_trace to "struct pid*". But we can't use
>> >> do_each_pid_task() without rcu_read_lock() even if we know the pid
>> >> itself can't go away (it was pinned in ftrace_pid_write). The exiting
>> >> task can detach itself from this pid at any moment.
>> >
>> > Q: why do we use do_each_pid_task(PIDTYPE_PID) ? We can never have more
>> > than 1 task in the loop. Perhaps,
>>
>> That is a bug in do_each_pid_task(PIDTYPE_PID).
>> For ftrace we really want to grab all tasks with a given pid even
>> in the crazy exec case.
>
> Yes, I thought about de_thread() too. But we can't "fix" do_each_pid_task()
> to avoid the race?

For the case of exec there is that.  There is also the case that
ftrace unlike everything else wants to trace be able to trace all of
the idle threads with pid 0.  I think that is a special case
currently, but for that case the only correct version I can think
of do_each_task_pid(), and current do_each_task_pid is wrong because
it does not allow that.

Eric
