Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbXGBIo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbXGBIo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 04:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXGBIoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 04:44:18 -0400
Received: from mail02.vsnet.ch ([153.109.10.41]:52485 "EHLO mail02.vsnet.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbXGBIoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 04:44:18 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: tglx@linutronix.de
Subject: [BUG] clockevents : clockevent_delta2ns usage
Date: Mon, 2 Jul 2007 10:43:39 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Remy Bohmer" <l.pinguin@gmail.com>,
       "David Brownell" <david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707021043.39617.marc.pignat@hevs.ch>
X-VSnet-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all!

We're currently working with David Brownell and Remy Bohmer on implementation
of clocksource/events on the at91rm9200 processor (arm arch).

While debugging our implementation, we came about a rounding problem, in the
setting of min_delta_ns field, and I think it can be in almost all clock_event_device.

Almost all clock_event_device initialize the field min_delta_ns this way:
	clkevt32k.mult = div_sc(CLOCK_TICK_RATE, NSEC_PER_SEC, clkevt32k.shift);
	clkevt32k.max_delta_ns = clockevent_delta2ns(0x000fffff, &clkevt32k);
	clkevt32k.min_delta_ns = clockevent_delta2ns(1, &clkevt32k);

The clockevent_delta2ns function rounds the result down, so the rounded min_delta_ns
can be smaller than the real min_delta_ns.

When clockevents_program_event is called, this rounding problem shows up:
...
	if (delta < dev->min_delta_ns)
		delta = dev->min_delta_ns;

	clc = delta * dev->mult;
	clc >>= dev->shift;

	return dev->set_next_event((unsigned long) clc, dev)

When delta is to small, min_delta_ns will be used, and with a wrong rounding,
will call set_next_event with a value smaller than the expected, and 
set_next_event will fail.

This will result in an infinite loop when clockevents_program_event is called
from tick_program_event with a too short delay.

In our driver, we fixed this problem using that:
-	clkevt32k.min_delta_ns = clockevent_delta2ns(1, &clkevt32k);
+	clkevt32k.min_delta_ns = clockevent_delta2ns(1, &clkevt32k)+1;

I think other clock_event_device can have the same problem.

Regards

Marc
