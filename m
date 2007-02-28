Return-Path: <linux-kernel-owner+w=401wt.eu-S933200AbXB1RMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbXB1RMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933198AbXB1RMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:12:24 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:54826 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933200AbXB1RMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:12:23 -0500
Date: Wed, 28 Feb 2007 09:07:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "David Brown" <dmlb2000@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Brice Goglin" <Brice.Goglin@ens-lyon.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21-rc2
Message-Id: <20070228090754.53a02a0b.randy.dunlap@oracle.com>
In-Reply-To: <9c21eeae0702280844w7f490b1bx7945467bbd13b994@mail.gmail.com>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	<45E531AE.5050300@ens-lyon.org>
	<m1hct6ig2v.fsf@ebiederm.dsl.xmission.com>
	<9c21eeae0702280844w7f490b1bx7945467bbd13b994@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__28_Feb_2007_09_07_54_-0800_FJy=NjhM8cXypUpD"
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Wed__28_Feb_2007_09_07_54_-0800_FJy=NjhM8cXypUpD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Feb 2007 08:44:45 -0800 David Brown wrote:

> > Yes. I goofed, and missed that stupid case.  The offending lines
> > should just die.  Patch already sent to Linus.
> 
> Could the patch be posted? or could I see a git commit so I can get it myself?

I'm attaching it below.  It hit the git commits mailing list
just a few minutes ago.

---
~Randy


--Multipart=_Wed__28_Feb_2007_09_07_54_-0800_FJy=NjhM8cXypUpD
Content-Type: text/x-patch;
 name="irq-desc-affinity.patch"
Content-Disposition: attachment;
 filename="irq-desc-affinity.patch"
Content-Transfer-Encoding: 7bit


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

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


--Multipart=_Wed__28_Feb_2007_09_07_54_-0800_FJy=NjhM8cXypUpD--
