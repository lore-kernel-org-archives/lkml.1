Return-Path: <linux-kernel-owner+w=401wt.eu-S1760308AbZBZWl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308AbZBZWl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759961AbZBZWk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:40:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759839AbZBZWkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:40:55 -0500
Date: Thu, 26 Feb 2009 14:40:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: john stultz <johnstul@us.ibm.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <1235687483.6811.26.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902261434390.3111@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6F39F.9040801@krogh.cc>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com> 
 <49A70B24.6090706@krogh.cc>  <1235685269.6811.11.camel@localhost.localdomain>  <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain> <1235687483.6811.26.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Feb 2009, john stultz wrote:
> 
> I'll kick up some of my own testing between these two releases to see if
> I can't find something similar.

Since the PIT timer read is possibly hw-dependent, it might be that you 
can't necessarily reproduce it on some random hardware.

How sensitive is ntpd to (stable) drift? IOW, if we get the calibration 
wrong, the TSC should still hopefully be very _stable_, it's just that the 
initial guesstimate for the frequency is off and ntp would have to correct 
for that.

The easiest way to test might be to just force a 1000ppm estimation error 
with something like this total hack (indented just so that nobody would 
ever apply this by mistake):

	 arch/x86/kernel/tsc.c |    4 ++++
	 1 files changed, 4 insertions(+), 0 deletions(-)

	diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
	index 599e581..b80a0c4 100644
	--- a/arch/x86/kernel/tsc.c
	+++ b/arch/x86/kernel/tsc.c
	@@ -350,6 +350,10 @@ static unsigned long quick_pit_calibrate(void)
	 		delta = (t2 - t1)*PIT_TICK_RATE;
	 		do_div(delta, QUICK_PIT_ITERATIONS*256*1000);
	 		printk("Fast TSC calibration using PIT\n");
	+
	+		/* HACK! */
	+		delta -= delta >> 10;
	+
	 		return delta;
	 	}
	 failed:

which wouldn't be hardware-dependent.

			Linus
