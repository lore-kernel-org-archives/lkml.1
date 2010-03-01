Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab0CANZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:25:27 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:19192
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751515Ab0CANZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:25:09 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h2a8h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYLULF-01-6WV-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org
CC: linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/4] x86/amd-iommu: Pt mode fix for domain_destroy
Date: Mon, 1 Mar 2010 14:24:41 +0100
Message-ID: <1267449882-1415-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267449882-1415-1-git-send-email-joerg.roedel@amd.com>
References: <1267449882-1415-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 01 Mar 2010 13:24:48.0802 (UTC) FILETIME=[912BB020:01CAB942]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

After a guest is shutdown, assigned devices are not properly
returned to the pt domain.  This can leave the device using
stale cached IOMMU data, and result in a non-functional
device after it's re-bound to the host driver.  For example,
I see this upon rebinding:

 AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x0000 address=0x000000007e2a8000 flags=0x0050]
 AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x0000 address=0x000000007e2a8040 flags=0x0050]
 AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x0000 address=0x000000007e2a8080 flags=0x0050]
 AMD-Vi: Event logged [IO_PAGE_FAULT device=02:00.0 domain=0x0000 address=0x000000007e2a80c0 flags=0x0050]
 0000:02:00.0: eth2: Detected Hardware Unit Hang:
 ...

The amd_iommu_destroy_domain() function calls do_detach()
which doesn't reattach the pt domain to the device.
Use __detach_device() instead.

Cc: stable@kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index b97f2f1..0c04254 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2298,7 +2298,7 @@ static void cleanup_domain(struct protection_domain *domain)
 	list_for_each_entry_safe(dev_data, next, &domain->dev_list, list) {
 		struct device *dev = dev_data->dev;
 
-		do_detach(dev);
+		__detach_device(dev);
 		atomic_set(&dev_data->bind, 0);
 	}
 
-- 
1.7.0


