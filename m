Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbXJYTri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbXJYTri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 15:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbXJYTra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 15:47:30 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:35748 "EHLO
	outbound2-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752557AbXJYTr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 15:47:29 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <4720F21F.9090404@am.sony.com>
Date: Thu, 25 Oct 2007 12:44:31 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: IRQ off latency of printk is very high
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2007 19:44:40.0112 (UTC) FILETIME=[7B6C1B00:01C8173F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been looking at 'IRQ off' latency in the Linux kernel, on
version 2.6.22 for target using an ARM processor.
I use a serial console, at 115200 bps.

I've noticed that calls to printk disable interrupts for
excessively long times.  I have a long test printk of
over 200 chars, that holds interrupts off for 24 milliseconds.

The kernel drops ticks in this case.  I changed to HZ=1000
to more easily see the dropped ticks, and I'm losing about
23 ticks (no surprise there).

I see long interrupt off periods for vprintk and release_console_sem,
both in kernel/printk.c

Results with HRT disabled, HZ=1000:

Below is output from a test printk I inserted into sys_sync().
I have PRINTK_TIMES turned on.

/proc # sync
[ 2292.851106] I'm now in the sys_sync system call, performing an extremely long
 printk with lots of words that go on and on and on and if it gets any longer I
just might scream but that's beside the point, as a test of interrupt disable ti
me for the printk system itself.
[ 2292.895751] interval=44816825, jiffies=22
[ 2292.904529] This is a shorter string - will we drop jiffies here??
[ 2292.933729] interval=29173886, jiffies=23
/proc # sync
[ 2296.353092] I'm now in the sys_sync system call, performing an extremely long
 printk with lots of words that go on and on and on and if it gets any longer I
just might scream but that's beside the point, as a test of interrupt disable ti
me for the printk system itself.
[ 2296.377637] interval=24573237, jiffies=1
[ 2296.381856] This is a shorter string - will we drop jiffies here??
[ 2296.388356] interval=6488141, jiffies=1

--------------------------

Data from irq_latency measurement tool
Notes:
 * 24 ms vprintk = long printk
 * 6 ms printk = shorter printk
 * 4 ms printk = timing report printks
 * I don't know what the heck that preempt_schedule_irq is doing in there.
 I only saw that once, on this test.

/proc # cat irq_latency
irq latency worst 20 @ CPU 0
filter: 0
    0.024348  vprintk
    0.024348  vprintk
    0.024343  vprintk
    0.006439  vprintk
    0.006439  vprintk
    0.006338  vprintk
    0.004260  preempt_schedule_irq
    0.004248  vprintk
    0.004248  vprintk
    0.004247  vprintk
    0.004072  vprintk
    0.003966  vprintk
    0.000345  latency_start
    0.000158  mpu_timer1  26
    0.000157  mpu_timer1  26
    0.000157  mpu_timer1  26
    0.000156  mpu_timer1  26
    0.000151  mpu_timer1  26
    0.000150  mpu_timer1  26
    0.000150  mpu_timer1  26

It looks like vprintk() holds off interrupts for the entire
duration of outputting the data to the serial console.
release_console_sem() appears to as well.

The local_irq_save and restore appear to have been added
in February, 2007 by Mathieu.

Are these are really needed, with all this other locking
going on?  Any ideas for fixing this?
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

