Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894Ab0ARSe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab0ARSe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888Ab0ARSey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:34:54 -0500
Received: from relay2.sgi.com ([192.48.179.30]:57634 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755859Ab0ARSew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:34:52 -0500
Message-Id: <20100118183444.775580000@alcatraz.americas.sgi.com>
References: <20100118183412.560438000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Jan 2010 12:34:15 -0600
From: Mike Travis <travis@sgi.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>
Cc: Russ Anderson <rja@sgi.com>, Dave Airlie <airlied@redhat.com>,
       Alex Chiang <achiang@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robin Holt <holt@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Adam Jackson <ajax@nwnk.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gaetan Nadon <memsize@videotron.ca>, "H. Peter Anvin" <hpa@zytor.com>,
       Aaron Plattner <aplattner@nvidia.com>, Jack Steiner <steiner@sgi.com>,
       Tiago Vignatti <tiago.vignatti@nokia.com>, Cliff Wickman <cpw@sgi.com>,
       Matthew Wilcox <willy@linux.intel.com>,
       Christian Zander <chzander@nvidia.com>, Yu Zhao <yu.zhao@intel.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org
Subject: [PATCH 3/4] vgaarb: Fix VGA Arbiter to accept PCI Domains other than 0
Content-Disposition: inline; filename=update-vgaarb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the VGA Arbiter to accept PCI Domains other than 0.

Signed-off-by: Mike Travis <travis@sgi.com>

Cc: Dave Airlie <airlied@redhat.com>
Cc: Alex Chiang <achiang@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Robin Holt <holt@sgi.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Adam Jackson <ajax@nwnk.net>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Gaetan Nadon <memsize@videotron.ca>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Aaron Plattner <aplattner@nvidia.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Tiago Vignatti <tiago.vignatti@nokia.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Christian Zander <chzander@nvidia.com>
Cc: Yu Zhao <yu.zhao@intel.com>

Cc: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: x86@kernel.org
---
 drivers/gpu/vga/vgaarb.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- linux.orig/drivers/gpu/vga/vgaarb.c
+++ linux/drivers/gpu/vga/vgaarb.c
@@ -954,6 +954,7 @@
 		}
 
 	} else if (strncmp(curr_pos, "target ", 7) == 0) {
+		struct pci_bus *pbus;
 		unsigned int domain, bus, devfn;
 		struct vga_device *vgadev;
 
@@ -969,18 +970,31 @@
 				ret_val = -EPROTO;
 				goto done;
 			}
+			pr_devel("vgaarb: %s ==> %x:%x:%x.%x\n", curr_pos,
+				domain, bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
 
-			pdev = pci_get_bus_and_slot(bus, devfn);
+			pbus = pci_find_bus(domain, bus);
+			pr_devel("vgaarb: pbus %p\n", pbus);
+			if (pbus == NULL) {
+				pr_err("vgaarb: invalid PCI domain and/or bus address %x:%x\n",
+					domain, bus);
+				ret_val = -ENODEV;
+				goto done;
+			}
+			pdev = pci_get_slot(pbus, devfn);
+			pr_devel("vgaarb: pdev %p\n", pdev);
 			if (!pdev) {
-				pr_info("vgaarb: invalid PCI address!\n");
+				pr_err("vgaarb: invalid PCI address %x:%x\n",
+					bus, devfn);
 				ret_val = -ENODEV;
 				goto done;
 			}
 		}
 
 		vgadev = vgadev_find(pdev);
+		pr_devel("vgaarb: vgadev %p\n", vgadev);
 		if (vgadev == NULL) {
-			pr_info("vgaarb: this pci device is not a vga device\n");
+			pr_err("vgaarb: this pci device is not a vga device\n");
 			pci_dev_put(pdev);
 			ret_val = -ENODEV;
 			goto done;
@@ -998,7 +1012,8 @@
 			}
 		}
 		if (i == MAX_USER_CARDS) {
-			pr_err("vgaarb: maximum user cards number reached!\n");
+			pr_err("vgaarb: maximum user cards (%d) number reached!\n",
+				MAX_USER_CARDS);
 			pci_dev_put(pdev);
 			/* XXX: which value to return? */
 			ret_val =  -ENOMEM;

-- 
