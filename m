Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZEFXz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZEFXz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 19:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbZEFXzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 19:55:16 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:11572
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753353AbZEFXzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 19:55:15 -0400
X-BigFish: VPS-1(z3b68lz14ffO4015Lzz1202hzzz2fh6bh15fn65h)
X-Spam-TCS-SCL: 4:0
Message-ID: <4A022333.8030200@am.sony.com>
Date: Wed, 6 May 2009 16:54:27 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: How to use a different sched_clock() for ftrace on omap?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 May 2009 23:54:28.0621 (UTC) FILETIME=[FE2F53D0:01C9CEA5]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've worked up a replacement sched_clock for ftrace on my omap platform.
The current sched_clock, based on the 32K timer, has low resolution and
doesn't provide very useful results.

Unfortunately, I'm not sure the best way to use my special one, in place
of a common one in arch/arm/plat-omap/common.c

Here's a patch:

---
 arch/arm/mach-omap1/time.c  |    9 +++++++++
 arch/arm/plat-omap/common.c |    2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -212,6 +212,15 @@ static struct clocksource clocksource_mp
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };

+unsigned long long notrace sched_clock(void)
+{
+	unsigned long long ret;
+
+	ret = (unsigned long long) ~omap_mpu_timer_read(1);
+	ret = (ret * clocksource_mpu.mult_orig) >>clocksource_mpu.shift;
+	return ret;
+}
+
 static void __init omap_init_clocksource(unsigned long rate)
 {
 	static char err[] __initdata = KERN_ERR
--- a/arch/arm/plat-omap/common.c
+++ b/arch/arm/plat-omap/common.c
@@ -203,7 +203,7 @@ static struct clocksource clocksource_32
  * Returns current time from boot in nsecs. It's OK for this to wrap
  * around for now, as it's just a relative time stamp.
  */
-unsigned long long notrace sched_clock(void)
+__attribute__((weak)) unsigned long long notrace sched_clock_old(void)
 {
 	unsigned long long ret;


Obviously, renaming the common sched_clock() to sched_clock_old() is
a hack.

I thought the __attribute__ ((weak)) would be enough to have the
sched_clock() in common.c get out of the way, and allow my board-specific
sched_clock() to be used.  But that didn't work.  What is the recommended
way to specify a board-specific function at compile time?

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

