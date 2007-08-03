Return-Path: <linux-kernel-owner+w=401wt.eu-S1762782AbXHCOOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762782AbXHCOOw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 10:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760803AbXHCOOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 10:14:46 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:34262 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760936AbXHCOOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 10:14:45 -0400
Subject: Regression in 2.6.22, clock problems on Turion with 32-bit kernel
From: Ben Collins <ben.collins@ubuntu.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>
Content-Type: text/plain
Organization: Canonical
Date: Fri, 03 Aug 2007 10:14:44 -0400
Message-Id: <1186150484.8105.57.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tim and I have both experienced this problem. With 2.6.20 things worked
perfectly fine on these systems. The two machines are a Dell 1501 Turion
X2 and Dell 1521 Turion X2.

With 2.6.22 the kernel hangs shortly after starting up, but after
several minutes, you can get activity by tapping keyboard (generating
interrupts). We have NO_HZ and HIGH_RES enabled, but even disabling this
doesn't help.

I've tried every combination of boot param revolving around clocksource
and interrupts. The only thing that gets me booting is nolapic, but then
again, that knocks me down to a single cpu. Setting maxcpus=1 or nosmp
doesn't fix it.

We both bisected (separately I might add) down to this commit:

commit e9e2cdb412412326c4827fc78ba27f410d837e6e
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Feb 16 01:28:04 2007 -0800

    [PATCH] clockevents: i386 drivers

    Add clockevent drivers for i386: lapic (local) and PIT/HPET (global).  Update
    the timer IRQ to call into the PIT/HPET driver's event handler and the
    lapic-timer IRQ to call into the lapic clockevent driver.  The assignement of
    timer functionality is delegated to the core framework code and replaces the
    compile and runtime evalution in do_timer_interrupt_hook()

    Use the clockevents broadcast support and implement the lapic_broadcast
    function for ACPI.

    No changes to existing functionality.

Note, the problem doesn't happen when using an x86_64 kernel with the
same basic config, on the same machine.

Hoping to get some tips to test something a bit more specific in this
patch.

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

