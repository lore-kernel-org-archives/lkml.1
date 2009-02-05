Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbZBECrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbZBECrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZBECrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:47:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51609 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZBECrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:47:45 -0500
Message-ID: <498A5348.3090508@jp.fujitsu.com>
Date: Thu, 05 Feb 2009 11:47:36 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Matthew Wilcox <willy@linux.intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI/MSI: fix msi_mask()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit bffac3c593eba1f9da3efd0199e49ea6558a40ce does:

 -    temp = (1 << multi_msi_capable(control));
 -    temp = ((temp - 1) & ~temp);
 +    temp = msi_mask((control & PCI_MSI_FLAGS_QMASK) >> 1);

and provides msi_mask() to avoid undefined shift by 32.

According to PCI Local Bus Spec 3.0 "6.8.1.3 Message Control for MSI",
relations between the encoded bits in control register, the number of
vectors and the proper maskbits should be as following table:

 control[3::1] | vectors  | maskbits
 --------------+----------+-----------
          000b |        1 | 0x1
          001b |        2 | 0x3
          010b |        4 | 0xf
          011b |        8 | 0xff
          100b |       16 | 0xffff
          101b |       32 | 0xffffffff
          110b | Reserved | n/a
          111b | Reserved | n/a

This patch fix the wrong array in the msi_mask().

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 drivers/pci/msi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 44f15ff..1c88958 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -109,7 +109,7 @@ static void msix_set_enable(struct pci_dev *dev, int enable)
  */
 static inline __attribute_const__ u32 msi_mask(unsigned x)
 {
-	static const u32 mask[] = { 1, 2, 4, 0xf, 0xff, 0xffff, 0xffffffff };
+	static const u32 mask[] = { 1, 3, 0xf, 0xff, 0xffff, 0xffffffff };
 	return mask[x];
 }
 
-- 
1.6.0


