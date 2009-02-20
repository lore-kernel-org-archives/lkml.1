Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbZBTDLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbZBTDLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZBTDL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:11:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZBTDL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:11:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@osdl.org>, daniel@hozac.com,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7][v8] SI_USER: Masquerade si_pid when crossing pid ns boundary
In-Reply-To: Eric W. Biederman's message of  Thursday, 19 February 2009 18:12:34 -0800 <m1wsblq2jx.fsf@fess.ebiederm.org>
References: <20090219030207.GA18783@us.ibm.com>
	<20090219030743.GG18990@us.ibm.com>
	<m1y6w21k6d.fsf@fess.ebiederm.org>
	<20090219185159.GA374@redhat.com>
	<m1fxiayss9.fsf@fess.ebiederm.org>
	<20090219223137.GA10378@redhat.com>
	<m1fxiaxbb5.fsf@fess.ebiederm.org>
	<20090219235159.6A542FC3BE@magilla.sf.frob.com>
	<m1bpsyt05t.fsf@fess.ebiederm.org>
	<20090220010600.DCEA7FC2F7@magilla.sf.frob.com>
	<m1wsblq2jx.fsf@fess.ebiederm.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090220031004.331EDFC2F7@magilla.sf.frob.com>
Date: Thu, 19 Feb 2009 19:10:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > think it would be best to fully elucidate what we think about desireable
> > semantics for the whole spectrum of cross-NS signal-sending cases before
> > actually choosing the implementation details.

... and then you answered all the questions that are already well settled,
and did not address the new question that you had raised earlier today.

To which processes should a pgrp-wide signal sent from user mode inside a
pid_ns go?  Should they go to a pgrp member in a different pid_ns, or not?

If your answer is that you don't care, my inclination is to leave it as it
is ("my pgrp" can include processes outside your pid_ns, which you could
not explicitly target in any other way).  The way we are going just for the
sake of cleanliness happens to make the si_pid values all work out right
for this.  Possibly the semantics are even what you want: If e.g. the
sub-init acts like many terminal apps and might use the tty in raw mode but
then handle something like ^Z by fiddling the tty and then kill(0,SIGTSTP)
to act like ^Z was hit in cooked mode, then this preserves the proper
effect of that suspending a whole script/pipeline.

> There are cases that happen, and it very much simplifies dealing with
> tty's if we allow it.

I don't call tty signals "sending a signal to outside the PID namespace".
I suspect Oleg did not intend it to be read that way either.  To me, a tty
signal comes from "the device"--not from some process--and I presume all
such sources we'd consider to "live in the global namespace" (really they
just don't exist in any PID namespace, they aren't processes).  So I don't
think Oleg's comment is meant to apply to such cases at all.

> Another case where we can send signals between namespaces is posix
> message queues.  Implemented in ipc/mqueue.c.  In that case because it
> is a unicast message we are generating the proper si_pid when we
> generate the signal.

Ah, this is the clear example of "any to any", since all the sender and
recipient have to share is the mqueue they each have a descriptor on.
But, as you say, it's got no problems because the sender is just
"current in mq_timedsend" to a single recipient, no different than
"current in sys_kill" when that is going to a single recipient.

> I think that is where we need to go, to be safe and to be certain
> weird things won't sneak up on us.  We already handle half of the logic in
> send_signal anyway.  We might as well handle the other half.

Agreed.


Thanks,
Roland
