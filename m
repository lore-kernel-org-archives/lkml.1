Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZBYEQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZBYEQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:16:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbZBYEQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:16:41 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:47419 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbZBYEQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:16:40 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <200902232239.05926.rjw@sisk.pl>
	<m1iqn01ph3.fsf@fess.ebiederm.org> <200902242342.07721.rjw@sisk.pl>
	<alpine.LFD.2.00.0902241449221.3111@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 24 Feb 2009 20:16:56 -0800
In-Reply-To: <alpine.LFD.2.00.0902241449221.3111@localhost.localdomain> (Linus Torvalds's message of "Tue\, 24 Feb 2009 14\:51\:45 -0800 \(PST\)")
Message-ID: <m18wnvup53.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: torvalds@linux-foundation.org, tglx@linutronix.de, jbarnes@virtuousgeek.org, lenb@kernel.org, linux-pm@lists.linux-foundation.org, jeremy@goop.org, benh@kernel.crashing.org, linux-kernel@vger.kernel.org, mingo@elte.hu, rjw@sisk.pl
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Tue, 24 Feb 2009, Rafael J. Wysocki wrote:
>>
>> > The only safe way on x86 to shutdown a level triggered ioapic irq
>> > outside of irq context is for the driver to program the hardware to
>> > not generate an irq.
>> 
>> Well, that changes things quite a bit, because it means we can't change the
>> suspend-resume sequence in a way we thought we could without fixing all
>> drivers first, but this is exactly what we'd like to avoid by changing the
>> core.
>
> Calling "disable_irq()" is perfectly fine.

Agreed, I did not mean to indicate otherwise.

> What is not possible on that broken IO-APIC (among other things) is to 
> actually turn the interrupts off at the apic (ie the whole ->shutdown() 
> thing). But that's not what we even want to do. What we care about is 
> just disabling the interrupt from a drievr perspective.
>
> IOW, the patches I have seen are fine, and all the comments from Eric are 
> just confusion about what we want done.

Largely yes.

> WE DO NOT WANT TO TURN OFF THE IO-APIC. That may or may happen later, but 
> that's totally unrelated to this whole "suspend_device_irq()" thing.

Right.

The question I was asking is:
Can we get the broken cpu hotunplug code out of the suspend path?

If we can get the devices into a low power state and not generating
interrupts by the time we disable cpus then we do not need to migrate
irqs from process context and risk hitting the ioapic bugs.

While related safely suspending cpus is a different problem and a
different patch.

Eric
