Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbYFFWQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbYFFWQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 18:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbYFFWQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 18:16:12 -0400
Received: from outbound-mail-124.bluehost.com ([67.222.38.24]:37834 "HELO
	outbound-mail-124.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752673AbYFFWQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 18:16:11 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git pull] PCI fixes
Date: Fri, 6 Jun 2008 15:16:01 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <200806061126.11037.jbarnes@virtuousgeek.org> <4849B468.8060903@garzik.org>
In-Reply-To: <4849B468.8060903@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806061516.01685.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 06, 2008 3:04 pm Jeff Garzik wrote:
> Jesse Barnes wrote:
> > Please pull a few more fixes for 2.6.26:
> > git pull
> > git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git
> > for-linus
> >
> > There's nothing big or critical here, just a couple of things that would
> > be nice to see in 2.6.26: a fix for OLPC and a new quirk for VIA bridges.
> >
> > Thanks,
> > Jesse
> >
> > Andres Salomon (1):
> >       PCI/x86: fix up PCI stuff so that PCI_GOANY supports OLPC
> >
> > Bertram Felgenhauer (1):
> >       x86/PCI: add workaround for bug in ASUS A7V600 BIOS (rev 1005)
> >
> >  arch/x86/Kconfig    |   11 +++++------
> >  arch/x86/pci/init.c |    3 ++-
> >  arch/x86/pci/irq.c  |    7 +++++++
> >  arch/x86/pci/olpc.c |    5 +++--
> >  arch/x86/pci/pci.h  |    2 +-
> >  5 files changed, 18 insertions(+), 10 deletions(-)
>
> Even though these patches have made a previous appearance on the list,
> any chance you could be talked into including a summary patch, when you
> push upstream?  It's nice to be able to give the push one last look.

Sure, that's a good idea.  Especially for post-merge window pull requests
like this.  Here's this one for reference (note that I don't really think
some of this OLPC code being patched should exist in its current form at
all, but I don't think this patch makes things any worse).

Jesse

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dcbec34..52e18e6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1508,13 +1508,13 @@ config PCI_GOMMCONFIG
 config PCI_GODIRECT
 	bool "Direct"
 
-config PCI_GOANY
-	bool "Any"
-
 config PCI_GOOLPC
 	bool "OLPC"
 	depends on OLPC
 
+config PCI_GOANY
+	bool "Any"
+
 endchoice
 
 config PCI_BIOS
@@ -1531,9 +1531,8 @@ config PCI_MMCONFIG
 	depends on X86_32 && PCI && ACPI && (PCI_GOMMCONFIG || PCI_GOANY)
 
 config PCI_OLPC
-	bool
-	depends on PCI && PCI_GOOLPC
-	default y
+	def_bool y
+	depends on PCI && OLPC && (PCI_GOOLPC || PCI_GOANY)
 
 config PCI_DOMAINS
 	def_bool y
diff --git a/arch/x86/pci/init.c b/arch/x86/pci/init.c
index e70b9c5..b821f44 100644
--- a/arch/x86/pci/init.c
+++ b/arch/x86/pci/init.c
@@ -15,7 +15,8 @@ static __init int pci_access_init(void)
 	pci_mmcfg_early_init();
 
 #ifdef CONFIG_PCI_OLPC
-	pci_olpc_init();
+	if (!pci_olpc_init())
+		return 0;	/* skip additional checks if it's an XO */
 #endif
 #ifdef CONFIG_PCI_BIOS
 	pci_pcbios_init();
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 0908fca..ca8df9c 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -621,6 +621,13 @@ static __init int via_router_probe(struct irq_router *r,
 			 */
 			device = PCI_DEVICE_ID_VIA_8235;
 			break;
+		case PCI_DEVICE_ID_VIA_8237:
+			/**
+			 * Asus a7v600 bios wrongly reports 8237
+			 * as 586-compatible
+			 */
+			device = PCI_DEVICE_ID_VIA_8237;
+			break;
 		}
 	}
 
diff --git a/arch/x86/pci/olpc.c b/arch/x86/pci/olpc.c
index 5e76365..e11e9e8 100644
--- a/arch/x86/pci/olpc.c
+++ b/arch/x86/pci/olpc.c
@@ -302,12 +302,13 @@ static struct pci_raw_ops pci_olpc_conf = {
 	.write = pci_olpc_write,
 };
 
-void __init pci_olpc_init(void)
+int __init pci_olpc_init(void)
 {
 	if (!machine_is_olpc() || olpc_has_vsa())
-		return;
+		return -ENODEV;
 
 	printk(KERN_INFO "PCI: Using configuration type OLPC\n");
 	raw_pci_ops = &pci_olpc_conf;
 	is_lx = is_geode_lx();
+	return 0;
 }
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index f3972b1..720c4c5 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -101,7 +101,7 @@ extern struct pci_raw_ops pci_direct_conf1;
 extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
 extern void pci_pcbios_init(void);
-extern void pci_olpc_init(void);
+extern int pci_olpc_init(void);
 
 /* pci-mmconfig.c */
 
