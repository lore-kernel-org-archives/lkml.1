Return-Path: <linux-kernel-owner+w=401wt.eu-S1761998AbXGPUkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998AbXGPUkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759681AbXGPUkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:40:16 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:34739 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759165AbXGPUkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:40:15 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Build error with latest git
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, jens.axboe@oracle.com
References: <469BC420.8080204@lwfinger.net>
In-Reply-To: <469BC420.8080204@lwfinger.net>
MIME-Version: 1.0
Date: Mon, 16 Jul 2007 23:39:36 +0300
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707162339.39197.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[Resend, gnupg damaged the patch, sorry for noise]

16 Tem 2007 Pts tarihinde, Larry Finger şunları yazmıştı: 
> Using the latest git pull (commit
> abce891a10559343d8ac9f79b46d78afdba63a40), I get the following linker
> error:
>
> block/built-in.o: In function `bsg_init':
> bsg.c:(.init.text+0x43d): undefined reference to `scsi_register_interface'
>
> This is on an x86_64 system with the following .config:

I've hit that also (current git cannot compiled with CONFIG_BLK_DEV_BSG=y
), if i'm not wrongly interpret the Makefile it seems a ordering issue;

Makefile
...
ifeq ($(KBUILD_EXTMOD),)
core-y· ·   += kernel/ mm/ fs/ ipc/ security/ crypto/ block/
...
vmlinux-init := $(head-y) $(init-y)
vmlinux-main := $(core-y) $(libs-y) $(drivers-y) $(net-y)
...

but block block/bsg.c uses "scsi_register_interface" exported by 
drivers/scsi/scsi_sysfs.c which lives in drivers-y. Moving bsg in 
drivers/scsi seems solves this issues, see following

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

 block/Kconfig                 |    8 --------
 block/Makefile                |    1 -
 drivers/scsi/Kconfig          |    8 ++++++++
 drivers/scsi/Makefile         |    1 +
 {block => drivers/scsi}/bsg.c |    0 
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 1d16b08..2859351 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -51,12 +51,4 @@ config LSF
 
 endif # BLOCK
 
-config BLK_DEV_BSG
-	bool "Block layer SG support"
-	depends on SCSI && EXPERIMENTAL
-	default y
-	---help---
-	Saying Y here will enable generic SG (SCSI generic) v4
-	support for any block device.
-
 source block/Kconfig.iosched
diff --git a/block/Makefile b/block/Makefile
index 959feeb..4b84d0d 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -4,7 +4,6 @@
 
 obj-$(CONFIG_BLOCK) := elevator.o ll_rw_blk.o ioctl.o genhd.o scsi_ioctl.o
 
-obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
 obj-$(CONFIG_IOSCHED_NOOP)	+= noop-iosched.o
 obj-$(CONFIG_IOSCHED_AS)	+= as-iosched.o
 obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3727231..fbb06de 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -81,6 +81,14 @@ config BLK_DEV_SD
 	  In this case, do not compile the driver for your SCSI host adapter
 	  (below) as a module either.
 
+config BLK_DEV_BSG
+	 bool "Block layer SG support"
+	depends on SCSI && EXPERIMENTAL
+	default y
+	---help---
+	Saying Y here will enable generic SG (SCSI generic) v4
+	support for any block device.
+
 config CHR_DEV_ST
 	tristate "SCSI tape support"
 	depends on SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 0f86895..15de029 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -139,6 +139,7 @@ obj-$(CONFIG_CHR_DEV_ST)	+= st.o
 obj-$(CONFIG_CHR_DEV_OSST)	+= osst.o
 obj-$(CONFIG_BLK_DEV_SD)	+= sd_mod.o
 obj-$(CONFIG_BLK_DEV_SR)	+= sr_mod.o
+obj-$(CONFIG_BLK_DEV_BSG)	+= bsg.o
 obj-$(CONFIG_CHR_DEV_SG)	+= sg.o
 obj-$(CONFIG_CHR_DEV_SCH)	+= ch.o
 
diff --git a/block/bsg.c b/drivers/scsi/bsg.c
similarity index 100%
rename from block/bsg.c
rename to drivers/scsi/bsg.c



Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
