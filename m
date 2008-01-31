Return-Path: <linux-kernel-owner+w=401wt.eu-S934798AbYAaWLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798AbYAaWLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934388AbYAaWKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:10:39 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:40277 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934020AbYAaWKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:10:37 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Greg KH <gregkh@suse.de>,
       Adrian Bunk <bunk@kernel.org>
Subject: [PATCH] pci: fix 4x section mismatch warnings
Date: Thu, 31 Jan 2008 23:10:31 +0100
Message-Id: <1201817440-5081-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080131220430.GA4874@uranus.ravnborg.org>
References: <20080131220430.GA4874@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings were issued during build of
drivers/pci with an allyesconfig build:
WARNING: o-x86_64/drivers/pci/built-in.o(.text+0xdaf): Section mismatch in reference from the function pci_add_new_bus() to the function .devinit.text:pci_alloc_child_bus()
WARNING: o-x86_64/drivers/pci/built-in.o(.text+0x15e2): Section mismatch in reference from the function pci_scan_single_device() to the function .devinit.text:pci_scan_device()
WARNING: o-x86_64/drivers/pci/built-in.o(.text+0x1b0c5): Section mismatch in reference from the function pci_bus_assign_resources() to the function .devinit.text:pci_setup_bridge()
WARNING: o-x86_64/drivers/pci/built-in.o(.text+0x1b32d): Section mismatch in reference from the function pci_bus_size_bridges() to the function .devinit.text:pci_bus_size_cardbus()

Investigating each case closer it looked like all
referred functions are only used in the init phase
or during hotplug.
So to avoid wasting too much memory in the non-hotplug
case the simpler fix was to allow the fuctions to
use code/data from the __devinit sections.
This was done in all four case by adding the __ref
annotation.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>
---
 drivers/pci/probe.c     |    4 ++--
 drivers/pci/setup-bus.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 496fc13..f419026 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -442,7 +442,7 @@ error_register:
 	return NULL;
 }
 
-struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev, int busnr)
+struct pci_bus *__ref pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev, int busnr)
 {
 	struct pci_bus *child;
 
@@ -959,7 +959,7 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	up_write(&pci_bus_sem);
 }
 
-struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn)
+struct pci_dev *__ref pci_scan_single_device(struct pci_bus *bus, int devfn)
 {
 	struct pci_dev *dev;
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 401e03c..86bb6f8 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -440,7 +440,7 @@ pci_bus_size_cardbus(struct pci_bus *bus)
 	}
 }
 
-void pci_bus_size_bridges(struct pci_bus *bus)
+void __ref pci_bus_size_bridges(struct pci_bus *bus)
 {
 	struct pci_dev *dev;
 	unsigned long mask, prefmask;
@@ -495,7 +495,7 @@ void pci_bus_size_bridges(struct pci_bus *bus)
 }
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
-void pci_bus_assign_resources(struct pci_bus *bus)
+void __ref pci_bus_assign_resources(struct pci_bus *bus)
 {
 	struct pci_bus *b;
 	struct pci_dev *dev;
-- 
1.5.4.rc3.14.g44397

