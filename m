Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbZBTEFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbZBTEFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 23:05:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZBTEEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 23:04:55 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:36185 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbZBTEEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 23:04:54 -0500
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
	<m1wsblq2jx.fsf@fess.ebiederm.org>
	<20090220031004.331EDFC2F7@magilla.sf.frob.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Feb 2009 20:05:11 -0800
In-Reply-To: <20090220031004.331EDFC2F7@magilla.sf.frob.com> (Roland McGrath's message of "Thu\, 19 Feb 2009 19\:10\:04 -0800 \(PST\)")
Message-ID: <m11vttn47c.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: roland@redhat.com, linux-kernel@vger.kernel.org, containers@lists.osdl.org, daniel@hozac.com, akpm@osdl.org, sukadev@linux.vnet.ibm.com, oleg@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Roland McGrath <roland@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2066]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid ns boundary
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath <roland@redhat.com> writes:

>> > think it would be best to fully elucidate what we think about desireable
>> > semantics for the whole spectrum of cross-NS signal-sending cases before
>> > actually choosing the implementation details.
>
> ... and then you answered all the questions that are already well settled,
> and did not address the new question that you had raised earlier today.

Oh sorry.  I misunderstood what you were asking.

> To which processes should a pgrp-wide signal sent from user mode inside a
> pid_ns go?  Should they go to a pgrp member in a different pid_ns, or not?
>
> If your answer is that you don't care, my inclination is to leave it as it
> is ("my pgrp" can include processes outside your pid_ns, which you could
> not explicitly target in any other way).  The way we are going just for the
> sake of cleanliness happens to make the si_pid values all work out right
> for this.  Possibly the semantics are even what you want: If e.g. the
> sub-init acts like many terminal apps and might use the tty in raw mode but
> then handle something like ^Z by fiddling the tty and then kill(0,SIGTSTP)
> to act like ^Z was hit in cooked mode, then this preserves the proper
> effect of that suspending a whole script/pipeline.

As it is are the easiest and most intuitive semantics to me.  It is
simply weird to people expecting that signals will never exit out of a
pid namespace.  Additionally I like having a prominent easy to create
case because it makes it much easier for people to realize it can
happen.

What I don't have is a compelling usage that means we must send to
every process in our process group if our process group spans multiple
pid namespaces.  Your description of manually implementing ^Z sounds
as close as I can come to a compelling case.

I simply have a compelling case for process groups and sessions that
span pid namespaces where the tty sends the signals to all of the
processes.

A nearly compelling case for the current process group semantics
and comes from using pid namespaces as inescapable process groups.
In that use case I would find it very convenient to be able to
set SIGCHLD to SIG_IGN and exec an arbitrary program a pid namespace
leader.

Ouch!

I have just recalled a use case that will cause problems with the
current ignoring of signals in this patchset.  Currently a container
init can not send SIGSTOP to itself.  And I have been taking advantage
of that in usages such as supporting the bash suspend command or the
M-x suspend-emacs.  And it is very handy for getting back to a shell
outside of a chroot like container.  SIGTSTP will still work, but
SIGSTOP which I'm pretty certain bash sends itself will not.

So I have the question.  How few special cases do we need to implement
to signal handling in a container init and still support running
programs written to be /sbin/init, on linux.  Can we limit this our
special case to just ignoring SIGKILL and SIGSTOP when sent from other
process in the same pid namespace?  Or do we actually need more?

>> Another case where we can send signals between namespaces is posix
>> message queues.  Implemented in ipc/mqueue.c.  In that case because it
>> is a unicast message we are generating the proper si_pid when we
>> generate the signal.
>
> Ah, this is the clear example of "any to any", since all the sender and
> recipient have to share is the mqueue they each have a descriptor on.
> But, as you say, it's got no problems because the sender is just
> "current in mq_timedsend" to a single recipient, no different than
> "current in sys_kill" when that is going to a single recipient.

I suspect there are others buried in the kernel somewhere or there
will be others in the future.  We have a very similar pattern with
fcntl and SIGIO and SIGURG, but they all look they are coming from the
kernel.  Everything except the tty code appears to slowly approach
the general case.

>> I think that is where we need to go, to be safe and to be certain
>> weird things won't sneak up on us.  We already handle half of the logic in
>> send_signal anyway.  We might as well handle the other half.
>
> Agreed.


Eric
