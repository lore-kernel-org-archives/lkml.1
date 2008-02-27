Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbYB0Uhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbYB0Uhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758412AbYB0UhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:37:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50603 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094AbYB0UhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:37:16 -0500
Date: Wed, 27 Feb 2008 21:36:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: hpwdt oops in clflush_cache_range
Message-ID: <20080227203655.GA30054@elte.hu>
References: <adad4qiwcmz.fsf@cisco.com> <alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de> <ada1w6y1bzk.fsf@cisco.com> <alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> > [    0.004000] Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06
> 
> This one has 36bit physical address space. You can verify that via
> /proc/cpuinfo
> 
> > [ 8425.910898] ACPI: PCI Interrupt 0000:01:04.0[A] -> GSI 21 (level, low) -> IRQ 21
> > [ 8425.915097] hpwdt: New timer passed in is 30 seconds.
> > [ 8425.915139] BUG: unable to handle kernel paging request at ffffc20001a0a000
> > [ 8425.919087] IP: [<ffffffff8021dacc>] clflush_cache_range+0xc/0x25
> > [ 8425.919087] PGD 1bf80e067 PUD 1bf80f067 PMD 1bb497067 PTE 80000047000ee17b
> 
> While the physical address of your ioremap is 47000ee000.
> 
> 2^ 36 == 1000000000
> ---->    47000ee000
> 
> So the fault is not very surprising. Unfortunately we do not check, 
> whether physaddr is inside the valid physical address space. I whip up 
> a patch to do that.

also note that the driver would have faulted in a similar same way 
anyway, the first time it tried to access that ioremap range. It's just 
that due to the clflush we took the fault first in ioremap().

via the physical range check we'll do a more graceful exit and the 
driver wont crash either. (it will just not work)

	Ingo
