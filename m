Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbZEAMWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbZEAMWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbZEAMWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:22:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:49467 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbZEAMWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:22:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 04/27] asm-generic: add legacy I/O header files
Date: Fri, 1 May 2009 14:22:29 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <10b3a32656e5552458db7412ef9ff8530d5f92aa.1241105648.git.arnd@arndb.de> <c1a198be0904302309w4154f97dqddd0b2df1924a821@mail.gmail.com>
In-Reply-To: <c1a198be0904302309w4154f97dqddd0b2df1924a821@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905011422.29753.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/HD5665Yuts8Y8MuI6I9YNA6u67o1pmGe9ujx
 AXOmFHfra0pWuZhpFWC5WXJ+yHDdLIvABpzmHJkbElM84ssJ+e
 kRc3v/9YYwLfxAbEw0wPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 May 2009, Michal Simek wrote:
> > +/*
> > + * CLOCK_TICK_RATE is highly PC-specific and should not
> > + * be used in portable code. 1193182 is the value for the
> > + * original i8253 PIC.
> > + */
> > +#ifndef CLOCK_TICK_RATE
> > +#define CLOCK_TICK_RATE                1193182
> > +#endif
> 
> 
> Why is this in generic code?

CLOCK_TICK_RATE is only used in a few places:

drivers/char/vt_ioctl.c:                        arg = CLOCK_TICK_RATE / arg;
drivers/char/vt_ioctl.c:                        count = CLOCK_TICK_RATE / count;
drivers/clocksource/acpi_pm.c:  ((CALIBRATE_LATCH * (PMTMR_TICKS_PER_SEC >> 10)) / (CLOCK_TICK_RATE>>10))
drivers/input/joystick/analog.c:#define DELTA(x,y)      (cpu_has_tsc ? ((y) - (x)) : ((x) - (y) + ((x) < (y) ? CLOCK_TICK_RATE / HZ : 0
drivers/rtc/rtc-pxa.c:#define TIMER_FREQ                CLOCK_TICK_RATE
drivers/serial/serial_ks8695.c:         .uartclk        = CLOCK_TICK_RATE * 16,
drivers/watchdog/davinci_wdt.c: timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) & 0xffffffff);
drivers/watchdog/davinci_wdt.c: timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) >> 32);
drivers/watchdog/ks8695_wdt.c:  unsigned long tval = wdt_time * CLOCK_TICK_RATE;
include/linux/jiffies.h:#define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ)  /* For divider */
include/linux/jiffies.h:#define ACTHZ (SH_DIV (CLOCK_TICK_RATE, LATCH, 8))
include/linux/timex.h: *        Moved CLOCK_TICK_RATE, CLOCK_TICK_FACTOR and FINETUNE to asm/timex.h
sound/oss/pas2_pcm.c:           foo = ((CLOCK_TICK_RATE / 2) + (arg / 2)) / arg;
sound/oss/pas2_pcm.c:           arg = ((CLOCK_TICK_RATE / 2) + (foo / 2)) / foo;
sound/oss/pas2_pcm.c:           foo = (CLOCK_TICK_RATE + (arg / 2)) / arg;
sound/oss/pas2_pcm.c:           arg = (CLOCK_TICK_RATE + (foo / 2)) / foo;

All of these are either PC-specific, or they don't actually care
about the specific value. Most architectures just use the
value from the IBM PC, so we might as well make that the generic
default.

Alternatively, we could also move the definition back to linux/timex.h
and allow asm/timex.h to be empty.

	Arnd <><
