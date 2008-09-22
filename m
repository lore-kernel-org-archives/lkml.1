Return-Path: <linux-kernel-owner+w=401wt.eu-S1752710AbYIVJEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbYIVJEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 05:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYIVJE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 05:04:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39013 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbYIVJEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 05:04:25 -0400
Date: Mon, 22 Sep 2008 11:04:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH -tip/master] x86: io-apic - interrupt remapping fix
Message-ID: <20080922090405.GA12630@elte.hu>
References: <20080919123320.GF7222@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919123320.GF7222@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Interrupt remapping could lead to NULL dereference in case of kzalloc 
> failed and memory leak in other way. So fix the both cases.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> Ingo, the patch is on top of applied one.
> 
> If I remember correctly Suresh was involved in
> this - so I think he could take a look and review
> the patch (please).

applied the combined patch below to tip/irq/sparseirq, thanks Cyrill.

	Ingo

----------------->
>From 77322deb4bc676a5ee645444e7ed1a89f854473d Mon Sep 17 00:00:00 2001
From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Thu, 18 Sep 2008 23:37:57 +0400
Subject: [PATCH] x86: io-apic - interrupt remapping fix

Interrupt remapping could lead to NULL dereference in case of
kzalloc failed and memory leak in other way. So fix the
both cases.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic.c    |   13 ++++++++++---
 arch/x86/kernel/io_apic.c |   19 +++++++++++++++++--
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 7841169..1f48bd1 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1360,7 +1360,12 @@ void enable_IR_x2apic(void)
 
 	local_irq_save(flags);
 	mask_8259A();
-	save_mask_IO_APIC_setup();
+
+	ret = save_mask_IO_APIC_setup();
+	if (ret) {
+		printk(KERN_INFO "Saving IO-APIC state failed: %d\n", ret);
+		goto end;
+	}
 
 	ret = enable_intr_remapping(1);
 
@@ -1370,14 +1375,15 @@ void enable_IR_x2apic(void)
 	}
 
 	if (ret)
-		goto end;
+		goto end_restore;
 
 	if (!x2apic) {
 		x2apic = 1;
 		apic_ops = &x2apic_ops;
 		enable_x2apic();
 	}
-end:
+
+end_restore:
 	if (ret)
 		/*
 		 * IR enabling failed
@@ -1386,6 +1392,7 @@ end:
 	else
 		reinit_intr_remapped_IO_APIC(x2apic_preenabled);
 
+end:
 	unmask_8259A();
 	local_irq_restore(flags);
 
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 5279b50..cb53a49 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -810,7 +810,7 @@ int save_mask_IO_APIC_setup(void)
 			kzalloc(sizeof(struct IO_APIC_route_entry) *
 				nr_ioapic_registers[apic], GFP_KERNEL);
 		if (!early_ioapic_entries[apic])
-			return -ENOMEM;
+			goto nomem;
 	}
 
 	for (apic = 0; apic < nr_ioapics; apic++)
@@ -824,17 +824,32 @@ int save_mask_IO_APIC_setup(void)
 				ioapic_write_entry(apic, pin, entry);
 			}
 		}
+
 	return 0;
+
+nomem:
+	for (; apic > 0; apic--)
+		kfree(early_ioapic_entries[apic]);
+	kfree(early_ioapic_entries[apic]);
+	memset(early_ioapic_entries, 0,
+		ARRAY_SIZE(early_ioapic_entries));
+
+	return -ENOMEM;
 }
 
 void restore_IO_APIC_setup(void)
 {
 	int apic, pin;
 
-	for (apic = 0; apic < nr_ioapics; apic++)
+	for (apic = 0; apic < nr_ioapics; apic++) {
+		if (!early_ioapic_entries[apic])
+			break;
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
 			ioapic_write_entry(apic, pin,
 					   early_ioapic_entries[apic][pin]);
+		kfree(early_ioapic_entries[apic]);
+		early_ioapic_entries[apic] = NULL;
+	}
 }
 
 void reinit_intr_remapped_IO_APIC(int intr_remapping)
