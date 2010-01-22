Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998Ab0AVRTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab0AVRTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148Ab0AVRSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:18:30 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:54661 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab0AVRS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:18:29 -0500
X-SpamScore: -7
X-BigFish: VPS-7(z78cMzab9bh936eMzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KWNS2F-01-CV9-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/5] x86/amd-iommu: Fix NULL pointer dereference in __detach_device()
Date: Fri, 22 Jan 2010 18:18:10 +0100
Message-ID: <1264180693-27197-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264180693-27197-1-git-send-email-joerg.roedel@amd.com>
References: <1264180693-27197-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 17:18:15.0704 (UTC) FILETIME=[E23CD180:01CA9B86]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the __detach_device function the reference count for a
device-domain binding may become zero. This results in the
device being removed from the domain and dev_data->domain
will be NULL. This is bad because this pointer is
dereferenced when trying to unlock the domain->lock. This
patch fixes the issue by keeping the domain in a seperate
variable.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index c2ccbd7..4478a48 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1489,11 +1489,14 @@ static void __detach_device(struct device *dev)
 {
 	struct iommu_dev_data *dev_data = get_dev_data(dev);
 	struct iommu_dev_data *alias_data;
+	struct protection_domain *domain;
 	unsigned long flags;
 
 	BUG_ON(!dev_data->domain);
 
-	spin_lock_irqsave(&dev_data->domain->lock, flags);
+	domain = dev_data->domain;
+
+	spin_lock_irqsave(&domain->lock, flags);
 
 	if (dev_data->alias != dev) {
 		alias_data = get_dev_data(dev_data->alias);
@@ -1504,7 +1507,7 @@ static void __detach_device(struct device *dev)
 	if (atomic_dec_and_test(&dev_data->bind))
 		do_detach(dev);
 
-	spin_unlock_irqrestore(&dev_data->domain->lock, flags);
+	spin_unlock_irqrestore(&domain->lock, flags);
 
 	/*
 	 * If we run in passthrough mode the device must be assigned to the
-- 
1.6.6


