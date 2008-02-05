Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbYBEAp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbYBEAp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 19:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbYBEApT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 19:45:19 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37500 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757463AbYBEApR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 19:45:17 -0500
Date: Mon, 4 Feb 2008 16:45:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: v2.6.24-mm1 lockdep.c warning
Message-Id: <20080204164509.a98d4ff5.akpm@linux-foundation.org>
In-Reply-To: <47A7AD18.9050304@gmail.com>
References: <47A7AD18.9050304@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2008 20:26:00 -0400
Kevin Winchester <kjwinchester@gmail.com> wrote:

> Found this in my dmesg:
> 
> [   10.671500] ------------[ cut here ]------------
> [   10.671500] WARNING: at kernel/lockdep.c:2037
> trace_hardirqs_on+0xba/0x113()
> [   10.671500] Pid: 0, comm: swapper Not tainted 2.6.24-mm1 #2
> [   10.671500]  [<c011a54f>] warn_on_slowpath+0x3c/0x4c
> [   10.671500]  [<c01335a0>] ? check_usage_forwards+0x19/0x3b
> [   10.671500]  [<c013376d>] ? mark_lock+0x1ab/0x3ae
> [   10.671500]  [<c026c84d>] ? ata_hsm_qc_complete+0xbc/0xc2
> [   10.671500]  [<c03495eb>] ? _spin_unlock_irq+0x22/0x42
> [   10.671500]  [<c0133b0e>] trace_hardirqs_on+0xba/0x113
> [   10.671500]  [<c03495eb>] _spin_unlock_irq+0x22/0x42
> [   10.671500]  [<c011103d>] hpet_rtc_interrupt+0xe8/0x299
> [   10.671500]  [<c0139547>] handle_IRQ_event+0x1a/0x46
> [   10.671500]  [<c013a359>] handle_edge_irq+0xa6/0x102
> [   10.671500]  [<c013a2b3>] ? handle_edge_irq+0x0/0x102
> [   10.671500]  [<c0106070>] do_IRQ+0x87/0xb0
> [   10.671500]  [<c010470a>] common_interrupt+0x2e/0x34
> [   10.671500]  [<c0102974>] ? default_idle+0x45/0x72
> [   10.671500]  [<c010292f>] ? default_idle+0x0/0x72
> [   10.671500]  [<c01028ff>] cpu_idle+0x73/0xa3
> [   10.671500]  [<c033fcd1>] rest_init+0x61/0x63
> [   10.671500]  =======================
> [   10.671500] ---[ end trace e5cdd42f557be0f0 ]---
> 
yup, I hit that too.  It looks like Ingo has deided to merge the
below into mainline.  I'll put it in the hot-fixes directory.


From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/rtc.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN include/linux/rtc.h~hpet-borkage-fix include/linux/rtc.h
diff -puN include/asm-generic/rtc.h~hpet-borkage-fix include/asm-generic/rtc.h
--- a/include/asm-generic/rtc.h~hpet-borkage-fix
+++ a/include/asm-generic/rtc.h
@@ -35,10 +35,11 @@
 static inline unsigned char rtc_is_updating(void)
 {
 	unsigned char uip;
+	unsigned long flags;
 
-	spin_lock_irq(&rtc_lock);
+	spin_lock_irqsave(&rtc_lock, flags);
 	uip = (CMOS_READ(RTC_FREQ_SELECT) & RTC_UIP);
-	spin_unlock_irq(&rtc_lock);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 	return uip;
 }
 
@@ -46,6 +47,8 @@ static inline unsigned int get_rtc_time(
 {
 	unsigned long uip_watchdog = jiffies;
 	unsigned char ctrl;
+	unsigned long flags;
+
 #ifdef CONFIG_MACH_DECSTATION
 	unsigned int real_year;
 #endif
@@ -72,7 +75,7 @@ static inline unsigned int get_rtc_time(
 	 * RTC has RTC_DAY_OF_WEEK, we ignore it, as it is only updated
 	 * by the RTC when initially set to a non-zero value.
 	 */
-	spin_lock_irq(&rtc_lock);
+	spin_lock_irqsave(&rtc_lock, flags);
 	time->tm_sec = CMOS_READ(RTC_SECONDS);
 	time->tm_min = CMOS_READ(RTC_MINUTES);
 	time->tm_hour = CMOS_READ(RTC_HOURS);
@@ -83,7 +86,7 @@ static inline unsigned int get_rtc_time(
 	real_year = CMOS_READ(RTC_DEC_YEAR);
 #endif
 	ctrl = CMOS_READ(RTC_CONTROL);
-	spin_unlock_irq(&rtc_lock);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
 	{
_

