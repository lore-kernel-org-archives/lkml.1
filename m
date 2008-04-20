Return-Path: <linux-kernel-owner+w=401wt.eu-S1760509AbYDTUSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509AbYDTUSy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 16:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbYDTUSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 16:18:47 -0400
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:62251 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756157AbYDTUSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 16:18:46 -0400
Date: Sun, 20 Apr 2008 23:18:38 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Check for breakpoint in text_poke to eliminate bug_on
Message-ID: <20080420231838.21eaf426@daedalus.pq.iki.fi>
In-Reply-To: <20080420194440.GA15319@Krystal>
References: <20080413230552.33ca587a@daedalus.pq.iki.fi>
	<20080414065713.GB16163@elte.hu>
	<20080419184137.79957a07@daedalus.pq.iki.fi>
	<20080419161956.GA24685@Krystal>
	<20080420000657.20ba6b4b@daedalus.pq.iki.fi>
	<20080420005208.12ad32fd@daedalus.pq.iki.fi>
	<20080419215826.GC2831@Krystal>
	<20080420014206.5cd61d4a@daedalus.pq.iki.fi>
	<20080420000509.GA7496@Krystal>
	<20080420101408.518b21b4@daedalus.pq.iki.fi>
	<20080420194440.GA15319@Krystal>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008 15:44:40 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Can you test this new version ? The check was buggy when it fell on a
> code boundary : the addr - 1 wan't always a valid address.
> 

Sorry, still the same. Btw. I had to apply your patch by hand on top of
your previous patch, and it ended up as just

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -520,11 +520,6 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
        struct page *pages[2];
        int i;
 
-       if (*((uint8_t *)addr - 1) != BREAKPOINT_INSTRUCTION) {
-               BUG_ON(len > sizeof(long));
-               BUG_ON((((long)addr + len - 1) & ~(sizeof(long) - 1))
-                       - ((long)addr & ~(sizeof(long) - 1)));
-       }
        if (!core_kernel_text((unsigned long)addr)) {

Now I took a log of echo 0, echo 1 cycle with 2.6.24-gentoo-r1-trace
kernel:
[  203.448534] CPU 1 is now offline
[  203.448975] SMP alternatives: switching to UP code
[  217.888298] SMP alternatives: switching to SMP code
[  217.889285] Booting processor 1/2 APIC 0x1
[  217.901404] Initializing CPU#1
[  217.982081] Calibrating delay using timer specific routine.. 3991.35 BogoMIPS (lpj=6650167)
[  217.982088] CPU: L1 I cache: 32K, L1 D cache: 32K
[  217.982089] CPU: L2 cache: 4096K
[  217.982091] CPU: Physical Processor ID: 0
[  217.982092] CPU: Processor Core ID: 1
[  217.982593] Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz stepping 0a
[  217.982644] Switched to high resolution mode on CPU 1

And the failing log from the latest try is:

[   87.064970] CPU 1 is now offline
[   87.065311] lockdep: fixing up alternatives.
[   87.065694] SMP alternatives: switching to UP code
[   97.192213] lockdep: fixing up alternatives.
[   97.192532] SMP alternatives: switching to SMP code
[   97.203495] Booting processor 1/1 ip 6000
and it hangs and reboots.

Does it make sense to bisect on sched-devel/latest?
I think I could try that after a sleep&work cycle.
Luckily this bug is easy to reproduce.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
