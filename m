Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbZBIBlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbZBIBlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbZBIBlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:41:07 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56693 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbZBIBlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:41:05 -0500
Message-ID: <498F89A7.9020208@jp.fujitsu.com>
Date: Mon, 09 Feb 2009 10:40:55 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] PCI/MSI: fix msi_mask() (rev. 2)
References: <498A5348.3090508@jp.fujitsu.com> <20090208112650.GD31509@parisc-linux.org>
In-Reply-To: <20090208112650.GD31509@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit bffac3c593eba1f9da3efd0199e49ea6558a40ce ("PCI MSI: Fix
undefined shift by 32") does:

 -    temp = (1 << multi_msi_capable(control));
 -    temp = ((temp - 1) & ~temp);
 +    temp = msi_mask((control & PCI_MSI_FLAGS_QMASK) >> 1);

and provides msi_mask() to avoid undefined shift by 32.

According to PCI Local Bus Spec 3.0 "6.8.1.3 Message Control for MSI",
relations between the encoded bits in control register, the number of
vectors and the proper maskbits should be as the following table:

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

This patch removes the wrong array in the msi_mask(), and adds a bonus of
not running off the end of the array if some device has a bogus value in
its config space.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 drivers/pci/msi.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 44f15ff..7b8a51e 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -109,8 +109,10 @@ static void msix_set_enable(struct pci_dev *dev, int enable)
  */
 static inline __attribute_const__ u32 msi_mask(unsigned x)
 {
-	static const u32 mask[] = { 1, 2, 4, 0xf, 0xff, 0xffff, 0xffffffff };
-	return mask[x];
+	/* Don't shift by >= width of type */
+	if (x >= 5)
+		return 0xffffffff;
+	return (1 << (1 << x)) - 1;
 }
 
 static void msix_flush_writes(struct irq_desc *desc)
-- 
1.6.0.3

