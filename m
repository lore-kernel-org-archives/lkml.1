Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbZFCM11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbZFCM11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 08:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbZFCM1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 08:27:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36353 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbZFCM1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 08:27:17 -0400
To: Gary Hade <garyhade@us.ibm.com>
Cc: mingo@elte.hu, mingo@redhat.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org, yinghai@kernel.org,
       lcm@us.ibm.com
Subject: Re: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining triggered "active" device IRQ interrruption
References: <20090602193216.GC7282@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 03 Jun 2009 05:27:13 -0700
In-Reply-To: <20090602193216.GC7282@us.ibm.com> (Gary Hade's message of "Tue\, 2 Jun 2009 12\:32\:16 -0700")
Message-ID: <m1y6s9qz8e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: garyhade@us.ibm.com, lcm@us.ibm.com, yinghai@kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@redhat.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade <garyhade@us.ibm.com> writes:

> Impact: Eliminates an issue that can leave the system in an
>         unusable state.
>
> This patch addresses an issue where device generated IRQs
> are no longer seen by the kernel following IRQ affinity
> migration while the device is generating IRQs at a high rate.
>
> I have been able to consistently reproduce the problem on
> some of our systems by running the following script (VICTIM_IRQ
> specifies the IRQ for the aic94xx device) while a single instance
> of the command
>   # while true; do find / -exec file {} \;; done
> is keeping the filesystem activity and IRQ rate reasonably high.

To be 100% clear.

If masking and checking to see if the irq was already pending was
sufficient to migrate irqs in process context was enough to
safely migrate irqs in process context then that is how we would
always do it.  I have been down that road and down some extensive
testing in the past.

I found hardware bugs in both AMD and Intel IOAPIC that make your
code demonstrably unsafe.

I was challenged by some of the software guys from Intel and eventually
the came back and told me they had talked with their hardware engineers
and I was correct.

So no.  This code is totally and severely broken and we should not do
it.

You are introducing complexity and heuristics to avoid the fact that
fixup_irqs is fundamentally broken.  Sure you might tweak things
so they work a little more often.

> The root cause is a known issue already addressed for some
> code paths [e.g. ack_apic_level() and the now obsolete
> migrate_irq_remapped_level_desc()] where the ioapic can
> misbehave when the I/O redirection table register is written
> while the Remote IRR bit is set.

No the reason we do this is not because of the IRR.  Although
that certainly does not help.

We do this because it is not in general safe to do complicated
reprogramming to the ioapic while the hardware may send an
irq.  You can lock up the hardware state machine etc.

If the work around was as simple as you propose a delayed work or busy
waiting until the irq handler was complete variant would have been
written and used long ago.

So my reaction to this horrible afterthought is 
NO NO NO NO NO NO NO NO NO NO NO NO NO NO NO NO NO NO NO NO NO NO
PLEASE NO.

Eric
