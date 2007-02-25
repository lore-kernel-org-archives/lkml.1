Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbXBYXqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbXBYXqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 18:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbXBYXqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 18:46:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52457
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbXBYXqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 18:46:37 -0500
Date: Sun, 25 Feb 2007 15:46:37 -0800 (PST)
Message-Id: <20070225.154637.70478886.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: MSI entry unlinked before arch_teardown_msi_irq().
From: David Miller <davem@davemloft.net>
In-Reply-To: <m17iu6r4eg.fsf@ebiederm.dsl.xmission.com>
References: <20070224.235020.92583817.davem@davemloft.net>
	<m17iu6r4eg.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 25 Feb 2007 02:08:07 -0700

> If that isn't the issue holler and I will look into it a little more.

Talking in code is always more effective :-)

This patch fixes the OOPS I was talking about:

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 68555c1..2f2d92e 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -678,12 +678,14 @@ static int msi_free_irq(struct pci_dev* dev, int irq)
 	}
 	type = entry->msi_attrib.type;
 	entry_nr = entry->msi_attrib.entry_nr;
+
+	arch_teardown_msi_irq(irq);
+
 	head = entry->link.head;
 	base = entry->mask_base;
 	get_irq_msi(entry->link.head)->link.tail = entry->link.tail;
 	get_irq_msi(entry->link.tail)->link.head = entry->link.head;
 
-	arch_teardown_msi_irq(irq);
 	kmem_cache_free(msi_cachep, entry);
 
 	if (type == PCI_CAP_ID_MSIX) {
