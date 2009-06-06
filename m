Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZFFC6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZFFC6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 22:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZFFC6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 22:58:42 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48873 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZFFC6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 22:58:41 -0400
To: suresh.b.siddha@intel.com
Cc: "mingo\@elte.hu" <mingo@elte.hu>, "hpa\@zytor.com" <hpa@zytor.com>,
       "tglx\@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ak\@linux.intel.com" <ak@linux.intel.com>,
       "travis\@sgi.com" <travis@sgi.com>,
       "steiner\@sgi.com" <steiner@sgi.com>, Gary Hade <garyhade@us.ibm.com>
References: <1244141989.27006.10369.camel@localhost.localdomain>
	<m1iqjbd243.fsf@fess.ebiederm.org>
	<1244164694.27006.10374.camel@localhost.localdomain>
	<1244164783.27006.10375.camel@localhost.localdomain>
	<m1vdnb4fki.fsf@fess.ebiederm.org>
	<1244251170.27006.10537.camel@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 05 Jun 2009 19:58:31 -0700
In-Reply-To: <1244251170.27006.10537.camel@localhost.localdomain> (Suresh Siddha's message of "Fri\, 05 Jun 2009 18\:19\:30 -0700")
Message-ID: <m1my8mukyw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: suresh.b.siddha@intel.com, garyhade@us.ibm.com, steiner@sgi.com, travis@sgi.com, ak@linux.intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;suresh.b.siddha@intel.com
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [patch] x64: Avoid irq_chip mask/unmask in fixup_irqs for interrupt-remapping
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> On Thu, 2009-06-04 at 18:47 -0700, Eric W. Biederman wrote:
>> As far as this patch goes it looks like an improvement.
>> 
>> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Thanks. Ingo, Peter: Can you please queue this patch? Eric, more
> comments below.
>
>> However after looking at Gary's issues I see some things that are still wrong
>> on this path.
>> 
>> 1) We don't do the part of irq migration that moves irq threads.
>>    We aren't using irq threads yet but still
>> 
>
> Ok. Will look at the irq threads code (-rt tree?).

In 2.6.30  No one is using them yet but the code is merged.

>>    If we could figure out how to call irq_set_affinity for the IRQ_MOVE_PCNTXT
>>    code path that would make the maintenance a lot simpler.
>
> Ok. Will post this cleanup sometime.

Thanks.

>> 2) We still diverge on 32bit vs 64bit for no reason.
>>    I expect the fixed 64bit version should be moved into apic/io_apic.c
>
> Agree.
>
>> 
>> 3) We still enable irqs for a short while after this to let things drain.
>>    I am wondering if that is really necessary.    It does very simply
>>    allow the irq cleanup ipi to happen, and it unjams any irqs that happened
>>    before we migrated them.
>
> Yes.
>
>>    If we wanted to very strictly follow the rules I guess we could do something
>>    like the cleanup_ipi by hand on the cpu that is going down and rebroadcast
>>    all of the pending irqs to another cpu to process.
>> 
>
> This will be ok for all the cases except the most difficult case (non
> interrupt-remapping and IO-APIC level triggered). We should service the
> pending interrupt from the same cpu 'X' (that is going down) because of
> the vector information (that is cpu 'X' specific) in the IO-APIC RTE.
> Otherwise we have to do directed EOI ( and I am not sure if all the
> IO-APIC's support that) to the io-apic.
>
> Is there a problem with enabling irqs in the fixup_irqs()?

Strictly speaking it is against the rules.  At least it was last time
I audited the cpu hotunplug path.  In practice it seems to work well.

> My old proposal (which will fix the stuck IRR issue seen by Gary) for
> fixing the level irq migration in fixup_irqs() is to do something like:
>
> Disable interrupts
> ..
> Mask io-apic RTE
> check if the IRR is set
> if so,
>    unmask the io-apic RTE
>    enable interrupts
>    and go back to top
> else
>    ok to migrate the io-apic rte.
>
> So if there is any other reason for keeping the interrupts disabled
> during fixup_irqs(), then we need to think of another strategy to
> address this.

As long as fixup_irqs is where we grow the nasty work-arounds and
we don't burden the other saner paths.  I am generally in favor of it.

> Otherwise, If everyone agrees with this direction then we can try to
> comeup with a clean patch for this.

There is also something else we can do.  We can register a cpu hotplug
notifier and tell hotunplug to fail if we dealing with a case that
we can not actually support cleanly.

At the same time there are a couple of more case that we can move into
process context.  MSI cpu irq migration being the primary.

It needs a really good testing but I think all of lowest priority interrupt
delivery can be done safely from process context as well.  Since we only
need a single register write and if we have properly shutdown the cpu
the hardware just won't deliver irqs to it automagically.

My pipe dream is that we can move just enough irq migration cases into
process context that the suspend to ram code code will be happy.  And
we can make cpu hotunplug fail if the irqs are only safe to migrate
in interrupt context.

Eric
