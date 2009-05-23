Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbZEWVqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbZEWVqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 17:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZEWVqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 17:46:22 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:40804 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZEWVqW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 17:46:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VId3YnFk95gkAaIfdR585ll0YmIsI49v/j8z9GfBVG29adUl00Eqd/Sisz0tteL0p7
         yibzdhIIaJpgVpHZbuUetchXKBsB/asj7KrBWJDdmx2BSWoB6EskuFISGMkyduh6TF5G
         wB24QivjNS0pQ9djLuSmhdl7FX1r1s6PYRJUs=
MIME-Version: 1.0
In-Reply-To: <63386a3d0905112337p2d426481o5f9bf9b9489cc57e@mail.gmail.com>
References: <63386a3d0905112337p2d426481o5f9bf9b9489cc57e@mail.gmail.com>
Date: Sat, 23 May 2009 23:46:22 +0200
Message-ID: <63386a3d0905231446h245bb4a9gec111f68a74a44e4@mail.gmail.com>
Subject: [PATCH] U300 sched_clock implementation
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was submitted to the ARM Linux maillist, but we need
some scheduler person to have a look at this sched_clock() thing.

The U300 timekeeping code is in the -next tree at:
arch/arm/mach-u300/time.c

The OMAP2 solution is in:
arch/arm/plat-omap/common.c

When I look at it I get the feeling, that if this works at all times, then
anything that has a continous clock source should actually
implement it this way if they have nothing else so schedule with.
I wonder how hard that would be to do in a generic way.


PATCH FOLLOWS
This overrides the global sched_clock() symbol in the Linux
scheduler with a local implementation which takes advantage of
the timesource in U300 giving a scheduling resolution of 1us. The
solution is the same as found in the OMAP2 core code.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-u300/timer.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-u300/timer.c b/arch/arm/mach-u300/timer.c
index 4bf82f8..222de18 100644
--- a/arch/arm/mach-u300/timer.c
+++ b/arch/arm/mach-u300/timer.c
@@ -346,6 +346,22 @@ static struct clocksource clocksource_u300_1mhz = {
       .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 };

+/*
+ * Override the global weak sched_clock symbol with this
+ * local implementation which uses the clocksource to get some
+ * better resolution when scheduling the kernel. We accept that
+ * this wraps around for now, since it is just a relative time
+ * stamp. (Inspired by OMAP implementation.)
+ */
+unsigned long long sched_clock(void)
+{
+       unsigned long long ret;
+
+       ret = (unsigned long long) u300_get_cycles();
+       ret = (ret * clocksource_u300_1mhz.mult_orig) >>
+               clocksource_u300_1mhz.shift;
+       return ret;
+}

 /*
 * This sets up the system timers, clock source and clock event.
--
1.6.2.1
