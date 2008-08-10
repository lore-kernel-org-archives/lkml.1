Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYHJHo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYHJHo4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 03:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbYHJHiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 03:38:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:7020 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbYHJHiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 03:38:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uTB1YP/cjCNwKsuc4KR48O0NTukfLDAmjTP1Irc8ZNQr1wHd/wyn5/mLE+caNOE1kE
         XQ4jw8CB77JXpLQOnMoizDEKmpYeOq3KQvJQvV8Daj5sl7X3igHec4Zb8gxLL/Ws24hP
         +DIvQXW4WE5ynQwbs/HVJrgKoy8BGQJjg80rs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 21/43] make irq2_iommu to use dyn_array
Date: Sun, 10 Aug 2008 00:36:10 -0700
Message-Id: <1218353792-3355-22-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218353792-3355-21-git-send-email-yhlu.kernel@gmail.com>
References: <1218353792-3355-1-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-2-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-3-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-4-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-5-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-6-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-7-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-8-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-9-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-10-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-11-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-12-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-13-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-14-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-15-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-16-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-17-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-18-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-19-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-20-git-send-email-yhlu.kernel@gmail.com>
 <1218353792-3355-21-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/pci/intr_remapping.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 980566e..6961be8 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -1,3 +1,4 @@
+#include <linux/interrupt.h>
 #include <linux/dmar.h>
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
@@ -11,12 +12,19 @@ static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static int ir_ioapic_num;
 int intr_remapping_enabled;
 
-static struct {
+struct irq_2_iommu {
 	struct intel_iommu *iommu;
 	u16 irte_index;
 	u16 sub_handle;
 	u8  irte_mask;
-} irq_2_iommu[NR_IRQS];
+};
+
+#ifdef CONFIG_HAVE_DYNA_ARRAY
+static struct irq_2_iommu *irq_2_iommu;
+DEFINE_DYN_ARRAY(irq_2_iommu, sizeof(struct irq_2_iommu), nr_irqs, PAGE_SIZE, NULL);
+#else
+static struct irq_2_iommu irq_2_iommu[NR_IRQS];
+#endif
 
 static DEFINE_SPINLOCK(irq_2_ir_lock);
 
-- 
1.5.4.5

