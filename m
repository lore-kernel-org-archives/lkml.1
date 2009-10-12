Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZJLMHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZJLMHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbZJLMHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:07:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:42949 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797AbZJLMHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:07:17 -0400
Subject: [PATCH 1/4] Rename pci_init() to pci_apply_final_quirks(), move it
 to quirks.c
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J.Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <1255342738.24732.265.camel@macbook.infradead.org>
References: <1255342738.24732.265.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 13:06:11 +0100
Message-Id: <1255349171.10605.8.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function may have done more in the past, but all it does now is
apply the PCI_FIXUP_FINAL quirks. So name it sensibly and put it where
it belongs.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/pci/pci.c    |   13 -------------
 drivers/pci/quirks.c |   13 +++++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6edecff..2b575cf 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2719,17 +2719,6 @@ int __attribute__ ((weak)) pci_ext_cfg_avail(struct pci_dev *dev)
 	return 1;
 }
 
-static int __devinit pci_init(void)
-{
-	struct pci_dev *dev = NULL;
-
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		pci_fixup_device(pci_fixup_final, dev);
-	}
-
-	return 0;
-}
-
 static int __init pci_setup(char *str)
 {
 	while (str) {
@@ -2767,8 +2756,6 @@ static int __init pci_setup(char *str)
 }
 early_param("pci", pci_setup);
 
-device_initcall(pci_init);
-
 EXPORT_SYMBOL(pci_reenable_device);
 EXPORT_SYMBOL(pci_enable_device_io);
 EXPORT_SYMBOL(pci_enable_device_mem);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6099fac..0142275 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2572,6 +2572,19 @@ void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
 	}
 	pci_do_fixups(dev, start, end);
 }
+
+static int __devinit pci_apply_final_quirks(void)
+{
+	struct pci_dev *dev = NULL;
+
+	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+		pci_fixup_device(pci_fixup_final, dev);
+	}
+
+	return 0;
+}
+
+device_initcall(pci_apply_final_quirks);
 #else
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev) {}
 #endif
-- 
1.6.5.rc2



