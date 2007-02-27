Return-Path: <linux-kernel-owner+w=401wt.eu-S1751448AbXB0H2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbXB0H2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 02:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbXB0H2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 02:28:20 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38962 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbXB0H2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 02:28:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Simon Arlott <58022e3be4e86309571hlooq00057abw@thunder.lp0.eu>
Subject: [PATCH] x86_64/i386 irq:  Fix !CONFIG_SMP compilation
References: <45E3663B.4000701@simon.arlott.org.uk>
Date: Tue, 27 Feb 2007 00:27:41 -0700
In-Reply-To: <45E3663B.4000701@simon.arlott.org.uk> (Simon Arlott's message of
	"Mon, 26 Feb 2007 22:59:07 +0000")
Message-ID: <m1mz30m55e.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


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
---
 arch/i386/kernel/io_apic.c   |    2 --
 arch/x86_64/kernel/io_apic.c |    4 ----
 2 files changed, 0 insertions(+), 6 deletions(-)

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
-- 
1.5.0.g53756

