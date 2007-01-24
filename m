Return-Path: <linux-kernel-owner+w=401wt.eu-S933193AbXAXHsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193AbXAXHsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 02:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933194AbXAXHsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 02:48:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56590 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933193AbXAXHsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 02:48:39 -0500
Date: Tue, 23 Jan 2007 23:45:07 -0800
From: Andrew Morton <akpm@osdl.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: sshtylyov@ru.mvista.com, Eric.Piel@lifl.fr, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] Make CARDBUS_MEM_SIZE and CARDBUS_IO_SIZE customizable
Message-Id: <20070123234507.08f63b5e.akpm@osdl.org>
In-Reply-To: <20070123.103027.126140726.nemoto@toshiba-tops.co.jp>
References: <45B4C2DA.8020906@lifl.fr>
	<20070122.233251.74752372.anemo@mba.ocn.ne.jp>
	<45B4D592.9050703@ru.mvista.com>
	<20070123.103027.126140726.nemoto@toshiba-tops.co.jp>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 10:30:27 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> Subject: [PATCH] Make CARDBUS_MEM_SIZE and CARDBUS_IO_SIZE customizable
> 
> CARDBUS_MEM_SIZE was increased to 64MB on 2.6.20-rc2, but larger size
> might result in allocation failure for the reserving itself on some
> platforms (for example typical 32bit MIPS).  Make it (and
> CARDBUS_IO_SIZE too) customizable by "pci=" option for such platforms.
> 
> ...
>
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1168,6 +1168,12 @@ static int __devinit pci_setup(char *str
>  		if (*str && (str = pcibios_setup(str)) && *str) {
>  			if (!strcmp(str, "nomsi")) {
>  				pci_no_msi();
> +			} else if (!strncmp(str, "cbiosize=", 9)) {
> +				pci_cardbus_io_size =
> +					memparse(str + 9, &str);
> +			} else if (!strncmp(str, "cbmemsize=", 10)) {
> +				pci_cardbus_mem_size =
> +					memparse(str + 10, &str);
>  			} else {
>  				printk(KERN_ERR "PCI: Unknown option `%s'\n",
>  						str);
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 89f3036..1dfc288 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -40,8 +40,11 @@ #define ROUND_UP(x, a)		(((x) + (a) - 1)
>   * FIXME: IO should be max 256 bytes.  However, since we may
>   * have a P2P bridge below a cardbus bridge, we need 4K.
>   */
> -#define CARDBUS_IO_SIZE		(256)
> -#define CARDBUS_MEM_SIZE	(64*1024*1024)
> +#define DEFAULT_CARDBUS_IO_SIZE		(256)
> +#define DEFAULT_CARDBUS_MEM_SIZE	(64*1024*1024)
> +/* pci=cbmemsize=nnM,cbiosize=nn can override this */
> +unsigned long pci_cardbus_io_size = DEFAULT_CARDBUS_IO_SIZE;
> +unsigned long pci_cardbus_mem_size = DEFAULT_CARDBUS_MEM_SIZE;

setup-bus.o is linked only on x86, so your patch will cause all other
pci-using architectures to not link.

An easy fix is to move the definitions of pci_cardbus_io_size and
pci_cardbus_mem_size into pci.c.  An ugly, fragile but more efficient fix
is, reluctantly:

diff -puN drivers/pci/pci.c~make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix drivers/pci/pci.c
--- a/drivers/pci/pci.c~make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix
+++ a/drivers/pci/pci.c
@@ -1212,13 +1212,15 @@ static int __devinit pci_setup(char *str
 		if (*str && (str = pcibios_setup(str)) && *str) {
 			if (!strcmp(str, "nomsi")) {
 				pci_no_msi();
-			} else if (!strncmp(str, "cbiosize=", 9)) {
-				pci_cardbus_io_size =
-					memparse(str + 9, &str);
+			}
+#ifdef CONFIG_X86
+			else if (!strncmp(str, "cbiosize=", 9)) {
+				pci_cardbus_io_size = memparse(str + 9, &str);
 			} else if (!strncmp(str, "cbmemsize=", 10)) {
-				pci_cardbus_mem_size =
-					memparse(str + 10, &str);
-			} else {
+				pci_cardbus_mem_size = memparse(str + 10, &str);
+			}
+#endif
+			else {
 				printk(KERN_ERR "PCI: Unknown option `%s'\n",
 						str);
 			}
diff -puN drivers/pci/setup-bus.c~make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix drivers/pci/setup-bus.c
--- a/drivers/pci/setup-bus.c~make-cardbus_mem_size-and-cardbus_io_size-boot-options-fix
+++ a/drivers/pci/setup-bus.c
@@ -36,10 +36,6 @@
 
 #define ROUND_UP(x, a)		(((x) + (a) - 1) & ~((a) - 1))
 
-/*
- * FIXME: IO should be max 256 bytes.  However, since we may
- * have a P2P bridge below a cardbus bridge, we need 4K.
- */
 #define DEFAULT_CARDBUS_IO_SIZE		(256)
 #define DEFAULT_CARDBUS_MEM_SIZE	(64*1024*1024)
 /* pci=cbmemsize=nnM,cbiosize=nn can override this */
_


Perhaps we should move the cbiosize= and cbmemsize= handlers over into
setup-bus.c.  The implementation would be cleaner, but then we wouldn't be
able to use the pci= namespace.

