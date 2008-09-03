Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYICSl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYICSl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbYICSlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:41:19 -0400
Received: from www.tglx.de ([62.245.132.106]:37189 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbYICSlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:41:18 -0400
Date: Wed, 3 Sep 2008 20:40:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
cc: Dmitry Nezhevenko <dion@inhex.net>, herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
In-Reply-To: <20080903143653.68bb58df@doriath.conectiva>
Message-ID: <alpine.LFD.1.10.0809032030271.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva> <alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de> <20080902175544.131bc54e@doriath.conectiva> <alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de> <20080903104132.7a736282@doriath.conectiva>
 <alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de> <20080903164415.GA24442@laptop.local> <alpine.LFD.1.10.0809031857020.3243@apollo.tec.linutronix.de>
 <20080903143653.68bb58df@doriath.conectiva>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Luiz Fernando N. Capitulino wrote:
> | Find a debug patch below, which looks at the two functions which might
> | loop forver under certain conditions. Does one of the checks hit ?
> 
>  I can actually boot with this patch. Was this intended?

Yes. That was the only point, where a hard hang could happen.
 
>  As the dmesg has various WARN_ON() outputs I'm attaching it, this is
> the first one:
> 
> """
> PCI: Using ACPI for IRQ routing
> DMAR:parse DMAR table failure.
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
> hpet0: 3 32-bit timers, 25000000 Hz
> Switched to high resolution mode on CPU 0
>
> tick_broadcast_set_event is stuck f09fa64 f0a01e4

Hmm, so we fail to force program that HPET with the standard minimum
delta.

I now see why this is happening and it is happening only on systems
with a fast HPET. Your's running 25MHz, so the delta is only 1.92
usec. I was staring at lots of those bugreports without noticing the
frequency.

Sigh. The idea to take a fixed number of HPET cycles as the minimum
was not really brilliant it seems.

Does the patch below help ? Keep the debug patch applied, as we can
see whether the check triggers or not.

Thanks,

	tglx
---
 arch/x86/kernel/hpet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/hpet.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/hpet.c
+++ linux-2.6/arch/x86/kernel/hpet.c
@@ -210,8 +210,8 @@ static void hpet_legacy_clockevent_regis
 	/* Calculate the min / max delta */
 	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
 							   &hpet_clockevent);
-	hpet_clockevent.min_delta_ns = clockevent_delta2ns(0x30,
-							   &hpet_clockevent);
+	/* 5 usec minimum reprogramming delta. */
+	hpet_clockevent.min_delta_ns = 5000;
 
 	/*
 	 * Start hpet with the boot cpu mask and make it

