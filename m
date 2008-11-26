Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYKZVGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYKZVGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYKZVG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:06:29 -0500
Received: from flusers.ccur.com ([12.192.68.2]:46390 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752248AbYKZVG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:06:28 -0500
Date: Wed, 26 Nov 2008 16:06:13 -0500
From: Joe Korty <joe.korty@ccur.com>
To: Greg KH <greg@kroah.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linux API <linux-api@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ABI Documentation for /proc/timer_list
Message-ID: <20081126210613.GA20529@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <20081121221113.GA13566@tsunami.ccur.com> <517f3f820811250806n33850ea8ua8e203347c0f7ba6@mail.gmail.com> <20081125185740.GA21806@tsunami.ccur.com> <20081126164845.GA17394@tsunami.ccur.com> <20081126170715.GA28422@kroah.com> <20081126173410.GA17879@tsunami.ccur.com> <20081126173931.GA1636@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126173931.GA1636@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document /proc/timer_list ABI.

This documents all of /timer_list, including the extension
adding jiffie timers, as proposed in the patch:

   [PATCH] Display active jiffie timers in /proc/timer_list, v2 

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.28-rc6/Documentation/ABI/stable/procfs-timer_list
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.28-rc6/Documentation/ABI/stable/procfs-timer_list	2008-11-26 15:55:04.000000000 -0500
@@ -0,0 +1,96 @@
+What:		/proc/timer_list
+Date:		November 2008
+Contact:	Ingo Molnar <mingo@elte.hu>
+		Thomas Gleixner <tglx@linutronix.de>
+		Joe Korty <joe.korty@ccur.com>
+Revision-Rate:	Moderate
+At-Revision:	0.5
+Description:
+		/proc/timer_list displays most everything about every kind
+		of timer, and some things about time too.
+
+		The contents of this file should be expected to change,
+		as the data displayed corresponds directly to various
+		kernel-internal data structures.  For this reason, the first
+		line contains the file revision.  It is the responsibility
+		of this file's maintainers to bump the revision each time a
+		kernel is released having incompatible changes in this file.
+
+		Section Overview
+		----------------
+		The file contains several somewhat independent sections.
+
+		The first section contains a few lines of global info.
+		Examples: file version id, #clock types in the kernel,
+		#nsecs since boot.
+
+		The second section is organized per-cpu.  Each cpu subsection
+		in turn contains several sub-subsections which are, in order
+		of appearance:
+
+		   The contents of the data structures associated with each
+		   clock (CLOCK_REALTIME, CLOCK_MONOTONIC, etc) on this cpu.
+		   Examples: base, index, resolution, get_timer, offset.
+		   Under each of these clocks is, in turn, a display of all
+		   the active high resolution timers queued to that clock.
+		   Example: all lines beginning with '#'.
+
+		   The contents of per-cpu timer data fields not associated
+		   with a particular clock type (ie, shared by both clocks or
+		   not associated with any clock). Examples: expires_next,
+		   hres_active, nr_event, nohz_mode, all things idle_*,
+		   tick_stopped, last_jiffies, next_jiffies.
+
+		   A display of low resolution (ie, jiffie) timer wheel
+		   data.  Examples: base, running_timer, timer_jiffies.
+		   Also under this section is a display, one per line, of
+		   each active jiffie timer queued to this cpu.  Examples:
+		   All lines under an 'active jiffie timers' section that
+		   begin with a number.
+
+		The third and final section describes each 'tick device'
+		known to the kernel.  A tick device is a piece of hardware
+		capable of generating periodic and/or one shot interrupts
+		under software control, and thus is capable of generating
+		the interrupts needed to expire the various active timers at
+		their given expiration times.  Examples: hpet, pit, lapic.
+
+		Hires Timer Layout
+		------------------
+		High resolution timers are displayed on lines that begin
+		with a '#' and always appear under one of the many sections
+		labeled 'active timers'.  There is an 'active timers'
+		section for every cpu and every clock.
+
+		The fields of a hrtimer, spread out over two lines, are:
+
+		line 1 fields:
+		  1 - unique hrtimer index (#0, #1, #2, etc)
+		  2 - kernel address of the hrtimer data structure
+		      in question
+		  3 - function to be called when timer expires
+		  4 - timer state (eg, S:01), avail states, OR-able:
+		      0 - inactive
+		      1 - enqueued
+		      2 - callback
+		      4 - pending
+		      8 - migrate
+		  5 - function which created the timer
+		  6 - process name & pid which created the timer
+
+		line 2 fields:
+		  1 - absolute expiration time, range format (start - end)
+		  2 - relative expiration time, range format (start - end)
+
+		Lowres Timer Layout
+		-------------------
+		Low resolution timers are displayed one-per-line under
+		sections labeled 'active jiffie timers'.  There is one such
+		section per cpu.  A lowres timer has the following fields:
+
+		  1 - #jiffies remaining until timer expires
+		  2 - function to be called on expiration
+		  3 - data value to be given to the above function on
+		      expiration
+		  4 - function which created this timer
+		  5 - name & pid of the process that created this timer

