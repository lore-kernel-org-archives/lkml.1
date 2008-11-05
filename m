Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbYKEMFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbYKEMFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 07:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbYKEMEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 07:04:55 -0500
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:59317 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755360AbYKEMEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 07:04:54 -0500
Subject: [PATCH v2] x86: Don't allow nr_irqs > NR_IRQS
From: Ben Hutchings <bhutchings@solarflare.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1225819102.3074.15.camel@achroite>
References: <1225819102.3074.15.camel@achroite>
Content-Type: text/plain; charset=UTF-8
Organization: Solarflare Communications
Date: Wed, 05 Nov 2008 12:04:46 +0000
Message-Id: <1225886687.3074.59.camel@achroite>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
X-Originating-Smarthost02-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some systems probe_nr_irqs() can return a value larger than
NR_IRQS.  This will lead to probe_irq_on() overrunning the irq_desc
array.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
---
 arch/x86/kernel/io_apic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
﻿
I hit this when running net-next-2.6 (close to 2.6.28-rc3) on a
Supermicro dual Xeon system.  NR_IRQS is 224 but probe_nr_irqs() detects
5 IOAPICs and returns 240.  Here are the log messages:

Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
Tue Nov  4 16:53:47 2008 IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x02] address[0xfec81000] gsi_base[24])
Tue Nov  4 16:53:47 2008 IOAPIC[1]: apic_id 2, version 32, address 0xfec81000, GSI 24-47
Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x03] address[0xfec81400] gsi_base[48])
Tue Nov  4 16:53:47 2008 IOAPIC[2]: apic_id 3, version 32, address 0xfec81400, GSI 48-71
Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x04] address[0xfec82000] gsi_base[72])
Tue Nov  4 16:53:47 2008 IOAPIC[3]: apic_id 4, version 32, address 0xfec82000, GSI 72-95
Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x05] address[0xfec82400] gsi_base[96])
Tue Nov  4 16:53:47 2008 IOAPIC[4]: apic_id 5, version 32, address 0xfec82400, GSI 96-119
Tue Nov  4 16:53:47 2008 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
Tue Nov  4 16:53:47 2008 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Tue Nov  4 16:53:47 2008 Enabling APIC mode:  Flat.  Using 5 I/O APICs

I have added a WARN_ON() as suggested by Yinghai Lu.

Ben.

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3611,6 +3611,8 @@ int __init probe_nr_irqs(void)
 	/* something wrong ? */
 	if (nr < nr_min)
 		nr = nr_min;
+	if (WARN_ON(nr > NR_IRQS))
+		nr = NR_IRQS;
 
 	return nr;
 }

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

