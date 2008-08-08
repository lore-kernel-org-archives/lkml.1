Return-Path: <linux-kernel-owner+w=401wt.eu-S1762981AbYHHV6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762981AbYHHV6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760667AbYHHVyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:54:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:58025 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760476AbYHHVyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=i2Lj975JO+nWye8U91qt/rZ0fo5/ObOSz8nY4vpht+afchcFTZF1M/7Ld4YV2G+k36
         gIo1p+5TYFWTPH55uV6qD1IXKV86hsnDiqygbYEsjpBOgqHr6fsBBHYvS7W/d/J4vFID
         iCAWLsflJeZASq7OZgY2yehyzt9iNkOG8iUc8=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 12/42] drivers intr remapping to use nr_irqs
Date: Fri,  8 Aug 2008 14:52:18 -0700
Message-Id: <1218232368-31228-13-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-12-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-10-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-11-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-12-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/pci/intr_remapping.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index bb642cc..980566e 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -22,7 +22,7 @@ static DEFINE_SPINLOCK(irq_2_ir_lock);
 
 int irq_remapped(int irq)
 {
-	if (irq > NR_IRQS)
+	if (irq > nr_irqs)
 		return 0;
 
 	if (!irq_2_iommu[irq].iommu)
@@ -35,7 +35,7 @@ int get_irte(int irq, struct irte *entry)
 {
 	int index;
 
-	if (!entry || irq > NR_IRQS)
+	if (!entry || irq > nr_irqs)
 		return -1;
 
 	spin_lock(&irq_2_ir_lock);
@@ -126,7 +126,7 @@ int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 	int index;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -140,7 +140,7 @@ int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -158,7 +158,7 @@ int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 int clear_irte_irq(int irq, struct intel_iommu *iommu, u16 index)
 {
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -180,7 +180,7 @@ int modify_irte(int irq, struct irte *irte_modified)
 	struct intel_iommu *iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -205,7 +205,7 @@ int flush_irte(int irq)
 	struct intel_iommu *iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
@@ -248,7 +248,7 @@ int free_irte(int irq)
 	struct intel_iommu *iommu;
 
 	spin_lock(&irq_2_ir_lock);
-	if (irq >= NR_IRQS || !irq_2_iommu[irq].iommu) {
+	if (irq >= nr_irqs || !irq_2_iommu[irq].iommu) {
 		spin_unlock(&irq_2_ir_lock);
 		return -1;
 	}
-- 
1.5.4.5

