Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYDQThb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYDQThb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 15:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYDQThX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 15:37:23 -0400
Received: from ns2.suse.de ([195.135.220.15]:58784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbYDQThW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 15:37:22 -0400
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: LKML <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz
Subject: PCI MSI breaks when booting with nosmp
Date: Thu, 17 Apr 2008 21:40:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@ucw.cz>, Tejun Heo <htejun@gmail.com>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Reuben Farrelly <reuben-lkml@reub.net>, Jeff Garzik <jgarzik@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804172140.02311.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

My Thinkpad T60p laptop won't boot any recent kernel with nosmp.
I investigated the issue because many people have been complaining
lately that nosmp was breaking their system, and that's unfortunate
because nosmp is a valuable debugging tool.

The actual problem is that the ahci driver fails during probe.
It's essentially the same problem that has been reported here over
3 years ago:
http://marc.info/?l=linux-ide&m=112729386600155&w=2

The post above gave me the idea to try booting with "nosmp pci=nomsi",
and that worked. This makes me believe that the problem is that PCI MSI
makes expectations that are no longer valid when booting with nomsp.

So, I have come up with the following naive patch:

* * * * *

Booting with "nosmp" doesn't work on my Thinkpad T60p laptop while
booting with "nosmp pci=nomsi" works. Forcibly disabling PCI MSI
when booting with nosmp fixes the problem. I'm not sure if it's the
correct fix though.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
---
 drivers/pci/pci.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2.6.25-rc9.orig/drivers/pci/pci.c
+++ linux-2.6.25-rc9/drivers/pci/pci.c
@@ -1635,6 +1635,10 @@ static int __devinit pci_init(void)
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		pci_fixup_device(pci_fixup_final, dev);
 	}
+#ifdef CONFIG_SMP
+	if (setup_max_cpus == 0)
+		pci_no_msi();
+#endif	
 	return 0;
 }
 

* * * * *

I would welcome comments on the patch above. Is it even remotely
correct? Or is the bug more likely in the ahci driver and the PCI MSI
code is innocent?

FWIW, booting with noapic or nolapic without disabling PCI MSI works
fine for me, so it doesn't seem to be an APIC problem (although this was
my first suspect originally.)

Thanks,
-- 
Jean Delvare
Suse L3
