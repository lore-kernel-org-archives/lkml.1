Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbYDUTkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbYDUTkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbYDUTkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:40:36 -0400
Received: from outbound-mail-138.bluehost.com ([67.222.39.28]:35467 "HELO
	outbound-mail-138.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756725AbYDUTkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:40:35 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: PCI MSI breaks when booting with nosmp
Date: Mon, 21 Apr 2008 12:35:23 -0700
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, Jean Delvare <jdelvare@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Tejun Heo <htejun@gmail.com>, Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
References: <200804172140.02311.jdelvare@suse.de> <87d4oj6o9a.fsf@basil.nowhere.org> <200804211207.00961.jbarnes@virtuousgeek.org>
In-Reply-To: <200804211207.00961.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804211235.25174.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 21, 2008 12:06 pm Jesse Barnes wrote:
> On Monday, April 21, 2008 11:45 am Andi Kleen wrote:
> > Jesse Barnes <jbarnes@virtuousgeek.org> writes:
> > > Ok, I see this too on my desktop machine.  It looks like we're not
> > > getting interrupts setup correctly in the nosmp case.  Still digging
> > > through to see why though...
> >
> > NoSMP disables the io-apic and a lot of modern systems don't work without
> > APIC.
> >
> > If you just want to run with a single cpu for testing etc. always use
> > maxcpus=1 (not 0, that will disable the APIC too)
>
> Right...  but it looks like the MSI code is buggy when noapic is specified
> via nosmp or maxcpus=0.  We should either fix it to work with noapic or
> disable it like we do the ioapic when nosmp or maxcpus=0:

Or if you want something that compiles & works (at least on my machine) here 
it is.  But the fact that noapic alone doesn't cause the bug means there's 
probably something depending on !setup_max_cpus that needs fixing instead.

Jesse

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index eabeb1f..9170589 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -39,14 +39,6 @@ extern struct rw_semaphore pci_bus_sem;
 
 extern unsigned int pci_pm_d3_delay;
 
-#ifdef CONFIG_PCI_MSI
-void pci_no_msi(void);
-extern void pci_msi_init_pci_dev(struct pci_dev *dev);
-#else
-static inline void pci_no_msi(void) { }
-static inline void pci_msi_init_pci_dev(struct pci_dev *dev) { }
-#endif
-
 #ifdef CONFIG_PCIEAER
 void pci_no_aer(void);
 #else
diff --git a/include/linux/pci.h b/include/linux/pci.h
index ea760e5..0ed53d6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -590,6 +590,13 @@ int pci_try_set_mwi(struct pci_dev *dev);
 void pci_clear_mwi(struct pci_dev *dev);
 void pci_intx(struct pci_dev *dev, int enable);
 void pci_msi_off(struct pci_dev *dev);
+#ifdef CONFIG_PCI_MSI
+void pci_no_msi(void);
+extern void pci_msi_init_pci_dev(struct pci_dev *dev);
+#else
+static inline void pci_no_msi(void) { }
+static inline void pci_msi_init_pci_dev(struct pci_dev *dev) { }
+#endif
 int pci_set_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask);
 int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size);
diff --git a/init/main.c b/init/main.c
index 99ce949..a9436b7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -58,6 +58,7 @@
 #include <linux/kthread.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
+#include <linux/pci.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -148,6 +149,7 @@ static int __init nosmp(char *str)
 {
 	setup_max_cpus = 0;
 	disable_ioapic_setup();
+	pci_no_msi();
 	return 0;
 }
 
@@ -156,9 +158,10 @@ early_param("nosmp", nosmp);
 static int __init maxcpus(char *str)
 {
 	get_option(&str, &setup_max_cpus);
-	if (setup_max_cpus == 0)
+	if (setup_max_cpus == 0) {
 		disable_ioapic_setup();
-
+		pci_no_msi();
+	}
 	return 0;
 }
 

