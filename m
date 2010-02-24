Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab0BXRg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 12:36:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:45198 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344Ab0BXRgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 12:36:25 -0500
Date: Wed, 24 Feb 2010 17:36:23 +0000
From: Kyle McMartin <kyle@hera.kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [git patches] boot fix for 2.6.33 for parisc
Message-ID: <20100224173623.GA21614@hera.kernel.org>
Reply-To: kyle@mcmartin.ca
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Feb 2010 17:36:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull the following change for parisc to fix and issue
which prevents Linux from booting. (Short summary: PCI CLS was being set
from the default by the PCI layer *after* fixups, which meant sym2
fixups had an unset PCI CLS, which meant we couldn't find the root
disk.)

regards, Kyle

The following changes since commit 75ef7cdda2daa35be9e070ac8e5258759ac03d06:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git urgent

Carlos O'Donell (1):
      parisc: Set PCI CLS early in boot.

 arch/parisc/kernel/pci.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/pci.c b/arch/parisc/kernel/pci.c
index f7064ab..9e74bfe 100644
--- a/arch/parisc/kernel/pci.c
+++ b/arch/parisc/kernel/pci.c
@@ -18,7 +18,6 @@
 
 #include <asm/io.h>
 #include <asm/system.h>
-#include <asm/cache.h>		/* for L1_CACHE_BYTES */
 #include <asm/superio.h>
 
 #define DEBUG_RESOURCES 0
@@ -123,6 +122,10 @@ static int __init pcibios_init(void)
 	} else {
 		printk(KERN_WARNING "pci_bios != NULL but init() is!\n");
 	}
+
+	/* Set the CLS for PCI as early as possible. */
+	pci_cache_line_size = pci_dfl_cache_line_size;
+
 	return 0;
 }
 
@@ -171,7 +174,7 @@ void pcibios_set_master(struct pci_dev *dev)
 	** upper byte is PCI_LATENCY_TIMER.
 	*/
 	pci_write_config_word(dev, PCI_CACHE_LINE_SIZE,
-				(0x80 << 8) | (L1_CACHE_BYTES / sizeof(u32)));
+			      (0x80 << 8) | pci_cache_line_size);
 }
 
 
