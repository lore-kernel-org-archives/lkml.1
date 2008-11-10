Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbYKJRhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbYKJRhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 12:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYKJRho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 12:37:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50846 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbYKJRho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:37:44 -0500
Date: Mon, 10 Nov 2008 18:46:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile: re-arm APIC_DM_NMI in ppro_check_ctrs()
Message-ID: <20081110174647.GX29626@one.firstfloor.org>
References: <20081107171339.GQ9785@erda.amd.com> <4917EB51.9020304@cosmosbay.com> <87ljvsott2.fsf@basil.nowhere.org> <491843C4.9090306@cosmosbay.com> <20081110154948.GW29626@one.firstfloor.org> <49185828.4090306@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49185828.4090306@cosmosbay.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 04:50:00PM +0100, Eric Dumazet wrote:
> Andi Kleen a écrit 


Can you send the /proc/cpuinfo output privately please?
I can ask around here.

> >> 			oprofile_add_sample(regs, i);
> >>+			/*
> >>+			 * We need to unmask the apic vector *before*
> >>+			 * writing reset_value to msr counter
> >>+			 */
> >>+			apic_write(APIC_LVTPC, APIC_DM_NMI);
> >> 			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
> >> 		}
> >> 	}
> >> 
> >>-	/* Only P6 based Pentium M need to re-unmask the apic vector but it
> >>-	 * doesn't hurt other P6 variant */
> >>-	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
> >
> >Did you also test if it really needs to be inside the if () or 
> >just before the wrmsrl? 
> 
> 
> In my testings, the "if (CTR_OVERFLOWED())" condition is always true.
> 
> (I am profiling one event only)

There can be other valid (but rare) cases of NMIs. The code handles this
by not having any overflow events.

It might be that the case where your NMI gets stuck is such
a stray NMI?

That is in theory it should be safe to unmask  that vector
multiple times (the other NMIs should come from other vectors),
but local APIC is an fragile area.

> 
> I felt uncomfortable issuing the apic_write() before oprofile_add_sample()
> 
> Do you mean doing the apic_write() right at the beginning of the 
> ppro_check_ctrs()
> function ?

Better once, otherwise you'll do it multiple times worst case
(multiple counters can overflow)

-Andi

-- 
ak@linux.intel.com
