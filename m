Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYIIAzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYIIAzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 20:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYIIAzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 20:55:32 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:23270 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754751AbYIIAzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 20:55:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MPEI7bBUzRvyNs3LUSfIUDPWu+OCXuG+k/o37ljqUkJVmsD4EanKxYdk3qUfR8NLfV4sOEA3DkN5WGd/PdjBZ5PgXKDigrBorWPmwJ8ef4QYSfwAowiTP3RTomGv/Cq+kbva73BfXJ+AE8G+aGmwD9WPEPDHo4RENRO/WEvMavo=  ;
X-YMail-OSG: NTTRycoVM1lX_kKpFob9qQb_zL2elcil2k4Yz7jBkL__DgWIzX9di2lYAr3lfdZ57G8.v5XRJnmnWZboEElJZ.KPSjsW5DiW0gceBCIDz5smCYdMAyTgYSatHMhd04Y-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
Date: Mon, 8 Sep 2008 17:55:25 -0700
User-Agent: KMail/1.9.9
Cc: James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, alessandro.zummo@towertech.it
References: <1220914847.8074.81.camel@localhost.localdomain> <200809081629.21125.david-b@pacbell.net> <20080908.164427.216880550.davem@davemloft.net>
In-Reply-To: <20080908.164427.216880550.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809081755.26148.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008, David Miller wrote:
> From: David Brownell <david-b@pacbell.net>
> Date: Mon, 8 Sep 2008 16:29:20 -0700
> 
> > That said, there's a bit of unresolved stuff around NTP hooks
> > in the kernel.  Some patches are pending to let thtem work with
> > the RTC framework -- where writing an RTC may need to sleep,
> > for example because the RTC is on an I2C or SPI bus.  And
> > then there's the discussion of whether that shouldn't all be
> > handled by NTPD anyway, no special kernel support desired.
> > Alessandro has opinions there.  ;)
> 
> My update_persistent_clock() on sparc64 is:
> 
> int update_persistent_clock(struct timespec now)
> {
> 	struct rtc_device *rtc = rtc_class_open("rtc0");

I'd be tempted to cache that ... notice how you never
close it, too.  That will goof lots of refcounts...


> 	if (rtc)
> 		return rtc_set_mmss(rtc, now.tv_sec);
> 
> 	return -1;
> }
> 
> and that should handle this NTP shouldn't it?

Depends on what patches have applied; I've lost track
of whether it's now ok for update_persistent_clock()
to sleep.  Previously it was not, without a critical
patch (appended).

Having something like that work is *certainly* a goal,
at least for those who don't want to get rid of those
kernel NTP hooks entirely.

And of course, once that works I'd claim it should live
in drivers/rtc for the benefit of other platforms.  :)

- Dave
 
=============== CUT ON THE DOTTED LINE ==================
Subject: ntp: let update_persistent_clock() sleep
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is a change that makes the 11-minute RTC update be run in the process
context.  This is so that update_persistent_clock() can sleep, which may
be required for certain types of RTC hardware -- most notably I2C devices.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/time/ntp.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/kernel/time/ntp.c	2008-06-30 21:20:51.000000000 -0700
+++ b/kernel/time/ntp.c	2008-06-30 21:21:27.000000000 -0700
@@ -10,13 +10,13 @@
 
 #include <linux/mm.h>
 #include <linux/time.h>
-#include <linux/timer.h>
 #include <linux/timex.h>
 #include <linux/jiffies.h>
 #include <linux/hrtimer.h>
 #include <linux/capability.h>
 #include <linux/math64.h>
 #include <linux/clocksource.h>
+#include <linux/workqueue.h>
 #include <asm/timex.h>
 
 /*
@@ -218,11 +218,11 @@ void second_overflow(void)
 /* Disable the cmos update - used by virtualization and embedded */
 int no_sync_cmos_clock  __read_mostly;
 
-static void sync_cmos_clock(unsigned long dummy);
+static void sync_cmos_clock(struct work_struct *work);
 
-static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
+static DECLARE_DELAYED_WORK(sync_cmos_work, sync_cmos_clock);
 
-static void sync_cmos_clock(unsigned long dummy)
+static void sync_cmos_clock(struct work_struct *work)
 {
 	struct timespec now, next;
 	int fail = 1;
@@ -258,13 +258,13 @@ static void sync_cmos_clock(unsigned lon
 		next.tv_sec++;
 		next.tv_nsec -= NSEC_PER_SEC;
 	}
-	mod_timer(&sync_cmos_timer, jiffies + timespec_to_jiffies(&next));
+	schedule_delayed_work(&sync_cmos_work, timespec_to_jiffies(&next));
 }
 
 static void notify_cmos_timer(void)
 {
 	if (!no_sync_cmos_clock)
-		mod_timer(&sync_cmos_timer, jiffies + 1);
+		schedule_delayed_work(&sync_cmos_work, 0);
 }
 
 #else

