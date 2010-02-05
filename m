Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086Ab0BEW7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 17:59:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:58863 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933950Ab0BEW7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 17:59:06 -0500
Date: Fri, 5 Feb 2010 22:58:07 GMT
From: tip-bot for Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       travis@sgi.com, holt@sgi.com, airlied@linux.ie,
       akpm@linux-foundation.org, steiner@sgi.com, jbarnes@virtuousgeek.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       travis@sgi.com, holt@sgi.com, airlied@linux.ie,
       jbarnes@virtuousgeek.org, akpm@linux-foundation.org, steiner@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <201002022238.o12McFe8018730@imap1.linux-foundation.org>
References: <201002022238.o12McFe8018730@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pci] vgaarb: Fix VGA arbiter to accept PCI domains other than 0
Message-ID: <tip-773a38dbdad03474c5ee235f7d9bf9f51c9e3c2b@git.kernel.org>
Git-Commit-ID: 773a38dbdad03474c5ee235f7d9bf9f51c9e3c2b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Feb 2010 22:58:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  773a38dbdad03474c5ee235f7d9bf9f51c9e3c2b
Gitweb:     http://git.kernel.org/tip/773a38dbdad03474c5ee235f7d9bf9f51c9e3c2b
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Tue, 2 Feb 2010 14:38:15 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 5 Feb 2010 14:05:41 -0800

vgaarb: Fix VGA arbiter to accept PCI domains other than 0

Update the VGA Arbiter to accept PCI Domains other than 0.

Signed-off-by: Mike Travis <travis@sgi.com>
LKML-Reference: <201002022238.o12McFe8018730@imap1.linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 drivers/gpu/vga/vgaarb.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 1ac0c93..ba7fa9e 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -954,6 +954,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		}
 
 	} else if (strncmp(curr_pos, "target ", 7) == 0) {
+		struct pci_bus *pbus;
 		unsigned int domain, bus, devfn;
 		struct vga_device *vgadev;
 
@@ -969,18 +970,31 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 				ret_val = -EPROTO;
 				goto done;
 			}
-
-			pdev = pci_get_bus_and_slot(bus, devfn);
+			pr_devel("vgaarb: %s ==> %x:%x:%x.%x\n", curr_pos,
+				domain, bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
+
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
@@ -998,7 +1012,8 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 			}
 		}
 		if (i == MAX_USER_CARDS) {
-			pr_err("vgaarb: maximum user cards number reached!\n");
+			pr_err("vgaarb: maximum user cards (%d) number reached!\n",
+				MAX_USER_CARDS);
 			pci_dev_put(pdev);
 			/* XXX: which value to return? */
 			ret_val =  -ENOMEM;
