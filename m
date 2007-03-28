Return-Path: <linux-kernel-owner+w=401wt.eu-S934026AbXC1JNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbXC1JNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 05:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934168AbXC1JNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 05:13:15 -0400
Received: from www.osadl.org ([213.239.205.134]:57409 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934062AbXC1JNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 05:13:14 -0400
Subject: Re: [PATCH] i386: disable local apic timer via command line or dmi
	quirk
From: Thomas Gleixner <tglx@linutronix.de>
To: Len Brown <lenb@kernel.org>
Cc: Stefan Prechtel <stefan.prechtel@googlemail.com>, Andi Kleen <ak@suse.de>,
       Grzegorz Chwesewicz <grzegorz.chwesewicz@chilan.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <200703272328.34685.lenb@kernel.org>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <b93822910703210604w6bcc2e1dt4cac7f9f9295edf8@mail.gmail.com>
	 <1174486483.10840.89.camel@localhost.localdomain>
	 <200703272328.34685.lenb@kernel.org>
Content-Type: text/plain
Date: Wed, 28 Mar 2007 11:13:10 +0200
Message-Id: <1175073190.4017.14.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len,

On Tue, 2007-03-27 at 23:28 -0400, Len Brown wrote:
> Is this failure specific to NO_HZ, and that is why the "nolapic_timer" fix is i386 only?
> I'm running 2.6.21-rc5 an nx6325 here in 64-bit mode and I don't see the dramatic
> boot failure described earlier in this thread.

The difference between x86_64 and i386 is that on i386 we now switch off
the PIT and do the jiffies increment in the local apic timer interrupt.
This is necessary for NO_HZ and HIGH_RES_TIMERS. We just fall back to
the PIT in C3 (enforced to C2 now due to massive breakage).

You can see the same problem on x86_64 by adding "apicmaintimer" to the
kernel command line. This should make your box really slow.

> However, I have observed that when running on battery,
> the LOC falls behind the irq0 timer to the tune of about
> 2 interrupt/minute.  eg. when i booted my machine, LOC was
> behind irq0 by 50, and now about a 20 minutes later it is behind
> irq0 by 99.  However, the LOC for each processor remain at
> a constant offset with respect to each other.
> 
> I do not see these this drift when running on AC.
> Yes, the system exports just C1 in both cases.

Right, but it does bad magic when running on battery. The offsets you
observe are due to the LAPIC stops. The delta is rather small, because
you wake up via the PIT periodically, so the APICs start to run as well.
And they do it on both cores.

Someone should apply a huge clue stick to BIOS developers.

I have some experimental code to detect the LAPIC breakage during run
time, but this needs more thought and is definitely not 2.6.21 material.

> Other oddities is the IRQ name on irq0 is garbled:
> 
> lenb@nx6325:~> uname -a; cat /proc/interrupts; sleep 100; cat /proc/interrupts
> Linux nx6325 2.6.21-rc5 #37 SMP Tue Mar 27 22:26:00 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux
>            CPU0       CPU1
>   0:     723812          0    <NULL>-edge      timer

Hrmpf. Ingo ???

	tglx


