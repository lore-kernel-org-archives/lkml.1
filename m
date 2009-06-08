Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbZFHTTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbZFHTTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZFHTTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:19:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45812 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZFHTTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:19:34 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Gary Hade <garyhade@us.ibm.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org, yinghai@kernel.org, lcm@us.ibm.com
References: <20090602193202.GB7282@us.ibm.com>
	<m1hbyxv8ep.fsf@fess.ebiederm.org> <20090604163840.GB7233@us.ibm.com>
	<20090607095403.GG31286@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 08 Jun 2009 12:19:30 -0700
In-Reply-To: <20090607095403.GG31286@elte.hu> (Ingo Molnar's message of "Sun\, 7 Jun 2009 11\:54\:03 +0200")
Message-ID: <m1hbyqcz3x.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: mingo@elte.hu, lcm@us.ibm.com, yinghai@kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@redhat.com, garyhade@us.ibm.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: lkml.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining triggered "inactive" device IRQ interrruption
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Gary Hade <garyhade@us.ibm.com> wrote:
>
>> On Wed, Jun 03, 2009 at 04:55:26AM -0700, Eric W. Biederman wrote:
>> > Gary Hade <garyhade@us.ibm.com> writes:
>> > 
>> > > Impact: Eliminates a race that can leave the system in an
>> > >         unusable state
>> > >
>> > > During rapid offlining of multiple CPUs there is a chance
>> > > that an IRQ affinity move destination CPU will be offlined
>> > > before the IRQ affinity move initiated during the offlining
>> > > of a previous CPU completes.  This can happen when the device
>> > > is not very active and thus fails to generate the IRQ that is
>> > > needed to complete the IRQ affinity move before the move
>> > > destination CPU is offlined.  When this happens there is an
>> > > -EBUSY return from __assign_irq_vector() during the offlining
>> > > of the IRQ move destination CPU which prevents initiation of
>> > > a new IRQ affinity move operation to an online CPU.  This
>> > > leaves the IRQ affinity set to an offlined CPU.
>> > >
>> > > I have been able to reproduce the problem on some of our
>> > > systems using the following script.  When the system is idle
>> > > the problem often reproduces during the first CPU offlining
>> > > sequence.
>> > 
>> > Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> > 
>> > fixup_irqs() is broken for allowing such a thing.
>> 
>> When fixup_irqs() calls the set_affinity function:
>>                    ...
>>   if (desc->chip->set_affinity)
>>   	desc->chip->set_affinity(irq, affinity);
>>                    ...
>> it receives no feedback so it obviously expects the set_affinity
>> function or it's called functions to do the right thing by preventing
>> or correctly handling any problems that should arise.  In the case of
>> this bug there is obviously a problem happening during the set_affinity
>> function call that needs to be resolved and/or properly handled.
>> 
>> When you made your "x86_64 irq: Safely cleanup an irq after moving it."
>> changes (re: http://lkml.org/lkml/2007/2/23/92) you added the check
>> to __assign_irq_vector() that causes it to return -EBUSY if the
>> migration of the IRQ is still in progress:
>> +	if ((cfg->move_in_progress) || cfg->move_cleanup_count)
>> +		return -EBUSY;
>> +
>> However, you did not add any code to other functions on the
>> call stack to properly deal with this error.  When doing this
>> you may have assumed (as I may have also assumed) that the underlying
>> code was solid enough that the handling was not needed.  Unfortunately,
>> you apparently did not anticipate the case where an idle or relatively
>> idle device may not generate the IRQ needed to complete the move
>> before the CPU that is still handling that IRQ is offlined.
>> 
>> My fix only addresses the issue that caused the -EBUSY return
>> and subsequent mess.  It does not address the omitted handling
>> for this error condition.  If we were to add the handling to
>> fixup_irq() and the arch and non-arch specific functions above
>> it on the call stack as you may be suggesting, it would be quite
>> involved because of all the things that would need to be undone.
>> 
>> I am not certain that my fix plugs the very last hole that could 
>> cause the -EBUSY return from __assign_irq_vector() so maybe we 
>> should at least add a warning or BUG_ON to make the unhandled 
>> error more obvious in the future.  I would be happy to provide 
>> this via a separate patch.
>
> A WARN_ON_ONCE() patch would certainly be nice, as a reminder and as 
> a prodder-tool.

In fixup_irqs such a warning would be reasonable.  In assign_irq_vector
it makes no sense.

I just read through the code.  Anything that assumes assign_irq_vector
will always succeed is BROKEN.  We can not guarantee it.  There are
also memory allocation failures and the fundamental problem that we
may have more irqs than can fit on a single cpu.

Furthermore while we require at least two irqs to complete a irq migration
I don't believe we can avoid returning -EBUSY there.

I really really hate these patches that come out of assuming that fixup_irqs
is or ever was working and reasonable.

Eric
