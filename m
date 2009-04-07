Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbZDGBdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbZDGBdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZDGBdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:33:31 -0400
Received: from outbound-mail-18.bluehost.com ([69.89.20.233]:40813 "HELO
	outbound-mail-18.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752500AbZDGBda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:33:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=NdUF/mveRly7Sp+Ol0JM3bMSPejYWaWRYHhm09nXuR3W0cB2Ju6BGXYv7WxEiJVV75sH++F9auxQADggImr6whHRHHZ8zgliku1LKu1MgtDqXgme52v0CpNa7hA3CAWc;
Date: Mon, 6 Apr 2009 18:33:24 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20090406183324.6997e70d@hobbes>
In-Reply-To: <alpine.LFD.2.00.0904061824410.4010@localhost.localdomain>
References: <20090406.175752.236260059.davem@davemloft.net>
	<alpine.LFD.2.00.0904061824410.4010@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009 18:25:31 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> The sky2 driver is buggered (by the previous pull, I presume). Some
> PCI interaction. NULL pointer dereference at boot.

Hopefully fixed by this patch in my for-linus branch?

-- 
Jesse Barnes, Intel Open Source Technology Center

commit d6141668c24d7d75c3486499c05a6b382cbc2bbe
Author: Anton Vorontsov <avorontsov@ru.mvista.com>
Date:   Wed Apr 1 02:23:41 2009 +0400

    PCI: Fix oops in pci_vpd_truncate
    
    pci_vpd_truncate() should check for dev->vpd->attr, otherwise
    this might happen:
    
    sky2 driver version 1.22
    Unable to handle kernel paging request for data at address 0x0000000c
    Faulting instruction address: 0xc01836fc
    Oops: Kernel access of bad area, sig: 11 [#1]
    [...]
    NIP [c01836fc] pci_vpd_truncate+0x38/0x40
    LR [c029be18] sky2_probe+0x14c/0x518
    Call Trace:
    [ef82bde0] [c029bda4] sky2_probe+0xd8/0x518 (unreliable)
    [ef82be20] [c018a11c] local_pci_probe+0x24/0x34
    [ef82be30] [c018a14c] pci_call_probe+0x20/0x30
    [ef82be50] [c018a330] __pci_device_probe+0x64/0x78
    [ef82be60] [c018a44c] pci_device_probe+0x30/0x58
    [ef82be80] [c01aa270] really_probe+0x78/0x1a0
    [ef82bea0] [c01aa460] __driver_attach+0xa4/0xa8
    [ef82bec0] [c01a96ac] bus_for_each_dev+0x60/0x9c
    [ef82bef0] [c01aa0b4] driver_attach+0x24/0x34
    [ef82bf00] [c01a9e08] bus_add_driver+0x12c/0x1cc
    [ef82bf20] [c01aa87c] driver_register+0x6c/0x110
    [ef82bf30] [c018a770] __pci_register_driver+0x4c/0x9c
    [ef82bf50] [c03782c8] sky2_init_module+0x30/0x40
    [ef82bf60] [c0001dbc] do_one_initcall+0x34/0x1a0
    [ef82bfd0] [c0362240] do_initcalls+0x38/0x58
    
    This happens with CONFIG_SKY2=y, and "ip=on" kernel command line, so
    pci_vpd_truncate() is called before late_initcall(pci_sysfs_init),
    therefore ->attr isn't yet initialized.
    
    Acked-by: Stephen Hemminger <shemminger@vyatta.com>
    Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 3814447..64dd7df 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -356,7 +356,8 @@ int pci_vpd_truncate(struct pci_dev *dev, size_t size)
 		return -EINVAL;
 
 	dev->vpd->len = size;
-	dev->vpd->attr->size = size;
+	if (dev->vpd->attr)
+		dev->vpd->attr->size = size;
 
 	return 0;
 }
