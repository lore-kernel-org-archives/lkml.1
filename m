Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYI2VDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYI2VDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 17:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYI2VDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 17:03:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:9280 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbYI2VDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 17:03:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=pTMrggkquffB81tQZIZxkdS4AhSSOLtf7FNG83e3O0sdOPot+PwoyUHOsaAMWezGvY
         lmBX214nBzWvL+MQ20ii+luCV8cdF/rwyE6wDUo7gMXDNpP7jEohIDcjRq+BtPOf0h11
         U9nqR0O/SYk9DslaFflvd/3q2XrK9OUaNO82E=
Message-ID: <4727185d0809291403w38422338p3ffe2a1c27c39939@mail.gmail.com>
Date: Mon, 29 Sep 2008 23:03:14 +0200
From: "Vincent Legoll" <vincent.legoll@gmail.com>
To: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] PCI probing debug message uniformization
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Here is a patch to uniformize PCI probing debug messages at
boot with dev_printk() intead of manual printk()

for example, it goes from the mixed-style:

PCI: 0000:00:1b.0 reg 10 64bit mmio: [f4280000, f4283fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold

to uniform:

pci 0000:00:1b.0: reg 10 64bit mmio: [f4280000, f4283fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold

If people prefer the UPPERCASE "PCI:" prefix from dev_printk(),
that would be matter for another patch...

I'm currently running the kernel with that patch applied, and
diffed bootlog, everything looks OK

Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>

-- 
Vincent Legoll

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 36698e5..2acb43d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -304,8 +304,9 @@ static int __pci_read_base(struct pci_dev *dev,
enum pci_bar_type type,
 		} else {
 			res->start = l64;
 			res->end = l64 + sz64;
-			printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
-				pci_name(dev), pos, (unsigned long long)res->start,
+			dev_printk(KERN_DEBUG, &dev->dev,
+				"reg %x 64bit mmio: [%llx, %llx]\n", pos,
+				(unsigned long long)res->start,
 				(unsigned long long)res->end);
 		}
 	} else {
@@ -316,8 +317,8 @@ static int __pci_read_base(struct pci_dev *dev,
enum pci_bar_type type,

 		res->start = l;
 		res->end = l + sz;
-		printk(KERN_DEBUG "PCI: %s reg %x %s: [%llx, %llx]\n", pci_name(dev),
-			pos, (res->flags & IORESOURCE_IO) ? "io port":"32bit mmio",
+		dev_printk(KERN_DEBUG, &dev->dev, "reg %x %s: [%llx, %llx]\n", pos,
+			(res->flags & IORESOURCE_IO) ? "io port" : "32bit mmio",
 			(unsigned long long)res->start, (unsigned long long)res->end);
 	}

@@ -389,8 +390,8 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n",
-			pci_name(dev), (unsigned long long) res->start,
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge io port: [%llx, %llx]\n",
+			(unsigned long long) res->start,
 			(unsigned long long) res->end);
 	}

@@ -403,8 +404,8 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
-			pci_name(dev), (unsigned long long) res->start,
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge 32bit mmio: [%llx, %llx]\n",
+			(unsigned long long) res->start,
 			(unsigned long long) res->end);
 	}

@@ -441,8 +442,8 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) |
IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
-			pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge %sbit mmio pref: [%llx, %llx]\n",
+			(res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
 			(unsigned long long) res->start, (unsigned long long) res->end);
 	}
 }
