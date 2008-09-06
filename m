Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbYIFVPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbYIFVPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 17:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYIFVPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 17:15:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbYIFVPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 17:15:22 -0400
Date: Sat, 6 Sep 2008 14:15:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Alok Kataria <akataria@vmware.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <alpine.LFD.1.10.0809062301520.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809061411430.3117@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>  <20080904160036.GA18382@elte.hu>  <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> 
 <20080904190728.59634020@lxorguk.ukuu.org.uk>  <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>  <20080904204305.GA29065@elte.hu> <1220653095.14401.72.camel@alok-dev1>
 <alpine.LFD.1.10.0809051522410.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809061803470.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061328400.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062233500.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809062240170.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061356270.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062301520.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Sep 2008, Thomas Gleixner wrote:
> > 
> > Show some _taste_.
> 
> Tell the hardware dudes who made that crap so difficult

No. I'm telling you, because that patch IS CRAP.

> Over which _whole_ thing ? You want to have the very very fast thing,
> which is not reliable under all circumstances as Alok pointed out and
> I merily added a sanity check around that for testing.

You can move that thing _out_ into a function of its own.

Look at this piece fo CRAP, and tell me, HOW MANY TIMES do you want to 
repeat it?

+               /*
+                * Return the fast_calibrate value when neither hpet
+                * nor pmtimer are available.
+                */
+               if (!hpet && !ref1 && !ref2) {
+                       printk("Fast TSC calibration using PIT\n");
+                       return fast_calibrate;
+               }
+
+               /* Check, whether the sampling was disturbed by an SMI */
+               if (tsc1 == ULLONG_MAX || tsc2 == ULLONG_MAX)
+                       goto slowpath;
+
+               tsc2 = (tsc2 - tsc1) * 1000000LL;
+               if (hpet)
+                       tsc2 = calc_hpet_ref(tsc2, ref1, ref2);
+               else
+                       tsc2 = calc_pmtimer_ref(tsc2, ref1, ref2);
+
+               /* Check the reference deviation */
+               delta = ((u64) fast_calibrate) * 100;
+               do_div(delta, tsc2);
+
+               if (delta >= 90 && delta <= 110) {
+                       printk("Fast TSC calibration using PIT\n");
+                       return fast_calibrate;
+               }
+       }

Here's a hint: we don't do cut-and-paste programming. And we don't get 
extra points for bloating a single function with the same unreadable code 
over and over and over again. 

How many copies do you want? And here's a hint: the answer is _one_. If 
you get any other answer, your patch is SHIT.

			Linus
