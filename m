Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbXB1SaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbXB1SaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 13:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbXB1SaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 13:30:07 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38198 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228AbXB1SaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 13:30:05 -0500
Date: Wed, 28 Feb 2007 10:30:20 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bill Davidsen <davidsen@tmr.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, ak@suse.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH] affinity is not defined in non-smp kernels - i386
In-Reply-To: <45E5BC5F.4060208@tmr.com>
Message-ID: <Pine.LNX.4.64.0702281029000.12485@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
 <1172646816.29709.15.camel@sebastian.intellilink.co.jp>
 <m1wt22iw1z.fsf@ebiederm.dsl.xmission.com> <45E5BC5F.4060208@tmr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Feb 2007, Bill Davidsen wrote:
> 
> Where is the initialization performed, then?

Here's the commit with the patch from Eric that I pushed out (I had 
thought I'd already applied it for rc2, but I obviously hadn't. Blush. 
It's there now in -git, but obviously not in the -rc2 release).

It's got the explanation too.

		Linus

---
commit 2ff7354fe888f46f6629b57e463b0a1eb956c02b
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Tue Feb 27 00:27:41 2007 -0700

    [PATCH] x86_64/i386 irq: Fix !CONFIG_SMP compilation
    
    When removing set_native_irq I missed the fact that it was
    called in a couple of places that were compiled even when
    SMP support is disabled.  And since the irq_desc[].affinity
    field only exists in SMP things broke.
    
    Thanks to Simon Arlott <simon@arlott.org> for spotting this.
    
    There are a couple of ways to fix this but the simplest one
    is to just remove the assignments.  The affinity field is only
    used to display a value to the user, and nothing on either i386
    or x86_64 reads it or depends on it being any particlua value,
    so skipping the assignment is safe.  The assignment that
    is being removed is just for the initial affinity value before
    the user explicitly sets it.  The irq_desc array initializes
    this field to CPU_MASK_ALL so the field is initialized to
    a reasonable value in the SMP case without being set.
    
    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
index 6fec4da..e4408ff 100644
--- a/arch/i386/kernel/io_apic.c
+++ b/arch/i386/kernel/io_apic.c
@@ -1354,7 +1354,6 @@ static void __init setup_IO_APIC_irqs(void)
 		}
 		spin_lock_irqsave(&ioapic_lock, flags);
 		__ioapic_write_entry(apic, pin, entry);
-		irq_desc[irq].affinity = TARGET_CPUS;
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 	}
 	}
@@ -2875,7 +2874,6 @@ int io_apic_set_pci_routing (int ioapic, int pin, int irq, int edge_level, int a
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	__ioapic_write_entry(ioapic, pin, entry);
-	irq_desc[irq].affinity = TARGET_CPUS;
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return 0;
diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index 48593f6..0a91368 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -830,10 +830,6 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq,
 		disable_8259A_irq(irq);
 
 	ioapic_write_entry(apic, pin, entry);
-
-	spin_lock_irqsave(&ioapic_lock, flags);
-	irq_desc[irq].affinity = TARGET_CPUS;
-	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
 static void __init setup_IO_APIC_irqs(void)
