Return-Path: <linux-kernel-owner+w=401wt.eu-S1753645AbZCFSKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbZCFSKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZCFSKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:10:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:58217 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbZCFSKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:10:39 -0500
Date: Fri, 6 Mar 2009 18:09:26 GMT
From: Daniel Yeisley <dan.yeisley@unisys.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, dan.yeisley@unisys.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, dan.yeisley@unisys.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1236352309.31604.2.camel@localhost.localdomain>
References: <1236352309.31604.2.camel@localhost.localdomain>
Subject: [tip:x86/urgent] x86: MSI: check for BIOS assigned addresses
Message-ID: <tip-805700617032d9df9bb247ee20571b17ccae28a8@git.kernel.org>
Git-Commit-ID: 805700617032d9df9bb247ee20571b17ccae28a8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 18:09:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  805700617032d9df9bb247ee20571b17ccae28a8
Gitweb:     http://git.kernel.org/tip/805700617032d9df9bb247ee20571b17ccae28a8
Author:     "Daniel Yeisley" <dan.yeisley@unisys.com>
AuthorDate: Fri, 6 Mar 2009 10:11:49 -0500
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 19:04:37 +0100

x86: MSI: check for BIOS assigned addresses

Impact: fix ACPI hotplug on certain systems

When creating MSI addresses the kernel makes them up and writes them to
the hardware without first checking for what the system BIOS may have
assigned.  The patch below checks for already assigned values, and
leaves them alone if they exist.

Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1236352309.31604.2.camel@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/io_apic.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index bc7ac4d..416e5e3 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3258,6 +3258,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 	struct irq_cfg *cfg;
 	int err;
 	unsigned dest;
+	struct irq_desc *desc = irq_to_desc(irq);
 
 	cfg = irq_cfg(irq);
 	err = assign_irq_vector(irq, cfg, TARGET_CPUS);
@@ -3266,6 +3267,8 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 
 	dest = cpu_mask_to_apicid_and(cfg->domain, TARGET_CPUS);
 
+	read_msi_msg_desc(desc, msg);
+
 #ifdef CONFIG_INTR_REMAP
 	if (irq_remapped(irq)) {
 		struct irte irte;
@@ -3295,17 +3298,18 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 	} else
 #endif
 	{
-		msg->address_hi = MSI_ADDR_BASE_HI;
-		msg->address_lo =
-			MSI_ADDR_BASE_LO |
-			((INT_DEST_MODE == 0) ?
-				MSI_ADDR_DEST_MODE_PHYSICAL:
-				MSI_ADDR_DEST_MODE_LOGICAL) |
-			((INT_DELIVERY_MODE != dest_LowestPrio) ?
-				MSI_ADDR_REDIRECTION_CPU:
-				MSI_ADDR_REDIRECTION_LOWPRI) |
-			MSI_ADDR_DEST_ID(dest);
-
+		if (!msg->address_hi && !msg->address_lo) {
+			msg->address_hi = MSI_ADDR_BASE_HI;
+			msg->address_lo =
+				MSI_ADDR_BASE_LO |
+				((INT_DEST_MODE == 0) ?
+					MSI_ADDR_DEST_MODE_PHYSICAL :
+					MSI_ADDR_DEST_MODE_LOGICAL) |
+				((INT_DELIVERY_MODE != dest_LowestPrio) ?
+					MSI_ADDR_REDIRECTION_CPU :
+					MSI_ADDR_REDIRECTION_LOWPRI) |
+				MSI_ADDR_DEST_ID(dest);
+		}
 		msg->data =
 			MSI_DATA_TRIGGER_EDGE |
 			MSI_DATA_LEVEL_ASSERT |
@@ -3440,11 +3444,13 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	int ret;
 	struct msi_msg msg;
 
+	set_irq_msi(irq, msidesc);
 	ret = msi_compose_msg(dev, irq, &msg);
-	if (ret < 0)
+	if (ret < 0) {
+		set_irq_msi(irq, NULL);
 		return ret;
+	}
 
-	set_irq_msi(irq, msidesc);
 	write_msi_msg(irq, &msg);
 
 #ifdef CONFIG_INTR_REMAP
