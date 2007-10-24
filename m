Return-Path: <linux-kernel-owner+w=401wt.eu-S1764946AbXJXQu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764946AbXJXQu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbXJXQ1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:27:54 -0400
Received: from li6-103.members.linode.com ([66.160.141.103]:55835 "EHLO
	smtp.falooley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760702AbXJXQ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:27:53 -0400
X-Greylist: delayed 2002 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 12:27:52 EDT
Date: Wed, 24 Oct 2007 08:54:13 -0700
From: Jason Lunz <lunz@falooley.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: atom ota <atomota@sleepyhammer.com>, Jeff Dike <jdike@addtoit.com>,
       uml-user@lists.sourceforge.net, linux-mtd@lists.infradead.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] allow use of mtd and jffs2 on uml
Message-ID: <20071024155413.GA14077@falooley.org>
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com> <20071024011712.GA3762@falooley.org> <1193208689.26096.48.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193208689.26096.48.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Push the "depends on HAS_IOMEM" in mtd down closer to the parts that
actually need it. This allows enough of mtd to build to let jffs2 be
used on uml.

Signed-off-by: Jason Lunz <lunz@falooley.org>

---

On Wed, Oct 24, 2007 at 07:51:29AM +0100, David Woodhouse wrote:
> Why build anything in chips/ or maps/ ? 

Did I mention it was crude? :)  I followed your suggestion, and this
version is much cleaner.

> We should make sure mtdram, nandsim and onenandsim are all buildable
> too.

I wanted to keep this a pure kbuild change. Getting nand and onenand to
build for uml would involve making them not use readb and friends, or
getting uml to provide stub versions.


 arch/um/Kconfig             |    4 +---
 drivers/mtd/Kconfig         |   12 +++++++-----
 drivers/mtd/chips/Kconfig   |   11 ++++++++---
 drivers/mtd/devices/Kconfig |    7 +++++++
 4 files changed, 23 insertions(+), 11 deletions(-)

Index: linux-2.6.23.1-uml/arch/um/Kconfig
===================================================================
--- linux-2.6.23.1-uml.orig/arch/um/Kconfig
+++ linux-2.6.23.1-uml/arch/um/Kconfig
@@ -326,9 +326,7 @@
 
 source "drivers/md/Kconfig"
 
-if BROKEN
-	source "drivers/mtd/Kconfig"
-endif
+source "drivers/mtd/Kconfig"
 
 #This is just to shut up some Kconfig warnings, so no prompt.
 config INPUT
Index: linux-2.6.23.1-uml/drivers/mtd/devices/Kconfig
===================================================================
--- linux-2.6.23.1-uml.orig/drivers/mtd/devices/Kconfig
+++ linux-2.6.23.1-uml/drivers/mtd/devices/Kconfig
@@ -78,6 +78,7 @@
 
 config MTD_SLRAM
 	tristate "Uncached system RAM"
+ 	depends on HAS_IOMEM
 	help
 	  If your CPU cannot cache all of the physical memory in your machine,
 	  you can still use it for storage or swap by using this driver to
@@ -85,6 +86,7 @@
 
 config MTD_PHRAM
 	tristate "Physical system RAM"
+ 	depends on HAS_IOMEM
 	help
 	  This is a re-implementation of the slram driver above.
 
@@ -151,10 +153,13 @@
 	  Testing MTD users (eg JFFS2) on large media and media that might
 	  be removed during a write (using the floppy drive).
 
+if HAS_IOMEM
 comment "Disk-On-Chip Device Drivers"
+endif
 
 config MTD_DOC2000
 	tristate "M-Systems Disk-On-Chip 2000 and Millennium (DEPRECATED)"
+ 	depends on HAS_IOMEM
 	select MTD_DOCPROBE
 	select MTD_NAND_IDS
 	---help---
@@ -177,6 +182,7 @@
 
 config MTD_DOC2001
 	tristate "M-Systems Disk-On-Chip Millennium-only alternative driver (DEPRECATED)"
+ 	depends on HAS_IOMEM
 	select MTD_DOCPROBE
 	select MTD_NAND_IDS
 	---help---
@@ -198,6 +204,7 @@
 
 config MTD_DOC2001PLUS
 	tristate "M-Systems Disk-On-Chip Millennium Plus"
+ 	depends on HAS_IOMEM
 	select MTD_DOCPROBE
 	select MTD_NAND_IDS
 	---help---
Index: linux-2.6.23.1-uml/drivers/mtd/Kconfig
===================================================================
--- linux-2.6.23.1-uml.orig/drivers/mtd/Kconfig
+++ linux-2.6.23.1-uml/drivers/mtd/Kconfig
@@ -2,7 +2,6 @@
 
 menuconfig MTD
 	tristate "Memory Technology Device (MTD) support"
-	depends on HAS_IOMEM
 	help
 	  Memory Technology Devices are flash, RAM and similar chips, often
 	  used for solid state file systems on embedded devices. This option
@@ -278,15 +277,18 @@
 	  This enables read only access to SmartMedia formatted NAND
 	  flash. You can mount it with FAT file system.
 
-source "drivers/mtd/chips/Kconfig"
 
-source "drivers/mtd/maps/Kconfig"
+if HAS_IOMEM
+	source "drivers/mtd/chips/Kconfig"
+	source "drivers/mtd/maps/Kconfig"
+endif
 
 source "drivers/mtd/devices/Kconfig"
 
-source "drivers/mtd/nand/Kconfig"
-
-source "drivers/mtd/onenand/Kconfig"
+if HAS_IOMEM
+	source "drivers/mtd/nand/Kconfig"
+	source "drivers/mtd/onenand/Kconfig"
+endif
 
 source "drivers/mtd/ubi/Kconfig"
 
Index: linux-2.6.23.1-uml/drivers/mtd/Makefile
===================================================================
--- linux-2.6.23.1-uml.orig/drivers/mtd/Makefile
+++ linux-2.6.23.1-uml/drivers/mtd/Makefile
@@ -26,6 +26,9 @@
 nftl-objs		:= nftlcore.o nftlmount.o
 inftl-objs		:= inftlcore.o inftlmount.o
 
-obj-y		+= chips/ maps/ devices/ nand/ onenand/
+obj-y		+= devices/
+ifdef CONFIG_HAS_IOMEM
+obj-y		+= chips/ maps/ nand/ onenand/
+endif
 
 obj-$(CONFIG_MTD_UBI)		+= ubi/
