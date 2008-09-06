Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYIFUDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYIFUDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 16:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYIFUDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 16:03:31 -0400
Received: from www.tglx.de ([62.245.132.106]:47419 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbYIFUD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 16:03:29 -0400
Date: Sat, 6 Sep 2008 22:03:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alok Kataria <akataria@vmware.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <alpine.LFD.1.10.0809051522410.3117@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809061803470.3243@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>  <20080904160036.GA18382@elte.hu>  <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> 
 <20080904190728.59634020@lxorguk.ukuu.org.uk>  <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>  <20080904204305.GA29065@elte.hu> <20080904205236.GA3864@elte.hu> 
 <alpine.LFD.1.10.0809041403450.3117@nehalem.linux-foundation.org>  <20080904213350.GA15678@elte.hu> <1220653095.14401.72.camel@alok-dev1> <alpine.LFD.1.10.0809051522410.3117@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Sep 2008, Linus Torvalds wrote:
> On Fri, 5 Sep 2008, Alok Kataria wrote:
> > 
> > This can happen if, in the pit_expect_msb (the one just before the 
> > second read_tsc), we hit an SMI/virtualization event *after* doing the 
> > 50 iterations of PIT read loop, this allows the pit_expect_msb to 
> > succeed when the SMI returns.
> 
> So theoretically, on real hardware, the minimum of 50 reads will take 
> 100us. The 256 PTI cycles will take 214us, so in the absolute worst case, 
> you can have two consecutive successful cycles despite having a 228us SMI 
> (or other event) if it happens just in the middle.

I just ran your patch in a loop on the SMI mephitic laptop with random
delays between the loops.

20 out of 10000 results are between 2200 and 8400Mhz while the CPU
still runs @2GHz.

And it also happened in an automated boot/reboot cycle (no extra loop)
once out of 50.

So the SMI hit exactly:

+      	t1 = get_cycles();
+      	for (expect = 0xfe, i = 0; i < QUICK_PIT_ITERATIONS; i++, expect--) {
+	      	if (!pit_expect_msb(expect))
+			goto failed;
+	}

-----> HERE

+	t2 = get_cycles();

The SMIs on that machine take between 500us and 100+ms according to my
instrumentation experiments: http://lkml.org/lkml/2008/9/2/202

Adding another check after the second get_cycles() makes it reliable:

+      	t1 = get_cycles();
+      	for (expect = 0xfe, i = 0; i < QUICK_PIT_ITERATIONS; i++) {
+	      	if (!pit_expect_msb(expect--))
+			goto failed;
+	}
+   	t2 = get_cycles();
+
+	if (!pit_expect_msb(expect))
+		goto failed;

That solves the problem on that box and will detect any virtualization
delay as well. I just had to move out the "expect--" from the for() as
gcc is overly clever.

> Of course, then the actual _error_ on the TSC read will be just half that, 
> but since there are two TSC reads - one at the beginning and one at the 
> end - and if the errors of the two reads go in opposite directions, they 
> can add up to 228us.
> 
> So I agree - in theory you can have a fairly big error if you hit 
> everything just right. In practice, of course, even that *maximal* error 
> is actually perfectly fine for TSC calibration.

The above _maximal_ error of 400% is not perfectly fine at all.

> So I just don't care one whit.  The fact is, fast bootup is more important 
> than some crazy and totally unrealistic VM situation. The 50ms thing was 
> already too long, the 250ms one is unbearable.

True. You applied a first draft of my patch right away from mail. It
was the accumulated findings of my detective work on various wreckaged
hardware.

The follow up patches I sent (http://lkml.org/lkml/2008/9/4/254),
bring it down to 10ms in the good and 30ms in the worst case with the
option for 50ms in the last round to make the virtualized/emulated
stuff happy. With that I have not seen any wrong result on any of my
jinxed boxen so far and it works very reliable on virtualized
environments as well.

Combining them with your fast calibration should be a solid and
reasonable fast solution in all corner cases.

Ingo put them into the -tip tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/tsc


Thanks,

	tglx
