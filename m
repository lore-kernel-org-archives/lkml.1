Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbYGUSA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbYGUSA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 14:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYGUSAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 14:00:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:35261 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbYGUSAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 14:00:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,224,1215414000"; 
   d="scan'208";a="599657820"
Date: Mon, 21 Jul 2008 10:59:41 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Zachary Amsden <zach@vmware.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Message-ID: <20080721175940.GA14380@linux-os.sc.intel.com>
References: <Pine.LNX.4.55.0807182254270.12125@cliff.in.clinika.pl> <1216420937.30348.30.camel@bodhitayantram.eng.vmware.com> <20080718224922.GB4507@linux-os.sc.intel.com> <86802c440807181551l7e6e143dy7cea8ab59f1830ed@mail.gmail.com> <20080718230012.GD4507@linux-os.sc.intel.com> <86802c440807181604y502e7deal98abfeb1ceee769d@mail.gmail.com> <20080718231828.GE4507@linux-os.sc.intel.com> <20080719214944.GC836@elte.hu> <20080719215325.GA12737@elte.hu> <20080720120811.GA16138@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720120811.GA16138@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 05:08:11AM -0700, Ingo Molnar wrote:
> 
> i've merged tip/x86/x2apic into tip/master, and it seems to be working
> fine. One UP build fix was needed for Xen, see below.

Thanks Ingo. I tested tip/master and found an issue (patch attached)
for x2apic support. This is not because of the recent merges we had, but
because of something(where we still access memory based interface after
enabling x2apic mode) that slipped through my earlier tests.

Probably it is a good idea to unmap the memory mapped interface, once we switch
to x2apic mode. That will catch the issues much earlier. I will
post another patch for this.

Meanwhile, I will do more testing of tip/master along with addressing
open issues.
---

[patch] x64, apic: use generic apic_write() for ack_APIC_irq()

ack_APIC_irq() is used at too many generic places (and not just during
irq_chip handling!) to use the native_apic_mem_write(). For ex, this will
break x2apic based systems.

Fix ack_APIC_irq() to use the generic apic_write() even for 64-bit.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index 300b65e..1df955f 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -138,11 +138,7 @@ static inline void ack_APIC_irq(void)
 	 */
 
 	/* Docs say use 0 for future compatibility */
-#ifdef CONFIG_X86_32
 	apic_write(APIC_EOI, 0);
-#else
-	native_apic_mem_write(APIC_EOI, 0);
-#endif
 }
 
 extern int lapic_get_maxlvt(void);
