Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZLSEEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZLSEEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 23:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZLSEEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 23:04:32 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:38421 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbZLSEEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 23:04:30 -0500
Subject: Re: 2.6.33-rc1: hrtimers and tickless broken on m68knommu.
From: john stultz <johnstul@us.ibm.com>
To: Steven King <sfking@fdwdc.com>
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
In-Reply-To: <200912181920.12905.sfking@fdwdc.com>
References: <200912181813.44220.sfking@fdwdc.com>
	 <1f1b08da0912181844u4f7e66a7ue30287208d075327@mail.gmail.com>
	 <200912181920.12905.sfking@fdwdc.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 20:04:23 -0800
Message-ID: <1261195463.4115.126.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 19:20 -0800, Steven King wrote:
> On Friday 18 December 2009 06:44:44 john stultz wrote:
> > On Fri, Dec 18, 2009 at 6:13 PM, Steven King <sfking@fdwdc.com> wrote:
> > > Attach is the .config; it works on v2.6.32 but fails to boot on .33-rc1;
> > > but if I deselect hrtimers && tickless then it works.
> >
> > Sorry for the dup, forgot to cc lkml on my reply.
> >
> > Fails to boot all together? Or does it hang at some point in the dmesg
> > that you can point out?
> 
> fails to boot all together; nothing on the serial console.
> >
> > Could you run the following so we can narrow down which clocksource your
> > using? cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> > cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> >
> > Then with the kernel that doesn't boot, go through the clocksources
> > listed in available_clocksources and try booting w/
> > "clocksource=<clock name>" and see if the behavior changes.
> 
> on the working .32 kernel:
> 
> # cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> pit
> # cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> pit
> 
> just to be sure, I tried clocksource=pit on the .33-rc1 kernel.  It didnt make 
> any difference.


Hrmm.. So looking at the code in arch/m68knommu/platform/coldfire/pit.c,
I'm a little confused on how this got marked as a continuous clocksource
(CLOCK_SOURCE_IS_CONTINUOUS), especially as it seems it couldn't handle
skipping an interrupt.

That said, I'm not sure how it worked in 2.6.32, as its been that way
for awhile it seems.  Maybe my assumptions on how the PIT works is wrong
(or just biased in how it works on x86)?

Greg, could you clarify how the PIT can be used as a clocksource if its
also being used in oneshot mode?

Steven, I assume the patch below avoids the issue (by disabling highres
timers and nohz)?

thanks
-john



The m68knommu coldfire pit clocksource looks like it was incorrectly
marked as a continuous clocksource. From the looks of it, running with
it marked as a continuous clocksource could cause hangs when the system
switches to highres mode or enables nohz.  I have no idea why it worked
in prior kernels, and I'm not 100% sure the following fix is really the
right solution.

This patch removes the CLOCK_SOURCE_IS_CONTINUOUS flag on the coldfire
pit clocksource. This will disallow systems using this clocksource from
entering oneshot mode (disabling highres timers and nohz).

Signed-off-by: John Stultz <johnstul@us.ibm.com>

---

diff --git a/arch/m68knommu/platform/coldfire/pit.c b/arch/m68knommu/platform/coldfire/pit.c
index d8720ee..aebea19 100644
--- a/arch/m68knommu/platform/coldfire/pit.c
+++ b/arch/m68knommu/platform/coldfire/pit.c
@@ -146,7 +146,6 @@ static struct clocksource pit_clk = {
 	.read	= pit_read_clk,
 	.shift	= 20,
 	.mask	= CLOCKSOURCE_MASK(32),
-	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 /***************************************************************************/


