Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbYH3IAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbYH3IAO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 04:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYH3H7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 03:59:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:38181 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYH3H7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 03:59:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fMWDYiRIKy3Ai7s5wOJLYxrifZPVkr5q8GUE4yN4+JlJatGxvkuru7uWdhvXjgGoEM
         r4YefHVrG5pmxQGTSH4vJNv//ltcudgcOVfkWJY0ZZIYw4qx+DC18U23Q3bHNYK+VtpW
         33MUU408K0SVW/dbCfFIRxxaW3FAgdLNJ+kS4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] pci: fix merging left out for BAR print out
Date: Sat, 30 Aug 2008 00:58:40 -0700
Message-Id: <1220083122-4058-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220083122-4058-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220083122-4058-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

print out for Device BAR address before kernel try to update them.

also change it to KERN_DEBUG instead...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index cce2f4c..4ee06c3 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -304,6 +304,8 @@ static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
+			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
+				 pci_name(dev), pos, res->start, res->end);
 		}
 	} else {
 		sz = pci_size(l, sz, mask);
@@ -313,6 +315,10 @@ static int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 
 		res->start = l;
 		res->end = l + sz;
+		printk(KERN_DEBUG "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
+			 pos, (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
+			 res->start, res->end);
+
 	}
 
  out:
@@ -383,7 +389,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
+		printk(KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
 	}
 
 	res = child->resource[1];
@@ -395,7 +401,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
+		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
 	}
 
 	res = child->resource[2];
@@ -431,7 +437,7 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n", pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",res->start, res->end);
+		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n", pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",res->start, res->end);
 	}
 }
 
