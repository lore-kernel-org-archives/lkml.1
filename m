Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbZDGX5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbZDGX5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZDGX4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:56:41 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:22498 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754260AbZDGX4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:56:39 -0400
Date: Tue, 07 Apr 2009 17:45:50 -0600
From: dougthompson@xmission.com
To: khali@linux-fr.org, qingtao.cao@windriver.com, jharan@Brocade.COM,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 2/3] edac: fix local pci_write_bits32
Message-ID: <49dbe5ae.HYnkazVjNjfmhjJe%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  Jeff Haran <jharan@Brocade.COM>

Fix the edac local pci_write_bits32 to properly note the 'escape' mask
if all ones in a 32-bit word.

Currently no consumer of this function uses that mask, so danger to
existing code. 


Signed-off-by:  Jeff Haran <jharan@Brocade.COM>
Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
---
 edac_core.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6.29/drivers/edac/edac_core.h
===================================================================
--- linux-2.6.29.orig/drivers/edac/edac_core.h
+++ linux-2.6.29/drivers/edac/edac_core.h
@@ -767,11 +767,19 @@ static inline void pci_write_bits16(stru
 	pci_write_config_word(pdev, offset, value);
 }
 
-/* write all or some bits in a dword-register*/
+/*
+ * pci_write_bits32
+ *
+ * edac local routine to do pci_write_config_dword, but adds
+ * a mask parameter. If mask is all ones, ignore the mask.
+ * Otherwise utilize the mask to isolate specified bits
+ *
+ * write all or some bits in a dword-register
+ */
 static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
 				    u32 value, u32 mask)
 {
-	if (mask != 0xffff) {
+	if (mask != 0xffffffff) {
 		u32 buf;
 
 		pci_read_config_dword(pdev, offset, &buf);
