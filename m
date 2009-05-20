Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbZETXte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbZETXte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZETXtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:49:25 -0400
Received: from outbound-mail-118.bluehost.com ([69.89.22.18]:57561 "HELO
	outbound-mail-118.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753229AbZETXtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:49:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=m0jQ63KJd95xKwUhMXUTcSJIIRbIwZnN124wgRf7MvfBoMKW6k+/2JpIP1nV7Mzmfhzew3BjhhXbrO707pkAHPUPFDIoWGwsGMZZcGG1fHmS2oadu1kxw7TrK88f8GVP;
Date: Wed, 20 May 2009 16:49:10 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Gary Hade <garyhade@us.ibm.com>,
       Alex Chiang <achiang@hp.com>, linux-acpi@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] x86/pci: do assign root bus res if _CRS is used
Message-ID: <20090520164910.6939b92b@jbarnes-g45>
In-Reply-To: <200905081640.12677.bjorn.helgaas@hp.com>
References: <49ED22EC.2040204@kernel.org>
	<200904291708.52830.bjorn.helgaas@hp.com>
	<200904300914.22772.bjorn.helgaas@hp.com>
	<200905081640.12677.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009 16:40:10 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> Did anything happen with this?
> 
> The longer we wait to make "use_crs" the default, the harder it
> will be, so I'd like to push ahead.

Here's a patch to make CRS the default.  If it looks ok I can push it
into my linux-next branch.  I'm all for using reliable data from the
BIOS.  I guess we'll find out fairly quickly if this stuff isn't...

-- 
Jesse Barnes, Intel Open Source Technology Center

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 90b3924..8d798bf 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1777,7 +1777,7 @@ and is between 256 and 4096 characters. It is defined in the file
 				IRQ routing is enabled.
 		noacpi		[X86] Do not use ACPI for IRQ routing
 				or for PCI scanning.
-		use_crs		[X86] Use _CRS for PCI resource
+		nocrs		[X86] Don't use _CRS for PCI resource
 				allocation.
 		routeirq	Do IRQ routing for all PCI devices.
 				This is normally done in pci_enable_device(),
diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index e60fd3e..010c08c 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -25,7 +25,7 @@
 #define PCI_BIOS_IRQ_SCAN	0x2000
 #define PCI_ASSIGN_ALL_BUSSES	0x4000
 #define PCI_CAN_SKIP_ISA_ALIGN	0x8000
-#define PCI_USE__CRS		0x10000
+#define PCI_NO_CRS		0x10000
 #define PCI_CHECK_ENABLE_AMD_MMCONF	0x20000
 #define PCI_HAS_IO_ECS		0x40000
 #define PCI_NOASSIGN_ROMS	0x80000
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index c0ecf25..9f562a3 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -217,7 +217,7 @@ struct pci_bus * __devinit pci_acpi_scan_root(struct acpi_device *device, int do
 #endif
 	}
 
-	if (bus && (pci_probe & PCI_USE__CRS))
+	if (bus && !(pci_probe & PCI_NO_CRS))
 		get_current_resources(device, busnum, domain, bus);
 	return bus;
 }
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index f893d6a..cfed6b1 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -101,7 +101,7 @@ void x86_pci_root_bus_res_quirks(struct pci_bus *b)
 	struct pci_root_info *info;
 
 	/* don't go for it if _CRS is used */
-	if (pci_probe & PCI_USE__CRS)
+	if (!(pci_probe & PCI_NO_CRS)
 		return;
 
 	/* if only one root bus, don't need to anything */
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 2202b62..3e361c7 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -515,8 +515,8 @@ char * __devinit  pcibios_setup(char *str)
 	} else if (!strcmp(str, "assign-busses")) {
 		pci_probe |= PCI_ASSIGN_ALL_BUSSES;
 		return NULL;
-	} else if (!strcmp(str, "use_crs")) {
-		pci_probe |= PCI_USE__CRS;
+	} else if (!strcmp(str, "nocrs")) {
+		pci_probe |= PCI_NO_CRS;
 		return NULL;
 	} else if (!strcmp(str, "earlydump")) {
 		pci_early_dump_regs = 1;

