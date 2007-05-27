Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbXE0BuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbXE0BuY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 21:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbXE0Btx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 21:49:53 -0400
Received: from imf09aec.mail.bellsouth.net ([205.152.59.57]:35557 "EHLO
	imf09aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbXE0Btw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 21:49:52 -0400
Date: Sat, 26 May 2007 20:26:30 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Adrian Bunk <bunk@stusta.de>
Cc: gregkh@suse.de, chrisw@sous-sol.org, csnook@redhat.com,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable][PATCH] pci: quirk disable MSI on via vt3351
Message-ID: <20070526202630.3afb7b8e@osprey.hogchain.net>
In-Reply-To: <20070527002052.GM3899@stusta.de>
References: <20070526220104.GA11530@osprey.hogchain.net>
	<20070527002052.GM3899@stusta.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 May 2007 02:20:52 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> On Sat, May 26, 2007 at 05:01:04PM -0500, Jay Cliburn wrote:
> > 
> > The Via VT3351 APIC does not play well with MSI and unleashes a
> > flood of APIC errors when MSI is used to deliver interrupts.  The
> > problem was recently exposed when the atl1 network device driver,
> > which enables MSI by default, stimulated APIC errors on an Asus M2V
> > mainboard, which employs the Via VT3351.
> > See http://bugzilla.kernel.org/show_bug.cgi?id=8472 for additional
> > details on this bug.
> >...
> 
> Please get patches included in Linus' tree _before_ submitting them
> for -stable.
> 
> Adding a fix to 2.6.21 that is not yet in 2.6.22-rc would create a 
> regression in 2.6.22.

Okay, thanks Adrian.  I didn't realize I was making a mistake.  I've
been waiting for the below patch to make it upstream, but it landed
in stable first, so I guess there's a regression as you indicate.  My
patch depends upon this one.


Subject: [patch 41/69] pci-quirks: disable MSI on RS400-200 and RS480
Date: Mon, 21 May 2007 12:16:53 -0700
Sender: linux-kernel-owner@vger.kernel.org
User-Agent: quilt/0.46-1

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Tejun Heo <htejun@gmail.com>

MSI doesn't work on RS400-200 and RS480 requiring pci=nomsi kernel boot
parameter for ahci to work.  This patch renames quirk_svw_msi() to
quirk_disable_all_msi() and use it to disable MSI on those chips.

  http://thread.gmane.org/gmane.linux.ide/17820
  http://thread.gmane.org/gmane.linux.ide/17516
  https://bugzilla.novell.com/show_bug.cgi?id=263893

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Matí-as Alejandro Torres <torresmat@gmail.com>
Cc: Greg K-H <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 drivers/pci/quirks.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- linux-2.6.21.1.orig/drivers/pci/quirks.c
+++ linux-2.6.21.1/drivers/pci/quirks.c
@@ -1737,18 +1737,20 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_N
 			quirk_nvidia_ck804_pcie_aer_ext_cap);
 
 #ifdef CONFIG_PCI_MSI
-/* The Serverworks PCI-X chipset does not support MSI. We cannot
easily rely
- * on setting PCI_BUS_FLAGS_NO_MSI in its bus flags because there are
actually
- * some other busses controlled by the chipset even if Linux is not
aware of it.
- * Instead of setting the flag on all busses in the machine, simply
disable MSI
- * globally.
+/* Some chipsets do not support MSI. We cannot easily rely on setting
+ * PCI_BUS_FLAGS_NO_MSI in its bus flags because there are actually
+ * some other busses controlled by the chipset even if Linux is not
+ * aware of it.  Instead of setting the flag on all busses in the
+ * machine, simply disable MSI globally.
  */
-static void __init quirk_svw_msi(struct pci_dev *dev)
+static void __init quirk_disable_all_msi(struct pci_dev *dev)
 {
 	pci_no_msi();
 	printk(KERN_WARNING "PCI: MSI quirk detected. MSI
deactivated.\n"); }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS,
PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_svw_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS,
PCI_DEVICE_ID_SERVERWORKS_GCNB_LE, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI,
PCI_DEVICE_ID_ATI_RS400_200, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480,
quirk_disable_all_msi); /* Disable MSI on chipsets that are known to
not support it */ static void __devinit quirk_disable_msi(struct
pci_dev *dev)

-- 
