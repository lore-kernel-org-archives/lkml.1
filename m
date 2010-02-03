Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab0BCTcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:32:36 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:41109 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472Ab0BCTcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:32:35 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
Date: Wed, 03 Feb 2010 11:31:40 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: x86: fix race in create_irq_nr on irq_desc
In-reply-to: <20100203174216.GB17985@jenkins.home.ifup.org>
To: Brandon Philips <bphilips@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Message-id: <4B69CF1C.7050603@sun.com>
References: <20100203033109.GA17985@jenkins.home.ifup.org>
 <4B694DEF.70301@kernel.org> <20100203174216.GB17985@jenkins.home.ifup.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5)
 Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 09:42 AM, Brandon Philips wrote:
> On 02:20 Wed 03 Feb 2010, Yinghai Lu wrote:
>> On 02/02/2010 07:31 PM, Brandon Philips wrote:
>>> Race in create_irq_nr():
>>>
>>> - Thread 1 loops through and calls irq_to_desc_alloc_node with new=0x66.
>>>
>>> - Thread 2 has exited the loop with irq=0x66 and calls dynamic_irq_init(0x66)
>>>   setting desc->chip_data = NULL
>>>
>>> - Thread 1 then dereferences NULL via desc_new->chip_data->vector
>>
>> two threads get same irq?
> 
> This race happened when two drivers were setting up MSI-X at the same
> time via pci_enable_msix(). See this dmesg excerpt:
> 
> [   85.170610] ixgbe 0000:02:00.1: irq 97 for MSI/MSI-X
> [   85.170611]   alloc irq_desc for 99 on node -1
> [   85.170613] igb 0000:08:00.1: irq 98 for MSI/MSI-X
> [   85.170614]   alloc kstat_irqs on node -1
> [   85.170616] alloc irq_2_iommu on node -1
> [   85.170617]   alloc irq_desc for 100 on node -1
> [   85.170619]   alloc kstat_irqs on node -1
> [   85.170621] alloc irq_2_iommu on node -1
> [   85.170625] ixgbe 0000:02:00.1: irq 99 for MSI/MSI-X
> [   85.170626]   alloc irq_desc for 101 on node -1
> [   85.170628] igb 0000:08:00.1: irq 100 for MSI/MSI-X
> [   85.170630]   alloc kstat_irqs on node -1
> [   85.170631] alloc irq_2_iommu on node -1
> [   85.170635]   alloc irq_desc for 102 on node -1
> [   85.170636]   alloc kstat_irqs on node -1
> [   85.170639] alloc irq_2_iommu on node -1
> [   85.170646] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000088
> 
> As you can see igb and ixgbe are both alternating on create_irq_nr()
> via pci_enable_msix() in their probe function. So, let me rewrite my
> explanation using this example:
> 
> ixgbe: While looping through irq_desc_ptrs[] via create_irq_nr() ixgbe
> choses irq_desc_ptrs[102] and exits the loop, drops vector_lock and
> calls dynamic_irq_init. Then it sets irq_desc_ptrs[102]->chip_data =
> NULL via dynamic_irq_init().
> 
> igb: Grabs the vector_lock now and starts looping over irq_desc_ptrs[]
> via create_irq_nr(). It gets to irq_desc_ptrs[102] and does this:
> 
> 	cfg_new = irq_desc_ptrs[102]->chip_data;
> 	if (cfg_new->vector != 0)
> 		continue;
> 
> This hits the NULL deref.
> 

please try following patch in addition to 

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=37ef2a3029fde884808ff1b369677abc7dd9a79a

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7edafc7..14099ba 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3280,12 +3280,9 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 	}
 	spin_unlock_irqrestore(&vector_lock, flags);
 
-	if (irq > 0) {
-		dynamic_irq_init(irq);
-		/* restore it, in case dynamic_irq_init clear it */
-		if (desc_new)
-			desc_new->chip_data = cfg_new;
-	}
+	if (irq > 0)
+		dynamic_irq_init_keep_chip_data(irq);
+
 	return irq;
 }
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index d13492d..cd6b870 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -400,6 +400,7 @@ static inline int irq_has_action(unsigned int irq)
 
 /* Dynamic irq helper functions */
 extern void dynamic_irq_init(unsigned int irq);
+void dynamic_irq_init_keep_chip_data(unsigned int irq);
 extern void dynamic_irq_cleanup(unsigned int irq);
 
 /* Set/get chip/data for an IRQ: */
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index ecc3fa2..370dbc4 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -22,7 +22,7 @@
  *	dynamic_irq_init - initialize a dynamically allocated irq
  *	@irq:	irq number to initialize
  */
-void dynamic_irq_init(unsigned int irq)
+static void dynamic_irq_init_x(unsigned int irq, bool keep_chip_data)
 {
 	struct irq_desc *desc;
 	unsigned long flags;
@@ -41,7 +41,8 @@ void dynamic_irq_init(unsigned int irq)
 	desc->depth = 1;
 	desc->msi_desc = NULL;
 	desc->handler_data = NULL;
-	desc->chip_data = NULL;
+	if (!keep_chip_data)
+		desc->chip_data = NULL;
 	desc->action = NULL;
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
@@ -54,6 +55,16 @@ void dynamic_irq_init(unsigned int irq)
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
+void dynamic_irq_init(unsigned int irq)
+{
+	dynamic_irq_init_x(irq, false);
+}
+
+void dynamic_irq_init_keep_chip_data(unsigned int irq)
+{
+	dynamic_irq_init_x(irq, true);
+}
+
 /**
  *	dynamic_irq_cleanup - cleanup a dynamically allocated irq
  *	@irq:	irq number to initialize
