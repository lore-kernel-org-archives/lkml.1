Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbYFIWAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbYFIWAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYFIWAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:00:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbYFIWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:00:19 -0400
Date: Mon, 9 Jun 2008 14:59:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: zippel@linux-m68k.org, tglx@linutronix.de, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NTP: Let update_persistent_clock() sleep
Message-Id: <20080609145923.fe5dc86d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.55.0806091912390.26593@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805281856200.29522@cliff.in.clinika.pl>
	<20080528201612.d2641dc3.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0806091950360.6791@localhost.localdomain>
	<Pine.LNX.4.55.0806091912390.26593@cliff.in.clinika.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008 19:18:52 +0100 (BST)
"Maciej W. Rozycki" <macro@linux-mips.org> wrote:

> Hi,
> 
> > > Roman does most of the NTP work afaik.  I consider Thomas's git-hrt
> > > tree to be the route via which NTP changes get into linux-next and
> > > mainline.
> > 
> > That function is a little misplaced, we already have a driver/rtc dir, 
> > where this should go in the long term and ntp.c only providing the 
> > trigger, that time is stable. There it would also be possible to better 
> > take into account any quirks needed to update the chip.
> 
>  I posted a separate change to implement a backend using the RTC class
> device.  I think this is the right solution till all the platforms are
> moved away from legacy RTC drivers.
> 
>  I think you are right about the long-term implications and apart from any
> possible quirks I think the interface could get improved as there are RTC
> chips we support nowadays that provide sub-second resolution.
> 


Are there any objections to the patch under discussion?

Thanks.


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

diff -puN kernel/time/ntp.c~ntp-let-update_persistent_clock-sleep kernel/time/ntp.c
--- a/kernel/time/ntp.c~ntp-let-update_persistent_clock-sleep
+++ a/kernel/time/ntp.c
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
_

