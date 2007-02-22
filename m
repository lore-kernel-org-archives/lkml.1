Return-Path: <linux-kernel-owner+w=401wt.eu-S1751668AbXBVPqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbXBVPqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 10:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXBVPqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 10:46:33 -0500
Received: from www.osadl.org ([213.239.205.134]:49789 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751667AbXBVPqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 10:46:32 -0500
Subject: Re: NO_HZ: timer interrupt stuck [Re: Linux 2.6.21-rc1]
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>
References: <20070221230409.GA1158@dreamland.darkstar.lan>
	 <1172099859.25076.132.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 16:51:41 +0100
Message-Id: <1172159501.25076.182.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 13:36 +0100, Jan Engelhardt wrote:
> >
> >Yes, we switch away from PIT and use the local APIC timer. (LOC)
> 
> What's the benefit of doing so - and why has not it been done before?
> I mean, I run a regular 2.6.18.6,
> /sys/devices/system/clocksource/clocksource0/current_clocksource (is this
> related?) shows "acpi_pm", but the IRQ0 counter increases at HZ. Maybe I
> am confusing things, but why the need for PIT when clocksource is acpi_pm
> anyway?

acpi_pm is only a readout device to keep track of current time.

PIT and local APIC timer are used to provide either periodic or one shot
programmable timer events.

Up to now the kernel started PIT and local APIC timer in parallel with
the same period where PIT incremented jiffies and local APIC timer
called update_process_times() and profile_tick. We changed this to let
the boot cpu increment jiffies inside the local apic timer interrupt
after PIT has been stopped. A whole interrupt for jiffies64++ is waste.

Also when we switch to nohz / high resolution mode, we want to use the
local APIC, as it is much faster to access. The maximum delta to program
is 27ms for the pit and ~1sec for the local APIC. This is important for
dynticks, as we can achieve longer idle sleeps w/o reprogramming the
timer.

	tglx



