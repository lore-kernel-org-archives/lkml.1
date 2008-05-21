Return-Path: <linux-kernel-owner+w=401wt.eu-S934586AbYEUNH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934586AbYEUNH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757040AbYEUNHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:07:50 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:49823 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755675AbYEUNHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:07:50 -0400
Message-ID: <411375292.14780@ustc.edu.cn>
X-WebMAIL-MUA: [211.86.158.64]
From: "" <jszhang3@mail.ustc.edu.cn>
To: stefanr@s5r6.in-berlin.de
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       krh@redhat.com
Date: Wed, 21 May 2008 21:08:12 +0800
Reply-To: "" <jszhang3@mail.ustc.edu.cn>
X-Priority: 3
Subject: [PATCH] firewire: fix some broken hardware NMI interrupt
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From JiSheng Zhang <jszhang3@mail.ustc.edu.cn>

Some broken pci-1394 card does not clear completely on-chip memory during boot, it
may cause pci parity error, then NMI interrupt. It will emit kernel message such
as"Uhhuh. NMI received for unknown reason b1 on CPU 0. You have some hardware
problem, likely on the PCI bus. Dazed and confused, but trying to continue" etc.
If panic_on_unrecovered_nmi is set to 1, the system will panic. This patch will
fix it


--- linux-2.6.25.4/drivers/firewire/fw-ohci.c.org	2008-05-21 20:44:26.901066202
+0800
+++ linux-2.6.25.4/drivers/firewire/fw-ohci.c	2008-05-21 20:55:15.290371532 +0800
@@ -2051,6 +2051,7 @@
 	struct fw_ohci *ohci;
 	u32 bus_options, max_receive, link_speed;
 	u64 guid;
+	u16 reg;
 	int err;
 	size_t size;
 
@@ -2082,6 +2083,10 @@
 
 	pci_set_master(dev);
 	pci_write_config_dword(dev, OHCI1394_PCI_HCI_Control, 0);
+	/* some broken hardware */
+	pci_read_config_word(dev, PCI_COMMAND, &reg);
+	reg &= ~(PCI_COMMAND_SERR | PCI_COMMAND_PARITY);
+	pci_write_config_word(dev, PCI_COMMAND, reg);
 	pci_set_drvdata(dev, ohci);
 
 #if defined(CONFIG_PPC_PMAC) && defined(CONFIG_PPC32)


