Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbZDLTcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbZDLTcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 15:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZDLTcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 15:32:23 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60803 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbZDLTcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 15:32:22 -0400
To: Gary Hade <garyhade@us.ibm.com>
Cc: mingo@elte.hu, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org, linux-kernel@vger.kernel.org, lcm@us.ibm.com
References: <20090408210735.GD11159@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 12 Apr 2009 12:32:11 -0700
In-Reply-To: <20090408210735.GD11159@us.ibm.com> (Gary Hade's message of "Wed\, 8 Apr 2009 14\:07\:35 -0700")
Message-ID: <m1ljq5r7lw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: garyhade@us.ibm.com, lcm@us.ibm.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gary Hade <garyhade@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 2/3] [BUGFIX] x86/x86_64: fix CPU offlining triggered inactive device IRQ interrruption
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade <garyhade@us.ibm.com> writes:

> Impact: Eliminates a race that can leave the system in an
>         unusable state
>
> During rapid offlining of multiple CPUs there is a chance
> that an IRQ affinity move destination CPU will be offlined
> before the IRQ affinity move initiated during the offlining
> of a previous CPU completes.  This can happen when the device
> is not very active and thus fails to generate the IRQ that is
> needed to complete the IRQ affinity move before the move
> destination CPU is offlined.  When this happens there is an
> -EBUSY return from __assign_irq_vector() during the offlining
> of the IRQ move destination CPU which prevents initiation of
> a new IRQ affinity move operation to an online CPU.  This
> leaves the IRQ affinity set to an offlined CPU.
>
> I have been able to reproduce the problem on some of our
> systems using the following script.  When the system is idle
> the problem often reproduces during the first CPU offlining
> sequence.

Ok.  I have had a chance to think through what you your patches
are doing and it is assuming the broken logic in cpu_down is correct
and patching over some but not all of the problems.

First the problem is not migrating irqs when IRR is set.  The general
problem is that the state machines in most ioapics are fragile and
can get confused if you reprogram them at any point when an irq can
come in.  In the middle of an interrupt handler is the one time we
know interrupts can not come in.

To really fix this problem we need to do two things.
1) Tack when irqs that can not be migrated from process context are
   on a cpu, and deny cpu hot-unplug.
2) Modify every interrupt that can be safely migrated in interrupt context
   to migrate irqs in interrupt context so no one encounters this problem
   in practice.

We can update MSIs and do a pci read to know when the update has made it
to a device.  Multi MSI is a disaster but I won't go there.

In lowest priority delivery mode when the irq is not changing domain but
just changing the set of possible cpus the interrupt can be delivered to.

And then of course all of the fun iommus that remap irqs.

Eric
