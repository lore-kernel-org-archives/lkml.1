Return-Path: <linux-kernel-owner+w=401wt.eu-S933190AbXAXHyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbXAXHyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 02:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933194AbXAXHyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 02:54:03 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56793 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933190AbXAXHyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 02:54:01 -0500
Date: Tue, 23 Jan 2007 23:50:29 -0800
From: Andrew Morton <akpm@osdl.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, sshtylyov@ru.mvista.com,
       Eric.Piel@lifl.fr, ralf@linux-mips.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] Make CARDBUS_MEM_SIZE and CARDBUS_IO_SIZE customizable
Message-Id: <20070123235029.d49eda3d.akpm@osdl.org>
In-Reply-To: <20070123234507.08f63b5e.akpm@osdl.org>
References: <45B4C2DA.8020906@lifl.fr>
	<20070122.233251.74752372.anemo@mba.ocn.ne.jp>
	<45B4D592.9050703@ru.mvista.com>
	<20070123.103027.126140726.nemoto@toshiba-tops.co.jp>
	<20070123234507.08f63b5e.akpm@osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 23:45:07 -0800
Andrew Morton <akpm@osdl.org> wrote:

> setup-bus.o is linked only on x86

oops, that's untrue.  But it will break ppc32, I think.

I suppose we can deprive the ppc32 guys of eight bytes of RAM.  But putting
cardbus things in pci.c seems wrong..


diff -puN drivers/pci/pci.c~make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix drivers/pci/pci.c
--- a/drivers/pci/pci.c~make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix
+++ a/drivers/pci/pci.c
@@ -21,6 +21,12 @@
 
 unsigned int pci_pm_d3_delay = 10;
 
+#define DEFAULT_CARDBUS_IO_SIZE		(256)
+#define DEFAULT_CARDBUS_MEM_SIZE	(64*1024*1024)
+/* pci=cbmemsize=nnM,cbiosize=nn can override this */
+unsigned long pci_cardbus_io_size = DEFAULT_CARDBUS_IO_SIZE;
+unsigned long pci_cardbus_mem_size = DEFAULT_CARDBUS_MEM_SIZE;
+
 /**
  * pci_bus_max_busnr - returns maximum PCI bus number of given bus' children
  * @bus: pointer to PCI bus structure to search
@@ -1213,11 +1219,9 @@ static int __devinit pci_setup(char *str
 			if (!strcmp(str, "nomsi")) {
 				pci_no_msi();
 			} else if (!strncmp(str, "cbiosize=", 9)) {
-				pci_cardbus_io_size =
-					memparse(str + 9, &str);
+				pci_cardbus_io_size = memparse(str + 9, &str);
 			} else if (!strncmp(str, "cbmemsize=", 10)) {
-				pci_cardbus_mem_size =
-					memparse(str + 10, &str);
+				pci_cardbus_mem_size = memparse(str + 10, &str);
 			} else {
 				printk(KERN_ERR "PCI: Unknown option `%s'\n",
 						str);
diff -puN drivers/pci/setup-bus.c~make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix drivers/pci/setup-bus.c
--- a/drivers/pci/setup-bus.c~make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix
+++ a/drivers/pci/setup-bus.c
@@ -36,16 +36,6 @@
 
 #define ROUND_UP(x, a)		(((x) + (a) - 1) & ~((a) - 1))
 
-/*
- * FIXME: IO should be max 256 bytes.  However, since we may
- * have a P2P bridge below a cardbus bridge, we need 4K.
- */
-#define DEFAULT_CARDBUS_IO_SIZE		(256)
-#define DEFAULT_CARDBUS_MEM_SIZE	(64*1024*1024)
-/* pci=cbmemsize=nnM,cbiosize=nn can override this */
-unsigned long pci_cardbus_io_size = DEFAULT_CARDBUS_IO_SIZE;
-unsigned long pci_cardbus_mem_size = DEFAULT_CARDBUS_MEM_SIZE;
-
 static void __devinit
 pbus_assign_resources_sorted(struct pci_bus *bus)
 {
_

