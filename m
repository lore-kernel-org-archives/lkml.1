Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbYIIHWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbYIIHWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYIIHWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:22:32 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16109 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbYIIHWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:22:30 -0400
Message-Id: <48C6406E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Tue, 09 Sep 2008 08:22:54 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: x86_{phys,virt}_bits field also for i386 (v2)
References: <48C13D1C.76E4.0078.0@novell.com>
 <20080905150030.GD10292@elte.hu> <48C51F8D.76E4.0078.0@novell.com>
 <20080908134019.GB11993@elte.hu> <20080908185417.GA17654@elte.hu>
In-Reply-To: <20080908185417.GA17654@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 08.09.08 20:54 >>>
>
>-tip testing found various kernel crashes on 32-bit testboxes and i've 
>bisected it down to:
>
>...
>
>a typical crash is like the one attached below. It's due to the ioremap 
>failing. The drivers/char/rio/rio_linux.c driver probes these addresses:
>
>   static int rio_probe_addrs[] = { 0xc0000, 0xd0000, 0xe0000 };
>
>which is questionable ...

No, they look absolutely valid, they're ISA ROM addresses.

>for now i've reverted it from current tip/master, see commit 
>e3fdd129901. (you can reinstate the commit by doing "git revert 
>e3fdd1299"
>
>Even if we decided to fail these ioremaps it would be better to emit a 
>warning instead of crashing the box.

We shouldn't fail them, they're valid. What the crash means is that even
addresses below 1Mb are considered out of range, which I can only take
as x86_phys_bits being zero (or a bogus very small number) on
secondary (or all) CPUs. However, looking at the call tree I can't see how
that could happen (provided CPUID doesn't produce garbage output):

- smp_store_cpu_info(), as it always did, pre-initializes the new CPU's
  info with boot_cpu_data, and calls identify_secondary_cpu()
- identify_secondary_cpu() calls identify_cpu()
- identify_cpu() pre-sets x86_phys_bits to 32, and since the field didn't
  exist for 32-bits before, nothing should be able to clear or otherwise
  alter it

Jan

