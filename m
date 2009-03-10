Return-Path: <linux-kernel-owner+w=401wt.eu-S1752299AbZCJLau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbZCJLau (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZCJLak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:30:40 -0400
Received: from www.tglx.de ([62.245.132.106]:40204 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZCJLaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:30:39 -0400
Date: Tue, 10 Mar 2009 12:29:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jesper Krogh <jesper@krogh.cc>, john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <alpine.LFD.2.00.0903092109460.19207@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903101103510.29264@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6F39F.9040801@krogh.cc>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com> 
 <49A70B24.6090706@krogh.cc>  <1235685269.6811.11.camel@localhost.localdomain>  <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>  <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>  <1235766936.7402.5.camel@localhost.localdomain>
 <49ACC853.8070205@krogh.cc>  <1236110026.6068.18.camel@localhost> <49AD90E2.7050209@krogh.cc>  <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>  <49AECA3B.5030503@krogh.cc>  <1236193075.3793.63.camel@jstultz-laptop> 
 <1236220759.6863.7.camel@localhost.localdomain> <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc> <alpine.LFD.2.00.0903092109460.19207@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, Linus Torvalds wrote:
> On Mon, 9 Mar 2009, Jesper Krogh wrote:
> > 
> > First boot.
> > [    0.000000] ref_freq: 2311825  pit_freq: 2310386
> > Second boot:
> > [    0.000000] ref_freq: 2311803  pit_freq: 2310190
> > Third boot:
> > [    0.000000] ref_freq: 2311824  pit_freq: 2310080
> > Fourth boot:
> > [    0.000000] ref_freq: 2311831  pit_freq: 2310130
> 
> It's really quite impressively stable, but the fast-PIT calibration 
> frequency is reliably about 3/4 of a promille low. Or, put another way, 
> the TSC difference over the pit calibration is just a _tad_ too small 
> compared to the value we'd expect if that loop of pit_expect_msb() would 
> really run at the expected delay of a 1.193182MHz clock divided by 256.
> 
> And it's stable in that it really always seems to be off by a very similar 
> amount. It's not moving around very much.
> 
> I also wonder why it seems to happen mainly just to _you_. There's 
> absolutely nothing odd in your system, neither a slow CPU or anything 
> else that would stand out.
> 
> Grr. Very annoyingly non-obvious.

Indeed. One hint is in the slow calibration path. 3 of 4 boots have:

> > [    0.000000] TSC: PIT calibration matches PMTIMER. 2 loops

So the slow calibration path detects some disturbance.

Jesper, can you please apply the following patch instead of Johns and
provide the output for a couple of boots? The output is:

Fast TSC calibration using PIT
tsc 43425305 tscmin 624008 tscmax 632610

Thanks,

	tglx

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
+				tscmin = (unsigned int) delta;
+			if ((unsigned long) delta > tscmax)
+				tscmax = (unsigned int) delta;
 		}
-		t2 = get_cycles();
 
 		/*
 		 * Make sure we can rely on the second TSC timestamp:
@@ -350,6 +357,8 @@ static unsigned long quick_pit_calibrate
 		delta = (t2 - t1)*PIT_TICK_RATE;
 		do_div(delta, QUICK_PIT_ITERATIONS*256*1000);
 		printk("Fast TSC calibration using PIT\n");
+		printk("tsc %ld tscmin %ld tscmax %ld\n",
+		       (unsigned long) (t2 - t1), tscmin, tscmax);
 		return delta;
 	}
 failed:
