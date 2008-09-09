Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbYIIHcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbYIIHcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbYIIHcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:32:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53757 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbYIIHcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:32:13 -0400
Date: Tue, 9 Sep 2008 09:31:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v2)
Message-ID: <20080909073153.GA10049@elte.hu>
References: <48C13D1C.76E4.0078.0@novell.com> <20080905150030.GD10292@elte.hu> <48C51F8D.76E4.0078.0@novell.com> <20080908134019.GB11993@elte.hu> <20080908185417.GA17654@elte.hu> <48C6406E.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C6406E.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <jbeulich@novell.com> wrote:

> >>> Ingo Molnar <mingo@elte.hu> 08.09.08 20:54 >>>
> >
> >-tip testing found various kernel crashes on 32-bit testboxes and i've 
> >bisected it down to:
> >
> >...
> >
> >a typical crash is like the one attached below. It's due to the ioremap 
> >failing. The drivers/char/rio/rio_linux.c driver probes these addresses:
> >
> >   static int rio_probe_addrs[] = { 0xc0000, 0xd0000, 0xe0000 };
> >
> >which is questionable ...
> 
> No, they look absolutely valid, they're ISA ROM addresses.

yeah - questionable in the sense of assuming that it's all non-RAM. But 
there's no better way to probe for ROMs i guess.

> > for now i've reverted it from current tip/master, see commit 
> > e3fdd129901. (you can reinstate the commit by doing "git revert 
> > e3fdd1299"
> >
> > Even if we decided to fail these ioremaps it would be better to emit 
> > a warning instead of crashing the box.
> 
> We shouldn't fail them, they're valid. What the crash means is that 
> even addresses below 1Mb are considered out of range, which I can only 
> take as x86_phys_bits being zero (or a bogus very small number) on 
> secondary (or all) CPUs. However, looking at the call tree I can't see 
> how that could happen (provided CPUID doesn't produce garbage output):
> 
> - smp_store_cpu_info(), as it always did, pre-initializes the new CPU's
>   info with boot_cpu_data, and calls identify_secondary_cpu()
> - identify_secondary_cpu() calls identify_cpu()
> - identify_cpu() pre-sets x86_phys_bits to 32, and since the field didn't
>   exist for 32-bits before, nothing should be able to clear or otherwise
>   alter it

there's nothing weird about this testbox (it's a usual whitebox) - and 
two other testboxes failed as well after some time (no crashlog 
available from them). A 64-bit testbox didnt fail so it seems 32-bit 
only.

	Ingo
