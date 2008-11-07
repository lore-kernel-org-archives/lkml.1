Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbYKGGa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbYKGGa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 01:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755971AbYKGG3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 01:29:32 -0500
Received: from i220-221-252-159.s30.a048.ap.plala.or.jp ([220.221.252.159]:40374
	"EHLO mail.m.clustcom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755958AbYKGG3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 01:29:30 -0500
Date: Fri, 7 Nov 2008 15:28:30 +0000
From: Hitoshi Mitake <mitake@clustcom.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, ktaka@clustcom.com
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081107152830.a42766f3.mitake@clustcom.com>
In-Reply-To: <20081106164641.ed369060.akpm@linux-foundation.org>
References: <20081105222911.d76e7e1c.mitake@clustcom.com>
	<413709.12821.qm@web50106.mail.re2.yahoo.com>
	<20081106164641.ed369060.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008 16:46:41 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 5 Nov 2008 08:26:12 -0800 (PST)
> Doug Thompson <norsk5@yahoo.com> wrote:
> 
> > > I wrote new version of this driver and tested. It works well.
> > > This is replacement for old version.
> > > Or should I send diff of two versions?
> > 
> > 
> > I would suggest sending a diff of what is now in the -mm tree to what it should be.
> 
> This driver is now in the mainline kernel so yes, a patch against that
> kernel is the only appropriate way of updating the driver.
> 

Sorry, and thanks for notification, Doug and Andrew.
This is patch against mainline kernel.

Signed-off-by: Hitoshi Mitake <mitake@clustcom.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---

Index: linux-2.6.28-rc3-git2/drivers/edac/Kconfig
===================================================================
--- linux-2.6.28-rc3-git2.orig/drivers/edac/Kconfig	2008-11-07 11:27:05.000000000 +0000
+++ linux-2.6.28-rc3-git2/drivers/edac/Kconfig	2008-11-07 11:27:14.000000000 +0000
@@ -104,7 +104,7 @@
 
 config EDAC_X38
 	tristate "Intel X38"
-	depends on EDAC_MM_EDAC && PCI && X86
+	depends on EDAC_MM_EDAC && PCI && (X86 || X86_64)
 	help
 	  Support for error detection and correction on the Intel
 	  X38 server chipsets.
Index: linux-2.6.28-rc3-git2/drivers/edac/x38_edac.c
===================================================================
--- linux-2.6.28-rc3-git2.orig/drivers/edac/x38_edac.c	2008-11-07 11:27:06.000000000 +0000
+++ linux-2.6.28-rc3-git2/drivers/edac/x38_edac.c	2008-11-07 11:27:29.000000000 +0000
@@ -162,10 +162,12 @@
 			 X38_ERRSTS_BITS);
 }
 
-static u64 x38_readq(const void __iomem *addr)
+#ifndef CONFIG_X86_64
+static u64 readq(const void __iomem *addr)
 {
 	return readl(addr) | (((u64)readl(addr + 4)) << 32);
 }
+#endif	/* CONFIG_X86_64 */
 
 static void x38_get_and_clear_error_info(struct mem_ctl_info *mci,
 				 struct x38_error_info *info)
@@ -184,9 +186,9 @@
 	if (!(info->errsts & X38_ERRSTS_BITS))
 		return;
 
-	info->eccerrlog[0] = x38_readq(window + X38_C0ECCERRLOG);
+	info->eccerrlog[0] = readq(window + X38_C0ECCERRLOG);
 	if (x38_channel_num == 2)
-		info->eccerrlog[1] = x38_readq(window + X38_C1ECCERRLOG);
+		info->eccerrlog[1] = readq(window + X38_C1ECCERRLOG);
 
 	pci_read_config_word(pdev, X38_ERRSTS, &info->errsts2);
 
@@ -197,10 +199,10 @@
 	 * should be UE info.
 	 */
 	if ((info->errsts ^ info->errsts2) & X38_ERRSTS_BITS) {
-		info->eccerrlog[0] = x38_readq(window + X38_C0ECCERRLOG);
+		info->eccerrlog[0] = readq(window + X38_C0ECCERRLOG);
 		if (x38_channel_num == 2)
 			info->eccerrlog[1] =
-				x38_readq(window + X38_C1ECCERRLOG);
+				readq(window + X38_C1ECCERRLOG);
 	}
 
 	x38_clear_error_info(mci);
