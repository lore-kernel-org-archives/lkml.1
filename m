Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbZFYPij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbZFYPij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 11:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758059AbZFYPia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 11:38:30 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:60737 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467AbZFYPi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 11:38:28 -0400
X-Greylist: delayed 1538 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jun 2009 11:38:28 EDT
Date: Thu, 25 Jun 2009 16:13:21 +0100 (BST)
From: Troy Moure <twmoure@szypr.net>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
cc: Alexander Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.31-rc1] oops in acpi_get_pci_dev
Message-ID: <alpine.LFD.2.00.0906251548300.2760@troy-laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alessandro Suardi wrote:

> On boot:
...
> kernel: BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000018
> kernel: IP: [<ffffffff8121b556>] acpi_get_pci_dev+0x113/0x17
...
> Dell Latitude E6400 x86_64 SMP with Fedora 11 userspace.

> Box continues working after Oops, but locks up when exiting X session.

> 2.6.30-git22 works fine (probably because acpi_get_pci_dev is
> introduced in -rc1)

I've encountered what seems to be the same issue (a NULL pointer 
dereference in acpi_get_pci_dev()).  In my case, it caused a kernel panic 
during boot (so I don't have any text logs to attach).

In my case, pci_get_slot() is returning a NULL pointer that  
acpi_get_pci_dev() doesn't check for.  The following patch fixes things 
for me.  Does it work for you, Alessandro?

(I don't know if it's the "right" fix or not, not being familiar with the 
system.  If it is, I can send it in as a proper patch.)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 8a5bf3b..55b5b90 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -395,7 +395,7 @@ struct pci_dev *acpi_get_pci_dev(acpi_handle handle)
 		fn  = adr & 0xffff;
 
 		pdev = pci_get_slot(pbus, PCI_DEVFN(dev, fn));
-		if (hnd == handle)
+		if (!pdev || hnd == handle)
 			break;
 
 		pbus = pdev->subordinate;
