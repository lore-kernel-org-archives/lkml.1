Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYIAXig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYIAXig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYIAXi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:38:26 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:52971 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbYIAXiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:38:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wf5NZ7dgomqeUQu8vCtL4EAxyPty9vVVHpGUwl0LQ3sRAGEGRyCsnbdRfp8xvy5rzw
         8pZPJQYY5sd8NND1tLlnLLQtPYqZpSgmmvFF5+x1GVZ9FUr7EjTdbzUGWbge69Qx8uuI
         V3B5p0HQKAO1eXFG/uEmq6WOHHbv+8RrwLd2Y=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/6] pci: fix merging left out for BAR print out
Date: Mon,  1 Sep 2008 16:37:21 -0700
Message-Id: <1220312246-30879-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print out for Device BAR address before kernel try to update them.

also change it to KERN_DEBUG instead...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/pci/probe.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -304,6 +304,8 @@ static int __pci_read_base(struct pci_de
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
+			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
+				 pci_name(dev), pos, res->start, res->end);
 		}
 	} else {
 		sz = pci_size(l, sz, mask);
@@ -313,6 +315,10 @@ static int __pci_read_base(struct pci_de
 
 		res->start = l;
 		res->end = l + sz;
+		printk(KERN_DEBUG "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
+			 pos, (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
+			 res->start, res->end);
+
 	}
 
  out:
@@ -383,7 +389,8 @@ void __devinit pci_read_bridge_bases(str
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
+		printk(KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n",
+				 pci_name(dev), res->start, res->end);
 	}
 
 	res = child->resource[1];
@@ -395,7 +402,8 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
+		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
+				 pci_name(dev), res->start, res->end);
 	}
 
 	res = child->resource[2];
@@ -431,7 +439,9 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n", pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",res->start, res->end);
+		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
+				 pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",
+				 res->start, res->end);
 	}
 }
 
