Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYIIT2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYIIT2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYIIT23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:28:29 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:2835 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbYIIT22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Gbjb0K2JHGm5ihZOVdOjt5c4iL9LHr59mWuWnalK+UZCau4MOeUAkaRApDSb3QAdCL
         7H9sT/DK7jCmkDFvesiDIcr2wMyUiMBPi1yFtCu7RUbvI0n8rLd7qSpcCDy1FiJ5jbmp
         Zltw9o8vlk+leD9xfB3jUpNs9x1OiR0sUvv98=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] pci: fix merging left out for BAR print out v2
Date: Tue,  9 Sep 2008 12:27:52 -0700
Message-Id: <1220988472-24139-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print out for Device BAR address before kernel try to update them.

also change it to KERN_DEBUG instead...

v2: update to linux-pci next
   also add (unsigned long long) cast

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index d8d3f90..e3bddc5 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -304,6 +304,9 @@ static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
+			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
+				pci_name(dev), pos, (unsigned long long)res->start,
+				(unsigned long long)res->end);
 		}
 	} else {
 		sz = pci_size(l, sz, mask);
@@ -313,6 +316,9 @@ static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 
 		res->start = l;
 		res->end = l + sz;
+		printk(KERN_DEBUG "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
+			pos, (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
+			(unsigned long long)res->start, (unsigned long long)res->end);
 	}
 
  out:
@@ -383,7 +389,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n",
+		printk(KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n",
 			pci_name(dev), (unsigned long long) res->start,
 			(unsigned long long) res->end);
 	}
@@ -397,8 +403,9 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev),
-			(unsigned long long) res->start, (unsigned long long) res->end);
+		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
+			pci_name(dev), (unsigned long long) res->start,
+			(unsigned long long) res->end);
 	}
 
 	res = child->resource[2];
@@ -434,7 +441,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
+		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
 			pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
 			(unsigned long long) res->start, (unsigned long long) res->end);
 	}
