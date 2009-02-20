Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbZBTCM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbZBTCM1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 21:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753115AbZBTCMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 21:12:18 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49428 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbZBTCMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 21:12:17 -0500
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@osdl.org>, daniel@hozac.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
References: <20090219030207.GA18783@us.ibm.com>
	<20090219030743.GG18990@us.ibm.com> <m1y6w21k6d.fsf@fess.ebiederm.org>
	<20090219185159.GA374@redhat.com> <m1fxiayss9.fsf@fess.ebiederm.org>
	<20090219223137.GA10378@redhat.com> <m1fxiaxbb5.fsf@fess.ebiederm.org>
	<20090219235159.6A542FC3BE@magilla.sf.frob.com>
	<m1bpsyt05t.fsf@fess.ebiederm.org>
	<20090220010600.DCEA7FC2F7@magilla.sf.frob.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Feb 2009 18:12:34 -0800
In-Reply-To: <20090220010600.DCEA7FC2F7@magilla.sf.frob.com> (Roland McGrath's message of "Thu\, 19 Feb 2009 17\:06\:00 -0800 \(PST\)")
Message-ID: <m1wsblq2jx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: roland@redhat.com, linux-kernel@vger.kernel.org, containers@lists.osdl.org, daniel@hozac.com, akpm@osdl.org, sukadev@linux.vnet.ibm.com, oleg@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Roland McGrath <roland@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0017]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid ns boundary
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> writes:

>> It is especially useful, and this is a deliberate feature.  
>
> Ok, I thought that might be so.
>
>> In practice I don't care about si_pid and I doubt I care about processes
>> sending signals outside of their pid namespace.  But I do care about
>> sharing a tty and a session and having job control work.
>
> Understood.
>
>> >> pid 10 should see si_pid 12.
>> >> pid 11 should see si_pid 2.
>> >
>> > We indeed have this problem if we think it's useful to continue to have
>> > a concept of pgrp for the sub-init that can see outside its own NS.
>> >
>> >> Neither should see si_pid 0, as from_ancestor_ns will not be true.
>> >
>> > Perhaps replace from_ancestor_ns with struct pid_namespace *sender_ns?
>> > (I don't know if there was already a can of worms with such an idea before.)
>> > Then si_pid could be translated as appropriate for each recipient.
>> > (Or perhaps just struct pid *sender and reset si_pid from that.)
>> 
>> The last was my original line of thinking.  I seem to recall Oleg
>> figuring the code gets pretty ugly when you add in the necessary test
>> to see if si_pid is actually present.
>
> Well, the existing test to set from_ancestor_ns is in one place and we
> think that its logic is OK.  What I had in mind was that when that logic
> says "0", we pass NULL and the innards don't touch .si_pid (same as now);
> when it says "1", we pass a pointer and the innards do rewrite it.
>
>> There are several other cases where we also signal a process outside
>> of our current pid namespace, where we have a pid inside the recipients
>> pid namespace.  do_notify_parent is the easiest example.
>
> It's the only example that Oleg has mentioned.  What others are there?
>
>> a) We pass in struct pid *sender and we reset si_pid in send_signal.
>> b) We make the rule that send_signal must receive a valid siginfo from
>>    the caller and we only do the extra work for process groups.
>
> That's what I said. ;-) The a) option seems cleaner to me regardless, to
> the extent that the "from_ancestor_ns" approach is a "clean" one.  But I
> think it would be best to fully elucidate what we think about desireable
> semantics for the whole spectrum of cross-NS signal-sending cases before
> actually choosing the implementation details.

With respect to si_pid I think the value should be:
    pid_nr_ns(sender, task_active_pid_ns(tsk));

With respect to init receiving signals.  
- SIGKILL and SIGSTOP are ignored not coming from an ancestor pid
  namespace.

For the other signals since init can set it's handlers I really
don't care how we handle them.  If we treat them all normally
/sbin/init should work fine.

For signals from the kernel I'm inclined to always call those from an
ancestor pid namespace.  It seems we don't have any legitimate reason
to special case signals ignoring that we either asked for or that if
we don't handle will cause an infinite signal handling loop in
/sbin/init.

But as long as we get si_pid set correctly and we get handling of SIGKILL
and SIGSTOP correct.  I'm happy.


Eric
