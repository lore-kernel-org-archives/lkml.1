Return-Path: <linux-kernel-owner+w=401wt.eu-S1760266AbYG1Rjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266AbYG1Rjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbYG1RjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:39:07 -0400
Received: from mail.tor.primus.ca ([216.254.136.21]:35762 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759466AbYG1RjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:39:06 -0400
From: Matthew Wilcox <matthew@wil.cx>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, eric@anholt.net,
       Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/3] PCI: Handle 64-bit resources better on 32-bit machines
Date: Mon, 28 Jul 2008 13:39:00 -0400
Message-Id: <1217266741-26519-3-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1217266741-26519-1-git-send-email-matthew@wil.cx>
References: <1217266741-26519-1-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the kernel is configured to support 64-bit resources on a 32-bit
machine, we can support 64-bit BARs properly.  Just change the condition
to check sizeof(resource_size_t) instead of BITS_PER_LONG.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/pci/probe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 3b690c3..2036300 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -270,10 +270,10 @@ static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		if (!sz64)
 			goto fail;
 
-		if ((BITS_PER_LONG < 64) && (sz64 > 0x100000000ULL)) {
+		if ((sizeof(resource_size_t) < 8) && (sz64 > 0x100000000ULL)) {
 			dev_err(&dev->dev, "can't handle 64-bit BAR\n");
 			goto fail;
-		} else if ((BITS_PER_LONG < 64) && l) {
+		} else if ((sizeof(resource_size_t) < 8) && l) {
 			/* Address above 32-bit boundary; disable the BAR */
 			pci_write_config_dword(dev, pos, 0);
 			pci_write_config_dword(dev, pos + 4, 0);
-- 
1.5.5.4

