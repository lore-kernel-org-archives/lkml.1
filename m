Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbZERRwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbZERRwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbZERRw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:52:27 -0400
Received: from mail.lang.hm ([64.81.33.126]:50501 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbZERRw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:52:26 -0400
Date: Mon, 18 May 2009 10:51:21 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard
To: linux-kernel <linux-kernel@vger.kernel.org>
cc: tj@kernel.org
Subject: Intel X25E doesn't work with nv sata in current kernels
Message-ID: <alpine.DEB.1.10.0905181041310.15782@asgard>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

according to but 12703 ( http://bugzilla.kernel.org/show_bug.cgi?id=12703 )
this worked with older kernels, but with 2.6.29.[13] and 2.6.30-rc6

according to this ticket it did work with older vendor kernels, but it's 
not clear which ones (and no older vanilla kernels)

I have verified that this drive does work on a PCI controller card in the 
same machine (with the same cables), so this is definantly a 
controller/kernel issue

booting with libata.force=#:nohrst (with # being the SATA controller that 
the SSD is on) does allow it to be detected, but the patch listed in the 
ticket

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 6cda12b..6673b1d 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1565,7 +1565,7 @@ static int nv_noclassify_hardreset(struct ata_link 
*link, unsigned int *class,
         bool online;
         int rc;

-       rc = sata_link_hardreset(link, sata_deb_timing_hotplug, deadline,
+       rc = sata_link_hardreset(link, sata_deb_timing_long, deadline,
                                  &online, NULL);
         return online ? -EAGAIN : rc;
  }

does not work.

Tejun Heo was working on this back in April, but it looks like the 
troubleshooting petered out.

one issue that I did notice, in the dmesg I see

$ grep SATA dmesg
ata1: SATA max UDMA/133 cmd 0xd480 ctl 0xd400 bmdma 0xcc00 irq 11
ata2: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xcc08 irq 11
ata1: SATA link down (SStatus 100 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3: SATA max UDMA/133 cmd 0xc880 ctl 0xc800 bmdma 0xc080 irq 5
ata4: SATA max UDMA/133 cmd 0xc480 ctl 0xc400 bmdma 0xc088 irq 5
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb480 irq 10
ata6: SATA max UDMA/133 cmd 0xb880 ctl 0xb800 bmdma 0xb488 irq 10
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)

note the ata1 line. it detects something different than the links where 
there really is nothing plugged in, but it doesn't come up

booting with nohrst results in SStatus 123

David Lang

