Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbZCOTFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbZCOTFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 15:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZCOTFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 15:05:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906AbZCOTFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 15:05:33 -0400
Date: Sun, 15 Mar 2009 12:02:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesper Krogh <jesper@krogh.cc>
cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <49BD4B2D.7000501@krogh.cc>
Message-ID: <alpine.LFD.2.00.0903151146550.3131@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com>  <49A70B24.6090706@krogh.cc> 
 <1235685269.6811.11.camel@localhost.localdomain>  <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain>  <1235687483.6811.26.camel@localhost.localdomain>  <49A78C79.304@krogh.cc>  <1235766936.7402.5.camel@localhost.localdomain> <49AD90E2.7050209@krogh.cc>
  <1236118969.6068.87.camel@localhost> <49AE9EA4.2080500@krogh.cc>  <49AECA3B.5030503@krogh.cc>  <1236193075.3793.63.camel@jstultz-laptop>  <1236220759.6863.7.camel@localhost.localdomain> <1236221530.6863.9.camel@localhost.localdomain> <49B57F3D.5030008@krogh.cc>
 <alpine.LFD.2.00.0903141814180.7421@localhost.localdomain> <49BD225C.4070305@krogh.cc> <alpine.LFD.2.00.0903151050070.3131@localhost.localdomain> <49BD4B2D.7000501@krogh.cc>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 15 Mar 2009, Jesper Krogh wrote:
> > > 
> > > [    0.000000] Fast TSC delta=34227730, error=6223+6219=12442
> > > [    0.000000] Fast TSC calibration using PIT
> > > [    0.000000] Detected 2312.045 MHz processor.
> 
> My conclusion was that I would get a time reset after some time since the
> offset just increased as time went by (being reasonably small at the
> beginning).
> 
> I had it up for around 30 minutes... Should I have tested longer?

It would be good to test longer. Your previous emails showed:

	2.6.26: time.c: Detected 2311.847 MHz processor.
	2.6.29: Detected 2310.029 MHz processor.

where that first one was a successful boot, and the second one was a 
failing one. So let's assume that 2311.847 is the "correct" frequency.

The difference between the correct one and your failing one is ~790 ppm, 
which is above the 500ppm ntpd threshhold. And as we saw earlier, those 
differences were pretty consistent, ie in your list of four successive 
boots, the old code consistently gave a frequency error that was roughly 
.7 permille off (ie exactly that 700 ppm).

HOWEVER! With that patch you just tried, you got 

	Detected 2312.045 MHz processor.

and the difference between _that_ and the assumed-correct-one is actually 
just 85 ppm. Which should be perfectly fine.

[ With the "test against PM timer, you had:

	[    0.000000] ref_freq: 2311825  pit_freq: 2310386
	[    0.000000] ref_freq: 2311803  pit_freq: 2310190
	[    0.000000] ref_freq: 2311824  pit_freq: 2310080
	[    0.000000] ref_freq: 2311831  pit_freq: 2310130

  on four boots, so averaging them gives 2311.82 Mhz, and the 2312.045MHz 
  you got with the improved fast-PIT code is still _way_ below 500ppm from 
  that - it's ~95 ppm away.

  IOW, the new frequency realy looks likely to work. ]

Quite frankly, we don't know how exact the PM-timer is either - we just 
know that the detection is "stable" (but so was the old PIT timer 
detection: it was stably at 700ppm lower from the PM timer. So there is 
nothing that says that 2311.82Mhz is the "correct" frequency, but we 
obviously know from your ntpd saga that it is much closer to correct than 
the old 2310.029 was.

End result of all this: I'd really like you to try the modified PIT 
frequency code for longer. Also, remember that getting one (or a couple) 
"time reset" messages from ntpd while it's trying to sync up is not a 
problem per se - it can validly take a while to synchronize. The problem 
is literally only if it doesn't synchonize over time at all.

			Linus
