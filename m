Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbYKKKqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbYKKKqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755339AbYKKKpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:45:55 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:45581 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbYKKKpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:45:54 -0500
Message-Id: <49197092.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 11 Nov 2008 10:46:26 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-pci@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] fix use of multi_msi_capable()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, isn't the single use of multi_msi_capable() broken (in the event that
the Multiple Message Capable field was 5, the shift would be undefined,
on x86 in particular would yield 1 as the result, where 0 would be needed),
and the subsequent twiddling of temp needlessly complicated (subtracting
one should be sufficient here).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/pci/msi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.28-rc4/drivers/pci/msi.c	2008-11-11 11:11:20.000000000 +0100
+++ 2.6.28-rc4-pci-multi-msi-capable/drivers/pci/msi.c	2008-11-07 09:11:36.000000000 +0100
@@ -389,9 +389,8 @@ static int msi_capability_init(struct pc
 		pci_read_config_dword(dev,
 			msi_mask_bits_reg(pos, entry->msi_attrib.is_64),
 			&maskbits);
-		temp = (1 << multi_msi_capable(control));
-		temp = ((temp - 1) & ~temp);
-		maskbits |= temp;
+		temp = 1U << (multi_msi_capable(control) - 1);
+		maskbits |= (temp << 1) - 1;
 		pci_write_config_dword(dev, entry->msi_attrib.is_64, maskbits);
 		entry->msi_attrib.maskbits_mask = temp;
 	}



