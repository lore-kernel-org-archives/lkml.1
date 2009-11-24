Return-Path: <linux-kernel-owner+w=401wt.eu-S934340AbZKXXGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340AbZKXXGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934172AbZKXXGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:06:35 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:56700 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934154AbZKXXGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:06:35 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dimitri Sivanich <sivanich@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20091120211139.GB19106@sgi.com>
	<m1r5rrr9v5.fsf@fess.ebiederm.org> <20091122011457.GA16910@sgi.com>
	<alpine.LFD.2.00.0911241246470.24119@localhost.localdomain>
	<1259069986.4531.1453.camel@laptop>
	<alpine.LFD.2.00.0911241443110.24119@localhost.localdomain>
	<20091124065022.6933be1a@infradead.org>
	<m1ws1f6csh.fsf@fess.ebiederm.org> <20091124214121.GA15182@sgi.com>
	<alpine.LFD.2.00.0911242243160.24119@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 24 Nov 2009 15:06:33 -0800
In-Reply-To: <alpine.LFD.2.00.0911242243160.24119@localhost.localdomain> (Thomas Gleixner's message of "Tue\, 24 Nov 2009 22\:51\:32 +0100 \(CET\)")
Message-ID: <m1ljhvwmiu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Thomas Gleixner <tglx@linutronix.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v6] x86/apic: limit irq affinity
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> Please do not put anything complex into x86 code at all. Such designs
> are likely to happen on other architectures and as I said before we
> want to have
>
> 1) the decision function what's valid and not in the generic code

For the UV problem I don't have an issue.    assign_irq_vector
enforces some rules that I don't see being able to expose
to user space.

> 2) a way to expose that information as part of the irq interface to
>    user space.

-EINVAL?

> So what's wrong with a per irq_chip function which returns the cpumask
> which is valid for irq N ?

I have no problems with a generic function to do that.

> That function would be called to check the affinity mask in
> set_irq_affinity and to dump the mask to /proc/irq/N/possible_cpus or
> whatever name we agree on.
>
> That way we don't have to worry about where in the x86 code the
> decision should reside as you simply would always get valid masks from
> the core code.

Impossible.  assign_irq_vector is the only function that can tell you
if a mask is valid or not.  Currently we support roughly 240 irqs
per cpu.  Currently we support more than 240 irqs.   I don't see
how you can enforce that limit.

Furthermore irq migration on x86 is a very non-trivial exercise.
We must wait until we get a new irq at the new location before
we cleanup the irq state at the old location, to ensure that the
state change has gone through.  At which point again we can not
know.

So Thomas the logical conclusion that you are requesting.  An
architecture specific interface for migrating irqs that does not
need to return error codes because the generic code has enough
information to avoid all problem cases is not going to happen.
It is totally unreasonable.

> That just works and is neither restricted to UV nor to x86.

Doing it all in the core totally fails as it gets the initial irq
assignment wrong.

Last I looked set_irq_affinity was a horribly broken interface.  We
can not return error codes to user space when they ask us to do the
impossible.  Right now irq->affinity is a hint that occasionally we
ignore when what it requests is impossible.

....

Thomas my apologies for ranting but I am extremely sensitive about
people placing demands on the irq code that would be very convenient
and simple for the rest of the world, except that the hardware does not
work the way people envision it should work.  The worst offender is
the cpu hotunplug logic that requests we perform the impossible when
it comes to irq migration.  In the case of UV I expect cpu hotplug is
going to request we migrate irqs to another node.

Right now a lot of the generic irq code is living in a deluded fantasy and
I really don't want to see more impossible requests from the irq code
added to the pile.

...

The architecture specific function setup_irq_vector has all of the
information available to it to make the decision.  We use it
consistently everywhere.  For the case of UV it needs to know about
another possible hardware limitation, to do it's job.  I am happy
if that information comes from an architecture agnostic source but
making the decision somewhere else is just a guarantee that we will
have more subtle breakage that occasionally fail for people but at
too low a rate that people will care enough to fix.

Eric
