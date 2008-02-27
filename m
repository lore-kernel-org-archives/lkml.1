Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbYB0Tsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbYB0Tsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758567AbYB0Tsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:48:32 -0500
Received: from www.tglx.de ([62.245.132.106]:37245 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758401AbYB0Tsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:48:31 -0500
Date: Wed, 27 Feb 2008 20:48:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland Dreier <rdreier@cisco.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: hpwdt oops in clflush_cache_range
In-Reply-To: <ada1w6y1bzk.fsf@cisco.com>
Message-ID: <alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de>
References: <adad4qiwcmz.fsf@cisco.com> <alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de> <ada1w6y1bzk.fsf@cisco.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Roland Dreier wrote:

>  > Can you provide a full boot log please ?
> 
> Sure, below.

> [    0.004000] Intel(R) Xeon(R) CPU            5160  @ 3.00GHz stepping 06

This one has 36bit physical address space. You can verify that via
/proc/cpuinfo

> [ 8425.910898] ACPI: PCI Interrupt 0000:01:04.0[A] -> GSI 21 (level, low) -> IRQ 21
> [ 8425.915097] hpwdt: New timer passed in is 30 seconds.
> [ 8425.915139] BUG: unable to handle kernel paging request at ffffc20001a0a000
> [ 8425.919087] IP: [<ffffffff8021dacc>] clflush_cache_range+0xc/0x25
> [ 8425.919087] PGD 1bf80e067 PUD 1bf80f067 PMD 1bb497067 PTE 80000047000ee17b

While the physical address of your ioremap is 47000ee000.

2^ 36 == 1000000000
---->    47000ee000

So the fault is not very surprising. Unfortunately we do not check,
whether physaddr is inside the valid physical address space. I whip up
a patch to do that.

Can you please instrument the driver to figure out where this
information comes from ? Or maybe lspci tells already.

Thanks,

	tglx
