Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbYIMJLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbYIMJLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 05:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbYIMJLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 05:11:11 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:15636 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbYIMJLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 05:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vKdPM8aCV1EZuIxYFWu7qGYzkVdg0p0gWnAXB+1zC/F4ZkU/0VTL3qEB+orR3g74Be
         1W4YB1+o7Vwol2M9unWdTfpIt/nVuKVEiUj+rgl/4FNBw0x+senBePjIdETmJtBp9yla
         qu64XfFgG1o3mhpcyrNscl8C0KXePY0g2mGKY=
Date: Sat, 13 Sep 2008 13:11:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86: io-apic - do not use KERN_DEBUG marker too much
Message-ID: <20080913091116.GA12564@lenovo>
References: <20080908153806.GB7278@lenovo> <86802c440809121255k1af2881dwb00ebb6f4a58057b@mail.gmail.com> <86802c440809121257s23e5193aqb7939fdc94473c9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809121257s23e5193aqb7939fdc94473c9d@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Fri, Sep 12, 2008 at 12:57:21PM -0700]
...
| >  0 add_pin_to_irq: irq 15 --> apic 0 pin 15
| > IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
| >  8-16 8-17 8-18 8-19 8-20 8-21 8-22 8-23 (apicid-pin) not connected
| >  9-0 9-1 9-2 9-3 9-4 9-5 9-6 9-7 9-8 9-9 9-10 9-11 9-12 9-13 9-14 9-15
| > 9-16 9-17 9-18 9-19 9-20 9-21 9-22 9-23 (apicid-pin) not connected
| >
| 
| only first one not connected at first, and ...
| 
| why not just revert those two patches?
| 
| YH
| 

Ingo, Yinghai,

here is a quick fix for this.

Ingo - choose either use this patch or just _revert_ both
previous - i do accept any decision.

		- Cyrill -
---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] x86: io-apic - fix misplaced EOL in setup_IO_APIC_irqs

This issue is brought by mine commit
f5143bce9d424bd400da48b1c7a2bc6a24403ada.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic.c	2008-09-11 22:37:18.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic.c	2008-09-13 13:02:20.000000000 +0400
@@ -1541,6 +1541,11 @@ static void __init setup_IO_APIC_irqs(vo
 						pin);
 				continue;
 			}
+			if (notcon) {
+				apic_printk(APIC_VERBOSE,
+					" (apicid-pin) not connected\n");
+				notcon = 0;
+			}
 
 			irq = pin_2_irq(idx, apic, pin);
 #ifdef CONFIG_X86_32
@@ -1552,11 +1557,6 @@ static void __init setup_IO_APIC_irqs(vo
 			setup_IO_APIC_irq(apic, pin, irq,
 					irq_trigger(idx), irq_polarity(idx));
 		}
-		if (notcon) {
-			apic_printk(APIC_VERBOSE,
-				" (apicid-pin) not connected\n");
-			notcon = 0;
-		}
 	}
 
 	if (notcon)
