Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYLEQgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYLEQgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 11:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYLEQgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 11:36:33 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:32768 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYLEQgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 11:36:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
References: <20081204052638.425740534@goodmis.org>
	<20081204052735.362609481@goodmis.org>
	<20081204001803.598063f5.akpm@linux-foundation.org>
	<20081204091023.GJ32594@elte.hu> <m1vdu0t7tz.fsf@frodo.ebiederm.org>
	<alpine.DEB.1.10.0812040946060.5240@gandalf.stny.rr.com>
	<m11vwnu10b.fsf@frodo.ebiederm.org>
	<alpine.DEB.1.10.0812041551590.32726@gandalf.stny.rr.com>
	<m1vdtzr4zn.fsf@frodo.ebiederm.org>
	<alpine.DEB.1.10.0812041653270.32726@gandalf.stny.rr.com>
	<m1r64nqd6v.fsf@frodo.ebiederm.org>
	<alpine.DEB.1.10.0812050715570.26316@gandalf.stny.rr.com>
Date: Fri, 05 Dec 2008 08:35:26 -0800
In-Reply-To: <alpine.DEB.1.10.0812050715570.26316@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Fri, 5 Dec 2008 07:23:07 -0500 (EST)")
Message-ID: <m1zljapokx.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Steven Rostedt <rostedt@goodmis.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 3/3] ftrace: add ability to only trace swapper tasks
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> Other pids get allocated per task. In the beginning of copy_process we 
> have:
>
>         if (pid != &init_struct_pid) {
>                 retval = -ENOMEM;
>                 pid = alloc_pid(task_active_pid_ns(p));
>
> Where alloc_pid allocates a pid structure. But this is only done if it is
> not a swapper task.

For PIDTYPE_PID.  For sessions and process groups we don't always allocate them,
and attach_pid is fine.

There is a bit of oddness in the pid freeing case, in using an unhashed pid,
so cpu hotunplug might be a problem.  But you certainly shouldn't be running
into this.

>> > When doing the code you suggested, I end up with only marking the last 
>> > idle task to be created.
>> 
>> Odd. It is all a linked list through the task structures.
>> I'm guessing the initialization isn't quite right.
>> 
>> Weird.  
>
> Do I need to change the loop to do_each_pid_thread?

> I'll try that later today.

I don't think so.  I'm pretty certain we aren't passing the necessary
clone flags to make that case work for idle threads, and in fact we aren't
even cloning from the idle task when we create additional idle threads
so I don't see how do_each_pid_thread could work better.

That said do_each_pid_thread appears to be a proper superset of
do_each_pid_task so it should not be harmful.

I am all for figuring out how to remove this special case if we can.

Eric
