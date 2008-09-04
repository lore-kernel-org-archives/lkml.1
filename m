Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbYIDPwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbYIDPwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYIDPwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:52:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55216 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYIDPwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:52:20 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Prarit Bhargava <prarit@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, arozansk@redhat.com, dzickus@redhat.com,
       Thomas.Mingarelli@hp.com, ak@linux.intel.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
From: Andi Kleen <andi@firstfloor.org>
References: <20080904130048.31841.3329.sendpatchset@prarit.bos.redhat.com>
	<1220535463.8609.223.camel@twins> <48BFF0C0.7060208@redhat.com>
	<20080904145617.GB28095@elte.hu>
Date: Thu, 04 Sep 2008 17:52:17 +0200
In-Reply-To: <20080904145617.GB28095@elte.hu> (Ingo Molnar's message of "Thu, 4 Sep 2008 16:56:17 +0200")
Message-ID: <87y727vrgu.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> i'd much rather attack this general problem from this angle:
>
>   static inline unsigned char get_nmi_reason(void)
>   {
>           return inb(0x61);
>   }
>
> that port 61H read is both arcane (on modern chipsets) and broken on 
> multiple levels.

Yes it is. I did some datasheet reading recently and unfortunately
there is no really standardized better way. So the only replacement
would be to have chipset specific NMI drivers that know 
the particular registers of the chipset.

 It's racy and SMP unsafe to begin with, if there's any 
> mixture of intentional cross-CPU or CPU self-generated NMIs mixed with 
> chipset generated NMIs.
>
> One possible approach would be to get rid of it, and to perhaps register 

Removing the IO port accesses by default would be a good idea
I agree. They are hardly useful for anything on modern systems.

But you still need some way to catch the chipset NMIs
and give some indication of the problem.

The way so far was to ask all the other sources (software NMIs
in memory flags, perfmon IPIs check perf ctrs, etc.) first 
and if it's none of them assume it's a chipset NMI
(or NMI button NMI if the sysctl is set).

Then if there's a chipset specific NMI driver it could
also check if the chipset raised it. That would be a possible
solution for HP -- they would need to implement such a driver
for their systems with the special watchdog.

Yes that's racy but the poor hardware support doesn't unfortunately 
leave much wiggling room to do better.

> a low-priority die notifier on systems where we know port 61 
> reads+writes to be safe and desired. Modern systems will emit MCEs in 
> most cases anyway, not NMIs.

The chipsets will still trigger NMIs (depending on their
configuration) -- e.g. on some PCI or internal errors -- they cannot
trigger MCEs directly.  Fortunately it's being replaced with PCI-AER
on PCI-Express, but PCI-X which doesn't do that is still very common
and shipping.

BTW the NMI handlers are also racy, it's not safe 
to call printk in a NMI handler. They really should be taught
to start using mce_log()

-Andi
-- 
ak@linux.intel.com
