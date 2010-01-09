Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797Ab0AISNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab0AISNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 13:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771Ab0AISNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 13:13:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754763Ab0AISNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 13:13:50 -0500
Date: Sat, 9 Jan 2010 10:11:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
cc: suresh.b.siddha@intel.com, yinghai@kernel.org, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] Make Intel 8-way Xeons boot again
In-Reply-To: <20100109101038.GA17555@in.ibm.com>
Message-ID: <alpine.LFD.2.00.1001091007150.7821@localhost.localdomain>
References: <20100109101038.GA17555@in.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 9 Jan 2010, Ananth N Mavinakayanahalli wrote:
>
> On an 8-way system with Intel Xeon X7350 CPUs, booting 2.6.32 or newer
> kernels fails at:
> 
> ...
> CPU0: Intel(R) Xeon(R) CPU           X7350  @ 2.93GHz stepping 0b
> Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
> Brought up 8 CPUs
> Total of 8 processors activated (46906.05 BogoMIPS).
> 
> Git bisect showed 2fbd07a5f as the offending commit.

Ok, that commit definitely is buggy.

> With the patch below, I am able to boot the latest Linus' git tree on
> the machine. If this patch is correct, it needs to get into the stable
> tree too.

I don't think the patch is correct, though. The thing is, the AMD check 
seems to be the correct one: you can only use 'apic_flat' if all the APIC 
ID's are < 8.

It doesn't matter _how_ many CPU's you have. If you have two CPU's, but 
one of them has an APIC ID >= 8, then you cannot use the flat APIC model, 
since it depends on a 8-bit bitfield.

So your patch doesn't seem right either, because it still tests 
num_processors, which is bogus.

In fact, I can't for the life of me understand why it treats different 
vendors differently. Why is that code not just a simple

	/* Flat apic mode requires that all APIC ID's are in the range 0..7 */
	if (apic == &apic_flat && max_physical_apicid >= 8)
		apic = &apic_physflat;

instead, with no crazy vendor tests.

What am I missing? 

		Linus
