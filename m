Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab0B1XwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 18:52:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:48237 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab0B1XwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 18:52:06 -0500
Message-ID: <4B8B0167.2000707@kernel.org>
Date: Sun, 28 Feb 2010 15:51:03 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] PCI changes for 2.6.34  -- pci_try_num
References: <20100226093957.7b99d09c@jbarnes-piketon> <alpine.LFD.2.00.1002281227300.3851@localhost.localdomain> <alpine.LFD.2.00.1002281246120.3637@localhost.localdomain> <33223F6C-10BD-4671-937D-6D5E4956DD3F@kernel.org> <alpine.LFD.2.00.1002281314110.3637@localhost.localdomain> <4B8AF121.2060106@kernel.org>
In-Reply-To: <4B8AF121.2060106@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check

[PATCH] pci: disable pci trying to reallocate pci bridge by default.

it broken Linus's Nouveau

bisected:to commit 977d17bb17
| PCI: update bridge resources to get more big ranges in PCI assign unssigned

so try disable it by default.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 Documentation/kernel-parameters.txt |    6 ++++++
 drivers/pci/pci.c                   |    4 ++++
 drivers/pci/pci.h                   |    2 ++
 drivers/pci/setup-bus.c             |   14 +++++++++-----
 4 files changed, 21 insertions(+), 5 deletions(-)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -1963,6 +1963,12 @@ and is between 256 and 4096 characters.
 				for broken drivers that don't call it.
 		skip_isa_align	[X86] do not align io start addr, so can
 				handle more pci cards
+		try=n		set the pci_try_num to reallocate the pci bridge resource
+				1: default
+				2: will set the num to max_depth, and try to reallocate res
+				   to get big range for the bridge. assume the pci peer root
+				   resource is right from _CRS or from hostbridge pci reg
+				   reading out.
 		firmware	[ARM] Do not re-enumerate the bus but instead
 				just use the configuration from the
 				bootloader. This is currently used on
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -2974,6 +2974,10 @@ static int __init pci_setup(char *str)
 				pci_no_aer();
 			} else if (!strcmp(str, "nodomains")) {
 				pci_no_domains();
+			} else if (!strncmp(str, "try=", 4)) {
+				int try_num = memparse(str + 4, &str);
+				if (try_num > 0)
+					pci_try_num = try_num;
 			} else if (!strncmp(str, "cbiosize=", 9)) {
 				pci_cardbus_io_size = memparse(str + 9, &str);
 			} else if (!strncmp(str, "cbmemsize=", 10)) {
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -212,6 +212,8 @@ static inline int pci_ari_enabled(struct
 	return bus->self && bus->self->ari_enabled;
 }
 
+extern int pci_try_num;
+
 #ifdef CONFIG_PCI_QUIRKS
 extern int pci_is_reassigndev(struct pci_dev *dev);
 resource_size_t pci_specified_resource_alignment(struct pci_dev *dev);
Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -869,6 +869,7 @@ static int __init pci_get_max_depth(void
  * second  and later try will clear small leaf bridge res
  * will stop till to the max  deepth if can not find good one
  */
+int pci_try_num = 1;
 void __init
 pci_assign_unassigned_resources(void)
 {
@@ -879,14 +880,17 @@ pci_assign_unassigned_resources(void)
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 	unsigned long failed_type;
-	int max_depth = pci_get_max_depth();
-	int pci_try_num;
 
 	head.next = NULL;
 
-	pci_try_num = max_depth + 1;
-	printk(KERN_DEBUG "PCI: max bus depth: %d pci_try_num: %d\n",
-		 max_depth, pci_try_num);
+	if (pci_try_num > 1) {
+		int max_depth = pci_get_max_depth();
+
+		if (max_depth + 1 > pci_try_num)
+			pci_try_num = max_depth + 1;
+		printk(KERN_DEBUG "PCI: max bus depth: %d pci_try_num: %d\n",
+			 max_depth, pci_try_num);
+	}
 
 again:
 	/* Depth first, calculate sizes and alignments of all
