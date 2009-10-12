Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbZJLMHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbZJLMHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbZJLMHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:07:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:42942 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbZJLMHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:07:06 -0400
Subject: [PATCH 3/4] Run pci_apply_final_quirks() sooner.
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
Date: Mon, 12 Oct 2009 13:06:17 +0100
Message-Id: <1255349177.10605.10.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having this as a device_initcall() means that some real device drivers
can actually initialise _before_ the quirks are run, which is wrong.

We want it to run _before_ device_initcall(), but _after_ fs_initcall(),
since some arch-specific PCI initialisation like pcibios_assign_resources()
is done at fs_initcall().

We could use rootfs_initcall() but I actually want to use that for the
IOMMU initialisation, which has to come after the quirks, but still
before the real devices. So use fs_initcall_sync() instead -- since this
is entirely synchronous, it doesn't hurt that it'll escape the
synchronisation.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 drivers/pci/quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 77bf620..4e1b1b8 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2584,7 +2584,7 @@ static int __init pci_apply_final_quirks(void)
 	return 0;
 }
 
-device_initcall(pci_apply_final_quirks);
+fs_initcall_sync(pci_apply_final_quirks);
 #else
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev) {}
 #endif
-- 
1.6.5.rc2



