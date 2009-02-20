Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbZBTAfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbZBTAfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 19:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZBTAfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 19:35:42 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:42136 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZBTAfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 19:35:41 -0500
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
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Feb 2009 16:35:58 -0800
In-Reply-To: <20090219235159.6A542FC3BE@magilla.sf.frob.com> (Roland McGrath's message of "Thu\, 19 Feb 2009 15\:51\:59 -0800 \(PST\)")
Message-ID: <m1bpsyt05t.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: roland@redhat.com, linux-kernel@vger.kernel.org, containers@lists.osdl.org, daniel@hozac.com, akpm@osdl.org, sukadev@linux.vnet.ibm.com, oleg@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Roland McGrath <roland@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0088]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid ns boundary
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> writes:

>> Suppose I have 3 processes in a process group in three separate pid
>> namespaces.
>> 
>> Looking from the init pid namespace I have:
>>      pid pgrp ppid
>>       10 10    1
>>       11 10    10
>>       12 10    11
>> 
>> Looking from the pid namespace of pid 11 I have:
>>      pid pgrp ppid
>>       0  0     0
>>       1  0     0
>>       2  0     1
>> 
>> Looking from the pid namespace of pid 12 I have:
>>      pid pgrp ppid
>>       0  0     0
>>       0  0     0
>>       1  0     0
>> 
>> So if the process with pid 12 in the initial pid namespace
>> sends to process group 0.
>
> There is no "process group 0".  0 means "the sender's pgrp".

Exactly.  It just happens in this case that pid_nr_ns returns 0 for
the process group number as well as the process group the process is a
member of, that was created outside of the current pid namespace.

> One possibility is that perhaps what people really want the pid_ns to mean
> is that "the sender's pgrp" in the view of the sender does not include any
> processes outside its pid_ns scope.  That would be consistent with the
> behavior of kill (kill_something_info) on -1; it's described as "all
> processes", but in fact means "all processes within my pid_ns scope".
>
> What I mean to describe there is changing kill_something_info, so that
> e.g. killpg() inside the NS would affect only the NS init itself but e.g.
> ^Z (effectively an implicit killpg() that's always from the global NS)
> would also go to that init's "mother" pgrp in the outer NS.

> Another possibility is to decide that's just not worth having at all, and
> CLONE_NEWNS should just implicitly reset pgrp to self.  That is simple.
> But perhaps today someone has a script running a pid_ns-world whose init is
> gracefully killed by ^C of the whole script and we wouldn't want to break
> that if it is actually useful now.

It is especially useful, and this is a deliberate feature.  Having
sessions and process groups extend across pid namespace borders means
you can share a tty and job control functions correctly.  Very handy
for circumstances where you want a light weight temporary container,
and something I am actively using today.  The practical benefit is
that you can upgrade from situations where you would previous use
chroot without extra hassle.

In practice I don't care about si_pid and I doubt I care about processes
sending signals outside of their pid namespace.  But I do care about
sharing a tty and a session and having job control work.

>> pid 10 should see si_pid 12.
>> pid 11 should see si_pid 2.
>
> We indeed have this problem if we think it's useful to continue to have
> a concept of pgrp for the sub-init that can see outside its own NS.
>
>> Neither should see si_pid 0, as from_ancestor_ns will not be true.
>
> Perhaps replace from_ancestor_ns with struct pid_namespace *sender_ns?
> (I don't know if there was already a can of worms with such an idea before.)
> Then si_pid could be translated as appropriate for each recipient.
> (Or perhaps just struct pid *sender and reset si_pid from that.)

The last was my original line of thinking.  I seem to recall Oleg
figuring the code gets pretty ugly when you add in the necessary test
to see if si_pid is actually present.

There are several other cases where we also signal a process outside
of our current pid namespace, where we have a pid inside the recipients
pid namespace.  do_notify_parent is the easiest example.  However those
cases can get the value right because they are unicast signals and
know their recipient when the set the si_pid originally.

My current line of thinking is either:
a) We pass in struct pid *sender and we reset si_pid in send_signal.
b) We make the rule that send_signal must receive a valid siginfo from
   the caller and we only do the extra work for process groups.

Eric
