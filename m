Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbZCJWXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbZCJWXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbZCJWXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:23:02 -0400
Received: from www.tglx.de ([62.245.132.106]:43904 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbZCJWXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:23:00 -0400
Date: Tue, 10 Mar 2009 23:22:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jesper Krogh <jesper@krogh.cc>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <49B6C2B8.7000407@krogh.cc>
Message-ID: <alpine.LFD.2.00.0903102107580.29264@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6F39F.9040801@krogh.cc>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com> 
 <49A70B24.6090706@krogh.cc>  <1235685269.6811.11.camel@localhost.localdomain>  <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>  <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>  <1235766936.7402.5.camel@localhost.localdomain>
 <49AD90E2.7050209@krogh.cc>  <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>  <49AECA3B.5030503@krogh.cc>  <1236193075.3793.63.camel@jstultz-laptop>  <1236220759.6863.7.camel@localhost.localdomain> <1236221530.6863.9.camel@localhost.localdomain>
 <49B57F3D.5030008@krogh.cc> <alpine.LFD.2.00.0903092109460.19207@localhost.localdomain> <alpine.LFD.2.00.0903101103510.29264@localhost.localdomain> <49B6C2B8.7000407@krogh.cc>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper,

On Tue, 10 Mar 2009, Jesper Krogh wrote:
> First boot:
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] tsc 34202223 tscmin 474069 tscmax 500664
> Second boot:
> Here I didnt get above messages.. http://krogh.cc/~jesper/dmesg-boot2.txt
> Third boot:
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] tsc 34199856 tscmin 470321 tscmax 502182
> Forth boot:
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] tsc 34202008 tscmin 475510 tscmax 501501
> 
> The second one is really strange.. is'nt it?

No, there simply the fast PIT calibration failed and it dropped into
the slow path:
[    0.000000] TSC: PIT calibration matches PMTIMER. 1 loops
[    0.000000] Detected 2311.878 MHz processor.

But the variance of the third run is interesting:

    avg = tsc / loops = 495650
    avg - tscmin      =  25329 (~ 10.9 us)
    tscmax - avg      =   6532 (~  2.8 us)

While this is in the range which the PIT calibration code accepts the
resulting CPU frequency of this run is 2310.159 MHz which is way off
the result of the slow path in the 2nd run. The 1st and the 4th run
have significant high variance as well.

I run the same patch on a couple of test machines and all have
deviations from avg in the range of +/- 2 us and the calibration
result is stable and correct.

I have no idea what might cause the problem with your machine. PIT via
SMM emulation comes to mind :)

But we can use the tscmin/max method to figure out whether the fast
PIT result is reliable. See patch below. It should drop out into the
slow calibration path on every boot on your machine.

    (tscmax - tscmin) / avg = 0.064 (result from third run)

On my test machines I get values below 0.02

While it's statistically not really correct we still can use that info
to catch cases like we see on your machines.

> While booting up I saw this one on the serial console..
> root@quad12:~# hwclock --systohc
> Cannot access the Hardware Clock via any known method.
> Use the --debug option to see the details of our search for an access method.
> root@quad12:~# hwclock --systohc --debug
> hwclock from util-linux-ng 2.13.1
> hwclock: Open of /dev/rtc failed, errno=2: No such file or directory.
> No usable clock interface found.
> Cannot access the Hardware Clock via any known method.

Can you provide your .config file please ?

Thanks,

	tglx

--------->

Subject: x86: make TSC fast calibration more robust
From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 10 Mar 2009 11:12:03 +0100

Check the min/max duration of each PIT loop against the resulting
average value and dismiss the fast calibration if it's larger than
2.5%. 2.5% is in the range of +/- 2us, which is a reasonable range
when we assume that a PIT read can easily take 1 us.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tsc.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c
+++ linux-2.6/arch/x86/kernel/tsc.c
@@ -317,15 +317,22 @@ static unsigned long quick_pit_calibrate
 
 	if (pit_expect_msb(0xff)) {
 		int i;
-		u64 t1, t2, delta;
+		u64 t1, t2, t3, delta;
 		unsigned char expect = 0xfe;
+		unsigned long tscmin = ULONG_MAX, tscmax = 0;
 
-		t1 = get_cycles();
+		t1 = t2 = get_cycles();
 		for (i = 0; i < QUICK_PIT_ITERATIONS; i++, expect--) {
 			if (!pit_expect_msb(expect))
 				goto failed;
+			t3 = get_cycles();
+			delta = t3 - t2;
+			t2 = t3;
+			if ((unsigned long) delta < tscmin)
+				tscmin = (unsigned long) delta;
+			if ((unsigned long) delta > tscmax)
+				tscmax = (unsigned long) delta;
 		}
-		t2 = get_cycles();
 
 		/*
 		 * Make sure we can rely on the second TSC timestamp:
@@ -334,6 +341,23 @@ static unsigned long quick_pit_calibrate
 			goto failed;
 
 		/*
+		 * Sanity check the min max values:
+		 *
+		 * We calculate the average tsc increment per loop
+		 * step. Now we take the tscmin and tscmax value and
+		 * check whether the deviation is inside an acceptable
+		 * range.
+		 */
+		delta = (t2 - t1);
+		do_div(delta, QUICK_PIT_ITERATIONS);
+		t3 = (unsigned long) delta;
+		delta = tscmax - tscmin;
+		delta *= 10000;
+		do_div(delta, t3);
+		/* Fail if the deviation is > 2.5 % */
+		if (delta > 250)
+			goto failed;
+		/*
 		 * Ok, if we get here, then we've seen the
 		 * MSB of the PIT decrement QUICK_PIT_ITERATIONS
 		 * times, and each MSB had many hits, so we never
