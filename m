Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbYLLAp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbYLLAp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 19:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbYLLApt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 19:45:49 -0500
Received: from mga14.intel.com ([143.182.124.37]:41409 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033AbYLLAps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 19:45:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,207,1228118400"; 
   d="scan'208";a="89308280"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Jiri Bohac <jbohac@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>
Date: Thu, 11 Dec 2008 16:46:29 -0800
Subject: RE: [RFC] Use HPET timers in 64-bit mode
Thread-Topic: [RFC] Use HPET timers in 64-bit mode
Thread-Index: AclIDVfqBgDr/3EkS/mQysQWwsvFbwT5MBOg
Message-ID: <7E82351C108FA840AB1866AC776AEC4643256D13@orsmsx505.amr.corp.intel.com>
References: <20081116170404.GB29009@midget.suse.cz>
In-Reply-To: <20081116170404.GB29009@midget.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Jiri Bohac [mailto:jbohac@suse.cz] 
>Sent: Sunday, November 16, 2008 9:04 AM
>To: Pallipadi, Venkatesh; Thomas Gleixner; lkml
>Subject: [RFC] Use HPET timers in 64-bit mode
>
>Hi,
>
>the kernel uses the HPET timers in 32-bit mode for clock-events.
>While 32 bits, with a wrap-around time of >4 minutes, is probably
>good enough for the clock-event purposes, on some chipsets this
>has a negative side-effect on the HPET main counter.
>
>Unlike the original HPET specification 1.0 from 2004, which does not
>mention any side-effects of setting TN_32MODE_CNF on the
>individual timers, the ICH9 documentation, for example, says:
>
>    NOTE: When this bit is set to '1', the hardware counter will
>    do a 32-bit operation on comparator match and rollovers, thus
>    the upper 32-bit of the Timer 0 Comparator Value register is
>    ignored. The upper 32-bit of the main counter is not involved
>    in any rollover from lower 32-bit of the main counter and
>    becomes all zeros.
>
>(see http://www.intel.com/assets/pdf/datasheet/316972.pdf, page
>819, section 21.1.5, Bit 8). I've seen this behaviour also on
>ICH8. I have no idea what other chipsets are affected. But I have
>seen AMD chipsets that Do The Right Thing.
>
>This means, that when the kernel configures the Timer 0 to 32-bit
>mode, on these chipsets it also cripples the 64-bit main counter
>to 32 bits.
>
>The HPET may be mmapped in userspace and the main counter
>accessed directly by applications, expecting a 64-bit main
>counter.
>
>I see two fays this could be fixed:
>1) do not use Timer 0 at all
>2) do not configure 64-bit capable timers to 32-bit mode
>
>The patch below is my attempt to do 2). I did not yet have a
>chance to test it (!!) as I don't have the affected hardware
>right here. I can do that next week. I did, however, test a
>previous x86_64-only version of the patch and it fixed the
>problem.
>
>I would like to get your opinions. I am worried about some of the
>32-bit parts:
>
>1) setting the timer value in periodic mode. The documentation
>says that the TN_SETVAL bit is automatically cleared when the
>value is written. I assume that any write within the 64-bit will
>reset the bit and we thus need to set it indivdually for the low
>and high 32 bits?
>
>2) setting the timer period. The documentation says:
>        After the main counter equals the value in this register,
>        the value in this register is increased by the value last
>        written to the register.
>
>I can only assume that writing the register in multiple writes
>does not matter. But to be on the safe side, hpet_write64()
>writes the (usually zero) high-order bits first.
>

Sorry about the delayed response. We can use HPET in 64 bit mode
with 64 bit kernel. But, doing so with 32 bit kernel will be a
problem. That is one of the main reasons why we always just used
32 bit counters.

Specifically this in the patch
>+       do {
>+               high = hpet_readl(HPET_COUNTER + 4);
>+               low   = hpet_readl(HPET_COUNTER);
>+               high2 = hpet_readl(HPET_COUNTER + 4);
>+       } while (high2 != high);

A single read of HPET is expensive (off the order of 2000 cycles).
3 reads like this multiplies it by 3 and that happens in a
common code path of hpet_next_event().

Compared to that with emulating the 2 or 3 other HPET timers to
be 64 bit using 32 bit base. That will cause 2 or 3 extra interrupts
for every 4 mins (overflow). That may be much lower overhead. There
May be accuracy issues that we have to deal in emulating. But,
still 3 hpet reads in place of 1, in common path, will be the deal killer.

Thanks,
Venki
