Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126AbXBWB5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbXBWB5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 20:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXBWB5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 20:57:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:1592 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbXBWB5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 20:57:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,208,1170662400"; 
   d="scan'208"; a="49746856:sNHT48458700"
Date: Thu, 22 Feb 2007 17:21:36 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: mingo@elte.hu
Cc: ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [patch] fix the irq migration
Message-ID: <20070222172135.A27563@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging some other irq migration issue, observed this issue with
-git kernels. Ingo, please ACK it.
---

With the commit 76d2160147f43f982dfe881404cfde9fd0a9da21, irq_chip
default_disable() became an empty function. And with this change, irq
migration in the case of Edge triggered IO-APIC and MSI interrupts happens
with out masking the irq.

Appended patch fixes by using the mask/unmask handlers of irq_chip directly
while doing the irq migration.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 4baa3bb..14ff345 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -66,11 +66,11 @@ void move_native_irq(int irq)
 		return;
 
 	if (likely(!(desc->status & IRQ_DISABLED)))
-		desc->chip->disable(irq);
+		desc->chip->mask(irq);
 
 	move_masked_irq(irq);
 
 	if (likely(!(desc->status & IRQ_DISABLED)))
-		desc->chip->enable(irq);
+		desc->chip->unmask(irq);
 }
 
