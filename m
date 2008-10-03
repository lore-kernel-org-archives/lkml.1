Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbYJCWuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbYJCWuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 18:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYJCWub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 18:50:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:4009 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbYJCWua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 18:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=N8ZeKZSqVsKEUfFN2pvm/AZwIMSkvgD4Th7wOBzMBYOGCpWTaIae9d/z+lxA6/bU09
         xhbwBLqkchNJ7lcLQrBtXYOO24kSZH0KaQBpPsSeAlGrcSuBkBvhXMqD6SNjBNErxKjl
         l+wxV/YBB5Ys+k2BagmVjSbpXdDZZVUGP1Aqk=
Message-ID: <4727185d0810031550l32592f7ep2d1d37f93be12874@mail.gmail.com>
Date: Sat, 4 Oct 2008 00:50:27 +0200
From: "Vincent Legoll" <vincent.legoll@gmail.com>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] PCI probing debug message uniformization
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200810031257.42457.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4727185d0809291403w38422338p3ffe2a1c27c39939@mail.gmail.com>
	 <4727185d0810030214t69666ea4qa2e9960283406270@mail.gmail.com>
	 <4727185d0810031113w2967fef7qa102d6ec4a89311e@mail.gmail.com>
	 <200810031257.42457.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2008 at 8:57 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> It'll be easier for Jesse if you include the proper changelog again
> with just a 1-2 line sample of the changed messages.  BTW, the "--"
> before your sig confused my mailer into not quoting the patch itself,
> hence the screwed up formatting below.

The "-- " line is the start-of-.sig marker have I been taught in my
school days, I think they then spoke about netiquette...

> dev_info() is exactly equivalent to dev_printk(KERN_INFO).  I usually
> use dev_info(), though I'm a bit ambivalent because it's nice to be
> able to grep for "printk".

I left dev_printk(KERN_INFO, ...) for grepability

> Anyway, maybe you can correct the grammar
> of "enabled forcedly" to something like "you can enable with ..." when
> you re-post with the changelog.

I've used "You can enable it back with", hoping the gramar is right

> (Note that dev_dbg() is NOT exactly equivalent to dev_printk(KERN_DEBUG),
> so you can't change all of them.  dev_printk(KERN_DEBUG) is always
> compiled in, while dev_dbg() is only compiled in when "DEBUG" is defined.)

Thanks for the hint, for I may have jumped the gun on those "other" cleanups
;-)

So here is the new version cut'n'pasted from git-format-patch

######################### CUT HERE #####################

>From 6250265aded9adcc2bdd5f62977c02a936b641f0 Mon Sep 17 00:00:00 2001
From: Vincent Legoll <vincent.legoll@gmail.com>
Date: Fri, 3 Oct 2008 23:56:02 +0200
Subject: [PATCH] PCI probing debug message uniformization

This patch uniformizes PCI probing debug boot messages
with dev_printk() intead of manual printk()

It changes adress range output from [%llx, %llx] to
[%#llx-%#llx], like in pci_request_region().

For example, it goes from the mixed-style:

PCI: 0000:00:1b.0 reg 10 64bit mmio: [f4280000, f4283fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold

to uniform:

pci 0000:00:1b.0: reg 10 64bit mmio: [0xf4280000-0xf4283fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold

This patch has been runtime tested, boot log messages diffed,
everything looks OK.

Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
---
 drivers/pci/pcie/aspm.c |    6 +++---
 drivers/pci/probe.c     |   21 +++++++++++----------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 851f5b8..fa0d1a4 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -528,9 +528,9 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 		pci_read_config_dword(child_dev, child_pos + PCI_EXP_DEVCAP,
 			&reg32);
 		if (!(reg32 & PCI_EXP_DEVCAP_RBER) && !aspm_force) {
-			printk("Pre-1.1 PCIe device detected, "
-				"disable ASPM for %s. It can be enabled forcedly"
-				" with 'pcie_aspm=force'\n", pci_name(pdev));
+			dev_printk(KERN_INFO, &child_dev->dev, "disabling ASPM"
+				" on pre-1.1 PCIe device. You can enable it"
+				" back with 'pcie_aspm=force'\n");
 			return -EINVAL;
 		}
 	}
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 36698e5..0ae65bf 100644
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
+				"reg %x 64bit mmio: [%#llx-%#llx]\n", pos,
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
+		dev_printk(KERN_DEBUG, &dev->dev, "reg %x %s: [%#llx-%#llx]\n", pos,
+			(res->flags & IORESOURCE_IO) ? "io port" : "32bit mmio",
 			(unsigned long long)res->start, (unsigned long long)res->end);
 	}

@@ -389,8 +390,8 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_DEBUG "PCI: bridge %s io port: [%llx, %llx]\n",
-			pci_name(dev), (unsigned long long) res->start,
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge io port: [%#llx-%#llx]\n",
+			(unsigned long long) res->start,
 			(unsigned long long) res->end);
 	}

@@ -403,8 +404,8 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_DEBUG "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
-			pci_name(dev), (unsigned long long) res->start,
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge 32bit mmio: [%#llx-%#llx]\n",
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
+		dev_printk(KERN_DEBUG, &dev->dev, "bridge %sbit mmio pref: [%#llx-%#llx]\n",
+			(res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
 			(unsigned long long) res->start, (unsigned long long) res->end);
 	}
 }
-- 
1.6.0.1
