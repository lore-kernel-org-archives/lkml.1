Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbZFMGti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbZFMGti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 02:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbZFMGta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 02:49:30 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:57568 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbZFMGt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 02:49:29 -0400
In-Reply-To: <alpine.LFD.2.00.0906091028020.3351@localhost.localdomain>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-arch@vger.kernel.org, linux-arch-owner@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 22/27] score: create kernel files signal.c sys_score.c time.c
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFEC1BACBF.E1025EE1-ON482575D4.0022F1FA-482575D4.0023C068@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Sat, 13 Jun 2009 14:26:02 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/13 ?? 02:26:06,
	Serialize complete at 2009/06/13 ?? 02:26:06
Content-Type: text/plain; charset="GB2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5D6oD54011773

Hi, tglx,

linux-arch-owner@vger.kernel.org –¥”⁄ 2009-06-09 16:51:13:

>   The clock source device is a device which provides a monotonic
>   increasing counter which can wrap around at some point. The wrap
>   around point has to be power of 2 and is defined via the .mask
>   member of the clock source device structure. The generic time
>   keeping code takes care of the conversion to nsec based time and
>   handles NTP and other adjustments.
> 
>   So in practice you need either two hardware devices (counter and
>   interrupt generator) or a device which has a monotonic increasing
>   counter and a match register which generates an interrupt when the
>   counter value and the match register are the same.
> 

I update time.h like below. Thanks your comment.

Best Regards
liqin

--
diff --git a/arch/score/kernel/time.c b/arch/score/kernel/time.c
new file mode 100644
index 0000000..cd66ba3
--- /dev/null
+++ b/arch/score/kernel/time.c
@@ -0,0 +1,99 @@
+/*
+ * arch/score/kernel/time.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+
+#include <asm/scoreregs.h>
+
+irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+       struct clock_event_device *evdev = dev_id;
+
+       /* clear timer interrupt flag */
+       outl(1, P_TIMER0_CPP_REG);
+       evdev->event_handler(evdev);
+
+       return IRQ_HANDLED;
+}
+
+static struct irqaction timer_irq = {
+       .handler = timer_interrupt,
+       .flags = IRQF_DISABLED | IRQF_TIMER,
+       .name = "timer",
+};
+
+static int score_timer_set_next_event(unsigned long delta,
+               struct clock_event_device *evdev)
+{
+       outl((TMR_M_PERIODIC | TMR_IE_ENABLE), P_TIMER0_CTRL);
+       outl(delta, P_TIMER0_PRELOAD);
+       outl(inl(P_TIMER0_CTRL) | TMR_ENABLE, P_TIMER0_CTRL);
+
+       return 0;
+}
+
+static void score_timer_set_mode(enum clock_event_mode mode,
+               struct clock_event_device *evdev)
+{
+       switch (mode) {
+       case CLOCK_EVT_MODE_PERIODIC:
+               outl((TMR_M_PERIODIC | TMR_IE_ENABLE), P_TIMER0_CTRL);
+               outl(SYSTEM_CLOCK/HZ, P_TIMER0_PRELOAD);
+               outl(inl(P_TIMER0_CTRL) | TMR_ENABLE, P_TIMER0_CTRL);
+               break;
+       case CLOCK_EVT_MODE_ONESHOT:
+       case CLOCK_EVT_MODE_SHUTDOWN:
+       case CLOCK_EVT_MODE_RESUME:
+       case CLOCK_EVT_MODE_UNUSED:
+               break;
+       default:
+               BUG();
+       }
+}
+
+static struct clock_event_device score_clockevent = {
+       .name           = "score_clockevent",
+       .features       = CLOCK_EVT_FEAT_PERIODIC,
+       .shift          = 16,
+       .set_next_event = score_timer_set_next_event,
+       .set_mode       = score_timer_set_mode,
+};
+
+void __init time_init(void)
+{
+       timer_irq.dev_id = &score_clockevent;
+       setup_irq(IRQ_TIMER , &timer_irq);
+
+       /* setup COMPARE clockevent */
+       score_clockevent.mult = div_sc(SYSTEM_CLOCK, NSEC_PER_SEC,
+                                       score_clockevent.shift);
+       score_clockevent.max_delta_ns = clockevent_delta2ns((u32)~0,
+                                       &score_clockevent);
+       score_clockevent.min_delta_ns = clockevent_delta2ns(50,
+                                               &score_clockevent) + 1;
+       score_clockevent.cpumask = cpumask_of(0);
+       clockevents_register_device(&score_clockevent);
+}
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
