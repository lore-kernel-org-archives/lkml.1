Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbZFWRTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbZFWRTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbZFWRS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:18:57 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:57091 "EHLO lvk.cs.msu.su"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbZFWRS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:18:57 -0400
X-Greylist: delayed 1420 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2009 13:18:56 EDT
From: "Nikita V. Youshchenko" <yoush@cs.msu.su>
To: linux-kernel@vger.kernel.org
Subject: [rt-preempt / powerpc] Looks like tick_sched_timer() is a major latency source
Date: Tue, 23 Jun 2009 20:55:11 +0400
User-Agent: KMail/1.9.9
Cc: Alexander Kaliadin <akaliadin@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906232055.12412@zigzag.lvk.cs.msu.su>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I was trying to get minimum possible in-kernel latencies on a freescale 
8360 CPU based board (powerpc arch). There is a project where <30 us worst 
case latency is required, and question was - is it possible to use 
linux+preempt-rt (which is preferred for a number of reason) or not.

I used 2.6.29.5-rt21 kernel, which, for my best knowledge, was the 
last "release" of preempt-rt at the moment when I started.

I used 8360's Generic Timer Module to both to generate interrupts and to 
measure lanencies. GTM timers continue to count after firing an interrupt, 
so latency may be measured my reading current timer value and comparing 
that with the value at which interrupt was generated. I believe this 
method is both simple and accurate.

The result is:

- average latency up to IRQF_NODELAY interrupt header is 2-3 us, even on a 
system with high i/o and cpu load. To generate load, I used a flood ping 
and several 'while true; do true; done' cpu-eaters.

- but worst-case latency is BAD. I occasionally got >50 us even on idle 
system.

I tried hard to identify the latency source, and at some moment discovered 
tick_sched_timer() from kernel/time/tick-sched.c. This routine is called 
from timer interrupt with hardware interrupts disabled, and may execute 
for 50 us and more.

Could someone please comment on this?
Is it possible to move (part of) tick_sched_timer() call tree out of 
hardware-interrupts-disabled context without breaking things?

Nikita

Please CC: reply to my e-mail address. Thanks.
