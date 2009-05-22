Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbZEVMIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbZEVMIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbZEVMH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:07:56 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:33169
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757310AbZEVMHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:07:55 -0400
X-BigFish: VPS1(zzzz1202hzzz32i)
X-FB-SS: 5,
X-WSS-ID: 0KK1OB9-01-JCF-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Chris Wright <chrisw@sous-sol.org>, Chris Wright <chrisw@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/4] amd iommu: properly detach from protection domain on ->remove
Date: Fri, 22 May 2009 14:06:31 +0200
Message-ID: <1242993991-28613-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242993991-28613-1-git-send-email-joerg.roedel@amd.com>
References: <1242993991-28613-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:06:47.0752 (UTC) FILETIME=[C824E480:01C9DAD5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

[ impact: bugfix ]

Some drivers may use the dma api during ->remove which will
cause a protection domain to get reattached to a device.  Delay the
detach until after the driver is completely unbound.

[ joro: added a little merge helper ]

Signed-off-by: Chris Wright <chrisw@redhat.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a97db99..d689883 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -57,6 +57,10 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 static struct dma_ops_domain *find_protection_domain(u16 devid);
 
 
+#ifndef BUS_NOTIFY_UNBOUND_DRIVER
+#define BUS_NOTIFY_UNBOUND_DRIVER 0x0005
+#endif
+
 #ifdef CONFIG_AMD_IOMMU_STATS
 
 /*
@@ -1012,7 +1016,7 @@ static int device_change_notifier(struct notifier_block *nb,
 		printk(KERN_INFO "AMD IOMMU: Using protection domain %d for "
 		       "device %s\n", dma_domain->domain.id, dev_name(dev));
 		break;
-	case BUS_NOTIFY_UNBIND_DRIVER:
+	case BUS_NOTIFY_UNBOUND_DRIVER:
 		if (!domain)
 			goto out;
 		detach_device(domain, devid);
-- 
1.6.3.1


