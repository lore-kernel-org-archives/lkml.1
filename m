Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXCEBuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXCEBuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXCEBuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:50:15 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49960 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752076AbXCEBtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:49:50 -0500
Date: Mon, 5 Mar 2007 02:49:51 +0100
From: Adrian Bunk <bunk@stusta.de>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, linux-kernel@vger.kernel.org
Subject: [-mm patch] fix the ROMFS_* dependencies
Message-ID: <20070305014951.GD3441@stusta.de>
References: <20070304152506.GC3441@stusta.de> <20070304041111.1d2774e7.akpm@linux-foundation.org> <20070302030026.5eef0c92.akpm@linux-foundation.org> <20070302030405.22f78999.akpm@linux-foundation.org> <45EAB46F.1030709@gmail.com> <14778.1173021069@redhat.com> <15200.1173022514@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <15200.1173022514@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 03:35:14PM +0000, David Howells wrote:
> Adrian Bunk <bunk@stusta.de> wrote:
> 
> > Is
> > 
> > CONFIG_BLOCK=y
> > CONFIG_ROMFS_FS=y
> > CONFIG_ROMFS_ON_BLOCK=n
> > CONFIG_ROMFS_ON_MTD=y
> > 
> > a reasonable configuration that should be supported, or can we turn 
> > CONFIG_ROMFS_ON_BLOCK always on if CONFIG_BLOCK=y?
> 
> Hmmm...  I don't really know the answer to that, apart from it depends.  On a
> non-embedded device, it's entirely reasonable, I think, to turn
> CONFIG_ROMFS_ON_BLOCK on if CONFIG_BLOCK is on, no questions asked.  However,
> on an embedded device you might want the extra option.

OK, what about the patch below?

> David

cu
Adrian


<--  snip  -->


This patch:
- adds the missing dependency of ROMFS_FS on BLOCK || MTD
- disallows the illegal ROMFS_FS=y, MTD=m, ROMFS_ON_MTD=y
- ensures that at least one of ROMFS_ON_BLOCK and ROMFS_ON_MTD is always 
  enabled:
  - automatically enable ROMFS_ON_MTD if BLOCK=n
  - automatically enable ROMFS_ON_BLOCK if ROMFS_ON_MTD=n
- if EMBEDDED=n, ROMFS_ON_BLOCK is always enabled
  - the "(which may have been disabled)" that could now confuse
    users has therefore been removed from the help text

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/Kconfig |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- linux-2.6.21-rc2-mm1/fs/Kconfig.old	2007-03-04 23:04:41.000000000 +0100
+++ linux-2.6.21-rc2-mm1/fs/Kconfig	2007-03-04 23:24:27.000000000 +0100
@@ -484,6 +484,7 @@
 
 config ROMFS_FS
 	tristate "ROM file system support"
+	depends on BLOCK || MTD
 	---help---
 	  This is a very small read-only file system mainly intended for
 	  initial ram disks of installation disks, but it could be used for
@@ -499,8 +500,9 @@
 	  answer N.
 
 config ROMFS_ON_BLOCK
-	bool "Block device-backed ROM file system support"
+	bool "Block device-backed ROM file system support" if (ROMFS_ON_MTD && EMBEDDED)
 	depends on ROMFS_FS && BLOCK
+	default y
 	help
 	  This permits ROMFS to use block devices buffered through the page
 	  cache as the medium from which to retrieve data.  It does not allow
@@ -509,14 +511,15 @@
 	  If unsure, answer Y.
 
 config ROMFS_ON_MTD
-	bool "MTD-backed ROM file system support"
-	depends on ROMFS_FS && MTD
+	bool "MTD-backed ROM file system support" if BLOCK
+	depends on ROMFS_FS
+	depends on MTD=y || (ROMFS_FS=m && MTD)
+	default y
 	help
 	  This permits ROMFS to use MTD based devices directly, without the
-	  intercession of the block layer (which may have been disabled).  It
-	  also allows direct mapping of MTD devices through romfs files under
-	  NOMMU conditions if the underlying device is directly addressable by
-	  the CPU.
+	  intercession of the block layer.  It also allows direct mapping of
+	  MTD devices through romfs files under NOMMU conditions if the
+	  underlying device is directly addressable by the CPU.
 
 	  If unsure, answer Y.
 

