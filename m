Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbXF1Jnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbXF1Jnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 05:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbXF1Jni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 05:43:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35488 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754988AbXF1Jni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 05:43:38 -0400
Date: Thu, 28 Jun 2007 02:42:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch-mm 00/28] High resolution timer updates and x86_64
 support - V3
Message-Id: <20070628024233.8e29a5bd.akpm@linux-foundation.org>
In-Reply-To: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 13:32:25 -0000 Thomas Gleixner <tglx@linutronix.de> wrote:

> The following patch series contains:
> 
> - dyntick bugfixes for -mm (caused by the cpuidle changes in ACPI)
> 
> - updates and improvements to high resolution timer / dynticks 
> 
> - high resolution timer / dynticks support for x86_64

Blam.  http://userweb.kernel.org/~akpm/hpet-crash.jpg

time_init() is called before slab is set up.  We cannot do memory
allocations inside time_init().

> The patch set has been tested in the -hrt and -rt trees for quite a while
> and the initial problems have been sorted out. Thanks to the folks from the
> PowerTop project for testing and feedback.

hrm.  Looks like none of your testers have HPET_ID_LEGSUP hardware.  This:

--- a/arch/i386/kernel/hpet.c~a
+++ a/arch/i386/kernel/hpet.c
@@ -376,7 +376,7 @@ int __init hpet_enable(void)
 
 	clocksource_register(&clocksource_hpet);
 
-	if (id & HPET_ID_LEGSUP) {
+	if (0 && (id & HPET_ID_LEGSUP)) {
 		hpet_enable_int();
 		hpet_reserve_platform_timers(id);
 		/*
_

gets it working.  It basically nobbles the hpet and the kernel chose the
TSC clocksource instead.


btw, if you want to know why I go on and on about crappy commenting, try to
work out from the kernel source code what HPET_ID_LEGSUP is, and why it
gets special treatment.  It is not possible.  This is not maintainable
code.

