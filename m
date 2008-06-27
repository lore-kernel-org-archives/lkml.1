Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbYF0MXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbYF0MXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYF0MX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:23:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbYF0MX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:23:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix pci_setup_device()'s sprinting into a const buffer
To: torvalds@osdl.org, akpm@linux-foundation.org, jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Date: Fri, 27 Jun 2008 13:23:20 +0100
Message-ID: <20080627122320.29319.14707.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make pci_setup_device() write the bus ID directly into the allotted storage,
rather than using pci_name() as the address as that now returns a const pointer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/pci/probe.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index f829119..0420fd8 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -713,8 +713,9 @@ static int pci_setup_device(struct pci_dev * dev)
 {
 	u32 class;
 
-	sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(dev->bus),
-		dev->bus->number, PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
+	snprintf(dev->dev.bus_id, BUS_ID_SIZE,
+		 "%04x:%02x:%02x.%d", pci_domain_nr(dev->bus),
+		 dev->bus->number, PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
 
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
 	dev->revision = class & 0xff;

